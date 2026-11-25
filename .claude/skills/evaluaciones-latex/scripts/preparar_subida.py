#!/usr/bin/env python3
"""Prepara la subida de evaluaciones a Google Drive (para el comando /subir-drive).

Uso: python3 preparar_subida.py <periodo> [materia ...] [--grados 6,7]
     python3 preparar_subida.py 2026-P4 filosofia --grados 8

Lee evaluaciones/drive.json y los PDF de evaluaciones/<periodo>/, y escribe en pantalla, por cada
archivo: título en Drive, carpeta destino (id o «CREAR: …») y la referencia
sha256:<hash>:<ruta absoluta> que necesita la herramienta create_file del conector.
"""
import argparse
import hashlib
import json
import os
import re
import sys

RAIZ = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../.."))
CONFIG = os.path.join(RAIZ, "evaluaciones", "drive.json")

ap = argparse.ArgumentParser()
ap.add_argument("periodo")
ap.add_argument("materias", nargs="*")
ap.add_argument("--grados")
a = ap.parse_args()

cfg = json.load(open(CONFIG, encoding="utf-8"))
carpeta = os.path.join(RAIZ, "evaluaciones", a.periodo)
if not os.path.isdir(carpeta):
    sys.exit(f"No existe {carpeta}")
grados = set(a.grados.split(",")) if a.grados else None

filas, pendientes = [], set()
for f in sorted(os.listdir(carpeta)):
    m = re.match(r"\d{4}-\d{2}-\d{2}_([a-z]+)-(\d+)(_docente)?\.pdf$", f)
    if not m:
        continue
    materia, grado, docente = m.group(1), m.group(2), bool(m.group(3))
    if a.materias and materia not in a.materias:
        continue
    if grados and grado not in grados:
        continue
    info = cfg["materias"].get(materia)
    if not info:
        print(f"AVISO: la materia «{materia}» no está en drive.json", file=sys.stderr)
        continue
    nombre = info["nombre"]
    if not info.get("id"):
        destino = f"CREAR: carpeta «{nombre}» dentro de Evaluaciones ({cfg['evaluaciones']})"
        pendientes.add(destino)
    else:
        sub = info["periodos"].get(a.periodo)
        if sub == "raiz":
            destino = info["id"]
        elif sub:
            destino = sub
        else:
            anio, per = a.periodo.split("-")
            destino = f"CREAR: carpeta «{anio} {per}» dentro de «{nombre}» ({info['id']})"
            pendientes.add(destino)
    ruta = os.path.join(carpeta, f)
    h = hashlib.sha256(open(ruta, "rb").read()).hexdigest()
    titulo = f"{nombre} {grado}° – {'Docente' if docente else 'Estudiante'}.pdf"
    filas.append({"titulo": titulo, "destino": destino, "bytes": os.path.getsize(ruta),
                  "referencia": f"sha256:{h}:{ruta}"})

if pendientes:
    print("Carpetas por crear (y luego guardar su id en evaluaciones/drive.json):")
    for p in sorted(pendientes):
        print("  -", p)
print(json.dumps(filas, ensure_ascii=False, indent=1))
print(f"{len(filas)} archivo(s).", file=sys.stderr)
