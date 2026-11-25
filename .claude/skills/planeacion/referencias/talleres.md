# Talleres dentro de la planeación

**El creador de talleres es la skill `talleres`** (`.claude/skills/talleres/`): criterios
pedagógicos, catálogo de actividades, material real (textos, imágenes, canciones, videos por QR),
plantilla `taller-recursos.sty` con versión del docente y revisión. Aquí solo lo que conecta el
taller con la planeación.

Un periodo tiene **de 1 a 3 talleres (máximo 3)**, no uno por clase: solo las clases marcadas
`[t]` en la parcelación. Cada una tiene su taller escrito en el repositorio
(`taller-<k>-P<n>.tex`, opción `taller`). Se crea **en el mismo turno** en que se aprueba la
parcelación (o cuando el docente lo pida), para que el taller, la parcelación y el programa digan lo
mismo. Modelos: `curriculo/filosofia/10/taller-1-P4.tex` (método) y `taller-2-P4.tex` (producto).

## Criterios (obligatorios)

1. **Una hora real.** ≈55 min sumando los pasos; el docente solo imprime la hoja (y, como mucho,
   hojas en blanco o marcadores). Nada que exija comprar, montar o preparar la víspera.
2. **Un desempeño** (a veces dos) de la malla, anotado en el comentario del `.tex` (no se imprime).
3. **No depende de la memoria**: la hoja trae explicaciones breves, enunciados y ejemplos para
   resolverla (skill `talleres`, `\recuerda`).
3b. **Aplica, no repite.** El taller usa lo visto en las clases anteriores (mirar la parcelación)
   para producir algo: una *quaestio*, una isla, un juicio, un cálculo, un diseño. Nunca un
   cuestionario de memoria.
4. **Modelo antes que tarea.** Un fragmento real y citado con `\fuente{texto}{referencia exacta}`
   (o una imagen real) que muestre cómo lo hizo el autor; luego el estudiante lo hace él mismo.
5. **Conexión con su vida.** El problema o la pregunta sale del colegio o del municipio o de algo actual,
   con opciones concretas y la posibilidad de proponer una propia.
6. **Pasos con tiempo** (`pasos` + `\paso{min}{…}`): enganche que recuerda la clase anterior →
   trabajo → intercambio, contraste o exposición breve → cierre con una pregunta.
7. **Se resuelve en la hoja**: espacios con `\lineas{n}` medidos para lo que se pide; si hay
   producto aparte (mapa, cartel), decirlo en los materiales.
8. **Rúbrica corta** (`rubrica` + `\criterio`): 3–4 criterios observables, escala
   Superior/Alto/Básico/Bajo, cada nivel en pocas palabras. Lo que se valora es lo que el
   desempeño pide.
9. **Trabajo en parejas o grupos pequeños** cuando ayude a discutir; individual si el desempeño es
   personal. Indicarlo en la ficha.
10. **Hasta 4 páginas**; sin páginas casi vacías.
11. **Pensado para los tiempos de la IA** (`curriculo/MODO-DE-TRABAJO.md`): se hace en clase y a
    mano; pide algo que un chatbot no tiene (lo que pasó en clase, la objeción del compañero, un
    problema del municipio); cuando sirva, incluye una respuesta de IA con errores para analizar.

## Estructura

```latex
\documentclass[taller,borrador]{planeacion}
\materia{…} \grado{…} \periodo{…} \anio{…} \docente{…}
\begin{document}
\fichataller{número}{Semana s, clase c}{55 min}{En parejas}
\destacado{TALLER k}{\textbf{\upshape Título.} Propósito en una frase.}
\seccion{1}{Lo que vas a demostrar}   % aprendizajes + \aprendizaje{D…}{…}
\seccion{2}{El modelo / Lo que hizo …} % \fuente{…}{…}
\seccion{3}{Paso a paso}              % pasos + \paso
\seccion{4}{Nuestro …}                % espacios con \lineas
\seccion{5}{Cómo se valora}           % rubrica + \criterio
\end{document}
```

## Conexiones

- Parcelación: la fila `\clase[t]` nombra el taller y su `[D…]`; el recurso dice «Taller k
  (guía)».
- Programa: el cronograma y la tabla de evaluación lo mencionan con el mismo nombre.
- Habilitación: el taller sirve de repaso del desempeño (`\recuperar{…}{…}{…}{el Taller k}`).
- Drive: el PDF va a la carpeta del periodo como «<Materia> <grado>° – Taller k P<n>.pdf».

## Señales de mal taller

Cuestionario de preguntas sueltas; más de 60 min; necesita fotocopias extra o materiales raros;
pide información que no está en la hoja ni en los apuntes; rúbrica con criterios vagos
(«creatividad», «presentación») que no son el desempeño; se puede entregar perfecto copiando
un chatbot sin haber estado en clase.
