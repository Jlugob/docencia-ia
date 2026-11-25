#!/usr/bin/env python3
"""Convierte curriculo/config/colegio.yaml y docente.yaml en kit-config.tex, el archivo que leen
las plantillas LaTeX (planeacion.cls, taller-recursos.sty y evaluacion.cls).

Uso: python3 curriculo/config/configurar.py      (los scripts de compilación lo llaman solos)
"""
import os
import re
import sys

try:
    import yaml
except ImportError:  # PyYAML no instalado: avisar con la solución
    sys.exit("Falta PyYAML: pip install pyyaml")

AQUI = os.path.dirname(os.path.abspath(__file__))
SALIDA = os.path.join(AQUI, "kit-config.tex")

ESPECIALES = {"&": r"\&", "%": r"\%", "#": r"\#", "_": r"\_", "$": r"\$", "{": r"\{", "}": r"\}"}


def tex(valor):
    """Escapa los caracteres especiales de LaTeX en un texto de la configuración."""
    return "".join(ESPECIALES.get(c, c) for c in str(valor if valor is not None else ""))


def color(valor, defecto):
    v = str(valor or defecto).lstrip("#").upper()
    if not re.fullmatch(r"[0-9A-F]{6}", v):
        sys.exit(f"Color inválido en colegio.yaml: {valor!r} (use 6 dígitos hexadecimales, p. ej. 003366)")
    return v


def rango(valor, defecto):
    if isinstance(valor, (list, tuple)) and len(valor) == 2:
        return int(valor[0]), int(valor[1])
    if isinstance(valor, int):
        return valor, valor
    return defecto


def leer(nombre):
    ruta = os.path.join(AQUI, nombre)
    if not os.path.exists(ruta):
        return {}
    with open(ruta, encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def main():
    c = leer("colegio.yaml")
    d = leer("docente.yaml")
    col, fmt, per = c.get("colegio", {}) or {}, c.get("formato", {}) or {}, d.get("perfil", {}) or {}

    nombre = col.get("nombre") or "Nombre del colegio"
    leyenda = col.get("leyenda") or f"Este documento es propiedad intelectual del {nombre}"
    encabezado = (fmt.get("encabezado") or "tabla").strip().lower()
    if encabezado not in ("tabla", "sencillo"):
        sys.exit(f"formato.encabezado debe ser «tabla» o «sencillo» (está «{encabezado}»)")
    papel = (fmt.get("papel_planeacion") or "oficio").strip().lower()
    if papel not in ("oficio", "carta"):
        sys.exit(f"formato.papel_planeacion debe ser «oficio» o «carta» (está «{papel}»)")
    # El logo se busca en curriculo/config/ (las plantillas lo encuentran por TEXINPUTS, así que
    # basta el nombre del archivo; kit-config.tex queda portátil, p. ej. para Overleaf).
    logo = col.get("logo") or ""
    ruta_logo = logo if os.path.isabs(logo) else os.path.join(AQUI, logo)
    if logo and not os.path.exists(ruta_logo):
        print(f"Aviso: no encuentro el logo {ruta_logo}; las plantillas pondrán un recuadro «LOGO».")
        logo = ""
    elif logo and os.path.dirname(os.path.abspath(ruta_logo)) == AQUI:
        logo = os.path.basename(ruta_logo)

    qmin, qmax = rango(per.get("quices_por_periodo"), (1, 1))
    tmin, tmax = rango(per.get("talleres_por_periodo"), (1, 3))
    lineas = [
        "% Generado por curriculo/config/configurar.py a partir de colegio.yaml y docente.yaml.",
        "% No editar a mano: los cambios se pierden al compilar.",
        rf"\def\kitcfg@colegio{{{tex(nombre)}}}",
        rf"\def\kitcfg@municipio{{{tex(col.get('municipio') or '')}}}",
        rf"\def\kitcfg@leyenda{{{tex(leyenda)}}}",
        rf"\def\kitcfg@firmainst{{{tex(col.get('firma_institucional') or 'Coordinación académica')}}}",
        rf"\def\kitcfg@logo{{{logo}}}",
        rf"\def\kitcfg@docente{{{tex(d.get('docente') or '')}}}",
        rf"\def\kitcfg@anio{{{tex(d.get('anio') or '')}}}",
        rf"\def\kitcfg@encabezado{{{encabezado}}}",
        rf"\def\kitcfg@papel{{{papel}}}",
        rf"\def\kitcfg@fuente{{{tex(fmt.get('fuente') or 'DejaVu Sans')}}}",
        rf"\def\kitcfg@colinst{{{color(fmt.get('color_institucional'), '003366')}}}",
        rf"\def\kitcfg@colprog{{{color(fmt.get('color_programa'), '2E5B40')}}}",
        rf"\def\kitcfg@colprogdos{{{color(fmt.get('color_programa_2'), '7C8746')}}}",
        rf"\def\kitcfg@coleval{{{color(fmt.get('color_evaluacion'), '166534')}}}",
        rf"\def\kitcfg@entregable{{{1 if per.get('entregable_por_clase', True) else 0}}}",
        rf"\def\kitcfg@quizmin{{{qmin}}}\def\kitcfg@quizmax{{{qmax}}}",
        rf"\def\kitcfg@tallermin{{{tmin}}}\def\kitcfg@tallermax{{{tmax}}}",
        rf"\def\kitcfg@evaluaciones{{{int(per.get('evaluaciones_de_periodo', 1))}}}",
    ]
    nuevo = "\n".join(lineas) + "\n"
    if not os.path.exists(SALIDA) or open(SALIDA, encoding="utf-8").read() != nuevo:
        with open(SALIDA, "w", encoding="utf-8") as f:
            f.write(nuevo)
        print(f"Configuración aplicada: {nombre} · encabezado {encabezado} · papel {papel}")


if __name__ == "__main__":
    main()
