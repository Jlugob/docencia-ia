#!/usr/bin/env bash
# Empaqueta la skill planeacion en un .zip para subirla a la cuenta de claude.ai
# (Configuración → Capacidades → Skills → Subir skill). Incluye la plantilla LaTeX, el modo de
# trabajo, la configuración, los referentes y el piloto, para que funcione fuera del repositorio.
# Uso: bash empaquetar.sh [carpeta_salida]   (por defecto: recursos/skills/)
set -euo pipefail
skill="$(cd "$(dirname "$0")/.." && pwd)"
raiz="$(cd "$skill/../../.." && pwd)"
salida="${1:-$raiz/recursos/skills}"
tmp="$(mktemp -d)"; dest="$tmp/planeacion"
mkdir -p "$dest/assets/plantilla" "$dest/assets/curriculo" "$dest/assets/piloto-filosofia-10"
cp -r "$skill/SKILL.md" "$skill/referencias" "$skill/scripts" "$dest/"
cp "$raiz/curriculo/plantilla/planeacion.cls" "$raiz/curriculo/plantilla/taller-recursos.sty" "$raiz/curriculo/plantilla/compilar.sh" \
   "$raiz/curriculo/plantilla/README.md" "$dest/assets/plantilla/"
cp "$raiz/curriculo/plantilla/ejemplos/malla-ejemplo-con-dba.tex" "$dest/assets/plantilla/"
cp "$raiz/curriculo/MODO-DE-TRABAJO.md" "$raiz/curriculo/README.md" "$raiz/curriculo/FLUJO.md" "$dest/assets/curriculo/"
cp -r "$raiz/curriculo/institucional" "$dest/assets/curriculo/"
mkdir -p "$dest/assets/curriculo/referentes"
cp "$raiz"/curriculo/referentes/*.md "$dest/assets/curriculo/referentes/"
cp "$raiz"/curriculo/filosofia/10/*.tex "$dest/assets/piloto-filosofia-10/"
# Configuración del colegio y del docente (para adaptarla, ver assets/config/LEEME.md)
python3 "$raiz/curriculo/config/configurar.py" >/dev/null
mkdir -p "$dest/assets/config"
cp "$raiz/curriculo/config/colegio.yaml" "$raiz/curriculo/config/docente.yaml" "$raiz/curriculo/config/configurar.py" \
   "$raiz/curriculo/config/logo-colegio.png" "$raiz/curriculo/config/kit-config.tex" "$dest/assets/config/"
cp "$raiz/docs/ADAPTAR.md" "$dest/assets/config/LEEME.md"
mkdir -p "$salida"
(cd "$tmp" && rm -f "$salida/planeacion.zip" && zip -qr "$salida/planeacion.zip" planeacion)
rm -rf "$tmp"
echo "Skill empaquetada: $salida/planeacion.zip ($(du -h "$salida/planeacion.zip" | cut -f1))"
