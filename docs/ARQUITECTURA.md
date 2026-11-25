# Arquitectura y decisiones de diseño

## Tres capas

```
┌──────────────────────────────────────────────────────────────────────────────┐
│ SKILLS (.claude/skills/)              el «cómo pensar»: procedimiento,       │
│  planeacion · talleres ·              criterios, catálogos, revisión          │
│  evaluaciones-latex · subir-drive                                             │
├──────────────────────────────────────────────────────────────────────────────┤
│ PLANTILLAS (LaTeX)                    el «cómo se ve» y las reglas que se     │
│  planeacion.cls · taller-recursos.sty  pueden comprobar: cuenta sellos,       │
│  evaluacion.cls · evaluacion-extras    talleres y quices; avisa al compilar    │
├──────────────────────────────────────────────────────────────────────────────┤
│ CONFIGURACIÓN (curriculo/config/)     el «de quién»: colegio, logo,           │
│  colegio.yaml · docente.yaml           formato, docente, materias, perfil     │
│  → configurar.py → kit-config.tex                                             │
└──────────────────────────────────────────────────────────────────────────────┘
```

- **Las skills no saben de qué colegio son.** Leen la configuración y el perfil, y si siguen con
  los datos de demostración, piden configurar primero.
- **Las plantillas no tienen nada fijo de un colegio.** Al cargar leen `kit-config.tex`, que
  `configurar.py` genera desde los YAML cada vez que se compila. Sin ese archivo (por ejemplo en
  Overleaf) usan valores neutros y un recuadro «LOGO».
- **El perfil pedagógico vive en dos lugares a propósito.** Los números (entregables, talleres,
  quices, evaluaciones) están en `docente.yaml`, porque la plantilla los verifica. Lo cualitativo
  (cómo se da la clase, qué se valora) está en `MODO-DE-TRABAJO.md`, porque lo interpreta Claude.

## Por qué LaTeX y no Word o Google Docs

- **Reproducible y versionable.** Cada documento es texto en git: se ve qué cambió y se vuelve a
  cualquier versión.
- **Las reglas se pueden comprobar.** La clase cuenta clases sin entregable, quices y talleres, y
  avisa al compilar. Los scripts leen el `.tex` para revisar la clave, los tiempos y la
  legibilidad.
- **Dos versiones de una sola fuente.** El taller y la evaluación salen en versión del estudiante y
  del docente (con respuestas, clave y modelo de respuesta) desde el mismo archivo.
- **Maqueta estable.** El encabezado se repite igual en cada página, las tablas largas se parten
  bien, el pie y las firmas nunca quedan solos en una hoja y no hay páginas casi vacías.

## Los desempeños como hilo

Cada periodo define desempeños `D1…Dn` en la malla. Desde ahí:

| Documento | Cómo aparece el desempeño |
|---|---|
| Parcelación | Cada clase indica en la columna de evaluación qué `[D…]` trabaja |
| Programa | Los aprendizajes del periodo, con su código, en lenguaje para estudiantes |
| Taller | Un desempeño por taller (comentario del `.tex` y autoevaluación) |
| Evaluación | `\especificacion{D…}` en cada pregunta (versión del docente) |
| Habilitación | `\recuperar{D…}{…}` por desempeño; se aprueba con el 60 % en **cada** uno |

## El «segundo cerebro»

Antes de entregar, cada pieza pasa por una revisión automática y por una cognitiva.

| Pieza | Automática | Cognitiva |
|---|---|---|
| Parcelación | Avisos «MODO DE TRABAJO» de la plantilla | Lista pedagógica (`planeacion/referencias/revision.md`) |
| Taller | `revisar_taller.py`: puntos que suman 5,0, tareas numeradas con dónde se resuelven, recursos con crédito, algo que no se resuelve con IA | Estudiante simulado: ¿entretiene, reta y cumple el desempeño? |
| Evaluación | `verificar_clave.py`: clave, rachas, opción más larga, absolutos, imágenes. `revisar_prueba.py`: tiempo por grado, legibilidad, pistas por intuición | Estudiante simulado con solo el PDF del estudiante |

## Correcciones que se acumulan

Cuando el docente corrige un criterio («los tiempos no se imprimen», «letra solo en negro», «nada
que parezca hecho por IA»), la corrección se escribe en la referencia de la skill que corresponde.
Así el sistema mejora con el uso y no repite el error. Las skills de este repositorio ya traen las
correcciones acumuladas durante un periodo real.

## Empaquetado para claude.ai

`bash .claude/skills/<skill>/scripts/empaquetar.sh` arma un `.zip` autocontenido en
`recursos/skills/` con la skill, la plantilla, la configuración de ejemplo (con su `kit-config.tex`
ya generado) y los ejemplos, para subirlo en la sección de Skills de claude.ai.

En las descripciones de las skills (el `description` del encabezado) no se usan los signos menor
que ni mayor que: claude.ai las rechaza.
