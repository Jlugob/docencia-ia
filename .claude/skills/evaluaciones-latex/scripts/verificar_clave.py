#!/usr/bin/env python3
"""Revisa un .tex de evaluación antes de entregarlo.

Uso: python3 verificar_clave.py archivo.tex ["1-B 2-C 3-A ..."]

Comprueba:
  1. La clave del .tex (y, si se da, que coincida con la sorteada), su distribución y rachas.
  2. Que cada \\grupo{Responde las preguntas X a Y ...} coincida con la numeración real.
  3. Pistas que delatan la respuesta: la correcta es claramente la opción más larga, o es la
     única que cambia de tono (las demás tienen "siempre", "nunca", "todos"...).
  4. Imágenes referenciadas que no existen en disco.
"""
import os
import re
import sys

ruta = sys.argv[1]
texto = open(ruta, encoding="utf-8").read()
sin_comentarios = re.sub(r"(?<!\\)%.*", "", texto)
avisos = 0


def aviso(msg):
    global avisos
    avisos += 1
    print("AVISO:", msg)


def argumentos(s, i, n):
    """Lee n argumentos {...} desde la posición i (respeta llaves anidadas)."""
    args = []
    while len(args) < n:
        while i < len(s) and s[i] in " \t\n%":
            i += 1
        if i >= len(s) or s[i] != "{":
            return None
        nivel, j = 0, i
        while j < len(s):
            if s[j] == "{" and s[j - 1] != "\\":
                nivel += 1
            elif s[j] == "}" and s[j - 1] != "\\":
                nivel -= 1
                if nivel == 0:
                    break
            j += 1
        args.append(s[i + 1:j])
        i = j + 1
    return args


def largo(t):
    t = re.sub(r"\\[a-zA-Z]+\*?(\[[^\]]*\])?", "", t)
    return len(re.sub(r"[{}$\\]", "", t).strip())


# ---------------------------------------------------------------- 1. clave
letras = re.findall(r"\\begin\{pregunta\}\[([^\]]+)\]", sin_comentarios)
seleccion = [l for l in letras if l != "abierta"]
clave = " ".join(f"{i + 1}-{l}" for i, l in enumerate(letras) if l != "abierta")
print(f"Preguntas: {len(letras)} ({len(seleccion)} de selección, {len(letras) - len(seleccion)} abiertas)")
print("Clave en el .tex:", clave)
print("Distribución:", ", ".join(f"{l}={seleccion.count(l)}" for l in "ABCD"))
s = "".join(seleccion)
rachas = [i + 1 for i in range(len(s) - 2) if s[i] == s[i + 1] == s[i + 2]]
if rachas:
    aviso(f"tres letras iguales seguidas desde la pregunta {rachas}")

# ---------------------------------------------------------------- 2. grupos
eventos = [(m.start(), "p", None) for m in re.finditer(r"\\begin\{pregunta\}", sin_comentarios)]
for m in re.finditer(r"\\grupo\{", sin_comentarios):
    contenido = argumentos(sin_comentarios, m.end() - 1, 1)[0]
    eventos.append((m.start(), "g", contenido))
eventos.sort()
n = 0
for k, (pos, tipo, cont) in enumerate(eventos):
    if tipo == "p":
        n += 1
        continue
    nums = [int(x) for x in re.findall(r"\d+", cont)[:2]]
    if not nums:
        continue
    siguiente = n + 1
    # cuántas preguntas siguen hasta el próximo grupo
    cuenta = 0
    for _, t2, _ in eventos[k + 1:]:
        if t2 == "g":
            break
        cuenta += 1
    if nums[0] != siguiente:
        aviso(f"el grupo «{cont[:60]}» empieza en {nums[0]}, pero la siguiente pregunta es la {siguiente}")
    if len(nums) == 2 and re.search(r"\d+\s*(a|y)\s*\d+", cont) and nums[1] - nums[0] + 1 > cuenta:
        aviso(f"el grupo «{cont[:60]}» llega a la {nums[1]}, pero antes del siguiente bloque solo hay {cuenta} pregunta(s)")

# ---------------------------------------------------------------- 3. pistas en las opciones
bloques = re.split(r"\\begin\{pregunta\}", sin_comentarios)[1:]
num = 0
for b in bloques:
    num += 1
    m = re.match(r"\[([^\]]+)\]", b)
    if not m or m.group(1) == "abierta":
        continue
    correcta = "ABCD".index(m.group(1))
    m2 = re.search(r"\\(opcioneslargas|opciones)\s*(?=\{)", b)
    if not m2:
        continue
    ops = argumentos(b, m2.end(), 4)
    if not ops:
        continue
    l = [largo(o) for o in ops]
    otras = [x for i, x in enumerate(l) if i != correcta]
    if l[correcta] > 25 and l[correcta] >= 1.3 * max(otras):
        aviso(f"pregunta {num}: la correcta ({m.group(1)}) es mucho más larga que las demás "
              f"({l[correcta]} vs. máx. {max(otras)} caracteres); alarga o matiza los distractores")
    absolutos = r"\b(siempre|nunca|todos|todas|ninguno|ninguna|solo|únicamente)\b"
    marcadas = [bool(re.search(absolutos, o, re.I)) for o in ops]
    if sum(marcadas) == 3 and not marcadas[correcta]:
        aviso(f"pregunta {num}: los tres distractores usan absolutos (siempre/nunca/todos...) y la correcta no")

# ---------------------------------------------------------------- 4. imágenes
carpeta = os.path.dirname(os.path.abspath(ruta))
for m in re.finditer(r"\\(?:imagenmarcada|imagen|figura|retrato|includegraphics)(?:\[[^\]]*\])?\{([^}]+)\}", sin_comentarios):
    archivo = m.group(1)
    if not os.path.exists(os.path.join(carpeta, archivo)):
        aviso(f"imagen no encontrada: {archivo}")

# ---------------------------------------------------------------- clave sorteada
if len(sys.argv) > 2:
    esperada = re.findall(r"\d+-([A-D])", sys.argv[2])
    if esperada == seleccion:
        print("OK: coincide con la clave sorteada.")
    else:
        dif = [i + 1 for i, (a, c) in enumerate(zip(esperada, seleccion)) if a != c]
        print("NO COINCIDE con la sorteada en las preguntas:", dif or "(cantidad distinta)")
        sys.exit(1)

print("Sin avisos." if avisos == 0 else f"{avisos} aviso(s): revísalos antes de entregar.")
