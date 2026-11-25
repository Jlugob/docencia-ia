#!/usr/bin/env python3
"""Sortea la clave de una evaluación: letras A-D parejas, sin rachas ni secuencias obvias.

Uso: python3 sortear_clave.py [numero_de_preguntas_de_seleccion]   (por defecto 16)
"""
import random
import sys

n = int(sys.argv[1]) if len(sys.argv) > 1 else 16
base = [l for i in range(n) for l in "ABCD"[i % 4]]
prohibidas = ("ABC", "BCD", "DCB", "CBA")

for _ in range(100000):
    random.shuffle(base)
    s = "".join(base)
    sin_rachas = all(not (s[i] == s[i + 1] == s[i + 2]) for i in range(n - 2))
    if sin_rachas and not any(p in s for p in prohibidas):
        break

print(" ".join(f"{i + 1}-{c}" for i, c in enumerate(s)))
print("Distribución:", ", ".join(f"{l}={s.count(l)}" for l in "ABCD"))
