# docencia-ia — instrucciones para Claude

Kit de skills para planear un periodo escolar completo: malla, parcelación, programa, talleres,
quiz y evaluación, y habilitación, con plantillas LaTeX adaptables a cualquier colegio.
Comunicación en español, directa.

## Al empezar una sesión

1. **¿Está configurado?** Si `curriculo/config/colegio.yaml` dice «Colegio Demo» o
   `curriculo/config/docente.yaml` dice «Nombre del Docente», ofrecer configurar el kit primero
   (`docs/ADAPTAR.md`). No inventar datos del colegio ni del docente.
2. Ubicar la tarea y **cargar la skill** que corresponde:

| Si el docente pide… | Skill | Punto de partida |
|---|---|---|
| «la malla», «la parcelación», «el programa del periodo», «planear el periodo» | `planeacion` | `curriculo/FLUJO.md`, piloto `curriculo/filosofia/10/` |
| «un taller», «una guía», «un repaso», «una hoja de trabajo» | `talleres` | `.claude/skills/talleres/referencias/capacidades.md` |
| «una evaluación», «un examen», «un quiz» | `evaluaciones-latex` | `evaluaciones/FLUJO-DE-TRABAJO.md` |
| «la habilitación», «la recuperación» | `planeacion` (`referencias/habilitacion.md`) + `evaluaciones-latex` (modo habilitación) | `curriculo/filosofia/10/habilitacion-P4.tex` |
| «súbelo al Drive», `/subir-drive` | `subir-drive` o `planeacion/referencias/drive.md` | `evaluaciones/drive.json`, `curriculo/config/drive.json` |
| Cambiar el colegio, el logo o el formato | `docs/ADAPTAR.md` | `curriculo/config/colegio.yaml` |

## Reglas que valen siempre

1. **Nunca inventar el temario**: preguntar qué se vio en clase o leerlo de la parcelación.
2. **Proponer el plan en pocas líneas antes de redactar** y ajustarlo con el docente.
3. Seguir el **perfil pedagógico** (`curriculo/MODO-DE-TRABAJO.md` y `perfil` en `docente.yaml`),
   incluida la regla de los **tiempos de la IA**.
4. Compilar, pasar la **revisión automática** de la skill y mirar las páginas antes de entregar.
5. Entregar: commit y push, los PDF y un resumen breve que diga qué se propuso sin que el docente lo
   pidiera. **Guardar cada corrección de criterio en la skill** para que no se repita.
6. Después de cambiar una skill o una plantilla, regenerar su zip:
   `bash .claude/skills/<skill>/scripts/empaquetar.sh`.
7. No guardar datos personales de estudiantes ni de familias (los nombres se llenan a mano).

## Convenciones

- Planeaciones en `curriculo/<materia>/<grado>/` (`malla-P<n>`, `parcelacion-P<n>`,
  `programa-P<n>`, `taller-<k>-P<n>`, `habilitacion-P<n>`, `img/`).
- Evaluaciones en `evaluaciones/<año>-P<n>/AAAA-MM-DD_<materia>-<grado>.tex`.
- Compilar: `bash curriculo/plantilla/compilar.sh <archivo.tex>` (planeación y talleres) y
  `bash .claude/skills/evaluaciones-latex/scripts/compilar.sh <archivo.tex>` (evaluaciones).
