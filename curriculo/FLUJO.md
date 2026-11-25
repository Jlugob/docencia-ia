# El flujo de trabajo del periodo

Cómo se conectan las tres skills (`planeacion`, `talleres`, `evaluaciones-latex`) y el comando
`/subir-drive` para producir todo el material de un periodo, de la malla a la habilitación.
Verificado de punta a punta con el piloto `curriculo/filosofia/10/` (todo compila
sin errores y las revisiones automáticas pasan sin avisos).

```
 config/colegio.yaml + docente.yaml + referentes + MODO-DE-TRABAJO.md
                │
                ▼
 1. MALLA ──► 2. PARCELACIÓN ──► 3. PROGRAMA DEL PERIODO        (skill planeacion)
                │   (una fila por clase, D1…, [t] [q] [e])
                ├──► 4. TALLERES: las clases [t], máx. 3 por periodo (skill talleres)
                ├──► 5. QUIZ [q] y EVALUACIÓN DE PERIODO [e]       (skill evaluaciones-latex)
                └──► 6. HABILITACIÓN: plan + evaluación corta      (planeacion + evaluaciones-latex)
                         │
                         ▼
 7. ENTREGA: commit + push · PDF al docente · Drive (Planeación / Evaluaciones) · zips para claude.ai
```

## Pasos

| Paso | Qué sale | Skill / comando | Revisión |
|---|---|---|---|
| 0. Datos | Materia, grado, clases por semana, qué se vio | `curriculo/config/docente.yaml`; preguntar al docente (nunca inventar el temario) | — |
| 1. Malla | `malla-P<n>.tex` (desempeños D1… con referente) | `planeacion` | `compilar.sh`, lista pedagógica |
| 2. Parcelación | `parcelacion-P<n>.tex` (clase por clase, `\sello`/`\firma`, `[t]` `[q]` `[e]`) | `planeacion` | avisos «MODO DE TRABAJO» |
| 3. Programa | `programa-P<n>.tex` (2 caras para estudiantes y acudientes, QR) | `planeacion` | 2 caras |
| 4. Talleres | `taller-<k>-P<n>.tex` + versión del docente | `talleres` (`referencias/capacidades.md`) | `revisar_taller.py` |
| 5. Quiz y evaluación | `evaluaciones/<año>-P<n>/…tex` estudiante + docente | `evaluaciones-latex` (lee parcelación y talleres) | `verificar_clave.py`, `revisar_prueba.py`, estudiante simulado |
| 6. Habilitación | `habilitacion-P<n>.tex` (trabajo por desempeño; aprobado/no aprobado) + evaluación corta | `planeacion` + `evaluaciones-latex` (modo habilitación) | lista de `habilitacion.md` |
| 7. Entrega | commit + push, PDF y resumen; Drive | `planeacion/referencias/drive.md`, `/subir-drive` | tamaños de archivo en Drive |

## Lo que une todo

- **Los mismos desempeños** (`D1`…) en malla, parcelación, programa, talleres (comentario del
  `.tex`), evaluaciones (`\especificacion`) y habilitación (`\recuperar`).
- **El modo de trabajo del docente** (`MODO-DE-TRABAJO.md`): sin dictado, un entregable con sello por
  clase, 1 a 3 talleres por periodo (máximo 3), 1 quiz, 1 evaluación; actividades de una hora; tiempos de la IA.
- **Una sola plantilla** (`plantilla/planeacion.cls` + `taller-recursos.sty`) con el encabezado del
  colegio; `compilar.sh` compila cualquiera de los documentos (y la versión del docente de los
  talleres).
- **Material real**: citas con referencia, imágenes de Wikimedia Commons y otros archivos con
  crédito, esquemas en TikZ, QR a canciones y videos.

## Comandos de verificación

```bash
bash curriculo/plantilla/compilar.sh curriculo/<materia>/<grado>/*.tex
```

```bash
python3 .claude/skills/talleres/scripts/revisar_taller.py curriculo/<materia>/<grado>/taller-<k>-P<n>.tex
```

```bash
bash .claude/skills/evaluaciones-latex/scripts/compilar.sh evaluaciones/<año>-P<n>/<archivo>.tex
```

```bash
python3 -I .claude/skills/evaluaciones-latex/scripts/revisar_prueba.py evaluaciones/<año>-P<n>/<archivo>.tex
```

```bash
for s in planeacion talleres evaluaciones-latex; do bash .claude/skills/$s/scripts/empaquetar.sh; done
```
