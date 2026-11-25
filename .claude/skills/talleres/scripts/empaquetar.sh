#!/usr/bin/env bash
# Empaqueta la skill talleres en un .zip para subirla a la cuenta de claude.ai
# (Configuración → Capacidades → Skills → Subir skill). Incluye la plantilla (planeacion.cls +
# taller-recursos.sty), el modo de trabajo y los talleres de ejemplo.
# Uso: bash empaquetar.sh [carpeta_salida]   (por defecto: recursos/skills/)
set -euo pipefail
skill="$(cd "$(dirname "$0")/.." && pwd)"
raiz="$(cd "$skill/../../.." && pwd)"
salida="${1:-$raiz/recursos/skills}"
tmp="$(mktemp -d)"; dest="$tmp/talleres"
mkdir -p "$dest/assets/plantilla" "$dest/assets/ejemplos"
cp -r "$skill/SKILL.md" "$skill/referencias" "$skill/scripts" "$dest/"
cp -r "$skill/assets/." "$dest/assets/"
cp "$raiz/curriculo/plantilla/planeacion.cls" "$raiz/curriculo/plantilla/taller-recursos.sty" \
   "$raiz/curriculo/plantilla/compilar.sh" \
   "$raiz/curriculo/plantilla/README.md" "$raiz/curriculo/plantilla/ejemplos/catalogo-taller.tex" \
   "$raiz/curriculo/plantilla/ejemplos/catalogo-taller.pdf" "$dest/assets/plantilla/"
cp "$raiz/curriculo/MODO-DE-TRABAJO.md" "$raiz/.claude/skills/planeacion/referencias/talleres.md" "$dest/referencias/" 2>/dev/null || true
mv "$dest/referencias/talleres.md" "$dest/referencias/talleres-en-la-planeacion.md"
cp "$raiz"/curriculo/filosofia/10/taller-*.tex "$dest/assets/ejemplos/"
cp -r "$raiz/curriculo/filosofia/10/img" "$dest/assets/ejemplos/img"
find "$dest" -name "__pycache__" -prune -exec rm -rf {} +
# Configuración del colegio y del docente (para adaptarla, ver assets/config/LEEME.md)
python3 "$raiz/curriculo/config/configurar.py" >/dev/null
mkdir -p "$dest/assets/config"
cp "$raiz/curriculo/config/colegio.yaml" "$raiz/curriculo/config/docente.yaml" "$raiz/curriculo/config/configurar.py" \
   "$raiz/curriculo/config/logo-colegio.png" "$raiz/curriculo/config/kit-config.tex" "$dest/assets/config/"
cp "$raiz/docs/ADAPTAR.md" "$dest/assets/config/LEEME.md"
mkdir -p "$salida"
(cd "$tmp" && rm -f "$salida/talleres.zip" && zip -qr "$salida/talleres.zip" talleres)
rm -rf "$tmp"
echo "Skill empaquetada: $salida/talleres.zip ($(du -h "$salida/talleres.zip" | cut -f1))"
