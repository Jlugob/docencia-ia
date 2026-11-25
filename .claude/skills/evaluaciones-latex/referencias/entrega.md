# Entregar y subir a Drive

## Entregar al docente

- Commit y push en la rama de trabajo (`.tex`, los dos PDF e `img/`).
- Enviar los dos PDF (SendUserFile).
- Responder con: tabla de bloques (preguntas, tema, qué se evalúa), la clave, el resultado de la
  revisión («tiempo estimado: X min; aciertos por intuición del estudiante simulado: N de 16;
  ajustes hechos»), fuentes e imágenes usadas y lo que debe revisar (contenidos que quizá no vio,
  datos por confirmar).
- Si corrige algo, sobrescribir el mismo archivo y conservar las letras de la clave.

## Subir a Google Drive: comando `/subir-drive`

La skill `subir-drive` (`.claude/skills/subir-drive/`) sube las versiones finales con el conector
de Google Drive. La configuración de carpetas está en `evaluaciones/drive.json`.

- Carpeta raíz «Evaluaciones» → una subcarpeta por materia → una subcarpeta por periodo
  (desde 2027; las del cuarto periodo de 2026 quedaron directamente en la carpeta de la materia).
- Nombres: «<Materia> <grado>° – Estudiante.pdf» y «<Materia> <grado>° – Docente.pdf».

## Cierre del periodo

Actualizar `evaluaciones/FLUJO-DE-TRABAJO.md` (tabla de evaluaciones con claves y lecciones nuevas)
y `referencias/<materia>.md` (citas e imágenes verificadas).
