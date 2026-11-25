# Criterios de diseño de las evaluaciones

Aplican a todas las evaluaciones que se hagan con la plantilla de `evaluaciones/plantilla/`.

## Datos por defecto

- Docente, colegio y logo: `curriculo/config/` (docente.yaml y colegio.yaml).
- Periodo y año: los que diga el docente.
- Duración: 1 hora (se indica en las instrucciones).
- 20 preguntas por evaluación.

## Estilo tipo ICFES (Saber)

- Preguntas que exijan **análisis, interpretación y aplicación**, no solo memoria: situaciones,
  casos, lecturas, gráficas, tablas e imágenes como contexto.
- Combinar tipos de pregunta:
  - Selección múltiple con única respuesta (A–D).
  - Varias afirmaciones (I, II, III…) para decidir cuáles son verdaderas, con opciones como
    "solo I", "I y III", "II y III", "I, II y III".
  - Afirmación y razón ("… PORQUE …"), con las opciones clásicas: ambas verdaderas y la razón
    explica la afirmación / ambas verdaderas pero la razón no la explica / afirmación verdadera
    y razón falsa / afirmación falsa y razón verdadera.
  - Preguntas agrupadas sobre un mismo contexto (lectura, caso, tabla, imagen).
  - Algunas abiertas para argumentar.
- **Ninguna pregunta de solo memoria**: todo lo que se necesita para responder debe estar en el
  enunciado o en el contexto (texto, tabla, caso, resumen de la película o de la teoría); lo que
  se evalúa es el análisis, la inferencia y la aplicación.
- Distractores plausibles, construidos con errores típicos de los estudiantes; nada de opciones
  absurdas ni de "todas las anteriores" como atajo.
- Se pueden incluir imágenes y figuras (TikZ o archivos) cuando aporten al análisis.

## Clave de respuestas

- La letra correcta se asigna **al azar** en cada pregunta. Nada de patrones (siempre A,
  secuencias A-B-C-D, rachas largas de la misma letra).
- Revisar al final que la distribución quede razonablemente equilibrada entre A, B, C y D.
