#!/usr/bin/env bash
# Compila una evaluación en dos versiones: estudiante y docente (opción "solucion").
# Uso: bash compilar.sh ruta/al/archivo.tex [carpeta_para_vistas_previas]
# Además: avisa de cajas desbordadas y caracteres que pdfLaTeX no imprime (griego, etc.),
# y deja una hoja de contactos (todas las páginas en una imagen) para revisar rápido.
set -euo pipefail

tex="$(realpath "$1")"
dir="$(dirname "$tex")"
base="$(basename "$tex" .tex)"
vistas="${2:-${TMPDIR:-/tmp}/vistas-evaluaciones}"
# Configuración del colegio (curriculo/config/colegio.yaml): colegio, logo, color y docente por defecto.
raiz="$(cd "$(dirname "$0")/../../../.." && pwd)"
if [ -f "$raiz/curriculo/config/configurar.py" ]; then
  python3 "$raiz/curriculo/config/configurar.py" >&2 || exit 1
  export TEXINPUTS="$raiz/curriculo/config:$raiz/evaluaciones/plantilla:${TEXINPUTS:-}"
fi
cd "$dir"

# Caracteres que la fuente de pdfLaTeX no tiene (griego, cirílico...): fallan al compilar.
if grep -nP '[\x{0370}-\x{03FF}\x{1F00}-\x{1FFF}\x{0400}-\x{04FF}]' "$base.tex" >/dev/null; then
  echo "AVISO: hay letras griegas o cirílicas en el .tex; pdfLaTeX no tiene esas fuentes."
  echo "       Usa \$\\Lambda\$, \$\\Sigma\$... en modo matemático o transliteración (ver SKILL.md)."
  grep -nP '[\x{0370}-\x{03FF}\x{1F00}-\x{1FFF}\x{0400}-\x{04FF}]' "$base.tex" | head -5
fi

compilar() {
  for _ in 1 2; do pdflatex -interaction=nonstopmode "$1.tex" > /dev/null 2>&1 || true; done
  if grep -q '^!' "$1.log"; then
    echo "ERRORES en $1:"; grep -A4 '^!' "$1.log" | head -30; return 1
  fi
  grep -o 'Output written on [^ ]* ([0-9]* pages' "$1.log" | sed 's/Output written on /  /'
  # Cajas desbordadas de más de 3 pt (texto o figura que se sale del margen)
  grep -E 'Overfull \\hbox \(([3-9]|[1-9][0-9]+)\.' "$1.log" | sed 's/^/  AVISO: /' | head -5 || true
}

echo "Estudiante:"; compilar "$base"

# Versión del docente: misma fuente con la opción "solucion" en \documentclass.
sed -E '0,/\\documentclass\[/s//\\documentclass[solucion,/' "$base.tex" > "${base}_docente.tex"
echo "Docente:"; compilar "${base}_docente"
rm -f "${base}_docente.tex"

rm -f ./*.aux ./*.log ./*.out
mkdir -p "$vistas"; rm -f "$vistas/${base}"-*.png "$vistas/${base}_contactos.png"
pdftoppm -r 80 -png "$base.pdf" "$vistas/$base"
echo "Vistas previas: $vistas/${base}-*.png"

# Hoja de contactos (versión docente, 4 páginas por fila) para revisar la maqueta de un vistazo
if python3 -c "import PIL" 2>/dev/null; then
  tmp="$(mktemp -d)"; pdftoppm -r 60 -png "${base}_docente.pdf" "$tmp/p"
  python3 - "$tmp" "$vistas/${base}_contactos.png" <<'PY'
import glob, sys
from PIL import Image
fs = sorted(glob.glob(sys.argv[1] + "/p-*.png"))
ims = [Image.open(f) for f in fs]; w, h = ims[0].size; c = 4; r = (len(ims) + c - 1) // c
m = Image.new("RGB", (w * c, h * r), "white")
for k, im in enumerate(ims): m.paste(im, ((k % c) * w, (k // c) * h))
m.save(sys.argv[2])
PY
  rm -rf "$tmp"; echo "Hoja de contactos: $vistas/${base}_contactos.png"
fi
