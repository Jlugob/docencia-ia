# Material real: textos, imágenes, canciones, videos

## Textos y fuentes

- Citar con referencia exacta en `\texto{RÓTULO}{contenido}{referencia}` o `\fuente{texto}{ref}`:
  autor, obra, año, capítulo o página; «(traducción propia)» si se traduce, «(adaptado)» si se
  acorta o se moderniza.
- Reutilizar lo ya verificado: `.claude/skills/evaluaciones-latex/referencias/filosofia.md` (citas
  e imágenes descargadas), `curriculo/referentes/` y las lecturas de la carpeta de Drive del
  periodo.
- Obras de dominio público para buscar escenas: Platón, Aristóteles, Agustín, Tomás, Moro, Erasmo,
  Descartes, Carroll (Alicia), Cervantes, fábulas de Esopo y Samaniego, refranero. Texto original
  en Project Gutenberg o Wikisource (si la red lo permite).
- Lo cotidiano es material válido y motivador: refranes, coros de canciones (un verso, no letras
  completas), titulares, publicidad, memes, normas del colegio. Indicar autor/año cuando lo tenga.

## Imágenes y esquemas (riqueza visual)

Los talleres se enriquecen con **imágenes reales** y **esquemas**, siempre con función: que ayuden a
entender o sean material para trabajar (analizar una obra, comparar un manuscrito, leer un mapa).

**Dónde buscar** (las mismas herramientas de las evaluaciones, ver
`evaluaciones-latex/referencias/imagenes.md`):

```bash
S=.claude/skills/evaluaciones-latex/scripts
python3 -I $S/wikimedia.py buscar "Tenniel Mad Tea Party"
python3 -I $S/wikimedia.py bajar curriculo/<materia>/<grado>/img "merienda=File:Alice par John Tenniel 25.png"
python3 -I $S/imagenes.py wellcome buscar "Aristotle"
python3 -I $S/imagenes.py url curriculo/<materia>/<grado>/img nombre "https://..." --credito "Autor, obra, licencia"
```

- Wikimedia Commons limita las descargas (HTTP 429): una a la vez, en segundo plano; el script
  reintenta y, si hace falta, baja una miniatura.
- Guardar en `curriculo/<materia>/<grado>/img/` (queda `creditos.json`). **Abrir cada imagen** y
  comprobar que es lo que dice el título.
- **Detalles**: recortar con PIL la parte que importa (p. ej. el cuadro de oposición dentro de la
  página de un manuscrito: `img/cuadro-detalle.jpg`) y ampliarla con LANCZOS.
- Pie con crédito: autor, obra, año, «Wikimedia Commons, dominio público» (o la licencia).
- Usar: `\figura[ancho]{img/…}{pie}`, `\imagenlado[0.3]{img/…}{explicación}`,
  `\imagenmarcada` para señalar detalles con números.

**Esquemas en TikZ** (cuando no hay imagen o el esquema enseña mejor): diagramas de Euler
(`\euler`), cuadros (cuadro de oposición con `nodo`/`nodovacio`), líneas de tiempo, mapas
conceptuales, árboles. Que **no regalen la respuesta**: usar ejemplos distintos a los ítems que se
evalúan (en el taller de lógica, el diagrama de conversión usa «perros/mamíferos», no las frases de
la tabla).

## Canciones, videos, podcasts (QR)

- `\recurso{TIPO}{Título (autor, año, duración)}{qué hacer con él}{enlace}`. Tipos: CANCIÓN,
  VIDEO, PODCAST, LECTURA, JUEGO, MAPA.
- **Verificar el enlace** antes de imprimir (que abra y sea el recurso correcto). Preferir canales
  oficiales (artista, sello, museo, universidad, MEN, Colombia Aprende, RTVC). Si la red de la sesión no
  permite verificar, usar un enlace de búsqueda de YouTube con el título exacto
  (`https://www.youtube.com/results?search_query=…`) y decírselo al docente para que lo reemplace por
  el enlace directo si quiere.
- Videos de ≤ 5 min o un fragmento con minuto de inicio (`&t=90s`); siempre con una tarea concreta
  mientras se ve o se escucha.
- La hoja debe poder resolverse **sin** el recurso (por si no hay internet en el aula): el verso o
  el dato clave va impreso.
- Con enlace vacío sale «QR pendiente».

## Derechos

Citas breves con fuente para fines educativos; nunca letras completas, capítulos enteros ni
imágenes con derechos en tamaño grande. Fotogramas pequeños como cita (ver `imagenes.md`).
