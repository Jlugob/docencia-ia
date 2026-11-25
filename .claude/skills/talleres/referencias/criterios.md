# Criterios pedagógicos del taller

Base: `curriculo/MODO-DE-TRABAJO.md` (perfil del docente) y el enfoque de Escuela Activa del PEI (aprender
haciendo con reflexión, autocorrección, autocontrol, espíritu social). Los criterios generales de
la planeación están en `.claude/skills/planeacion/referencias/talleres.md`; aquí, cómo lograr que
un taller **enganche y enseñe**.

## 1. Principios

1. **Un desempeño, una hora** (los tiempos se planean en el `.tex` pero **no se imprimen** en la
   hoja). Uno (a veces dos) de la malla, anotado en el comentario inicial del
   `.tex` (no se imprime: la hoja empieza directo con «Taller: tema» y lo que hay que hacer). La suma de
   tiempos de los retos y el gancho ≈ 55 min. Si no cabe, se quita, no se apura.
2. **No depende de la memoria** (criterio del perfil): aunque el tema ya se explicó en clase, la hoja
   trae lo necesario para resolverla —enunciados claros, explicaciones breves con ejemplo
   (`\recuerda`), textos, diálogos, cuadros—, de modo que el estudiante **se apropie del
   conocimiento usándolo**, no recordándolo. Cada punto con tareas tiene su material de apoyo.
2c. **Riqueza visual**: imágenes reales (Wikimedia Commons, Wellcome, museos y archivos con
   licencia libre; detalles recortados) y esquemas en TikZ (diagramas de Euler, cuadros, líneas de
   tiempo, mapas conceptuales) que ayuden a entender y a resolver, no de adorno. Cada imagen con su
   crédito en el pie. Ver `recursos.md`.
2b. **Gancho que intriga (≤ 5 min).** Una escena, una paradoja, una canción, una imagen extraña, una
   pregunta con trampa. Debe **plantear el problema** del taller, no decorar (ej.: el Sombrerero de
   Alicia para la conversión de proposiciones).
3. **Desafío óptimo: puntos que suben de dificultad** (`\reto`): primero comprender y aplicar lo
   básico, luego usar la herramienta en un caso, al final analizar, crear o transferir (sin estrellas:
   el orden y el puntaje ya lo dicen). Todo estudiante logra el
   primero; el tercero exige pensar.
4. **Material real y citado.** Textos con referencia exacta (autor, obra, capítulo/página;
   «traducción propia» o «adaptado» cuando aplique), imágenes con crédito, canciones y videos con
   autor y año. Nunca citas inventadas. Lo cotidiano también vale como material: refranes, coros,
   memes, titulares, situaciones del colegio y del municipio.
5. **Variedad de formatos** en la misma hora (tabla, diagrama, relacionar, V/F, escribir, crear),
   sin volverlo un cuadernillo: 3–4 actividades bien hechas.
6. **Cooperación con roles** cuando ayude: parejas que discuten, intercambio de hojas, «la otra
   pareja objeta». Indicar la modalidad en la ficha.
7. **Tiempos de la IA** (regla del modo de trabajo): se hace en clase y a mano; se ancla en lo
   vivido en clase y en la vida del estudiante; cuando sirva, `\respuestaia{…}` con errores
   plausibles para detectar y corregir con la regla aprendida.
8. **Retroalimentación inmediata**: pistas (`\pista`, al derecho) que ayudan sin regalar la respuesta,
   puntajes visibles por reto, socialización breve al final.
9. **Metacognición y cierre**: autoevaluación de 2–3 logros (`\cierre`), puntaje y **sello** (el
   entregable de la clase).
10. **Fácil para el docente**: imprimir la hoja y, como mucho, poner una canción o un video del QR. Nada
    de materiales raros ni preparación la víspera. Versión del docente con todas las respuestas.
11. **Instrucciones claras**: todo lo que el estudiante debe hacer va en **viñetas de número** (2.1,
    2.2…), una acción por viñeta, y dice **dónde** se resuelve: en esta hoja, en el cuaderno, en una
    hoja aparte, en voz alta. Nada de instrucciones escondidas en un párrafo.
12. **Inclusión**: instrucciones cortas y en segunda persona del plural; un ejemplo resuelto si el
    formato es nuevo; letra legible; espacio suficiente para escribir a mano. Si hay estudiantes
    con PIAR, preguntar al docente qué ajuste necesitan (menos ítems, apoyo visual, más tiempo).
13. **Rigor**: todo resoluble con lo visto y lo que está en la hoja; respuestas inequívocas en las
    actividades cerradas; en las abiertas, la versión del docente da una respuesta modelo y qué se
    acepta.

## 2. Estructura típica de la hora

La hoja: ficha → «Taller: tema» + indicación corta → puntos numerados 1, 2, 3… → cierre. **Menos
es más**: nada de «Lo que vas a demostrar», propósitos largos ni secciones dentro de secciones.


| Momento | Tiempo | Para qué |
|---|---|---|
| Gancho | 3–5 min | Intrigar y plantear el problema |
| Punto básico | 10–12 min | Activar y practicar lo básico |
| Punto intermedio | 12–15 min | Usar la herramienta en un caso |
| Punto avanzado | 10–15 min | Analizar, crear, transferir (aquí suele ir lo de la IA) |
| Cierre | 3–5 min | Autoevaluación, socializar, puntaje y sello |

Variantes: taller de **método** (modelo del autor → hacerlo uno mismo, ej. la *quaestio*), de
**producto** (diseñar algo con riesgos, ej. la isla de Utopía), de **repaso y evaluación** (retos
con puntaje que cubren el tema, ej. lógica categórica).

## 3. Puntaje y nota

Todo taller tiene puntaje: cada punto lleva sus puntos (`\reto{0}{…}{tiempo}{1,5}`) y **todos suman
5,0**, así la suma es la nota en la escala de 0 a 5 (`\cierre{5,0}{…}` o `\cierretaller{5,0}`). Repartir
según el peso del desempeño: más puntos al punto central o de producción. La versión del docente
tiene todas las soluciones; en los de producto, la rúbrica orienta cuántos puntos dar.

## 4. Señales de mal taller (rediseñar)

- Cuestionario de preguntas sueltas o de memoria; copiar definiciones.
- Más de 60 min, o un reto que no cabe en su tiempo.
- Gancho decorativo que no plantea el problema.
- Se puede entregar perfecto copiando un chatbot sin haber estado en clase.
- Material sin fuente, citas inventadas, enlaces sin verificar.
- Más de 4 páginas o páginas casi vacías; todo metido en tablas o recuadros («hecho por IA») o, al
  revés, una hoja sin ningún decorado: punto intermedio (ver `plantilla.md`).
- Rúbrica o criterios vagos («creatividad», «presentación») que no son el desempeño.
