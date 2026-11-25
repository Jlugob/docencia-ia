# Skills empaquetadas para claude.ai

Las skills de este repositorio, listas para subirlas a una cuenta de claude.ai y usarlas en sus
chats (fuera de Claude Code).

| Archivo | Qué trae |
|---|---|
| `planeacion.zip` | El flujo del periodo: malla, parcelación, programa, talleres y habilitación; criterios pedagógicos y regla de los tiempos de la IA; plantilla `planeacion.cls`; configuración de ejemplo; referentes del MEN; piloto de Filosofía 10.° |
| `talleres.zip` | El creador de talleres: criterios, catálogo de actividades, material real con QR, plantilla `taller-recursos.sty` con versión del docente, script de revisión y talleres de ejemplo |
| `evaluaciones-latex.zip` | Evaluaciones estilo Saber: redacción, perfiles cognitivos por grado, revisión («segundo cerebro»), scripts y la plantilla `evaluacion.cls` con su catálogo de formatos |

Cada zip trae `assets/config/` con `colegio.yaml`, `docente.yaml`, el logo de ejemplo y
`kit-config.tex`. Para usarlo con tu colegio, cuéntale a Claude tus datos (nombre, municipio, logo,
colores, materias, perfil) en el primer chat: la skill ajusta la configuración (ver
`assets/config/LEEME.md`).

## Cómo subirlas

1. Descarga el `.zip` (en GitHub: abre el archivo y usa «Download raw file»).
2. En claude.ai entra a **Configuración → Capacidades** y busca la sección **Skills**.
3. Activa la ejecución de código si te lo pide.
4. Pulsa **Subir skill** y elige el `.zip` tal como está (sin descomprimirlo).

Los nombres de los menús pueden cambiar un poco con las actualizaciones de claude.ai.

## Cómo se usan allá

- Pide como siempre: «hazme la evaluación de Ciencias de 8.°» y cuenta qué se vio en clase.
- Si el entorno no puede compilar LaTeX, la skill entrega el `.tex`. Para compilarlo en Overleaf,
  sube el `.tex` junto con la plantilla y los archivos de `assets/config/` (`kit-config.tex` y el
  logo). La evaluación compila con pdfLaTeX; la planeación y los talleres, con XeLaTeX.
- El flujo completo (compilar, buscar imágenes, revisar, subir a Drive) funciona en **Claude Code**
  sobre este repositorio.
