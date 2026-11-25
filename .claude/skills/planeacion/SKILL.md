---
name: planeacion
description: Flujo de trabajo completo de un periodo en cualquier colegio con la plantilla LaTeX configurable del kit (logo, formato y perfil en curriculo/config), según el modo de trabajo y los criterios pedagógicos del docente - malla curricular, parcelación por clases, programa del periodo para estudiantes, talleres (de 1 a 3 por periodo, máximo 3), conexión con el quiz y la evaluación (skill evaluaciones-latex) y plan de habilitación (recuperación) - y deja los recursos en su carpeta de Google Drive con un código QR. Úsala cuando el docente pida «la malla», «la parcelación», «el programa del periodo», «la hoja de temas», «el temario», «el syllabus», «un taller», «la guía del taller», «la habilitación» o «la recuperación» de una materia y grado, cuando quiera planear un periodo o ajustar una planeación ya hecha.
---

# Planeación: el flujo de trabajo del periodo

Sistema completo y estado: `curriculo/README.md`. **Flujo de punta a punta: `curriculo/FLUJO.md`.**
**Modo de trabajo y criterios pedagógicos del docente (obligatorio): `curriculo/MODO-DE-TRABAJO.md`.**
Ejemplo completo (piloto): `curriculo/filosofia/10/` (Filosofía 10.°, periodo IV).

## Antes de empezar: ¿el colegio está configurado?

Si `curriculo/config/colegio.yaml` todavía dice «Colegio Demo» o `curriculo/config/docente.yaml`
dice «Nombre del Docente», **configurar primero** (una sola vez, guía en `docs/ADAPTAR.md`):
nombre y municipio del colegio, logo (pedir el archivo y guardarlo en `curriculo/config/`), estilo
de encabezado (`tabla` o `sencillo`), colores, docente, materias con grados y clases por semana, y
**perfil pedagógico** (mostrar el que viene y preguntar qué cambia). No inventar ninguno de estos
datos. Las plantillas los aplican solas al compilar.

## En una línea

Planear **como trabaja el docente en el aula**: según su perfil (el que viene de ejemplo: sin dictado, apuntes que el docente firma), **un entregable corto
con sello por clase**, 1 a 3 talleres por periodo (máximo 3, no uno por clase), 1 quiz y la evaluación de periodo al final; actividades con un
giro que motive pero **de una hora y fáciles de preparar**; clases **encadenadas** hacia un punto de
llegada, en **secuencia didáctica** y con **orden epistemológico**; proyectos solo si lo ameritan.
**Todo se diseña para los tiempos de la IA** (regla en `curriculo/MODO-DE-TRABAJO.md`): la
evidencia se produce en clase y a mano, anclada en lo que pasó en el aula y en la vida del
estudiante; la IA se usa como objeto de análisis (respuestas con errores para corregir) y su uso en
casa se declara.

Más que una skill es un **flujo**: todo sale de la misma planeación y queda en el repositorio y en
Drive, de modo que cada pieza tiene el contexto real de las demás.

```
malla ─► parcelación ─► programa del periodo
              │
              ├─► talleres [t]  (se crean aquí mismo)
              ├─► quiz [q] y evaluación [e]  (skill evaluaciones-latex)
              └─► cierre: plan de habilitación ─► evaluación de habilitación (evaluaciones-latex)
```

## Referencias (leer la que corresponda a cada paso)

| Archivo | Cuándo |
|---|---|
| `referencias/diseno-pedagogico.md` | Pensar el periodo: pasos de diseño, una hora por actividad, banco de giros sencillos, señales de mala planeación |
| `referencias/referentes.md` | Datos del docente, normativa y referente de cada materia, rótulos de columnas |
| `referencias/documentos.md` | Qué lleva la malla, la parcelación y el programa, y cómo se conectan |
| `referencias/talleres.md` | Cómo se conectan los talleres con la planeación (el creador es la skill `talleres`) |
| `referencias/habilitacion.md` | Plan de habilitación y evaluación de habilitación |
| `referencias/plantilla.md` | Comandos de la clase LaTeX, compilación, reglas de formato y trampas |
| `referencias/drive.md` | Carpeta de Drive, subida de PDF y recursos, QR del programa |
| `referencias/revision.md` | Revisión automática, visual y pedagógica; cómo entregar |

## Flujo

1. **Datos.** Leer `curriculo/config/docente.yaml` (¿dicta esa materia en ese grado?, clases por
   semana, semanas por periodo, perfil) y el referente de la materia (`referentes.md`).
2. **Qué se vio o se verá.** Preguntar al docente los temas, autores, películas y lecturas. **Nunca
   inventar el temario.** Si existe una evaluación del periodo, usarla como fuente.
3. **Proponer el diseño** en pocas líneas antes de redactar: pregunta del periodo y punto de
   llegada, desempeños D1…, orden de los bloques y por qué, reparto en clases, talleres, quiz,
   evaluación y los giros previstos. Ajustar con el docente.
4. **Malla** (`malla-P<n>.tex`): desempeños con código y referente.
5. **Parcelación** (`parcelacion-P<n>.tex`): una fila por clase con su entregable (`\sello` o
   `\firma`) y sus desempeños `[D…]`.
6. **Programa del periodo** (`programa-P<n>.tex`): la misma secuencia en lenguaje para estudiantes,
   en 2 caras.
7. **Compilar y revisar** (`revision.md`): sin errores ni avisos «⚠ MODO DE TRABAJO», páginas
   bien, lista pedagógica completa, los tres documentos coherentes.
8. **Talleres** (skill `talleres` + `talleres.md`): por cada `\clase[t]` de la parcelación (máximo 3 por periodo), escribir
   `taller-<k>-P<n>.tex` en el mismo turno (una hora, un desempeño, modelo citado, pasos con
   tiempo, espacios para responder, rúbrica).
9. **Recursos y Drive** (`drive.md`): preparar lo demás que las actividades necesitan (lecturas,
   fichas) y subirlo con los PDF a la carpeta del periodo; QR solo cuando el docente autorice compartir.
10. **Entregar** (commit + push, PDF y resumen) y **ajustar** según las correcciones del docente,
    actualizando todos los documentos a la vez.
11. **Quiz y evaluación de periodo** con la skill `evaluaciones-latex`, que lee esta parcelación
    (temas y desempeños) y los talleres.
12. **Cierre: habilitación** (`habilitacion.md`): plan de habilitación del periodo
    (`habilitacion-P<n>.tex`, trabajo por desempeño) y su evaluación corta con
    `evaluaciones-latex` en modo habilitación.

Tras cambiar la skill o la plantilla, regenerar el zip para claude.ai:
`bash .claude/skills/planeacion/scripts/empaquetar.sh` (y el de evaluaciones si cambió).
