# Imágenes: dónde buscarlas y cómo usarlas

- Preferir TikZ para esquemas. Para obras de arte, retratos, papiros, fotos: Wikimedia Commons.
- **Fuentes que funcionan desde el entorno** (red «Docencia»):
  1. **Wikimedia Commons** (`wikimedia.py`): la más completa (obras de arte, retratos, mapas,
     manuscritos). Limita mucho (HTTP 429): una descarga a la vez, en segundo plano, con pausas.
     Si el original falla, el script prueba solo miniaturas en tamaños estándar (1280, 960, 500,
     330 px; otros tamaños dan 400).
  2. **Wellcome Collection** (`imagenes.py wellcome ...`): miles de grabados y retratos de
     filósofos, científicos y escenas históricas, casi todos de dominio público; responde rápido.
  3. **URL directa** (`imagenes.py url ...`): cualquier imagen de un host permitido; el crédito se
     escribe a mano con `--credito`.
  4. **Cualquier otro sitio de la web**: busca con WebSearch (p. ej. «<obra> high resolution public
     domain»), abre la página con curl para hallar la URL del archivo y **confirma la licencia**
     (dominio público, «No copyright», CC). Si el host no está permitido (error de red o
     `ENOTFOUND`), propón agregarlo con `get_environment` + `update_environment` (exact hosts) y
     luego descarga con `imagenes.py url`. Ejemplo que funcionó: portada del *Leviatán* desde la
     Pitts Theology Library (`digital.pitts.emory.edu/files/download/original/...`).
     Retratos de pintura clásica: `standardebooks.org/artworks/...` (reproducciones de dominio
     público con prueba de licencia; la imagen está en `/images/artworks/<n>.jpg`).
  5. **Fotogramas de películas**: `www.filmsite.org/<pelicula>.html` (página «Greatest Film
     Scenes») tiene capturas pequeñas (≈160 px): úsalas en una tira de 2–3 fotogramas de ≈1,9 cm
     de alto (ver la tira de `2026-11-14_filosofia-8.tex`), con crédito «fotogramas de <película>
     (<director>, <año>), filmsite.org, uso educativo». Son imágenes con derechos: solo fotogramas
     pequeños, como cita, nunca afiches completos ni capturas grandes.
  - La Biblioteca del Congreso, Gallica, World History Encyclopedia y el Museo Metropolitano bloquean clientes automáticos:
    no intentes saltarte el bloqueo. Para otro sitio, pide al docente que lo agregue a la red del
    entorno (con `update_environment`, que le muestra una tarjeta de aprobación).
  ```bash
  S=.claude/skills/evaluaciones-latex/scripts
  python3 -I $S/wikimedia.py buscar "Socrates Louvre"
  python3 -I $S/wikimedia.py bajar evaluaciones/<año>-P<n>/img/<carpeta> "socrates=File:Socrates Louvre.jpg"
  python3 -I $S/imagenes.py wellcome buscar "Rousseau"
  python3 -I $S/imagenes.py wellcome bajar evaluaciones/<año>-P<n>/img/<carpeta> rousseau=d8zfjkp9
  python3 -I $S/imagenes.py url evaluaciones/<año>-P<n>/img/<carpeta> nombre "https://..." --credito "Autor, obra, licencia"
  ```
  Cada script deja `<nombre>.jpg` (≤ 900 px) y `creditos.json`, e imprime la línea para
  `\creditos{...}`. **Abre cada imagen y compruébala** antes de usarla (el título puede engañar).
  Imágenes de uso común entre grados: `evaluaciones/<año>-P<n>/img/comun/` (ejemplo: `evaluaciones/ejemplos/img/comun/`).
- Si ninguna fuente entrega la imagen a tiempo, dibújala en TikZ (esquema fiel, no imitación) y
  sigue; no retrases la entrega por una imagen.
- Para `\imagenmarcada`, ubica las coordenadas cuadriculando la imagen (PIL) y revisa el PDF.
- Mientras bajan, redacta: `\retrato`, `\figura` e `\imagenmarcada` dejan un recuadro si falta el archivo.
