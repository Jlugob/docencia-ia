# Capacidades: todo lo que podemos integrar en un taller

Inventario de lo que el flujo sabe hacer hoy para crear talleres ricos, claros y propios del
colegio. Cada capacidad dice **cómo se usa** y **dónde está**. Probado con
`curriculo/filosofia/10/taller-logica-categorica.tex` (taller completo de ejemplo) y el catálogo
`curriculo/plantilla/ejemplos/catalogo-taller.pdf` (un ejemplo de cada comando).

## 1. Estructura de la hoja (plantilla)

`\documentclass[taller,borrador]{planeacion}` + `curriculo/plantilla/taller-recursos.sty`.

| Pieza | Comando | Notas |
|---|---|---|
| Encabezado del colegio | automático | Logo, «NOMBRE DEL FORMATO: TALLER <año>», página X de Y |
| Ficha | `\fichataller{n}{semana}{duración}{modalidad}` | Nombres y fecha a mano; la duración no se imprime |
| Título | `\titulotaller{Tema}{indicación}` | «Taller: Tema» centrado + dónde se resuelve |
| Puntos | `\reto{0}{título}{tiempo}{puntos}` | 1., 2., 3.… con puntaje; los puntajes suman **5,0** (la nota) |
| Tareas | `tareas` + `\tarea{…}` | 2.1, 2.2…; empiezan por `\enlahoja`, `\encuaderno`, `\enhojaaparte`, `\envozalta` |
| Apartado sin número | `\apartado{Cómo se valora}` | |
| Cierre | `\cierre{5,0}{\logro…}` o `\cierretaller{5,0}` | Nota sobre 5,0 y recuadro del sello |
| Borrador | opción `borrador` | Marca de agua; quitarla en la versión final |

Estilo del perfil: letra en negro (negrita para destacar), tablas en negro con cabecera gris,
verde solo en la barra de los textos, sin estrellas ni tiempos impresos, hasta 4 páginas.

## 2. Textos y explicaciones (para que no dependa de la memoria)

| Qué | Comando | Fuente del contenido |
|---|---|---|
| Fragmento citado | `\texto{Rótulo}{texto}{referencia exacta}` | Obras de dominio público (Platón, Aristóteles, Agustín, Tomás, Moro, Erasmo, Descartes, Carroll…); citas verificadas en `evaluaciones-latex/referencias/filosofia.md`; lecturas de Drive |
| Cita corta | `\fuente{texto}{referencia}` | |
| Diálogo o escena | `dialogo` + `\habla{Personaje}{…}` | Obras, entrevistas, debates |
| Explicación breve | `\recuerda[Título]{…}` | Escrita por nosotros con ejemplo; **no tablas dentro** |
| Glosario | `\concepto{término}{definición}` | |
| Respuesta de IA para corregir | `\respuestaia{…}` | Redactada con errores plausibles (tiempos de la IA) |
| Material cotidiano | dentro de `\texto` o tablas | Refranes, versos de canciones (solo un verso), titulares, normas del colegio, el municipio |

Textos originales: Project Gutenberg y Wikisource si la red de la sesión los permite (hoy
`gutenberg.org` y `standardebooks.org` están bloqueados: citar de memoria solo lo seguro y avisar a
El docente para cotejar). Traducciones propias marcadas «(traducción propia)».

## 3. Imágenes reales

| Fuente | Cómo | Notas |
|---|---|---|
| Wikimedia Commons | `python3 -I .claude/skills/evaluaciones-latex/scripts/wikimedia.py buscar "…"` y `… bajar curriculo/<materia>/<grado>/img "nombre=File:…"` | Obras, retratos, manuscritos, mapas, grabados. Límite 429: una a la vez, en segundo plano |
| Wellcome Collection | `imagenes.py wellcome buscar/bajar` | Grabados y retratos de dominio público; rápido |
| Cualquier URL con licencia libre | `imagenes.py url … --credito "…"` | Si el host no está permitido, pedir al docente que lo agregue a la red |
| Fotogramas de películas | `filmsite.org` (pequeños, como cita) | Ver `evaluaciones-latex/referencias/imagenes.md` |

En la hoja: `\figura[ancho]{img/…}{pie con crédito}`, `\imagenlado[0.3]{img/…}{explicación}`,
`\imagenmarcada[ancho]{img/…}{pie}{x/y/1,…}` (marcas numeradas para analizar detalles).
**Recortar el detalle** que importa con PIL (ej. `img/cuadro-detalle.jpg`). Abrir cada imagen
antes de usarla. Crédito siempre en el pie.

## 4. Esquemas y gráficas (TikZ y pgfplots)

| Esquema | Cómo |
|---|---|
| Diagramas de Euler / Venn | `\euler{código TikZ}{leyenda}` en fila con `\hfill` |
| Cuadros y diagramas para completar | TikZ con estilos `nodo`, `nodovacio` (punteado), `enlace`, `etiqueta`; `\sol{…}` dentro de los nodos vacíos |
| Mapas conceptuales, árboles, líneas de tiempo | TikZ con los mismos estilos |
| Gráficas de datos o funciones | `pgfplots` (`\begin{axis}…`), útil en Tecnología y estadística |

Regla: el esquema ayuda a entender pero **no regala la respuesta** (usar ejemplos distintos a los
ítems evaluados).

## 5. Multimedia por QR

`\recurso{CANCIÓN|VIDEO|PODCAST|LECTURA|JUEGO|MAPA}{título (autor, año)}{qué hacer}{enlace}`.
Verificar el enlace; si no se puede verificar desde la sesión, enlace de búsqueda de YouTube y
avisar al docente. La hoja se puede resolver sin el recurso (el verso o dato clave va impreso).

## 6. Actividades y dinámicas

Catálogo completo en `actividades.md`: traducir a forma técnica, clasificar, relacionar
(`\relacionar`), verdadero o falso (`verdaderofalso`), completar (`\hueco`), selección
(`opciones`), tablas para llenar (`tablataller[altura]`), deducir, detective, analizar una
fuente, corregir a la IA, inventar el caso propio, la objeción del otro, diseñar con riesgos,
debate relámpago; juegos sin preparación (escape en papel, bingo conceptual, duelo de parejas);
pistas (`\pista`).

## 7. Evaluación y versión del docente

- Puntajes por punto que suman 5,0 → la suma es la nota. Rúbrica de 4 niveles (`rubrica`) como
  guía en los talleres de producto.
- **Versión del docente automática**: `compilar.sh` genera `<taller>-docente.pdf`; aparece en
  vino todo lo escrito con `\sol`, `\hueco[…]`, `\respuesta{…}`, `\vf`, `\op*`,
  `\relacionar[…]`.

## 8. Integración con el resto del flujo

| Con | Cómo |
|---|---|
| Malla y parcelación | 1 a 3 talleres por periodo (máximo 3): cada `\clase[t]` tiene su `taller-<k>-P<n>.tex`; desempeño `D…` en el comentario inicial |
| Programa del periodo | El cronograma nombra el taller igual |
| Evaluaciones (`evaluaciones-latex`) | Leen los talleres: lo producido en clase es contexto real para las preguntas |
| Habilitación | `\recuperar{D…}{…}{…}{el Taller k}` remite al taller como repaso |
| Google Drive | PDF a `Planeación/<Materia>/<Grado>°/<Año> – Periodo <n>` (`planeacion/referencias/drive.md`) |
| claude.ai | `recursos/skills/talleres.zip` (`scripts/empaquetar.sh`) |

## 9. Revisión (segundo cerebro)

`python3 .claude/skills/talleres/scripts/revisar_taller.py <taller>.tex` avisa de: tiempo total
fuera de la hora, puntajes que no suman 5,0, falta de nota y sello, desempeño no declarado,
tareas sin numerar o sin decir dónde se resuelven, puntos sin explicación ni material (memoria),
sin imágenes ni esquemas, citas sin referencia, QR pendientes o de búsqueda, imágenes faltantes,
nada de «tiempos de la IA», falta de `\titulotaller`. Luego revisión visual y, si el taller es
nuevo o evaluable, estudiante simulado (`revision.md`).

## 10. Límites conocidos

- Red de la sesión: algunos sitios bloqueados (Gutenberg, Standard Ebooks; YouTube no se puede
  verificar). Se piden con `update_environment` si hacen falta.
- Wikimedia limita descargas (429): paciencia y miniaturas.
- Derechos: citas breves; nada de letras completas ni imágenes con derechos en tamaño grande.
- Dentro de `\recuerda`/`\texto` no van tablas (rompen el salto de página).
