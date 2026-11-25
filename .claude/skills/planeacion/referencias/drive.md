# Recursos en Google Drive y código QR

Cada planeación tiene su carpeta en Drive. **Siempre dejar ahí los recursos** de las actividades
(lecturas con referencia, fichas de rol, presentaciones) y los PDF de malla, parcelación,
programa, talleres y plan de habilitación. El programa lleva un QR a la carpeta.

## Estructura

`Planeación/<Materia>/<Grado>°/<Año> – Periodo <n>` en la raíz de Mi unidad, junto a
`Evaluaciones` (las evaluaciones siguen en su propia carpeta, con `/subir-drive`). Ids en
`curriculo/config/drive.json`. La primera vez `planeacion` está en `null`: crear la carpeta
`Planeación` en la raíz de Mi unidad (requiere el conector de Google Drive) y guardar su id.

## Pasos

1. Si falta la carpeta del periodo (o de la materia o el grado), crearla con `create_file` y
   `contentMimeType: application/vnd.google-apps.folder`, `parentId` del nivel superior. Guardar el
   id nuevo en `drive.json`.
2. Subir cada PDF con `create_file`: `title` «<Materia> <grado>° – <Documento> P<n>
   (borrador).pdf» mientras sea borrador, `contentMimeType: application/pdf`,
   `disableConversionToGoogleType: true`, `base64Content` = `sha256:<hash>:<ruta absoluta>`.
   Comprobar que `fileSize` coincida con el tamaño local.
3. Para reemplazar una versión: `update_file` no cambia contenido; mover la anterior a la papelera
   (`trash_file`, reversible) y subir la nueva. Actualizar `drive.json`.
4. **QR**: el programa lleva `\carpeta{}` vacío («QR pendiente») hasta que el docente autorice compartir
   la carpeta «cualquier persona con el enlace puede ver» (el enlace queda público): **pedir
   confirmación cada vez**. Luego `\carpeta{https://drive.google.com/drive/folders/<id>}`,
   recompilar y volver a subir el programa. Marcar `"compartida": true` en `drive.json`.
