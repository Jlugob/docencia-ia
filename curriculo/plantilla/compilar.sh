#!/usr/bin/env bash
# Compila un documento de planeación (malla, parcelación, programa, taller, habilitación) con
# planeacion.cls. Los talleres salen en dos versiones: estudiante y docente (con respuestas).
# Uso: bash curriculo/plantilla/compilar.sh ruta/al/archivo.tex [más archivos…]
# Borra el .aux anterior (para recalcular desde cero si el contenido cambió) y hace cuatro
# pasadas de XeLaTeX: «Página X de Y» y la regla que impide que la nota y las firmas queden solas
# en una hoja usan datos de la pasada anterior. Luego limpia los auxiliares y avisa de errores o
# texto que se sale.
set -uo pipefail
plantilla="$(cd "$(dirname "$0")" && pwd)"
config="$(cd "$plantilla/../config" && pwd)"
# Aplica la configuración del colegio y del docente (colegio.yaml, docente.yaml → kit-config.tex)
python3 "$config/configurar.py" || exit 1
for tex in "$@"; do
  dir="$(cd "$(dirname "$tex")" && pwd)"; base="$(basename "$tex" .tex)"
  rm -f "$dir/$base.aux"
  ( cd "$dir" && for i in 1 2 3 4; do
      max_print_line=10000 TEXINPUTS="$plantilla:$config:" xelatex -interaction=nonstopmode "$base.tex" >/dev/null 2>&1
    done )
  # Talleres: además la versión del docente con las respuestas (<archivo>-docente.pdf)
  if grep -q '\\documentclass\[[^]]*taller' "$tex"; then
    ( cd "$dir" && rm -f "$base-docente.aux" && for i in 1 2 3; do
        max_print_line=10000 TEXINPUTS="$plantilla:$config:" xelatex -interaction=nonstopmode \
          -jobname="$base-docente" "\\def\\pldocente{1}\\input{$base.tex}" >/dev/null 2>&1
      done
      e=$(grep -c '^!' "$base-docente.log" || true)
      echo "$base-docente.pdf: $(pdfinfo "$base-docente.pdf" 2>/dev/null | awk '/^Pages/{print $2}') página(s), $e error(es)"
      [ "$e" -gt 0 ] && grep -A4 '^!' "$base-docente.log" | head -12
      rm -f "$base-docente.log" "$base-docente.aux" "$base-docente.out" )
  fi
  log="$dir/$base.log"
  errores=$(grep -c '^!' "$log" || true)
  desbordes=$(grep -c 'Overfull \\hbox' "$log" || true)
  paginas=$(pdfinfo "$dir/$base.pdf" 2>/dev/null | awk '/^Pages/{print $2}')
  echo "$base.pdf: ${paginas:-?} página(s), $errores error(es), $desbordes línea(s) desbordada(s)"
  [ "$errores" -gt 0 ] && grep -A4 '^!' "$log" | head -20
  # Avisos del modo de trabajo (clases sin entregable, número de quices y talleres…)
  grep "planeacion Warning: MODO DE TRABAJO" "$log" | sed "s/.*Warning: /  ⚠ /; s/\.$//" | sort -u || true
  rm -f "$dir/$base.log" "$dir/$base.out" "$dir/$base.aux"
done
