#!/usr/bin/env python3
"""Segundo cerebro (parte automática): revisión cognitiva de una evaluación.

Uso: python3 revisar_prueba.py archivo.tex [--grado 8] [--minutos 60] [--informe salida.md]

Calcula, a partir del .tex:
  1. Tiempo estimado de resolución según el grado (lectura + decisión + escritura).
  2. Legibilidad (Fernández-Huerta) de contextos y enunciados, comparada con el grado.
  3. Pistas que permiten acertar sin entender («testwiseness»):
     - la correcta es la más larga o la única matizada («puede», «suele», «en parte»…);
     - los distractores usan absolutos y la correcta no;
     - eco del enunciado: la correcta repite más palabras del enunciado que los distractores;
     - copia literal del contexto: la correcta copia una frase del texto y los distractores no;
     - convergencia: la correcta es la opción «central» (comparte más palabras con las otras);
     - negación en el enunciado sin resaltar; «todas/ninguna de las anteriores».
  4. Variedad de formatos y distribución de competencias.

Los perfiles por grado están en referencias/perfiles-cognitivos.md. El informe no reemplaza la
revisión del «estudiante simulado» (ver referencias/revision.md).
"""
import argparse
import re
import statistics
import sys
import unicodedata

# ----------------------------------------------------------------- perfiles por grado
WPM = {6: 110, 7: 120, 8: 130, 9: 140, 10: 150, 11: 160}
SEG_LINEA = {6: 40, 7: 40, 8: 40, 9: 35, 10: 35, 11: 35}
FH_MIN = {6: 70, 7: 65, 8: 60, 9: 55, 10: 50, 11: 50}
GRADOS = {"sexto": 6, "séptimo": 7, "septimo": 7, "octavo": 8, "noveno": 9, "décimo": 10,
          "decimo": 10, "undécimo": 11, "undecimo": 11, "once": 11}
SEG_TIPO = {"seleccion": 35, "afirmaciones": 60, "afirmacionrazon": 60, "diagrama": 50,
            "secuencia": 50}
SEG_FIGURA = 20

STOP = set("""a al algo algunas algunos ante antes aquí así aun aunque bajo cada como con contra
cual cuales cuando de del desde donde dos el ella ellas ellos en entre era es esa ese eso esta
este esto fue ha hay la las le les lo los más mas me mi muy no nos o otra otro para pero poco por
porque que qué se sea según ser si sí sin sino sobre solo su sus también tan tanto te todo tras
un una uno unos y ya yo""".split())
MATIZ = r"\b(puede|pueden|podría|suele|suelen|en parte|a veces|generalmente|en general|probablemente|algunos|algunas|tiende|tienden)\b"
ABSOL = r"\b(siempre|nunca|todos|todas|ninguno|ninguna|nada|jamás|únicamente|completamente|totalmente)\b"


# ----------------------------------------------------------------- utilidades de texto
def argumentos(s, i, n):
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


def limpiar(t):
    """Convierte LaTeX en texto plano aproximado (lo que lee el estudiante)."""
    t = re.sub(r"(?<!\\)%.*", "", t)
    t = re.sub(r"\\begin\{tikzpicture\}.*?\\end\{tikzpicture\}", " ", t, flags=re.S)
    t = re.sub(r"\\begin\{axis\}.*?\\end\{axis\}", " ", t, flags=re.S)
    t = re.sub(r"\\(justificacion|especificacion|modelo)\{", r"\\IGNORAR{", t)
    while "\\IGNORAR{" in t:
        k = t.index("\\IGNORAR{")
        a = argumentos(t, k + len("\\IGNORAR"), 1)
        fin = k + len("\\IGNORAR") + (len(a[0]) + 2 if a else 0)
        t = t[:k] + t[fin:]
    t = re.sub(r"\\(imagenmarcada|figura|retrato|imagen|includegraphics)(\[[^\]]*\])?\{[^}]*\}", " ", t)
    t = re.sub(r"\\[a-zA-Z@]+\*?(\[[^\]]*\])?", " ", t)
    t = re.sub(r"[{}$&~\\^_]", " ", t)
    t = t.replace("«", " ").replace("»", " ")
    return re.sub(r"\s+", " ", t).strip()


def palabras(t):
    return re.findall(r"[a-záéíóúüñA-ZÁÉÍÓÚÜÑ0-9]+", t)


def contenido(t):
    return {quitar_tildes(p.lower()) for p in palabras(t) if len(p) >= 5 and p.lower() not in STOP}


def quitar_tildes(p):
    return "".join(c for c in unicodedata.normalize("NFD", p) if unicodedata.category(c) != "Mn")


def silabas(p):
    p = quitar_tildes(p.lower())
    grupos = re.findall(r"[aeiouy]+", p)
    n = 0
    for g in grupos:   # hiatos fuertes cuentan doble (aproximación)
        n += 1 + len(re.findall(r"[aeo](?=[aeo])", g))
    return max(1, n)


def fernandez_huerta(t):
    ps = palabras(t)
    if len(ps) < 30:
        return None
    oraciones = max(1, len(re.findall(r"[.!?;:]", t)))
    P = 100 * sum(silabas(p) for p in ps) / len(ps)
    F = 100 * oraciones / len(ps)
    return 206.84 - 0.60 * P - 1.02 * F


# ----------------------------------------------------------------- lectura del .tex
def leer(ruta):
    s = open(ruta, encoding="utf-8").read()
    s_sin = re.sub(r"(?<!\\)%.*", "", s)
    grado = None
    m = re.search(r"\\grado\{([^}]*)\}", s_sin)
    if m:
        g = m.group(1).strip().lower()
        grado = GRADOS.get(g) or (int(re.sub(r"\D", "", g)) if re.search(r"\d", g) else None)
    cuerpo = s_sin[s_sin.find("\\begin{preguntas}"):]
    contextos, preguntas = [], []
    pos = 0
    patron = re.compile(r"\\begin\{(contexto|pregunta)\}")
    for m in patron.finditer(cuerpo):
        if m.start() < pos:
            continue
        tipo = m.group(1)
        fin = cuerpo.index("\\end{" + tipo + "}", m.end())
        bloque = cuerpo[m.end():fin]
        pos = fin
        if tipo == "contexto":
            contextos.append({"texto": bloque,
                              "figuras": len(re.findall(r"\\begin\{tikzpicture\}|\\imagenmarcada|\\figura|\\begin\{tabla|tabularx|\\lineadetiempo|\\begin\{historieta|\\begin\{chat", bloque)),
                              "ini": len(preguntas)})
        else:
            preguntas.append(bloque)
    return grado, contextos, preguntas


def analizar_pregunta(b):
    m = re.match(r"\s*\[([^\]]+)\]", b)
    clave = m.group(1) if m else "?"
    d = {"clave": clave, "abierta": clave == "abierta"}
    if d["abierta"]:
        m2 = re.search(r"\\abierta\[(\d+)\]", b)
        lineas = int(m2.group(1)) if m2 else 4
        if "\\tablarellenar" in b:
            n = re.search(r"\\tablarellenar\{(\d+)\}", b)
            lineas += 3 * int(n.group(1)) if n else 6
        d["lineas"] = lineas
        d["texto"] = limpiar(b[m.end():] if m else b)
        return d
    tipo = "seleccion"
    if "\\afirmacionrazon" in b:
        tipo = "afirmacionrazon"
    elif "\\begin{afirmaciones}" in b:
        tipo = "afirmaciones"
    elif "\\opcionesdiagrama" in b:
        tipo = "diagrama"
    elif "\\secuencia" in b:
        tipo = "secuencia"
    d["tipo"] = tipo
    d["figuras"] = len(re.findall(r"\\begin\{tikzpicture\}|\\begin\{axis\}|tabularx", b))
    ops = None
    m3 = re.search(r"\\(opcioneslargas|opciones)\s*(?=\{)", b)
    if m3:
        ops = argumentos(b, m3.end(), 4)
        d["enunciado"] = limpiar(b[(m.end() if m else 0):m3.start()])
    else:
        d["enunciado"] = limpiar(b[(m.end() if m else 0):])
    if tipo == "afirmacionrazon":
        ops = None  # opciones fijas: no aplica el análisis de pistas
    d["opciones"] = [limpiar(o) for o in ops] if ops else None
    d["crudo"] = b
    return d


# ----------------------------------------------------------------- pistas por pregunta
def pistas(d, ctx_texto):
    avisos = []
    ops = d.get("opciones")
    if not ops or d["clave"] not in "ABCD":
        return avisos
    k = "ABCD".index(d["clave"])
    corr, dist = ops[k], [o for i, o in enumerate(ops) if i != k]
    L = [len(o) for o in ops]
    if L[k] > 25 and L[k] >= 1.25 * max(len(o) for o in dist):
        avisos.append(f"la correcta es la más larga ({L[k]} vs. {max(len(o) for o in dist)} caracteres)")
    if len(L) == 4 and statistics.mean(L) > 0 and statistics.pstdev(L) / statistics.mean(L) > 0.35:
        avisos.append("opciones de longitud muy desigual")
    if re.search(MATIZ, corr, re.I) and not any(re.search(MATIZ, o, re.I) for o in dist):
        avisos.append("solo la correcta está matizada («puede», «suele»…)")
    if sum(bool(re.search(ABSOL, o, re.I)) for o in dist) >= 2 and not re.search(ABSOL, corr, re.I):
        avisos.append("los distractores usan absolutos y la correcta no")
    enun = contenido(d.get("enunciado", ""))
    eco = [len(contenido(o) & enun) for o in ops]
    if eco[k] >= 2 and eco[k] > max(e for i, e in enumerate(eco) if i != k):
        avisos.append(f"eco del enunciado: la correcta repite {eco[k]} palabras del enunciado")
    if ctx_texto:
        ctx = " " + quitar_tildes(ctx_texto.lower()) + " "
        def copia(o):
            ps = [quitar_tildes(p.lower()) for p in palabras(o)]
            return any(" ".join(ps[i:i + 5]) in ctx for i in range(max(0, len(ps) - 4)))
        cs = [copia(o) for o in ops]
        if cs[k] and not any(c for i, c in enumerate(cs) if i != k):
            avisos.append("copia literal: solo la correcta reproduce una frase del contexto")
    conj = [contenido(o) for o in ops]
    centr = [sum(len(conj[i] & conj[j]) for j in range(4) if j != i) for i in range(4)]
    if centr[k] >= 3 and centr[k] > max(c for i, c in enumerate(centr) if i != k):
        avisos.append("convergencia: la correcta es la opción que más palabras comparte con las demás")
    en_crudo = d.get("crudo", "")
    m = re.search(r"(cuál|cuáles|qué|quién)[^?]*?(?<!\by )(?<!\bo )\b(no|NO)\b[^?]*\?", d.get("enunciado", ""), re.I)
    if m and not re.search(r"\\textbf\{no\}|\\textbf\{NO\}|\\emph\{no\}", en_crudo):
        avisos.append("negación en el enunciado sin resaltar")
    if any(re.search(r"todas las anteriores|ninguna de las anteriores", o, re.I) for o in ops):
        avisos.append("usa «todas/ninguna de las anteriores»")
    return avisos


# ----------------------------------------------------------------- informe
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("tex")
    ap.add_argument("--grado", type=int)
    ap.add_argument("--minutos", type=int, default=60)
    ap.add_argument("--informe")
    a = ap.parse_args()

    grado_tex, contextos, bloques = leer(a.tex)
    grado = a.grado or grado_tex or 9
    wpm, seg_linea = WPM.get(grado, 140), SEG_LINEA.get(grado, 35)
    preguntas = [analizar_pregunta(b) for b in bloques]

    # contexto de cada pregunta (el último contexto anterior a ella)
    ctx_de = {}
    for c in contextos:
        for i in range(c["ini"], len(preguntas)):
            ctx_de[i] = c
    lineas_inf = []
    out = lineas_inf.append

    # 1. tiempo
    pal_ctx = sum(len(palabras(limpiar(c["texto"]))) for c in contextos)
    pal_preg = sum(len(palabras(p.get("enunciado", p.get("texto", "")))) +
                   sum(len(palabras(o)) for o in (p.get("opciones") or [])) for p in preguntas)
    t_lectura = (pal_ctx + pal_preg) / wpm * 60
    t_figuras = SEG_FIGURA * (sum(c["figuras"] for c in contextos) + sum(p.get("figuras", 0) for p in preguntas if not p["abierta"]))
    t_decidir = sum(SEG_TIPO[p["tipo"]] for p in preguntas if not p["abierta"])
    t_escribir = sum(p["lineas"] * seg_linea for p in preguntas if p["abierta"])
    total = (t_lectura + t_figuras + t_decidir + t_escribir) / 60
    pct = 100 * total / a.minutos
    out(f"# Revisión cognitiva: {a.tex.split('/')[-1]} (grado {grado}.°)\n")
    out("## Tiempo estimado\n")
    out(f"| Parte | Minutos |\n|---|---|")
    out(f"| Leer contextos y preguntas ({pal_ctx + pal_preg} palabras a {wpm} pal/min) | {t_lectura/60:.0f} |")
    out(f"| Interpretar figuras, tablas y gráficas | {t_figuras/60:.0f} |")
    out(f"| Pensar y decidir (selección) | {t_decidir/60:.0f} |")
    out(f"| Escribir las abiertas | {t_escribir/60:.0f} |")
    out(f"| **Total** | **{total:.0f} de {a.minutos} ({pct:.0f} %)** |\n")
    if pct > 100:
        veredicto = "DEMASIADO LARGA: recortar texto de contextos o líneas de las abiertas."
    elif pct > 90:
        veredicto = "justa: casi no deja tiempo para revisar; conviene recortar un poco."
    elif pct < 60:
        veredicto = "corta: hay margen para un contexto más rico o una pregunta más exigente."
    else:
        veredicto = "adecuada (entre 60 % y 90 % del tiempo)."
    out(f"Veredicto: {veredicto}\n")

    # 2. legibilidad
    out("## Legibilidad (Fernández-Huerta)\n")
    minimo = FH_MIN.get(grado, 55)
    out(f"Mínimo recomendado para {grado}.°: {minimo}. Los fragmentos originales pueden estar por debajo si son cortos.\n")
    out("| Contexto | Palabras | Índice | Nota |\n|---|---|---|---|")
    for n, c in enumerate(contextos, 1):
        txt = limpiar(c["texto"])
        fh = fernandez_huerta(txt)
        nota = "" if fh is None or fh >= minimo else ("difícil para el grado" if fh >= minimo - 15 else "muy difícil para el grado")
        titulo = re.match(r"\s*\[([^\]]*)\]", c["texto"])
        out(f"| {n}. {limpiar(titulo.group(1))[:40] if titulo else ''} | {len(palabras(txt))} | {fh:.0f} | {nota} |" if fh else
            f"| {n}. {limpiar(titulo.group(1))[:40] if titulo else ''} | {len(palabras(txt))} | — | |")
    largos = [p for p in preguntas if not p["abierta"] and len(palabras(p["enunciado"])) > 60]
    if largos:
        out(f"\nEnunciados de más de 60 palabras: {len(largos)} (revisar si la extensión es necesaria).")

    # 3. pistas
    out("\n## Pistas que permiten acertar sin entender\n")
    total_avisos = 0
    for i, p in enumerate(preguntas):
        if p["abierta"]:
            continue
        ctx = limpiar(ctx_de[i]["texto"]) if i in ctx_de else ""
        av = pistas(p, ctx)
        if av:
            total_avisos += len(av)
            out(f"- **Pregunta {i+1}** ({p['clave']}): " + "; ".join(av))
    if total_avisos == 0:
        out("Ninguna pista detectada.")
    claves = "".join(p["clave"] for p in preguntas if not p["abierta"])
    dist = {l: claves.count(l) for l in "ABCD"}
    out(f"\nDistribución de claves: {dist}.")

    # 4. variedad
    out("\n## Variedad y competencias\n")
    tipos = {}
    for p in preguntas:
        t = "abierta" if p["abierta"] else p["tipo"]
        tipos[t] = tipos.get(t, 0) + 1
    out("Formatos de pregunta: " + ", ".join(f"{k} {v}" for k, v in tipos.items()))
    fmt_ctx = set()
    for c in contextos:
        for f, pat in [("fragmentos", r"\\fragmento"), ("retratos/figuras", r"\\retrato|\\figura|\\imagen"),
                       ("imagen marcada", r"\\imagenmarcada"), ("línea de tiempo", r"\\lineadetiempo"),
                       ("tabla", r"tabularx|\\begin\{tabla"), ("gráfica", r"\\begin\{axis\}"),
                       ("historieta", r"historieta"), ("chat", r"\\begin\{chat"), ("diálogo", r"\\begin\{dialogo"),
                       ("esquema TikZ", r"\\begin\{tikzpicture\}")]:
            if re.search(pat, c["texto"]):
                fmt_ctx.add(f)
    out(f"Recursos en los contextos ({len(fmt_ctx)}): " + ", ".join(sorted(fmt_ctx)))
    comp = {}
    for b in bloques:
        m = re.search(r"\\especificacion\{([^}]*)\}", b)
        if m:
            comp[m.group(1)] = comp.get(m.group(1), 0) + 1
    if comp:
        out("Competencias: " + ", ".join(f"{k} {v}" for k, v in comp.items()))

    informe = "\n".join(lineas_inf)
    if a.informe:
        open(a.informe, "w", encoding="utf-8").write(informe + "\n")
    print(informe)
    print(f"\nResumen: {total:.0f} min estimados ({pct:.0f} %), {total_avisos} pista(s) detectada(s).")


if __name__ == "__main__":
    main()
