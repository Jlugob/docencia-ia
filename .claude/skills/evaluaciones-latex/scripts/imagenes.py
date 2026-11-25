#!/usr/bin/env python3
"""Busca y descarga imágenes de colecciones abiertas o de una URL directa, con sus créditos.

Fuentes (deben estar permitidas en la red del entorno «Docencia»):
  wellcome  Wellcome Collection: grabados, retratos, ciencia e historia (casi todo dominio público)
  url       Cualquier URL directa de imagen (de un host permitido); el crédito se escribe a mano
  (Wikimedia Commons tiene su propio script: wikimedia.py)

Ejemplos:
  python3 -I imagenes.py wellcome buscar "Rousseau"
  python3 -I imagenes.py wellcome bajar evaluaciones/2026-P4/img/filosofia8 rousseau=d8zfjkp9
  python3 -I imagenes.py url evaluaciones/2026-P4/img/x nombre "https://.../imagen.jpg" \\
          --credito "Autor, Obra (año), Institución, dominio público"

Cada imagen se guarda como <carpeta>/<nombre>.jpg (≤ 900 px, calidad 85, sin metadatos) y sus
datos en <carpeta>/creditos.json. Al final imprime la línea para \\creditos{...}.
Si un host responde 403/000, no está permitido en la red del entorno o bloquea clientes
automáticos (Cloudflare): Biblioteca del Congreso, Gallica y el Met lo hacen. No intentes
saltarte esos bloqueos (p. ej. cambiando el User-Agent): usa Wikimedia, Wellcome o TikZ.
"""
import json
import os
import subprocess
import sys
import time
import urllib.parse
import urllib.request

UA = {"User-Agent": "DocenciaEvaluaciones/1.0 (material escolar; uso educativo)"}


def pedir(url, intentos=4, binario=False):
    for k in range(intentos):
        try:
            req = urllib.request.Request(url, headers=UA)
            return urllib.request.urlopen(req, timeout=60).read()
        except urllib.error.HTTPError as e:
            if e.code in (403, 404):
                print(f"  HTTP {e.code}: {url}")
                return None
            espera = 20 * (k + 1)
            print(f"  reintento {k + 1} en {espera}s (HTTP {e.code})", flush=True)
            time.sleep(espera)
        except Exception as e:
            print(f"  error de red ({e}); ¿el host está permitido en el entorno?", flush=True)
            time.sleep(10)
    return None


def guardar(carpeta, nombre, binario, credito):
    os.makedirs(carpeta, exist_ok=True)
    destino = os.path.join(carpeta, nombre + ".jpg")
    crudo = destino + ".orig"
    open(crudo, "wb").write(binario)
    r = subprocess.run(["convert", crudo + "[0]", "-resize", "900x900>", "-quality", "85",
                        "-strip", "-background", "white", "-flatten", destino])
    os.remove(crudo)
    if r.returncode != 0:
        print(f"FALLÓ la conversión de {nombre} (¿no era una imagen?)")
        return
    ruta = os.path.join(carpeta, "creditos.json")
    cred = json.load(open(ruta)) if os.path.exists(ruta) else {}
    cred[nombre] = credito
    json.dump(cred, open(ruta, "w"), ensure_ascii=False, indent=1)
    print(f"OK {nombre}: {credito['texto']}")


def imprimir_creditos(carpeta):
    ruta = os.path.join(carpeta, "creditos.json")
    if os.path.exists(ruta):
        cred = json.load(open(ruta))
        print("\nCréditos para \\creditos{...}:")
        print("; ".join(f"{n}: {c.get('texto') or c.get('autor', '')}" for n, c in cred.items()) + ".")


# ------------------------------------------------------------------ Wellcome Collection
def wellcome_buscar(q):
    url = ("https://api.wellcomecollection.org/catalogue/v2/images?pageSize=12&query="
           + urllib.parse.quote(q))
    datos = pedir(url)
    if not datos:
        sys.exit("Sin respuesta de Wellcome.")
    for r in json.loads(datos).get("results", []):
        loc = r.get("locations", [{}])[0]
        print(f"{r['id']}  [{loc.get('license', {}).get('id')}]  {r['source'].get('title', '')[:100]}")


def wellcome_bajar(carpeta, pares):
    for par in pares:
        nombre, ident = par.split("=", 1)
        datos = pedir(f"https://api.wellcomecollection.org/catalogue/v2/images/{ident}")
        if not datos:
            continue
        r = json.loads(datos)
        loc = r.get("locations", [{}])[0]
        base = loc["url"].rsplit("/info.json", 1)[0]
        binario = pedir(base + "/full/900,/0/default.jpg")
        if not binario:
            continue
        lic = loc.get("license", {}).get("label", "")
        titulo = r["source"].get("title", "")
        guardar(carpeta, nombre, binario, {
            "fuente": f"Wellcome Collection ({ident})", "titulo": titulo, "licencia": lic,
            "texto": f"{titulo}, Wellcome Collection ({lic})"})
        time.sleep(2)
    imprimir_creditos(carpeta)


# ------------------------------------------------------------------ URL directa
def url_bajar(carpeta, nombre, url, credito):
    binario = pedir(url)
    if not binario:
        sys.exit("No se pudo descargar (¿host no permitido o URL incorrecta?).")
    guardar(carpeta, nombre, binario, {"fuente": url, "texto": credito or f"Fuente: {url}"})
    imprimir_creditos(carpeta)


if __name__ == "__main__":
    a = sys.argv[1:]
    try:
        if a[:2] == ["wellcome", "buscar"]:
            wellcome_buscar(" ".join(a[2:]))
        elif a[:2] == ["wellcome", "bajar"]:
            wellcome_bajar(a[2], a[3:])
        elif a[0] == "url":
            cred = a[a.index("--credito") + 1] if "--credito" in a else ""
            url_bajar(a[1], a[2], a[3], cred)
        else:
            raise IndexError
    except (IndexError, ValueError):
        print(__doc__)
