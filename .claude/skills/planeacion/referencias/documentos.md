# Los documentos del periodo y cómo se conectan

Carpeta: `curriculo/<materia>/<grado>/`. Ejemplo completo y aprobado como piloto:
`curriculo/filosofia/10/` (Filosofía 10.°, periodo IV). Claude escribe el `.tex` directamente con
la clase `curriculo/plantilla/planeacion.cls` (sin generadores ni YAML).

## 1. Malla curricular (`malla-P<n>.tex`, opción `malla`)

Formato del colegio: oficio horizontal, para coordinación.

- `\begin{malla}{<fila superior>}`: la fila superior es la de **estándares** del formato; en las
  materias sin estándares ni DBA se rotula con su referente (`\materia{…}` lo hace solo; ver `referentes.md`).
- Una `\fila{temas}{componente}{subproceso}{competencias}{referente}` por bloque de tema.
  - Temas: título en negrita + contenido + código del desempeño `{\scriptsize[FIL-10-P4-D1]}`.
  - Código: `<MAT>-<grado>-P<periodo>-D<n>` (MAT: FIL, TEC, ETI, EMO; ver `config/docente.yaml`).
  - Última columna: evidencias o desempeños observables, con `\punto` (no `itemize`).
- La nota aclaratoria (por qué no hay DBA) sale sola según la materia.

## 2. Parcelación (`parcelacion-P<n>.tex`, opción `parcelacion`)

Para coordinación y para el docente; **una fila por clase**, sin fechas (reutilizable).

```latex
\clasesporsemana{2}                       % según el grado (config/docente.yaml)
\begin{parcelacion}
  \clase{temas}{actividad}{recursos}{\sello{entregable} {\scriptsize[D1]}}
  \clase{temas}{explicación…}{recursos}{\firma{Apuntes de la explicación.} {\scriptsize[D2]}}
  \clase[t]{Taller 1: …}{…}{…}{Taller evaluativo. {\scriptsize[D3]}}
  \clase[q]{Quiz del periodo.}{…}{…}{Quiz. {\scriptsize[D1--D4]}}
  \clase[e]{Evaluación de periodo.}{…}{…}{Evaluación de periodo. {\scriptsize[D1--D5]}}
  \festivo{motivo}   % clase perdida;   \receso{motivo}   % semana sin clases
\end{parcelacion}
```

- Temas: título en negrita y una línea de contenido. Actividad: qué pasa en la hora (inicio con
  conexión, desarrollo, cierre). Recursos: materiales reales y sencillos.
- Evaluación: el **entregable** (`\sello` o `\firma`) y los desempeños que trabaja `[D…]`.
- Comentarios `% ---- Semana n · D… tema` para leer el `.tex`.
- Fechas solo si coordinación las pide: `\fechainicio{AAAA-MM-DD}` y `\diasclase{lun,jue}`.

## 3. Programa del periodo (`programa-P<n>.tex`, opción `programa`)

Para **estudiantes y acudientes**; carta vertical, **una hoja por ambas caras**; se entrega al
inicio del periodo. Tono cercano y claro (tú), sin jerga.

Estructura (ver el piloto):
1. `\fichaprograma` y `\destacado{PREGUNTA DEL\newline PERIODO}{…}`.
2. `\seccion{1}{Lo que vas a aprender}`: los desempeños de la malla en lenguaje de estudiante
   («Al terminar el periodo podrás…»), con `\aprendizaje{D1}{…}`.
3. `\seccion{2}{Cómo vamos a trabajar}`: no se dicta, apuntes firmados, un entregable con sello
   por clase, qué traer, cómo debatir, qué hacer si se falta.
4. `\seccion{3}{Cronograma de clases}`: `\begin{cronograma}` con un `\sesion[tipo]{tema}{qué
   haremos}{\sello{…}}` por clase: **la misma secuencia de la parcelación**, en pocas palabras.
5. `\seccion{4}{Evaluación}`: tabla (actividad, semana, aprendizajes, qué se tiene en cuenta) con
   `\estilotabla` y `\cabecera`; escala Superior/Alto/Básico/Bajo. Porcentajes solo cuando se
   conozca el SIEE (no inventarlos).
6. `\seccion{5}{Lecturas y recursos}` con referencias, y `\recibido` (firmas + QR de Drive).

## 4. Talleres y habilitación

Cada `\clase[t]` (de 1 a 3 por periodo, máximo 3) tiene su `taller-<k>-P<n>.tex` (ver `talleres.md`); al cierre del periodo,
`habilitacion-P<n>.tex` (ver `habilitacion.md`). Mismos desempeños, mismos nombres.

## 5. Conexiones obligatorias

| Elemento | Malla | Parcelación | Programa | Evaluación |
|---|---|---|---|---|
| Desempeños D1… | Fila por bloque | `[D…]` en cada clase | «Lo que vas a aprender» | `\especificacion` de cada pregunta |
| Temas | Columna de temas | Columna de temas | Cronograma | Contextos de las preguntas |
| Talleres, quiz, evaluación | — | `[t]`, `[q]`, `[e]` | Cronograma y tabla de evaluación | Quiz y evaluación con `evaluaciones-latex`; cada taller en su archivo |
| Habilitación | Desempeños | Clases y talleres (repaso) | — | Plan con `\recuperar` por D; evaluación corta |
| Entregables | — | `\sello` / `\firma` | Cronograma | — |

Si se cambia uno, actualizar los demás en el mismo turno.
