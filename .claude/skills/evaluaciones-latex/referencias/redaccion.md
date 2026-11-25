# Diseño y redacción de las preguntas

## 1 Plan antes de redactar
Haz una tabla mental de especificaciones: bloques (un contexto por tema), qué competencia mide
cada pregunta (interpretativa, argumentativa, propositiva) y qué evidencia la demuestra. En la
versión docente esto sale impreso con `\especificacion{...}{...}` y `\tablaespecificaciones`.
Reparte: ~20 % comprensión literal mínima (dato que el análisis necesita), ~60 % inferencia,
aplicación a casos nuevos y comparación, ~20 % evaluación de argumentos. Las 4 abiertas piden
argumentar, decidir, crear o transferir a la vida del estudiante.

## 2 Variedad de formatos (usar al menos 6 distintos por evaluación)
Del catálogo: fragmentos citados con fuente, retrato o figura con pie, **imagen con marcas
numeradas** (obras de arte, fotos), línea de tiempo, cadena de transformaciones, esquema TikZ,
gráfica pgfplots con datos, tabla, historieta con globos, chat simulado, diálogo, textos en
contraste, mapa conceptual con casilla vacía, secuencia para ordenar, afirmaciones I–II–III,
afirmación–razón, opciones que son diagramas, código QR a un recurso visto en clase, abierta con
tabla para completar.

## 3 Redacción de ítems (lista de chequeo)
- El enunciado plantea **una tarea completa**: se debería poder responder antes de leer las opciones.
- Todo lo necesario está en la hoja (texto, tabla, esquema, imagen). Nada de memoria pura.
- **Una sola respuesta defendible**; las demás claramente falsas para quien entendió.
- **Distractores con errores típicos** (confundir autores, lectura literal, generalizar,
  invertir causa y efecto, confundir mayoría con verdad, anacronismos). Nunca absurdos, nunca
  «todas/ninguna de las anteriores».
- **Opciones homogéneas en longitud y estilo**: la correcta no puede ser la más larga ni la más
  matizada (el script lo detecta). Si hace falta, alarga los distractores con detalles plausibles.
- Evita absolutos que delatan («siempre», «nunca») solo en los distractores.
- Una idea por opción; sin negaciones dobles; si se pregunta por lo que **no** es, resáltalo.
- Escribe `\justificacion{...}` en cada pregunta de selección: por qué la clave es correcta y qué
  error revela cada distractor. Solo sale en la versión docente y sirve para retroalimentar.

## 4 Rigor en textos, citas e imágenes
- **Cita la fuente de todo fragmento**: autor, obra, libro/capítulo y pasaje (numeración estándar:
  Diels-Kranz «DK 22 B 12» para presocráticos, Stephanus para Platón «*República* 514a», Bekker
  para Aristóteles «*Metafísica* I, 3, 983b»). Usa `\fragmento{texto}{referencia}`.
- Si simplificas o resumes para el grado, escribe «adaptado» en la referencia. Nunca presentes
  como textual algo que no lo es. Usa `\fragmento*` (sin comillas) para paráfrasis.
- Solo cita pasajes que conozcas con seguridad; si dudas de la ubicación exacta, cita la obra sin
  pasaje y marca «adaptado», o pregunta. Añade a `referencias/<materia>.md` lo que verifiques.
- Retratos de autores antiguos: indicar en el pie que son **retratos imaginados**.
- Datos y estudios: redondeados y marcados como «aproximados» o «inspirados en». Empresas y
  marcas: ficticias.
- Español neutro con tildes, ñ, ¿ ¡ y comillas latinas «…».

## 3. Clave al azar (obligatorio, antes de redactar)

```bash
python3 .claude/skills/evaluaciones-latex/scripts/sortear_clave.py        # 16 preguntas
```

Cuatro de cada letra, sin tres iguales seguidas ni secuencias ABC/DCB. **Redacta cada pregunta
para que su respuesta caiga en la letra sorteada.** En afirmación–razón la letra fija qué es
cierto (A: ambas y explica; B: ambas, no explica; C: solo la afirmación; D: solo la razón).
