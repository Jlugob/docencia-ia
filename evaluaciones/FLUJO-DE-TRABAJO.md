# Flujo de trabajo de las evaluaciones

Cómo hicimos las evaluaciones del cuarto periodo de 2026 (Filosofía 6.°–11.°, sobre la base de
Tecnología 6.°–11.° y Ética 8.° y 11.°). Es la referencia para los próximos periodos; las
instrucciones operativas detalladas están en `.claude/skills/evaluaciones-latex/SKILL.md`.

## 1. Piezas del sistema

| Pieza | Dónde | Para qué |
|---|---|---|
| Clase del colegio | `evaluaciones/plantilla/evaluacion.cls` | Membrete, preguntas A–D, abiertas, clave automática, autoevaluación |
| Paquete de extras | `evaluaciones/plantilla/evaluacion-extras.sty` | Fragmentos citados, retratos, imágenes con marcas, líneas de tiempo, historietas, chats, diálogos, mapas conceptuales, secuencias, QR, justificaciones y tabla de especificaciones |
| Catálogo de formatos | `evaluaciones/plantilla/catalogo-formatos.pdf` (+ `_docente`) | Un ejemplo de cada formato para elegir |
| Skill | `.claude/skills/evaluaciones-latex/` | Flujo, reglas de redacción, esqueleto, scripts |
| Scripts | `scripts/` de la skill | `sortear_clave.py`, `compilar.sh`, `verificar_clave.py`, `wikimedia.py`, `imagenes.py` |
| Banco de fuentes | `referencias/filosofia.md` de la skill | Citas verificadas con referencia exacta e imágenes ya descargadas |
| Criterios | `evaluaciones/CRITERIOS.md` | Reglas de diseño del perfil |

## 2. Paso a paso (una evaluación a la vez)

1. **Preguntar** grado y qué se vio en clase (temas, autores, películas, lecturas; qué se vio solo
   «por encima»). La fecha suele ser «mañana».
2. **Proponer el plan** al docente en pocas líneas (bloques, formatos, imágenes, conexiones) y
   ajustarlo antes de redactar.
3. **Sortear la clave** (`sortear_clave.py`): 4 de cada letra, sin rachas.
4. **Planear**: 5–6 bloques, cada uno con un contexto (texto, fragmento, imagen, gráfica, caso) y
   2–4 preguntas; al menos 6 formatos distintos; competencia y evidencia de cada pregunta.
5. **Imágenes en segundo plano** mientras se redacta: Wellcome Collection (rápida), Wikimedia
   (lenta, límite 429), y cualquier sitio web con licencia libre (pedir permiso de red con
   `update_environment`). Verificar cada imagen abriéndola. Si no llega, dibujarla en TikZ.
6. **Redactar** el `.tex` a partir de `assets/esqueleto.tex`; cada pregunta de selección con
   `\justificacion` y `\especificacion`; abiertas con `\modelo` y criterios con puntaje.
7. **Compilar** (`compilar.sh`) y pasar el **segundo cerebro** (`referencias/revision.md` de la
   skill): `verificar_clave.py` sin avisos; `revisar_prueba.py` (tiempo estimado según el grado,
   legibilidad, pistas que permiten acertar por intuición, variedad); y el **estudiante simulado**,
   un subagente que resuelve la prueba sin la clave, primero solo por intuición y luego leyendo todo.
8. **Revisar cada página** (hoja de contactos y PNG): nada desbordado, etiquetas sin encimarse,
   marcas sobre el detalle correcto, sin páginas desperdiciadas (4 páginas + clave es lo ideal).
9. **Entregar**: commit y push, enviar los dos PDF, resumen con tabla de bloques, clave, fuentes,
   imágenes y lo que el docente debe revisar.
10. **Ajustar** según sus correcciones en el mismo archivo, conservando la clave.
11. **Subir a Drive** con el comando `/subir-drive` cuando lo pida (configuración en `evaluaciones/drive.json`).

## 3. Las dos versiones

- **Estudiante** (`<archivo>.pdf`): preguntas, contextos, abiertas con líneas, autoevaluación y
  créditos. La **última página es la clave**: no se imprime.
- **Docente** (`<archivo>_docente.pdf`, opción `solucion`): la respuesta correcta en círculo, una
  caja verde de **justificación** en cada pregunta (por qué es correcta y qué error revela cada
  distractor), la **competencia y la evidencia** de cada ítem, la **tabla de especificaciones** al
  final y la página de clave con las **respuestas modelo** de las abiertas.

## 4. Lo que pidió y corrigió el docente autor del perfil (aplicar siempre)

- Análisis, inferencia y aplicación; algo de memoria, pero «difícil y no irresoluble».
- Todo lo necesario está en la hoja; si un tema se vio por encima, va como contexto explicado.
- Imágenes reales y significativas (retratos, grabados, portadas originales, fotogramas); buscar
  en toda la web si Wikimedia falla. Citar fuente y licencia en los créditos.
- Fragmentos con referencia exacta (DK, Stephanus, Bekker, sección o capítulo) y «adaptado» si se
  simplificó. Precisar atribuciones dudosas (p. ej. «buen salvaje» no es de Rousseau; las *Tesis
  sobre Feuerbach* son de Marx; *homo homini lupus* viene de Plauto, citado en *De cive*).
- Con películas: preguntas de la película a la teoría y de la teoría a la película.
- Opciones equilibradas en longitud (la correcta no debe destacar).
- Sin páginas con solo créditos o espacio perdido.

## 5. Ejemplo real

`evaluaciones/ejemplos/2026-11-14_filosofia-10.tex`: evaluación de periodo de Filosofía 10.°
(de la escolástica a la *Utopía*), con contextos, línea de tiempo, imágenes con crédito, afirmación
y razón, abiertas con modelo de respuesta y versión del docente. Es la misma evaluación que cierra
el piloto `curriculo/filosofia/10/`.

## 6. Lecciones técnicas

- Wikimedia bloquea por exceso de peticiones (429) durante horas: una descarga a la vez, en
  segundo plano; no reintentar en bucle. Wellcome Collection responde siempre.
- La Biblioteca del Congreso, Gallica, el Met y World History Encyclopedia bloquean clientes
  automáticos: no intentar saltar el bloqueo.
- Sitios que funcionaron: Pitts Theology Library (Emory), Standard Ebooks (retratos), Luminarium
  (*Utopía* 1516), Filmsite (fotogramas pequeños de películas).
- pdfLaTeX no tiene fuentes griegas: usar `$\Lambda$`, `$\Sigma$` o transliterar.
- Contextos grandes con imagen: separarlos en dos bloques (texto + imagen con su pregunta) para que
  la maqueta no deje columnas vacías.

## 7. Mejoras hechas en noviembre de 2026

- Paso de **plan previo** aprobado por el docente.
- **Segundo cerebro**: `revisar_prueba.py` + perfiles cognitivos por grado + estudiante simulado.
- Comando **`/subir-drive`** (`.claude/skills/subir-drive/`, `evaluaciones/drive.json`).
- Skill **dividida** en referencias por tema y **empaquetada** para la cuenta de claude.ai
  (`scripts/empaquetar.sh` → `recursos/skills/evaluaciones-latex.zip`).

## 8. Evaluación honesta del flujo (15/11/2026) y mejoras pendientes

**Fortalezas:** plantilla fija, clave equilibrada, versión docente con justificaciones y tabla de
especificaciones, plan aprobado por el docente, citas exactas, imágenes reales, todo versionado.

**Debilidades:**

- **El segundo cerebro adivina, no mide.** El estudiante simulado es una IA (lee mejor que un niño
  de 6.°) y el tiempo sale de promedios. Sin datos de respuestas reales no sabemos la dificultad,
  la discriminación ni qué distractores funcionan.
- **Costo de tiempo:** cada evaluación es una sesión larga y se hace desde cero.
- **Riesgos:** la clave va en la última página del PDF del estudiante (se puede imprimir por
  error); una sola versión facilita la copia; sin adaptaciones para estudiantes con PIAR (Decreto
  1421 de 2017); abiertas sin rúbrica; las citas exigen verificación constante.

**Mejoras, en orden de impacto:**

1. **Aprovechar los resultados reales:** la calificación (OMR e integración con el sistema
   académico) ya la resuelve el docente con su propio flujo y **queda fuera de este sistema**. Lo que sí
   sirve es, si él comparte las respuestas por pregunta (sin nombres), un script de análisis
   (dificultad *p*, discriminación, uso de cada distractor) que marque los ítems a corregir.
2. **Banco de preguntas e imágenes** por tema y grado, con sus estadísticas: el año siguiente se arma
   con ítems probados más algunos nuevos.
3. **Versiones A/B automáticas** (orden de preguntas y opciones, cada una con su clave).
4. **Clave en archivo aparte**; **versión adaptada** (letra grande, menos texto, apoyos) para PIAR.
5. **Rúbricas** cortas para las abiertas y retroalimentación por estudiante.

Mejoras rápidas pendientes: clave aparte y versiones A/B. Digital (Forms/Quizizz) descartado como
reemplazo: se mantiene el impreso en LaTeX.

Ideas relacionadas: el flujo completo del periodo está en `curriculo/FLUJO.md` (la evaluación lee la
parcelación y los talleres).
