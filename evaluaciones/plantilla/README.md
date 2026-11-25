# Plantilla LaTeX de evaluaciones

Formato de evaluaciones configurable (colegio, logo y color en `curriculo/config/colegio.yaml`) (el mismo del generador de evaluaciones de
SistemAcadémico): membrete con el logo del colegio, datos del estudiante, preguntas de selección
A–D, preguntas abiertas con líneas, lecturas compartidas, tablas, código, diagramas de Venn,
silogismos, imágenes, autoevaluación y clave de respuestas automática.

| Archivo | Qué es |
|---|---|
| `evaluacion.cls` | La clase con todo el formato. No hace falta editarla |
| `evaluacion-ejemplo.tex` | Evaluación de muestra con todos los elementos: cópiala para empezar una nueva |
| `logo-colegio.png` | Logo del colegio que sale en el membrete |
| `evaluacion-extras.sty` | Paquete opcional con formatos adicionales (ver «Extras») |
| `catalogo-formatos.tex` / `.pdf` | Catálogo con un ejemplo de cada formato (y versión `_docente`) |

## Compilar

- **Motor**: pdfLaTeX (recomendado). También compila con XeLaTeX o LuaLaTeX.
- Compila **dos veces** para que salga bien el "Página X de Y":

```bash
pdflatex evaluacion-ejemplo.tex
pdflatex evaluacion-ejemplo.tex
```

- La evaluación nueva va en esta misma carpeta, junto a `evaluacion.cls` y `logo-colegio.png`.
- En Windows sirve MiKTeX (descarga solo los paquetes que falten). En Overleaf: sube los tres
  archivos y deja el compilador en pdfLaTeX.
- Paquetes que usa (vienen en MiKTeX y TeX Live): `babel` (spanish), `geometry`, `xcolor`,
  `tabularx`, `multirow`, `multicol`, `enumitem`, `fancyhdr`, `lastpage`, `listings`, `tikz`,
  `tcolorbox`, `hyperref`, `amsmath`.

## Fuentes

No necesita instalar fuentes:

- Con **pdfLaTeX** usa Helvetica (paquete `helvet`, incluido en toda distribución de LaTeX) como
  letra del documento, y la mono de Computer Modern para el código.
- Con **XeLaTeX/LuaLaTeX** usa DejaVu Sans si está instalada en el equipo (la misma letra de los
  PDF de la plataforma); si no, la sans por defecto.

## Cambiar los datos del encabezado

Colegio, logo, color y docente salen solos de `curriculo/config/colegio.yaml` y `docente.yaml`
(al compilar con `.claude/skills/evaluaciones-latex/scripts/compilar.sh`). Para cambiarlos en un
documento, o si se usa la plantilla sola (p. ej. en Overleaf), al inicio del `.tex`, antes de
`\begin{document}`:

```latex
\colegio{Nombre del colegio}
\logo{logo-colegio.png}
\colorcolegio{166534}            % color del nombre del colegio, hexadecimal sin #
\asignatura{Matemáticas}
\grado{Séptimo}
\periodo{Cuarto periodo}
\anio{2026}
\docente{Nombre del docente}
% \fecha{2026-11-20}             % si se omite, queda una línea para escribir
% \estudiante{...}               % si se omite, queda una línea para escribir
% \titulo{...}                   % si se omite: "Evaluación general de <asignatura>"
\instrucciones{Lee con atención cada pregunta...}
```

## Opciones de la clase

```latex
\documentclass[carta,doscolumnas,compacta]{evaluacion}
```

- Papel: `carta` (por defecto) o `a4`.
- Columnas: `doscolumnas` (por defecto) o `unacolumna`.
- Densidad: `normal`, `compacta` (por defecto) o `muycompacta`.
- `solucion`: encierra en un círculo la respuesta correcta de cada pregunta (versión del docente).
- `sinautoevaluacion`: omite el recuadro de autoevaluación.

## Datos del encabezado

```latex
\colegio{Nombre del colegio}
\logo{logo-colegio.png}
\colorcolegio{166534}           % hexadecimal, sin #
\asignatura{Matemáticas}
\grado{Noveno}
\periodo{Tercer periodo}
\anio{2026}
\docente{Nombre del docente}
\fecha{}                        % vacío = línea para escribir
\estudiante{}                   % vacío = línea para escribir
\titulo{}                       % vacío = "Evaluación general de <asignatura>"
\instrucciones{Lee con atención...}
```

## Comandos

| Elemento | Cómo se escribe |
|---|---|
| Inicio | `\encabezado` y luego `\begin{preguntas} ... \end{preguntas}` |
| Pregunta de selección | `\begin{pregunta}[B] Enunciado \opciones{A}{B}{C}{D} \end{pregunta}` (`[B]` = correcta) |
| Opciones largas | `\opcioneslargas{A}{B}{C}{D}` (una por renglón) |
| Opciones con código, tablas o imágenes | `\begin{opcioneslista} \item ... \item ... \item ... \item ... \end{opcioneslista}` |
| Opciones que son diagramas | `\opcionesdiagrama{\venn[...]{S,M,P}}{...}{...}{...}` (rejilla 2×2) |
| Pregunta abierta | `\begin{pregunta}[abierta] Enunciado \abierta[5] \modelo{respuesta} \end{pregunta}` |
| Lectura compartida | `\begin{contexto}[Título] \grupo{Responde las preguntas 1 a 3...} Texto \end{contexto}` |
| Tabla | `\begin{tabla}[Título]{\|l\|c\|} \encabezados A & B \fila 1 & 2 \fila \end{tabla}` |
| Código | `\begin{codigo}[language=Python] ... \end{codigo}` (también `pseint`, `Java`, `C`, `HTML`...) |
| Código en línea | `\cod{x = 3}` |
| Imagen | `\imagen[0.8]{archivo.png}` (ancho = fracción de la columna; si falta, deja un recuadro) |
| Diagrama de Venn | `\venn[sombreado={SM,S}, marcas={SP}, titulo={...}, escala=0.6]{S,M,P}` |
| Silogismo | `\silogismo{Premisa mayor}{Premisa menor}{Conclusión}` |
| Final | `\autoevaluacion` y `\imprimirclave` (la clave sale sola en la última página) |

Las preguntas **nunca se parten** entre columnas ni páginas. Cualquier TikZ, `pgfplots`,
`chemfig`, `circuitikz` o fórmula (`$...$`, `\[...\]`) funciona dentro de una pregunta.

### Diagramas de Venn

- 2 o 3 conjuntos de una letra. Con 3, el 1.º va arriba a la izquierda, el 2.º abajo y el 3.º
  arriba a la derecha (`{S,M,P}` = la disposición clásica del silogismo).
- Una **región** se nombra con las letras que están *dentro* de ella, en el orden de los
  conjuntos: con `S,M,P`, `S` es "solo S", `SM` es "S y M pero no P", `SMP` es el centro.
- `sombreado` = regiones vacías (trama diagonal). `marcas` = una × en la región;
  `SP|SMP` la pone sobre la línea entre dos regiones.
- Reglas para silogismos (S sujeto, P predicado, M término medio):
  - **A** "Todo X es Y" → sombrear las regiones de X que no están en Y.
  - **E** "Ningún X es Y" → sombrear las regiones de X∩Y.
  - **I** "Algún X es Y" → × en X∩Y (si una de las dos partes está sombreada, en la otra;
    si ninguna, sobre la línea).
  - **O** "Algún X no es Y" → × en X fuera de Y, con el mismo criterio.

### Clave de respuestas

Cada `\begin{pregunta}[letra]` se anota sola. `\imprimirclave` agrega una última página con la
clave en texto plano (`1-B, 2-A, 3-abierta…`), la rejilla y las respuestas modelo de las
abiertas. Para imprimir el examen sin la clave, imprime todas las páginas menos la última.

## Extras (`evaluacion-extras.sty`)

Se carga después de la clase: `\usepackage{evaluacion-extras}` (o `../plantilla/evaluacion-extras`
desde otra carpeta). No cambia nada de la clase; agrega:

| Elemento | Cómo se escribe |
|---|---|
| Fragmento citado con fuente | `\fragmento{texto}{Autor, \emph{Obra} pasaje}` (`\fragmento*` sin comillas) |
| Retrato con texto al lado | `\retrato[0.30]{img/x.jpg}{pie}{texto}` |
| Figura con pie | `\figura[0.9]{img/x.jpg}{pie}` |
| Imagen con marcas numeradas | `\imagenmarcada{img/x.jpg}{pie}{0.47/0.63/1, 0.55/0.63/2}` |
| Línea de tiempo | `\lineadetiempo[desde=-650,hasta=450,paso=200,franjas={-624/-399/presocráticos}]{-624/Tales/1, 360/Hipatia/1}` |
| Cadena de pasos | `\cadena[resaltar=aire]{fuego,aire,viento,nube}` |
| Historieta | `\begin{historieta}[2] \vineta{Ana}{texto} \vineta[derecha]{Leo}{texto} \end{historieta}` |
| Chat simulado | `\begin{chat}[Grupo 7.° B] \mensaje{Camila}{...} \respuesta{Tú}{...} \end{chat}` |
| Diálogo | `\begin{dialogo} \habla{Sócrates}{...} \end{dialogo}` |
| Textos en contraste | `\texto{Texto 1 · Autor}{contenido}` |
| Concepto o glosario | `\concepto{Arjé}{definición}` |
| Secuencia para ordenar | `\secuencia{a}{b}{c}{d}` + opciones `\opciones{2-1-4-3}{...}{...}{...}` |
| Afirmaciones I, II, III | `\begin{afirmaciones} \item ... \end{afirmaciones}` |
| Afirmación y razón | `\afirmacion{afirmación}{razón}` + `\afirmacionrazon` |
| Mapa conceptual | estilos TikZ `nodo`, `nodovacio`, `enlace`, `etiqueta` |
| Código QR | `\qr{https://...}{texto}` |
| Tabla para completar | `\tablarellenar{filas}{Col 1}{Col 2}{Col 3}` |
| Gráficas | `\begin{axis}[eval, ...]` (estilo pgfplots con el color del colegio) |
| Justificación (solo docente) | `\justificacion{...}` dentro de la pregunta |
| Especificación (solo docente) | `\especificacion{Competencia}{Evidencia}` y al final `\tablaespecificaciones` |
| Créditos | `\creditos{...}` después de `\autoevaluacion` |

## Prompt para pedirle evaluaciones a Claude

Pega esto (y adjunta `evaluacion.cls` y `evaluacion-ejemplo.tex` si la conversación no los tiene):

> Genera una evaluación en LaTeX usando la clase `evaluacion` (adjunta: `evaluacion.cls` y
> `evaluacion-ejemplo.tex` como modelo). Datos: colegio **[…]**, asignatura **[…]**, grado
> **[…]**, periodo **[…]**, año 2026, docente **[…]**. Tema: **[…]**. Quiero **[N]**
> preguntas de selección múltiple (A–D, una sola correcta) y **[M]** abiertas con **[k]**
> líneas cada una, en **[dos columnas / una columna]**, densidad **[compacta]**.
>
> Reglas:
> - Usa solo los comandos de la clase (ver `README.md`): `\begin{pregunta}[letra]`,
>   `\opciones`, `\opcioneslargas`, `\opcioneslista`, `\opcionesdiagrama`, `\abierta`,
>   `\modelo`, `contexto`, `\grupo`, `tabla`, `codigo`, `\cod`, `\imagen`, `\venn`,
>   `\silogismo`. Puedes usar TikZ/pgfplots para gráficas y figuras.
> - Indica siempre la respuesta correcta en `[ ]` y escribe `\modelo{...}` en cada abierta.
> - Reparte las respuestas correctas entre A, B, C y D; los distractores deben ser plausibles.
> - Agrupa con `contexto` las preguntas que comparten una lectura, tabla o código.
> - Español neutro con tildes, ñ y ¿ ¡ correctos.
> - Si necesitas una imagen que no puedes dibujar, usa `\imagen{nombre-descriptivo.png}` y
>   dime al final qué imágenes debo poner en la carpeta.
> - Termina con `\autoevaluacion` y `\imprimirclave`. Entrega un solo `.tex` completo que compile
>   con pdfLaTeX.
