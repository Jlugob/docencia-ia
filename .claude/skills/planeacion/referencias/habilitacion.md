# Habilitación (recuperación)

Al cerrar el periodo, el estudiante que no alcanzó uno o más desempeños los recupera en **dos
pasos**: (1) un **trabajo** en casa sobre los desempeños marcados y (2) una **evaluación de
habilitación** corta sobre esos mismos desempeños. El trabajo es la preparación de la evaluación.
Modelo: `curriculo/filosofia/10/habilitacion-P4.tex`.

## 1. Plan de habilitación (`habilitacion-P<n>.tex`, opción `habilitacion`)

Un solo documento por periodo y grado, **genérico**: sirve para todos los estudiantes que
habiliten. El docente marca a mano (casilla) los desempeños que cada uno debe recuperar y llena
nombre y fechas a mano (**nunca** escribir nombres de estudiantes en el repositorio).

- `\fichahabilitacion`: espacios para estudiante, entrega del trabajo y fecha de la evaluación.
- `\destacado{CÓMO\newline FUNCIONA}{…}`: los dos pasos en tres líneas.
- entorno `recuperacion` (una sola tabla: marca, aprendizaje, actividad) con
  `\recuperar{D…}{qué debe demostrar}{actividad}{qué repasar}` por **cada** desempeño de la malla.
- Entrega, evaluación y resultado (viñetas), «Para aprobar» (casillas) y `\recibido`
  (firma del estudiante y del acudiente; QR de la carpeta del periodo).
- 2 caras como máximo.

## Criterios de las actividades

- **Una actividad por desempeño**, hecha a mano, que se pueda resolver en una o dos horas con los
  apuntes firmados, los talleres y los recursos de Drive. Nada que exija internet obligatorio o
  materiales que el estudiante no tenga.
- **Producir y argumentar, no copiar**: línea de tiempo con explicación, párrafo con postura,
  una *quaestio* nueva, una ley con su riesgo. Evitar resúmenes o copias que se puedan bajar de
  internet o pedir a una IA sin pensar; pedir ejemplos propios y conexión con su vida.
- **«Repasa» remite a lo que ya existe**: clases (semana), entregables, talleres y lecturas de la
  carpeta del periodo.
- Mismo nivel de exigencia que el periodo: es otra oportunidad, no una versión rebajada.
- **Tiempos de la IA**: el trabajo se hace en casa y puede hacerse con IA, por eso (a) es a mano,
  con sus palabras y referencias a sus apuntes; (b) pide lo que pasó en clase y ejemplos de su
  vida; (c) al menos una actividad analiza una respuesta de IA con errores (ver D4 del piloto);
  (d) el estudiante declara si usó IA y para qué; (e) **la evaluación presencial decide**.

## 2. Evaluación de habilitación (skill `evaluaciones-latex`, «modo habilitación»)

- Se genera con la skill de evaluaciones, leyendo la malla, la parcelación y este plan.
- **Corta**: unas 10 preguntas (8 de selección + 2 abiertas) o lo que el docente pida, en 30–40 min.
- Solo los desempeños del periodo; cada pregunta indica su `D…` en `\especificacion`, de modo que
  el docente sepa qué preguntas corresponden a cada desempeño marcado. Si el docente prefiere una por
  estudiante, filtrar por los desempeños que indique.
- Contextos nuevos (no repetir las preguntas de la evaluación de periodo), mismos formatos y la
  misma revisión del segundo cerebro.
- Archivo en `evaluaciones/<año>-P<n>/` con «habilitación» en el nombre; a Drive con `/subir-drive`.

## Resultado y formato (criterio del perfil)

- La habilitación **se aprueba o no se aprueba**: no hay nota intermedia. Los criterios los fija el
  docente (el colegio da libertad). Criterios por defecto, en la sección «Para aprobar» con
  casillas: (1) trabajo completo, a tiempo, a mano y con palabras propias; (2) razones y ejemplos
  propios; (3) al menos **nivel básico (60 % de los puntos)** en **cada** desempeño marcado en la
  evaluación. Al final, «Resultado: ☐ Aprobado ☐ No aprobado».
- Sin rúbrica de cuatro niveles (no aplica a un resultado binario).
- **Formato oficial**: el mismo encabezado institucional de la plantilla con el nombre del
  formato «PLAN DE HABILITACIÓN»; no hay otro formato del colegio.

## Por confirmar con el docente

Cuándo se habilita (al final de cada periodo o del año) y si hay sustentación oral.
