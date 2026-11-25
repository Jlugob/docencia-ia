#!/usr/bin/env python3
"""Descarga una norma del Gestor Normativo de Función Pública (texto vigente con notas de
modificación) y la guarda como texto plano.

El servidor de Función Pública (y el de SUIN-Juriscol) envía su certificado sin el intermedio
correcto. En vez de desactivar la verificación, este script completa la cadena con los
certificados intermedios oficiales (Let's Encrypt YR1 + Root YR firmado por ISRG X1, y Sectigo EV
R36) y verifica normalmente.

Uso:
  python3 gestor_normativo.py <id> [salida.txt]       # id = parámetro i= de norma.php
  python3 gestor_normativo.py 292 ley115.txt            # Ley 115 de 1994
Ids útiles: 292 Ley 115/1994 · 77913 Decreto 1075/2015 · 261856 Ley 2503/2025
Requiere red hacia www.funcionpublica.gov.co, letsencrypt.org y crt.sh.
"""
import html, os, re, subprocess, sys, urllib.request, ssl

CA_DIR = os.path.expanduser("~/.local/share/ca-normativa")
CA = os.path.join(CA_DIR, "ca.pem")
INTERMEDIOS = [
    "https://letsencrypt.org/certs/gen-y/int-yr1.pem",
    "https://letsencrypt.org/certs/gen-y/root-yr-by-x1.pem",
    "https://crt.sh/?d=4267304687",  # Sectigo Public Server Authentication CA EV R36 (SUIN)
]
BASE = os.environ.get("SSL_CERT_FILE") or "/root/.ccr/ca-bundle.crt"


def bajar(url, ctx=None):
    with urllib.request.urlopen(url, timeout=120, context=ctx) as r:
        return r.read()


def preparar_ca():
    if os.path.exists(CA):
        return
    os.makedirs(CA_DIR, exist_ok=True)
    partes = [open(BASE).read()] if os.path.exists(BASE) else []
    for u in INTERMEDIOS:
        partes.append(bajar(u).decode())
    open(CA, "w").write("\n".join(partes))


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    preparar_ca()
    ctx = ssl.create_default_context(cafile=CA)
    url = f"https://www.funcionpublica.gov.co/eva/gestornormativo/norma.php?i={sys.argv[1]}"
    t = bajar(url, ctx).decode("utf-8", "ignore")
    t = re.sub(r"<script.*?</script>|<style.*?</style>", "", t, flags=re.S)
    t = html.unescape(re.sub(r"<[^>]+>", "\n", t))
    t = re.sub(r"[ \t]+", " ", re.sub(r"\n\s*\n+", "\n", t))
    salida = sys.argv[2] if len(sys.argv) > 2 else f"norma-{sys.argv[1]}.txt"
    open(salida, "w").write(f"# Fuente: {url}\n\n{t}")
    print(f"{salida}: {len(t)} caracteres")


if __name__ == "__main__":
    main()
