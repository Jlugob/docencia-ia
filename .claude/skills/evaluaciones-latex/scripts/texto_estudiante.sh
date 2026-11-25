#!/usr/bin/env bash
# Extrae el texto que ve el estudiante (sin la última página, que es la clave) para que el
# «estudiante simulado» resuelva la prueba sin conocer las respuestas.
# Uso: bash texto_estudiante.sh evaluaciones/2026-P4/<archivo>.pdf <salida.txt>
set -euo pipefail
pdf="$1"; salida="$2"
paginas=$(pdfinfo "$pdf" | awk '/^Pages:/{print $2}')
ultima=$((paginas - 1))
pdftotext -layout -f 1 -l "$ultima" "$pdf" "$salida"
echo "Texto del estudiante (páginas 1 a $ultima de $paginas): $salida"
