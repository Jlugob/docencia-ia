---
name: evaluaciones-latex
description: Crea evaluaciones (exámenes) de cualquier asignatura y grado con la plantilla LaTeX configurable del kit (evaluaciones/plantilla; colegio y logo en curriculo/config), estilo ICFES, con clave sorteada al azar, versión del estudiante y del docente en PDF, y revisión cognitiva («segundo cerebro») antes de entregar. Úsala cuando el docente pida "una evaluación", "un examen", "una prueba", "un quiz" o "la evaluación de" una materia y grado, aunque no mencione LaTeX ni la plantilla; también para la evaluación de habilitación o recuperación y para corregir o ajustar una evaluación ya hecha.
---

# Evaluaciones con la plantilla LaTeX del colegio

Flujo probado en un periodo real (Tecnología, Ética y Filosofía de 6.° a 11.°). Ejemplos
reales en `evaluaciones/ejemplos/` (Filosofía 10.°). Contexto completo y correcciones del docente:
`evaluaciones/FLUJO-DE-TRABAJO.md`.

**Fuera del repositorio** (p. ej. en claude.ai): la plantilla, los criterios y el catálogo están en
`assets/plantilla/` de esta skill, y el flujo en `referencias/flujo-de-trabajo.md`. Para compilar
hace falta pdfLaTeX con TikZ, pgfplots y tcolorbox; si el entorno no los tiene, entrega el `.tex`.

## Antes de empezar: ¿el colegio está configurado?

Si `curriculo/config/colegio.yaml` todavía dice «Colegio Demo» o `curriculo/config/docente.yaml`
dice «Nombre del Docente», **configurar primero** (una sola vez, guía en `docs/ADAPTAR.md`):
nombre y municipio del colegio, logo (pedir el archivo y guardarlo en `curriculo/config/`), estilo
de encabezado (`tabla` o `sencillo`), colores, docente, materias con grados y clases por semana, y
**perfil pedagógico** (mostrar el que viene y preguntar qué cambia). No inventar ninguno de estos
datos. Las plantillas los aplican solas al compilar.

## Referencias (leer la que corresponda a cada paso)

| Archivo | Cuándo |
|---|---|
| `referencias/redaccion.md` | Plan, formatos, lista de chequeo de ítems, rigor en citas, clave |
| `referencias/perfiles-cognitivos.md` | Qué exigir en cada grado, tiempos, legibilidad, distribución cognitiva |
| `referencias/imagenes.md` | Dónde buscar imágenes (Wellcome, Wikimedia, web) y cómo usarlas |
| `referencias/latex.md` | Estructura del `.tex`, compilación, trampas de LaTeX, maqueta |
| `referencias/revision.md` | Segundo cerebro: verificación, revisión cognitiva, estudiante simulado |
| `referencias/entrega.md` | Entrega al docente y subida a Drive (`/subir-drive`) |
| `referencias/filosofia.md` | Citas verificadas e imágenes ya descargadas (Filosofía) |
| `evaluaciones/plantilla/catalogo-formatos.pdf` | Todos los formatos con un ejemplo |
| `evaluaciones/CRITERIOS.md` | Reglas de diseño obligatorias |

## Conexión con la planeación

Flujo completo del periodo: `curriculo/FLUJO.md`.

Si existe la parcelación del periodo (`curriculo/<materia>/<grado>/parcelacion-P<n>.tex`), los temas
y desempeños (`D1`…) salen de ahí y de la malla, y no hace falta preguntar qué se vio (solo
confirmarlo). El perfil pide **1 quiz** y **1 evaluación de periodo** por periodo
(`curriculo/MODO-DE-TRABAJO.md`): la evaluación abarca todo el periodo; el quiz, lo visto hasta su
semana. Cada pregunta indica en `\especificacion` el desempeño que evalúa.
Si hay talleres del periodo (`taller-<k>-P<n>.tex`, skill `talleres`), leerlos: lo que los estudiantes produjeron
es contexto real para las preguntas (sin repetir el taller). Tiempos de la IA: las preguntas
pueden partir de lo vivido en clase o de una respuesta de IA con errores para corregir
(`curriculo/MODO-DE-TRABAJO.md`).

**Modo habilitación.** Cuando el docente pida la evaluación de habilitación (recuperación), leer además
`habilitacion-P<n>.tex` y seguir `.claude/skills/planeacion/referencias/habilitacion.md`: prueba
**corta** (≈10 preguntas: 8 de selección + 2 abiertas, 30–40 min, salvo que el docente diga otra cosa),
solo sobre los desempeños del periodo, cada pregunta con su `D…` en `\especificacion`, contextos
nuevos (no repetir la evaluación de periodo) y la misma revisión del segundo cerebro. El
resultado es **aprobado/no aprobado**: aprueba con al menos el 60 % de los puntos en **cada**
desempeño marcado (indicar en la versión docente qué preguntas son de cada `D…`). Nombre del
archivo con «habilitacion».

## Flujo (una evaluación a la vez)

1. **Preguntar** lo que falte: materia, grado, **qué se vio en clase** (temas, autores, películas,
   qué se vio por encima) y fecha. Por defecto: 20 preguntas (16 de selección + 4 abiertas),
   1 hora, docente de `curriculo/config/docente.yaml`. Nunca inventar el temario.
2. **Proponer el plan** antes de redactar, en pocas líneas: bloques (contexto + preguntas), formatos,
   imágenes previstas, conexiones (p. ej. película ↔ teoría). Si el docente corrige, ajustar primero.
3. **Sortear la clave** (`scripts/sortear_clave.py`) y redactar cada pregunta para su letra.
4. **Imágenes en segundo plano** mientras se redacta (`referencias/imagenes.md`).
5. **Redactar** desde `assets/esqueleto.tex` con `evaluacion-extras`: `\justificacion` y
   `\especificacion` en cada pregunta, `\modelo` en cada abierta, créditos completos.
6. **Compilar** (`scripts/compilar.sh`) y ajustar la maqueta (4 páginas + clave).
7. **Segundo cerebro** (`referencias/revision.md`): `verificar_clave.py` sin avisos,
   `revisar_prueba.py` (tiempo, legibilidad, pistas) y el **estudiante simulado**. Corregir.
8. **Entregar**: commit + push, enviar los dos PDF, resumen (bloques, clave, revisión, qué revisar).
9. **Ajustar** según las correcciones del docente en el mismo archivo, conservando la clave.
10. **Subir a Drive** cuando el docente lo pida: comando `/subir-drive`.

## Scripts (`scripts/`)

| Script | Para qué |
|---|---|
| `sortear_clave.py [n]` | Clave equilibrada sin rachas |
| `compilar.sh <tex> <vistas>` | PDF estudiante + docente, avisos, hoja de contactos |
| `verificar_clave.py <tex> "<clave>"` | Clave, grupos, opción más larga, absolutos, imágenes |
| `revisar_prueba.py <tex>` | Tiempo estimado por grado, legibilidad, pistas de intuición, variedad |
| `texto_estudiante.sh <pdf> <txt>` | Texto sin la clave para el estudiante simulado |
| `wikimedia.py` / `imagenes.py` | Buscar y descargar imágenes con créditos |
| `preparar_subida.py` | Lista de archivos y carpetas para `/subir-drive` |
| `empaquetar.sh` | Zip de la skill para subirla a la cuenta de claude.ai |
