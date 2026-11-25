#!/usr/bin/env python3
"""Revisión automática de un taller (segundo cerebro, capa 1).

Uso: python3 revisar_taller.py ruta/al/taller.tex [--duracion 55]

Revisa tiempos, puntos, desempeños, soluciones para el docente, citas, QR, elemento de los
tiempos de la IA e imágenes. Imprime avisos (⚠) y un resumen; código de salida 1 si hay avisos.
"""
import argparse
import os
import re
import sys


def args_de(cmd, texto, n):
    """Devuelve la lista de argumentos obligatorios {…} de cada aparición de \\cmd (n argumentos),
    saltando un argumento opcional [..] o un asterisco."""
    res = []
    for m in re.finditer(r'\\' + cmd + r'(?![A-Za-z])', texto):
        i = m.end()
        if i < len(texto) and texto[i] == '*':
            i += 1
        if i < len(texto) and texto[i] == '[':
            prof = 0
            while i < len(texto):
                if texto[i] == '[':
                    prof += 1
                elif texto[i] == ']':
                    prof -= 1
                    if prof == 0:
                        i += 1
                        break
                i += 1
        partes = []
        for _ in range(n):
            while i < len(texto) and texto[i] in ' \n\t%':
                i += 1
            if i >= len(texto) or texto[i] != '{':
                break
            prof, ini = 0, i
            while i < len(texto):
                if texto[i] == '{' and texto[i - 1] != '\\':
                    prof += 1
                elif texto[i] == '}' and texto[i - 1] != '\\':
                    prof -= 1
                    if prof == 0:
                        partes.append(texto[ini + 1:i])
                        i += 1
                        break
                i += 1
        if len(partes) == n:
            res.append(partes)
    return res


def minutos(s):
    m = re.search(r'(\d+)\s*min', s)
    return int(m.group(1)) if m else 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('tex')
    ap.add_argument('--duracion', type=int, default=55)
    a = ap.parse_args()
    crudo = open(a.tex, encoding='utf-8').read()
    t = '\n'.join(l.split('%')[0] if not l.lstrip().startswith('%') else '' for l in crudo.splitlines())
    avisos, info = [], []

    # Tiempos
    retos = args_de('reto', t, 4)
    pasos = args_de('paso', t, 2)
    total = sum(minutos(r[2]) for r in retos) + sum(minutos(p[0]) for p in pasos)
    gancho = 5 if re.search(r'\\seccion\{1\}\{[^}]*(empezar|gancho)', t, re.I) else 0
    info.append(f'Tiempo: retos/pasos {total} min + gancho ≈{gancho} min = {total + gancho} min (meta {a.duracion})')
    if total + gancho > a.duracion + 5:
        avisos.append(f'El taller suma {total + gancho} min: más de una hora de clase.')
    if total + gancho < a.duracion - 15:
        avisos.append(f'El taller suma solo {total + gancho} min: ¿falta un reto o el cierre?')

    # Puntos: deben sumar 5,0 (la suma es la nota de 0 a 5)
    def num(x):
        x = x.strip().replace(',', '.')
        try:
            return float(x)
        except ValueError:
            return None
    pts = [num(r[3]) for r in retos if num(r[3]) is not None]
    sin_pts = [i + 1 for i, r in enumerate(retos) if num(r[3]) is None]
    total_pts = round(sum(pts), 2)
    info.append(f'Puntos: {total_pts:g} de 5'.replace('.', ','))
    if retos and abs(total_pts - 5) > 0.01:
        avisos.append(f'Los puntos suman {total_pts:g}, no 5: la suma debe ser la nota (0 a 5).'.replace('.', ',', 1))
    if retos and sin_pts:
        avisos.append(f'Punto(s) {sin_pts} sin puntaje.')
    cierre = args_de('cierre', t, 2) or [[c[0], ''] for c in args_de('cierretaller', t, 1)]
    if not cierre:
        avisos.append('Sin \\cierre ni \\cierretaller: falta la nota sobre 5 y el sello.')
    elif num(cierre[0][0]) not in (5.0,):
        avisos.append(f'El cierre dice «{cierre[0][0]}»: debe ser 5,0.')

    # Desempeños
    des = re.findall(r'\\aprendizaje\{(D\d+)\}', t) or sorted(set(re.findall(r'^%.*?\b(D\d+)\b', crudo, re.M)))
    info.append(f'Desempeños: {", ".join(des) or "ninguno"}')
    if not des:
        avisos.append('No se declara ningún desempeño (en el comentario inicial: «% Desempeño: D…»).')

    # Soluciones para el docente
    n_sol = len(re.findall(r'\\sol\{', t)) + len(re.findall(r'\\respuesta(\[\d+\])?\{', t)) \
        + len(re.findall(r'\\hueco\[', t)) + len(re.findall(r'\\op\*', t)) + len(re.findall(r'\\vf\{', t))
    info.append(f'Elementos con solución para el docente: {n_sol}')
    if re.search(r'\\lineas\{', t) and not re.search(r'\\respuesta', t):
        (info if re.search(r'\\begin\{rubrica\}', t) else avisos).append('Usa \\lineas sin \\respuesta: la versión del docente no tendrá respuesta modelo.')
    for env in ('tablataller',):
        for bloque in re.findall(r'\\begin\{' + env + r'\}(.*?)\\end\{' + env + r'\}', t, re.S):
            filas = [f for f in bloque.split('\\\\')[1:] if '&' in f]
            vacias = [f for f in filas if re.search(r'&\s*(?=&|$)', f) and '\\sol' not in f]
            if vacias:
                avisos.append(f'Una tabla tiene {len(vacias)} fila(s) con celdas vacías sin \\sol (¿respuesta del docente?).')

    # Citas y fuentes
    for txt in args_de('texto', t, 3):
        if len(re.sub(r'\s', '', txt[2])) < 8:
            avisos.append(f'\\texto «{txt[0][:30]}» sin referencia exacta.')
    for f in args_de('fuente', t, 2):
        if len(re.sub(r'\s', '', f[1])) < 8:
            avisos.append('\\fuente sin referencia exacta.')
    n_fuentes = len(args_de('texto', t, 3)) + len(args_de('fuente', t, 2))
    info.append(f'Textos citados: {n_fuentes}')

    # Recursos con QR
    for r in args_de('recurso', t, 4):
        url = r[3].strip()
        if not url:
            avisos.append(f'Recurso «{r[1][:40]}» con QR pendiente (sin enlace).')
        elif 'search_query' in url or '/results?' in url:
            info.append(f'Recurso «{r[1][:40]}»: enlace de búsqueda (decirle al docente; reemplazar por el directo si se verifica).')
    # Imágenes
    base = os.path.dirname(os.path.abspath(a.tex))
    for cmd in ('figura', 'imagenmarcada'):
        for m in re.finditer(r'\\' + cmd + r'(?:\[[^\]]*\])?\{([^}]*)\}', t):
            if not os.path.exists(os.path.join(base, m.group(1))):
                avisos.append(f'Imagen no encontrada: {m.group(1)}')

    # Tiempos de la IA
    if not re.search(r'\\respuestaia|inventen|inventa|objeci|propia|de tu vida|municipio|colegio', t, re.I):
        avisos.append('No se ve ningún elemento «tiempos de la IA» (respuesta de IA para corregir, caso propio, objeción del compañero, anclaje en clase).')

    # Instrucciones claras: cada punto con tareas numeradas y el lugar donde se resuelve
    bloques = re.split(r'\\reto(?![A-Za-z])', t)[1:]
    sin_tareas = [i + 1 for i, b in enumerate(bloques) if not re.search(r'\\tarea\{|\\paso\{', b)]
    if bloques and sin_tareas:
        avisos.append(f'Punto(s) {sin_tareas} sin tareas numeradas (\\tarea): lo que deben hacer va en viñetas de número.')
    if bloques and not re.search(r'\\enlahoja|\\encuaderno|\\enhojaaparte|en esta hoja|en el cuaderno|hoja aparte', t, re.I):
        avisos.append('No se dice dónde se resuelve (en esta hoja, en el cuaderno, en una hoja aparte).')
    # No depende de la memoria: cada punto con tareas trae material de apoyo
    apoyo = r'\\recuerda|\\texto\{|\\fuente\{|\\concepto\{|\\figura|\\imagenmarcada|\\respuestaia|\\recurso\{|dialogo|tikzpicture|Ejemplo|ejemplo'
    # (el material de un punto anterior cuenta: está en la misma hoja)
    sin_apoyo, hay = [], False
    for i, b in enumerate(bloques):
        hay = hay or bool(re.search(apoyo, b))
        if re.search(r'\\tarea\{', b) and not hay:
            sin_apoyo.append(i + 1)
    if sin_apoyo:
        avisos.append(f'Punto(s) {sin_apoyo} sin explicación, texto o ejemplo: el taller no debe depender de la memoria (\\recuerda).')
    # Riqueza visual
    if not re.search(r'\\figura|\\imagenlado|\\imagenmarcada|\\euler|tikzpicture', t):
        avisos.append('Sin imágenes ni esquemas: agregar al menos una imagen real con crédito o un esquema (recursos.md).')
    # Inicio directo
    if not re.search(r'\\titulotaller\{', t):
        avisos.append('Falta \\titulotaller{tema}{indicación}: la hoja debe empezar directo con «Taller: tema».')

    print('Revisión del taller:', os.path.basename(a.tex))
    for i in info:
        print('  ·', i)
    for w in avisos:
        print('  ⚠', w)
    if not avisos:
        print('  ✔ Sin avisos.')
    sys.exit(1 if avisos else 0)


if __name__ == '__main__':
    main()
