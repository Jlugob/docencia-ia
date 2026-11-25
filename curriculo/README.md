# Currículo: planeación del periodo

Índice de todo lo que usa la skill `planeacion` (y que leen `talleres` y `evaluaciones-latex`).
Flujo de punta a punta: **`FLUJO.md`**. Perfil pedagógico: **`MODO-DE-TRABAJO.md`**.

| Carpeta / archivo | Qué contiene |
|---|---|
| `config/colegio.yaml` | Identidad del colegio y formato (nombre, logo, colores, encabezado, papel) |
| `config/docente.yaml` | Docente, materias, grados, clases por semana, perfil pedagógico |
| `config/configurar.py` | Convierte los dos YAML en `kit-config.tex` (lo corre `compilar.sh`) |
| `config/drive.json` | Ids de las carpetas de Google Drive (se llenan al crearlas) |
| `plantilla/` | `planeacion.cls` (malla, parcelación, programa, taller, habilitación), `taller-recursos.sty`, `compilar.sh`, ejemplos |
| `referentes/` | Marco normativo y referentes del MEN (Colombia) con extractos literales en `fuentes/` |
| `institucional/pei.md` | Resumen del PEI del colegio (llenar al adaptar) |
| `filosofia/10/` | **Piloto completo**: Filosofía 10.°, periodo IV |
| `<materia>/<grado>/` | Planeaciones nuevas: `malla-P<n>`, `parcelacion-P<n>`, `programa-P<n>`, `taller-<k>-P<n>`, `habilitacion-P<n>`, `img/` |

## El piloto (`filosofia/10/`)

Un periodo real de Filosofía 10.° (de la herencia griega en la Edad Media a la *Utopía* de Moro),
hecho con todo el flujo:

| Documento | Archivo | Páginas |
|---|---|---|
| Malla curricular | `malla-P4.tex` | 1 (oficio horizontal) |
| Parcelación por clases (2 por semana, sellos, firmas, taller, quiz, evaluación) | `parcelacion-P4.tex` | 2 |
| Programa del periodo para estudiantes y acudientes | `programa-P4.tex` | 2 (una hoja) |
| Taller 1 («Mi *quaestio*»: argumentar al modo escolástico) y taller 2 («Diseña tu isla de Utopía» para un problema real) | `taller-1-P4.tex`, `taller-2-P4.tex` | 3 y 2, más versión del docente |
| Taller de repaso de lógica categórica (Alicia, una canción, respuesta de IA para corregir) | `taller-logica-categorica.tex` | 3, más versión del docente |
| Plan de habilitación por desempeños | `habilitacion-P4.tex` | 2 |
| Evaluación de periodo | `../../evaluaciones/ejemplos/2026-11-14_filosofia-10.tex` | 5, más versión del docente |

```bash
bash curriculo/plantilla/compilar.sh curriculo/filosofia/10/*.tex
```
