#!/usr/bin/env bash
# Empaqueta la skill evaluaciones-latex en un .zip para subirla a la cuenta de claude.ai
# (Configuración → Capacidades → Skills → Subir skill). Incluye la plantilla del colegio dentro de
# assets/plantilla/ para que funcione fuera del repositorio.
# Uso: bash empaquetar.sh [carpeta_salida]   (por defecto: recursos/skills/)
set -euo pipefail
skill="$(cd "$(dirname "$0")/.." && pwd)"
raiz="$(cd "$skill/../../.." && pwd)"
salida="${1:-$raiz/recursos/skills}"
tmp="$(mktemp -d)"
dest="$tmp/evaluaciones-latex"
mkdir -p "$dest"
cp -r "$skill/SKILL.md" "$skill/referencias" "$skill/scripts" "$skill/assets" "$dest/"
mkdir -p "$dest/assets/plantilla"
cp "$raiz/evaluaciones/plantilla/evaluacion.cls" "$raiz/evaluaciones/plantilla/evaluacion-extras.sty" \
   "$raiz/evaluaciones/plantilla/README.md" \
   "$raiz/evaluaciones/plantilla/catalogo-formatos.pdf" "$raiz/evaluaciones/CRITERIOS.md" \
   "$dest/assets/plantilla/"
cp "$raiz/evaluaciones/FLUJO-DE-TRABAJO.md" "$dest/referencias/flujo-de-trabajo.md"
find "$dest" -name "__pycache__" -prune -exec rm -rf {} +
# Configuración del colegio y del docente (para adaptarla, ver assets/config/LEEME.md)
python3 "$raiz/curriculo/config/configurar.py" >/dev/null
mkdir -p "$dest/assets/config"
cp "$raiz/curriculo/config/colegio.yaml" "$raiz/curriculo/config/docente.yaml" "$raiz/curriculo/config/configurar.py" \
   "$raiz/curriculo/config/logo-colegio.png" "$raiz/curriculo/config/kit-config.tex" "$dest/assets/config/"
cp "$raiz/docs/ADAPTAR.md" "$dest/assets/config/LEEME.md"
mkdir -p "$salida"
(cd "$tmp" && rm -f "$salida/evaluaciones-latex.zip" && zip -qr "$salida/evaluaciones-latex.zip" evaluaciones-latex)
rm -rf "$tmp"
echo "Skill empaquetada: $salida/evaluaciones-latex.zip ($(du -h "$salida/evaluaciones-latex.zip" | cut -f1))"
