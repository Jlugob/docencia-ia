# LaTeX, compilación y maqueta

## 4. Redactar el `.tex`

- Ruta: `evaluaciones/<año>-P<periodo>/<aaaa-mm-dd>_<materia>-<grado>.tex`.
- Parte de `assets/esqueleto.tex`. Encabezado:
  ```latex
  \documentclass[carta,doscolumnas,compacta]{../plantilla/evaluacion}
  \usepackage{../plantilla/evaluacion-extras}
  \logo{../plantilla/logo-colegio.png}
  ```
- Agrupa con `contexto` + `\grupo{Responde las preguntas X a Y...}` (el script verifica los rangos).
- Cada abierta lleva `\modelo{...}` con criterios y puntaje por criterio.
- Final: `\autoevaluacion`, `\creditos{...}`, `\tablaespecificaciones`, `\imprimirclave`.
- Ancho útil de una columna ≈ 8,8 cm: dibuja TikZ para ese ancho (usa fracciones de `\linewidth`).

## Trampas de LaTeX ya resueltas
- **Letras griegas**: pdfLaTeX de este entorno no tiene fuentes griegas (`textalpha`/LGR no
  instalados). Escribe mayúsculas con letras latinas y `$\Lambda$`, `$\Sigma$`, etc.
  (p. ej. `HPAK$\boldsymbol{\Lambda}$EITO$\boldsymbol{\Sigma}$`) o translitera (*arjé*, *physis*).
- `\color` al inicio de una columna `p{}` desalinea la fila: usa `>{\leavevmode\color{...}}`.
- `%` en matemáticas con babel español: escribe `35\%` sin `\,` delante.
- En `\foreach` no uses `\v`, `\c`, `\d` como variables (son acentos de LaTeX).
- `\ifx` con una letra: compara contra una macro (`\def\q{?}\ifx\x\q`), no contra el carácter.

## 5. Compilar las dos versiones

```bash
bash .claude/skills/evaluaciones-latex/scripts/compilar.sh evaluaciones/<año>-P<n>/<archivo>.tex <carpeta_vistas>
```

Genera `<archivo>.pdf` (estudiante; la última página es la clave, no se imprime) y
`<archivo>_docente.pdf` (respuestas en círculo, justificaciones, competencias y tabla de
especificaciones). Avisa de cajas desbordadas y de caracteres que pdfLaTeX no imprime, y deja
una **hoja de contactos** (`<archivo>_contactos.png`) con todas las páginas.

## Maqueta: ahorrar páginas

- La versión del estudiante debe terminar en la última página útil (ideal: 4 páginas + clave).
- Si los créditos o la autoevaluación quedan solos: separar contextos grandes en dos bloques
  (texto y luego imagen con su pregunta, conservando las letras de la clave), reducir imágenes,
  dejar las abiertas en 5–6 líneas y acortar los créditos.
- Mirar la hoja de contactos y luego cada página: nada fuera de su recuadro, etiquetas sin
  encimarse, figuras legibles, marcas sobre el detalle correcto.
