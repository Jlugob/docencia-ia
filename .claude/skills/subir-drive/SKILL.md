---
name: subir-drive
description: Sube a Google Drive las versiones finales de las evaluaciones (estudiante y docente) en la carpeta «Evaluaciones / Materia / periodo». Úsala cuando el docente escriba /subir-drive o pida «subir las evaluaciones al Drive», «guardar en Drive» o «subir la de» una materia y grado.
argument-hint: "[periodo] [materia] [grados]  (p. ej. 2026-P4 filosofia 8,9)"
---

# Subir evaluaciones a Google Drive

Argumentos opcionales: periodo (por defecto el más reciente en `evaluaciones/`), materia
(`filosofia`, `tecnologia`, `etica`…; por defecto todas) y grados separados por comas.

0. **Primera vez**: si `evaluaciones/drive.json` tiene `"evaluaciones": null`, crear la carpeta
   `Evaluaciones` en la raíz de Mi unidad con `create_file` (`contentMimeType:
   application/vnd.google-apps.folder`) y guardar su id. Requiere el conector de Google Drive.
1. **Confirmar qué subir** si el docente no lo dijo: «¿Subo las versiones finales de <materia> <grados>
   del periodo <periodo>?». Si ya lo dijo, no preguntar.
2. **Comprobar que sean las finales**: `git status` limpio y PDF compilados después del último
   cambio del `.tex` (si no, compilar con `scripts/compilar.sh` de la skill evaluaciones-latex).
3. **Preparar la lista**:
   ```bash
   python3 .claude/skills/evaluaciones-latex/scripts/preparar_subida.py <periodo> [materia] [--grados 6,7]
   ```
4. **Crear las carpetas que falten** (líneas «CREAR: …») con la herramienta `create_file` del
   conector de Google Drive (`contentMimeType: application/vnd.google-apps.folder`, `parentId` el
   indicado) y **guardar el id nuevo** en `evaluaciones/drive.json` (en `id` de la materia o en
   `periodos`). Volver a correr el paso 3.
5. **Antes de subir, buscar duplicados**: si en la carpeta destino ya existe un archivo con el mismo
   título (búsqueda con `search_files` o listado de la carpeta), preguntar al docente si lo reemplaza
   (mover el anterior a la papelera con `trash_file`) o conserva ambos.
6. **Subir** cada archivo con `create_file`: `title` = título, `parentId` = destino,
   `contentMimeType: application/pdf`, `disableConversionToGoogleType: true` y
   `base64Content` = la referencia `sha256:…:<ruta>` tal cual. Se pueden enviar varias en paralelo.
7. **Comprobar** que el `fileSize` devuelto coincida con `bytes` de la lista.
8. **Responder** con el enlace a la carpeta y la lista de archivos subidos; commit y push si cambió
   `drive.json`.
