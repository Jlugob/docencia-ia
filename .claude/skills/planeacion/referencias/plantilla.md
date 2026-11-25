# Plantilla LaTeX: referencia rápida

Clase `curriculo/plantilla/planeacion.cls` (fiel al formato de Word del colegio, con agregados
pequeños aprobados por el docente). Documentación completa e historia del diseño:
`curriculo/plantilla/README.md`. Alternativa no usada: `planeacion-institucional.cls`.

## Compilar

```bash
bash curriculo/plantilla/compilar.sh ruta/al/archivo.tex [más archivos]
```

Borra el `.aux`, hace 4 pasadas de XeLaTeX (paginación y regla de pie), limpia auxiliares e
informa páginas, errores, líneas desbordadas y avisos «⚠ MODO DE TRABAJO». Revisar siempre las
páginas renderizadas (`pdftoppm -r 80 -png`), no solo el resumen.

## Preámbulo

| Comando | Para qué |
|---|---|
| `\documentclass[malla\|parcelacion\|programa\|taller\|habilitacion,borrador]{planeacion}` | Documento; `borrador` = marca de agua |
| `\materia{filosofia\|tecnologia\|etica\|emocional}` | Área, rótulos de columnas y nota aclaratoria |
| `\materia{Matemáticas}` (cualquier otro nombre) | Columnas originales del formato con estándares y DBA, sin nota |
| `\grado{10.°} \periodo{IV} \anio{2027}` | Datos de la ficha |
| `\clasesporsemana{n}` | Parcelación/programa por clases |
| `\fechainicio{AAAA-MM-DD}` · `\diasclase{lun,jue}` | Fechas opcionales |
| `\carpeta{enlace}` | QR del programa (vacío = «QR pendiente») |
| `\nota{…}` | Texto extra en la nota aclaratoria |
| `\hiloconductor{camino}{llegada}` | Solo si el docente pide imprimir el hilo |

## Cuerpo

- Malla: `\begin{malla}{fila superior}` · `\fila{…}{…}{…}{…}{…}` · viñetas con `\punto`.
- Parcelación: `\clase[tipo]{temas}{actividad}{recursos}{evaluación}` · `\festivo{…}` ·
  `\receso{…}` · forma antigua por semanas `\semana[tipo]{n}{…}`.
- Entregables: `\sello{…}` (entregable corto) · `\firma{…}` (apuntes firmados).
- Tipos de clase (color y etiqueta legible en blanco y negro): `q` quiz · `t` taller · `p`
  proyecto · `e` evaluación de periodo · `r` recuperación · `i` institucional. Nuevos:
  `\tiposemana{clave}{HTML}{etiqueta}{texto}`.
- Programa: `\fichaprograma` · `\destacado{rótulo}{texto}` · `\seccion{n}{título}` ·
  `aprendizajes` + `\aprendizaje{D1}{…}` · `cronograma` + `\sesion[tipo]{tema}{qué haremos}{entrega}`
  · tablas con `\estilotabla` y `\cabecera` · `\recibido` (el texto se adapta: programa o plan de
  habilitación). `\seccion` nunca queda sola al pie de página (needspace).
- Taller: `\fichataller{número}{semana y clase}{duración}{modalidad}` (con espacios para nombres
  y fecha) · `\fuente{texto}{referencia}` (cita con recuadro) · `pasos` + `\paso{min}{texto}` ·
  `\lineas{n}` (renglones para responder) · `rubrica` + `\criterio{nombre}{superior}{alto}{básico}{bajo}`.
- Habilitación: `\fichahabilitacion` · `\casilla` ·
  `recuperacion` + `\recuperar{D1}{debes demostrar}{actividad}{repasa}` (una sola tabla) · además `\fuente`, `\lineas`, `rubrica`.

## Reglas de formato (correcciones del docente)

- Fiel al Word del colegio; nada que se vea «hecho por IA» (rechazó recuadros redondeados y
  rediseños vistosos). **Sin filetes horizontales decorativos**: solo las líneas de firma.
- Programa: azul solo en el encabezado; el resto en verde (franjas pino→oliva con corte diagonal y
  bisel sutil, cabeceras oliva claro).
- Sin páginas desperdiciadas: la nota y las firmas nunca quedan solas (la clase lo controla); el
  programa cabe en **2 caras**: si se pasa, acortar textos antes que achicar letra.
- Nada de tarjetas o recuadros sueltos por ítem: tablas continuas como los formatos del colegio.
- Texto de celdas: `\punto` para viñetas; `\leavevmode` antes de `\color` al inicio de una celda.

## Trampas técnicas conocidas

`\rowcolor` no funciona dentro de comandos con argumento opcional (usar `\cellcolor`);
`\rowcolors` se filtra al encabezado (se anula localmente); xltabular compone la tabla varias
veces (los contadores se reinician en la fila de títulos); nada no expandible antes de
`\multicolumn`; ningún condicional dentro de la especificación de columnas; los avisos no deben
contener comandos sin `\string`; títulos de columna con `\@ct`, no `\multicolumn{1}{c|}` (ensancha
la columna y el color no llega a la regla); anchos con `\@anchos`/`P{}`, no `\hsize=`.
