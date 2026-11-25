---
name: talleres
description: Crea talleres de clase para cualquier colegio con la plantilla LaTeX configurable del kit - una hora, un desempeño, con textos y fuentes citadas, imágenes reales, canciones, videos y podcasts por QR, puntos numerados con puntaje que suma 5,0 (la nota), juegos, pistas, respuesta de una IA para analizar, autoevaluación y sello - en versión del estudiante y del docente (con respuestas), y revisa que entretenga, rete y cumpla el desempeño. Úsala cuando el docente pida «un taller», «una guía», «una actividad para la clase», «un repaso», «una hoja de trabajo» o cuando la parcelación tenga una clase [t], aunque no mencione LaTeX ni la plantilla.
---

# Talleres: el creador

Parte del flujo del periodo (skill `planeacion`): un periodo tiene **de 1 a 3 talleres (máximo
3)**, en las clases marcadas `[t]` de la parcelación (no uno por clase), y el quiz y la evaluación (skill `evaluaciones-latex`) pueden usar lo que se produjo en él.
También sirve para talleres sueltos (repasos, refuerzos, una clase especial).
**Modo de trabajo del docente (obligatorio): `curriculo/MODO-DE-TRABAJO.md`.**
Ejemplos: `curriculo/filosofia/10/taller-logica-categorica.tex` (repaso y evaluación con retos,
canción, Alicia, IA) y `taller-1-P4.tex` / `taller-2-P4.tex` (método y producto).

## Antes de empezar: ¿el colegio está configurado?

Si `curriculo/config/colegio.yaml` todavía dice «Colegio Demo» o `curriculo/config/docente.yaml`
dice «Nombre del Docente», **configurar primero** (una sola vez, guía en `docs/ADAPTAR.md`):
nombre y municipio del colegio, logo (pedir el archivo y guardarlo en `curriculo/config/`), estilo
de encabezado (`tabla` o `sencillo`), colores, docente, materias con grados y clases por semana, y
**perfil pedagógico** (mostrar el que viene y preguntar qué cambia). No inventar ninguno de estos
datos. Las plantillas los aplican solas al compilar.

## En una línea

Un taller **de una hora** que el estudiante **disfruta y recuerda**: un gancho que intriga, puntos
que suben de dificultad, material real (textos, imágenes, canciones, videos) citado con su fuente, algo
que **solo se puede hacer pensando en clase** (no copiando a una IA), y un cierre con
autoevaluación, puntaje y sello. Fácil de preparar para el docente: imprimir y listo.

## Referencias

| Archivo | Cuándo |
|---|---|
| `referencias/capacidades.md` | **Inventario de todo lo que se puede integrar** (textos, imágenes, esquemas, QR, actividades, evaluación, conexiones, límites) |
| `referencias/criterios.md` | Siempre: principios pedagógicos, estructura de la hora, señales de mal taller |
| `referencias/actividades.md` | Elegir el formato: catálogo por propósito (explorar, practicar, aplicar, crear, evaluar) y juegos |
| `referencias/recursos.md` | Textos, imágenes, canciones, videos, podcasts: dónde buscarlos, cómo citarlos, QR, derechos |
| `referencias/plantilla.md` | Comandos de `taller-recursos.sty`, versión del docente, compilación, trampas |
| `referencias/revision.md` | Segundo cerebro del taller: script, estudiante simulado, lista final |
| `assets/esqueleto-taller.tex` | Punto de partida |

## Flujo (un taller a la vez)

1. **Datos.** Materia, grado, desempeño (`D…` de la malla) y **qué se vio en clase** (de la
   parcelación si existe; si no, preguntar). Duración (55 min por defecto), modalidad (parejas,
   grupos, individual), si es de práctica, repaso o evaluación (puntaje). **Nunca inventar el
   temario.**
2. **Proponer el diseño** en pocas líneas antes de redactar: gancho, 2–4 puntos con tiempo y puntaje
   (suman 5,0), material real previsto (texto, imagen, canción, video), elemento «tiempos de la IA», el
   producto y el cierre. Ajustar con el docente.
3. **Buscar el material real y los esquemas** (en segundo plano si son imágenes): imágenes de
   Wikimedia Commons y otros archivos (scripts de `evaluaciones-latex`), detalles recortados, esquemas
   en TikZ (Euler, cuadros, líneas de tiempo, mapas); citas con referencia exacta,
   imágenes con crédito y licencia, enlaces verificados para los QR (`recursos.md`).
4. **Redactar** con la plantilla (`\documentclass[taller,borrador]{planeacion}`): cada actividad
   con su `\sol{…}` / `\respuesta{…}` para la versión del docente.
5. **Compilar** (`bash curriculo/plantilla/compilar.sh <archivo>.tex`): salen la versión del
   estudiante y la del docente. Hasta **4 páginas** (2 hojas) sin páginas casi vacías; 0 errores ni desbordes.
6. **Revisar** (`revision.md`): `scripts/revisar_taller.py`, mirar las páginas, estudiante
   simulado si es un taller evaluable, lista final.
7. **Entregar**: commit + push, enviar los dos PDF, resumen (gancho, retos, puntos, material y
   fuentes, lo que se propuso sin que el docente lo dijera). Subir a la carpeta de Drive del periodo
   (`planeacion/referencias/drive.md`) como «<Materia> <grado>° – Taller <k> P<n>.pdf» (y la del
   docente si el docente quiere).
8. **Conectar**: si el taller es de la parcelación, revisar que la fila `[t]`, el programa y la
   habilitación lo nombren igual.

Después de cambiar la skill: `bash .claude/skills/talleres/scripts/empaquetar.sh` (zip para
claude.ai).
