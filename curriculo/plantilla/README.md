# Plantilla LaTeX de planeación (malla, parcelación, programa, taller y habilitación)

Formatos de planeación escolar en LaTeX para no trabajarlos en Word. **Se adaptan a cualquier
colegio sin tocar el código**: nombre, municipio, logo, leyenda del encabezado, colores, fuente,
papel y estilo del encabezado se leen de `../config/colegio.yaml`, y el docente y su perfil
pedagógico de `../config/docente.yaml` (guía: `docs/ADAPTAR.md` en la raíz del repositorio).

| Archivo | Qué es |
|---|---|
| `planeacion.cls` | Clase de todos los documentos de planeación |
| `taller-recursos.sty` | Recursos de taller (textos citados, imágenes con crédito, QR, retos, versión del docente) |
| `compilar.sh` | Aplica la configuración, compila (borra el `.aux` y hace 4 pasadas de XeLaTeX) y avisa de errores, líneas desbordadas y avisos del modo de trabajo |
| `ejemplos/` | Ejemplos con texto de relleno (ver tabla al final) |

## Tres formatos

| Opción | Documento | Papel | Para quién |
|---|---|---|---|
| `malla` | Malla curricular por periodo | Oficio horizontal | Coordinación |
| `parcelacion` | Parcelación por clases | Oficio horizontal | Coordinación y docente |
| `programa` | **Programa del periodo** (pregunta, aprendizajes, contenidos, metodología, cronograma, evaluación, recursos, firmas de recibido) | **Carta vertical**, 2 caras | **Estudiantes y acudientes**, al inicio del periodo |
| `taller` | **Taller** (gancho, material citado con imágenes y esquemas, puntos con tareas numeradas, espacios para responder, nota sobre 5,0 y sello); sale también la **versión del docente** con respuestas | Carta vertical, hasta 4 páginas | Estudiantes, en la clase del taller |
| `habilitacion` | **Plan de habilitación** (desempeños con casilla, actividad y repaso por cada uno, entrega, rúbrica, firmas) | Carta vertical, ≤ 2 caras | Estudiantes que habilitan y acudientes, al cierre del periodo |

Todos usan el mismo encabezado institucional (taller y habilitación con la paleta verde del programa). El programa se escribe a partir de la malla y la
parcelación del mismo periodo, en lenguaje para estudiantes.

## Uso

```latex
\documentclass[malla]{planeacion}        % o [parcelacion]; añadir ,borrador para la marca de agua
\materia{tecnologia}                     % tecnologia | filosofia | etica | emocional | otro nombre (p. ej. Matemáticas) = formato original con estándares y DBA
\grado{6.°} \periodo{I} \anio{2027} \docente{el docente de docente.yaml}
\nota{Texto adicional para la nota aclaratoria (opcional).}
% \fechainicio{2027-01-25}              % solo parcelación y solo si se quieren fechas
\begin{document}
\begin{malla}{Texto de la fila superior (competencias de referencia o estándares)}
  \fila{temas}{componente}{desempeños}{competencias}{\punto evidencia \punto evidencia}
\end{malla}
\end{document}
```

Parcelación **por clases** (forma principal: se planea cada clase, no cada semana):

```latex
\documentclass[parcelacion]{planeacion}
\materia{filosofia}
\grado{10.°} \periodo{IV} \anio{2027} \docente{el docente de docente.yaml}
\clasesporsemana{2}            % Filosofía 10.°: 2 clases; los demás grados: 1
% \fechainicio{2027-09-13}     % opcional: lunes de la semana 1
% \diasclase{lun,jue}          % opcional: días de clase, para la fecha exacta de cada una
\begin{document}
\begin{parcelacion}
  \clase{temas}{actividad}{recursos}{evaluación}       % semana y n.º de clase se calculan solos
  \clase[q]{…}{…}{…}{…}                                % clase con quiz (código de colores)
  \festivo{festivo (Día de la Raza)}                   % esa clase no se dicta: ocupa su lugar
  \receso{RECESO ESCOLAR DE OCTUBRE}                   % semana completa sin clases
\end{parcelacion}
\end{document}
```

Forma anterior, una fila por semana (sigue funcionando): `\semana[tipo]{n}{temas}{actividad}{recursos}{evaluación}`.

Compilar (desde la raíz del repositorio):

```bash
bash curriculo/plantilla/compilar.sh ruta/al/archivo.tex
```

## Qué hace la plantilla

**Encabezado configurable** (`formato.encabezado` en `colegio.yaml`): `tabla` (formato tipo Word
con logo, nombre del colegio y municipio en el color institucional, nombre del formato con el año,
leyenda de propiedad intelectual y «Página X de Y») o `sencillo` (logo y colegio a la izquierda,
formato y página a la derecha, una línea debajo). Cuerpo: tabla con rejilla negra; letra sans (DejaVu Sans, de la familia de Verdana/Tahoma, la del Word).

**Agregados pequeños** (aprobados por el docente, 15/11/2026):
- Encabezado a todo el ancho y alineado con la tabla; márgenes de 1,8 cm.
- Ficha con bordes para área/asignatura, grado, periodo, año y docente (en lugar del título
  repetido y una línea suelta).
- Fila de títulos de columna en gris claro (sombreado estándar de Word) y repetida en cada página.
- Filas alternas en crema muy leve para distinguir una de otra.
- Partición de palabras en columnas angostas; viñetas compactas en celdas con `\punto`.
- **Columnas rotuladas según la materia** con su referente oficial y **nota aclaratoria
  automática** que explica por qué no hay DBA (ver `../referentes/`).
- Pie de página con área, grado y periodo.

**Código de colores de la parcelación** (`\semana[clave]{…}`): colorea la fila y pone una
etiqueta junto al número de semana, legible también en fotocopia en blanco y negro. Debajo de la
tabla aparecen solas las **convenciones** de los tipos usados.

| Clave | Color | Etiqueta | Significado |
|---|---|---|---|
| `q` | azul claro | Quiz | Evaluación corta (quiz, control de lectura) |
| `t` | lila claro | Taller | Taller o actividad evaluativa |
| `p` | verde claro | Proyecto | Entrega o sustentación de proyecto |
| `e` | ocre claro | Ev. periodo | Evaluación de periodo |
| `r` | rosa claro | Recup. | Recuperación o nivelación |
| `i` | gris claro | Instit. | Actividad institucional (sin clase regular) |

Otro tipo: `\tiposemana{clave}{color HTML}{etiqueta corta}{texto de la convención}` en el preámbulo.

**Parcelación por clases.** Con `\clasesporsemana{n}` cada `\clase` es una sesión: la plantilla
numera semana y clase («Semana 3 · Clase 2»), pinta igual las clases de una misma semana
(blanco/crema alternando por semana), las separa con línea gris y pone línea negra entre semanas.
`\festivo{motivo}` ocupa el lugar de una clase que no se dicta (festivo, salida, jornada) y corre
las demás; `\receso{motivo}` ocupa una semana entera. Debajo de la tabla sale un **resumen**:
semanas, clases por semana, clases planeadas y clases perdidas. Con `\fechainicio` y
`\diasclase{lun,jue}` cada clase muestra su fecha exacta («lun 13 sep», «jue 16 sep»); sin
`\diasclase`, la primera clase de cada semana muestra el rango de la semana.

**Programa del periodo** (`\documentclass[programa]{planeacion}`, ver
`curriculo/filosofia/10/programa-P4.tex`): `\fichaprograma` (ficha en dos filas con clases por
semana), `\destacado{PREGUNTA DEL\newline PERIODO}{…}`, `\seccion{n}{Título}`, entorno
`aprendizajes` con `\aprendizaje{D1}{…}`, entorno `cronograma` con `\sesion[tipo]{tema}{qué
haremos}{evaluación o entrega}` (misma numeración automática, colores, festivos y recesos que la
parcelación) y `\recibido` (firmas de estudiante, acudiente y docente, con el **QR de la carpeta de Drive** del
periodo a la derecha: `\carpeta{enlace}` en el preámbulo; vacío = recuadro «QR pendiente»). Debe caber en una hoja por
ambas caras. Los títulos de sección son franjas verdes (número en verde pino oscuro #1B3A2B separado por un
corte diagonal; título en letra blanca sobre degradado de pino #2E5B40 a oliva #7C8746; extremo
derecho con corte inclinado, chaflán leve y bisel sutil: «bello pero suficiente», pedido por el docente;
relleno con transparencia leve, 80 %, para que no pese en la hoja). Paleta del programa: azul solo en el encabezado
institucional; todo lo demás en la familia verde (cabeceras de tabla y rótulos de la ficha en oliva
muy claro #E6EAD6 con texto pino #24493A; códigos D en pino). Tablas del programa con reglas de
0,5 pt en carbón (`\estilotabla`, `\cabecera`), mayúsculas con espaciado (`\espaciado`), separación
entre clases en gris muy claro y contenido centrado en vertical en la tabla de evaluación. Marca de
agua del borrador más tenue; **no se usan filetes horizontales decorativos** (el docente los considera marca
de documentos hechos con IA). Las únicas líneas sueltas son las de firma.

**Taller** (`\documentclass[taller]{planeacion}`, ver `curriculo/filosofia/10/taller-1-P4.tex`):
`\fichataller{número}{semana y clase}{duración}{modalidad}` (ficha con espacios para nombres y
fecha), `\destacado{TALLER k}{título y propósito}`, `\fuente{texto}{referencia}` (cita en recuadro
con la referencia a la derecha), entorno `pasos` con `\paso{min}{texto}`, `\lineas{n}` (renglones
para responder) y entorno `rubrica` con `\criterio{nombre}{superior}{alto}{básico}{bajo}`.

**Estilo del taller**: letra solo en negro (negrita para destacar), tablas y ficha en negro con
cabecera gris, verde solo en la barra de los textos citados (como el contexto de las evaluaciones), sin tiempos impresos, sin estrellas, puntos que suman 5,0 (la nota), textos
en párrafo y pistas al derecho. Estructura directa: `\titulotaller{Tema}{indicación}` y puntos
numerados con `\reto` y tareas numeradas (`tareas`/`\tarea`); los desempeños van en el comentario
del `.tex`. **Recursos de taller**
(`taller-recursos.sty`, se carga con `[taller]` y `[habilitacion]`):
textos citados con rótulo (`\texto`), explicaciones (`\recuerda`), imágenes con crédito (`\figura`,
`\imagenmarcada`, `\imagenlado`), diagramas de Euler (`\euler`), QR a
canciones, videos y podcasts (`\recurso`), glosario (`\concepto`), diálogos, respuesta de una IA
para analizar (`\respuestaia`), puntos numerados con tiempo y puntaje que suman 5,0 (`\reto`), pistas
(`\pista`), tablas para llenar (`tablataller`), completar (`\hueco`), verdadero o falso,
selección, relacionar columnas, estilos TikZ para diagramas y cierre con autoevaluación, puntaje y
sello (`\cierre`). **Versión del docente**: todo lo escrito con `\sol`, `\hueco[…]`,
`\respuesta{…}`, `\vf`, `\op*` y `\relacionar[…]` aparece en vino solo en
`<archivo>-docente.pdf`, que `compilar.sh` genera automáticamente para los talleres. Catálogo con un
ejemplo de cada comando: `ejemplos/catalogo-taller.pdf` (y su versión docente). Guía completa:
skill `talleres` (`.claude/skills/talleres/referencias/plantilla.md`).

**Plan de habilitación** (`\documentclass[habilitacion]{planeacion}`, ver
`curriculo/filosofia/10/habilitacion-P4.tex`): `\fichahabilitacion` (estudiante, entrega del
trabajo y fecha de la evaluación, a mano), entorno `recuperacion` con `\recuperar{D1}{debes demostrar}{actividad}{repasa}` (una sola tabla
sobria: marca, aprendizaje, actividad; centrada en vertical; sin tarjetas sueltas, que el docente ve
«hechas por IA»), «Para aprobar» con casillas (resultado aprobado/no
aprobado) y `\recibido` (el texto dice «este plan de
habilitación»). Criterios en `.claude/skills/planeacion/referencias/talleres.md` y `habilitacion.md`.

El logo va centrado en su celda en todos los formatos (caja de la misma altura que el bloque de texto).

Los títulos `\seccion` nunca quedan solos al pie de una página (needspace).

**Hilo conductor (opcional, no se usa por defecto).** El hilo conductor es un criterio de diseño
(ver `curriculo/MODO-DE-TRABAJO.md`), no un recuadro obligatorio. Solo si el docente lo pide:
`\hiloconductor{cómo avanza el periodo}{punto de llegada}` en el preámbulo (la parcelación lo
muestra bajo la ficha; el programa, con `\mostrarhilo`). Ver los criterios pedagógicos en `curriculo/MODO-DE-TRABAJO.md`.

**Fechas opcionales.** La parcelación se guarda **sin fechas** para reutilizarla cada año. Para
imprimirla con fechas basta una línea en el preámbulo: `\fechainicio{AAAA-MM-DD}` (el lunes de la
primera semana). Cada semana muestra su rango lunes–viernes («25–29 ene», «29 mar – 2 abr») y la
columna se titula SEMANA / FECHA. Las semanas sin clase se escriben en su lugar con
`\receso{texto}`: ocupan una semana del calendario y salen como fila gris con su rango de fechas.
Sin `\fechainicio`, `\receso` sale igual pero sin fechas. Los festivos sueltos (un lunes) no
corren el calendario: se anotan en la celda si hace falta.

**Cambio de página.** Se repiten el encabezado y los títulos de columna; las filas no se parten; las
franjas y colores continúan. La nota aclaratoria, las convenciones y las firmas van en el pie final
de la tabla, así que quedan al final de la última página; y si en una pasada quedaron solas en
una hoja, en la siguiente la última fila pasa con ellas. Por eso `compilar.sh` borra el `.aux`
(para no arrastrar una decisión vieja si el contenido cambió) y hace cuatro pasadas.

**Marca de agua «BORRADOR».** Opción `borrador` de la clase (`\documentclass[malla,borrador]{planeacion}`):
se quita cuando coordinación aprueba el documento.

## Ejemplos (`ejemplos/`)

| Archivo | Muestra |
|---|---|
| `malla-ejemplo` | Malla de Tecnología 6.°, periodo I |
| `parcelacion-ejemplo` | Parcelación de Filosofía 10.° con todos los tipos de semana |
| `parcelacion-con-fechas` | Forma por semanas con `\fechainicio{2027-01-25}` y receso de Semana Santa (22–26 mar de 2027) |
| `parcelacion-por-clases-con-fechas` | **Por clases** (2 por semana, lunes y jueves) con fechas desde el 13 sep 2027, receso de octubre y festivo del lunes 18 oct (Día de la Raza trasladado) |
| `malla-prueba-varias-paginas`, `parcelacion-prueba-varias-paginas` | Pruebas de cambio de página |
| `malla-ejemplo-con-dba` | Malla de un área con estándares y DBA (Matemáticas), columnas estándar |
| `catalogo-taller` | Todos los recursos de taller, en versión del estudiante y del docente |

## Historia del diseño

Nació como réplica fiel de los formatos de Word de un colegio real. Se probó un rediseño con
recuadros redondeados y se descartó por verse «hecho por IA»; se eligió la versión fiel al formato
y se le fueron sumando agregados que ayudan a leer, imprimir y reutilizar. Después se separó la
identidad del colegio (nombre, logo, colores, leyenda, encabezado) en `config/colegio.yaml` para
que el mismo código sirva a cualquier colegio. Criterio: respetar el formato del colegio y mejorar
solo lo que ayuda.

## Trampas técnicas (para quien mantenga la clase)

- `\rowcolor` no funciona dentro de un comando con argumento opcional: el color de las semanas
  especiales se pone celda por celda con `\cellcolor`.
- `\rowcolors` se filtra al encabezado (que se compone durante la tabla) y tapaba el logo: el
  encabezado y el pie lo anulan localmente con `\rowcolors{1}{}{}`.
- `xltabular` compone la tabla varias veces para medir columnas: todo lo que lleva cuenta
  (calendario, número de fila) se reinicia en la fila de títulos.
- Nada no expandible antes de `\multicolumn` (p. ej. el reinicio de contadores va dentro de la
  celda); y nada de `\relax` tras `\hline` en el fin de fila, porque abriría la fila siguiente.
- **Títulos de columna** con `\@ct{…}` (centrado dentro del ancho de la columna), nunca con
  `\multicolumn{1}{c|}{…}`: un título más ancho que su columna la ensanchaba y el color de las
  filas no llegaba a la regla vertical (franja blanca; error visto por el docente en la malla, nov. 2026).
- **Anchos de columna explícitos** (`\@anchos`, columna `P{…}`; la última es `X` y toma lo que
  sobra) en lugar de `>{\hsize=…}X`.
- **Logo**: el bloque de texto del encabezado se compone en una caja y el logo va en una caja de la
  misma altura, centrado en ambos sentidos (`\@cajaenc`).
- **Áreas con DBA**: `\materia{<nombre>}` con un nombre distinto de las cuatro claves restaura las
  columnas originales del formato (ejemplo `ejemplos/malla-ejemplo-con-dba.tex`).
- Encabezado sin `\multirow` para el logo: se usa una tabla anidada de ancho fijo para que la
  altura sea exacta (con `\multirow` sobresalía).
