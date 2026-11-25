#!/usr/bin/env python3
"""Busca y descarga imágenes de Wikimedia Commons con sus créditos.

Wikimedia limita mucho las descargas (HTTP 429): este script hace una petición a la vez,
espera entre descargas y reintenta con pausas crecientes. Conviene correrlo en segundo plano.

Buscar títulos de archivo:
    python3 wikimedia.py buscar "Heraclitus Moreelse"

Descargar (nombre_local=Título exacto del archivo):
    python3 wikimedia.py bajar evaluaciones/2026-P4/img/filosofia7 \\
        "socrates=File:Socrates Louvre.jpg" "atenas=File:Sanzio 01.jpg"

Cada imagen se guarda como <carpeta>/<nombre>.jpg (máx. 900 px, calidad 85, sin metadatos)
y sus datos quedan en <carpeta>/creditos.json. Al final imprime una línea de créditos lista
para pegar en \\creditos{...} (revísala: autor y licencia vienen de Commons).
"""
import json
import os
import re
import subprocess
import sys
import time
import urllib.parse
import urllib.request

API = "https://commons.wikimedia.org/w/api.php"
UA = {"User-Agent": "DocenciaEvaluaciones/1.0 (material escolar; uso educativo)"}


def pedir(url, intentos=7):
    for k in range(intentos):
        try:
            req = urllib.request.Request(url, headers=UA)
            return urllib.request.urlopen(req, timeout=60).read()
        except Exception as e:  # 429, timeouts...
            espera = 30 * (k + 1)
            print(f"  reintento {k + 1} en {espera}s ({e})", flush=True)
            time.sleep(espera)
    return None


def limpiar(html):
    return re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", html or "")).strip()


def buscar(consulta):
    q = urllib.parse.urlencode({"action": "query", "list": "search", "srnamespace": 6,
                                "srlimit": 10, "format": "json", "srsearch": consulta})
    datos = pedir(f"{API}?{q}")
    if not datos:
        sys.exit("No se pudo consultar Wikimedia.")
    for r in json.loads(datos)["query"]["search"]:
        print(r["title"])


def bajar(carpeta, pares):
    os.makedirs(carpeta, exist_ok=True)
    ruta_cred = os.path.join(carpeta, "creditos.json")
    cred = json.load(open(ruta_cred)) if os.path.exists(ruta_cred) else {}
    for par in pares:
        nombre, titulo = par.split("=", 1)
        destino = os.path.join(carpeta, nombre + ".jpg")
        if os.path.exists(destino) and nombre in cred:
            print(f"Ya existe: {nombre}")
            continue
        q = urllib.parse.urlencode({"action": "query", "format": "json", "prop": "imageinfo",
                                    "iiprop": "url|extmetadata", "titles": titulo})
        datos = pedir(f"{API}?{q}")
        if not datos:
            print(f"FALLÓ (metadatos): {nombre}", flush=True)
            continue
        pagina = next(iter(json.loads(datos)["query"]["pages"].values()))
        if "imageinfo" not in pagina:
            print(f"NO EXISTE en Commons: {titulo}", flush=True)
            continue
        info = pagina["imageinfo"][0]
        meta = info.get("extmetadata", {})
        cred[nombre] = {
            "titulo": titulo,
            "autor": limpiar(meta.get("Artist", {}).get("value")),
            "licencia": limpiar(meta.get("LicenseShortName", {}).get("value")),
            "fecha": limpiar(meta.get("DateTimeOriginal", {}).get("value"))[:40],
            "descripcion": limpiar(meta.get("ImageDescription", {}).get("value"))[:200],
        }
        time.sleep(15)
        binario = pedir(info["url"].split("?")[0], intentos=3)
        if not binario:
            # Plan B: miniaturas en los tamaños estándar que Wikimedia sirve (https://w.wiki/GHai)
            original = info["url"].split("?")[0]
            ruta = original.split("/wikipedia/commons/")[1]
            archivo = ruta.rsplit("/", 1)[1]
            for ancho in (1280, 960, 500, 330):
                url_min = f"https://upload.wikimedia.org/wikipedia/commons/thumb/{ruta}/{ancho}px-{archivo}"
                print(f"  probando miniatura de {ancho} px", flush=True)
                binario = pedir(url_min, intentos=2)
                if binario and not binario.lstrip().startswith(b"<"):
                    break
                binario = None
        if not binario:
            print(f"FALLÓ (descarga): {nombre}", flush=True)
            continue
        crudo = destino + ".orig"
        open(crudo, "wb").write(binario)
        subprocess.run(["convert", crudo + "[0]", "-resize", "900x900>", "-quality", "85",
                        "-strip", "-background", "white", "-flatten", destino], check=False)
        os.remove(crudo)
        json.dump(cred, open(ruta_cred, "w"), ensure_ascii=False, indent=1)
        print(f"OK {nombre}: {cred[nombre]['autor']} ({cred[nombre]['licencia']})", flush=True)
        time.sleep(25)

    partes = []
    for nombre, c in cred.items():
        lic = c["licencia"].replace("Public domain", "dominio público")
        partes.append(f"{nombre}: {c['autor'] or 'autor desconocido'} ({lic})")
    print("\nCréditos para \\creditos{...}:")
    print("Imágenes de Wikimedia Commons. " + "; ".join(partes) + ".")
    print("FIN")


if __name__ == "__main__":
    if len(sys.argv) >= 3 and sys.argv[1] == "buscar":
        buscar(" ".join(sys.argv[2:]))
    elif len(sys.argv) >= 4 and sys.argv[1] == "bajar":
        bajar(sys.argv[2], sys.argv[3:])
    else:
        print(__doc__)
