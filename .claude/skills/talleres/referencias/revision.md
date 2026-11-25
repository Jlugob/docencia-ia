# Revisión del taller (segundo cerebro)

## 1. Script

```bash
python3 .claude/skills/talleres/scripts/revisar_taller.py <taller>.tex
```

Revisa: tiempos (suma de `\reto`, `\paso` y gancho ≈ 55 min), puntos que sumen 5,0 (la nota) y el cierre sobre 5,0
desempeños declarados, que cada actividad tenga solución para el docente, citas con
referencia, enlaces de QR (vacíos o de búsqueda), elemento «tiempos de la IA», imágenes faltantes.
**Corregir los avisos** antes de seguir.

## 2. Visual

Compilar y mirar las dos versiones: hasta 4 páginas sin páginas casi vacías, nada desbordado, ningún reto partido de su
contenido, espacio suficiente para escribir, la versión del docente con todas las respuestas.

## 3. Estudiante simulado (talleres evaluables o nuevos formatos)

Un subagente con la versión del estudiante (texto de `pdftotext`) y el perfil del grado
(`evaluaciones-latex/referencias/perfiles-cognitivos.md`) resuelve el taller **sin** la versión del
docente y reporta: qué no entendió, dónde se atascó, cuánto tardó cada reto y qué le pareció
aburrido. Comparar con la clave; ajustar instrucciones ambiguas.

## 4. Lista final

- [ ] Desempeño declarado y trabajado; **resoluble con lo que trae la hoja** (no depende de la
      memoria: cada punto tiene su explicación, texto o ejemplo).
- [ ] Gancho que plantea el problema; puntos que suben de dificultad; puntajes que suman 5,0; cierre con nota y sello.
- [ ] Material real con referencia exacta; enlaces verificados (o avisados).
- [ ] Tiempos de la IA: no se puede entregar perfecto copiando un chatbot.
- [ ] Versión del docente completa; respuestas inequívocas.
- [ ] Hasta 4 páginas, sin páginas casi vacías; estilo sobrio de la plantilla.
- [ ] Riqueza visual: al menos una imagen real con crédito o un esquema que ayude a entender.
- [ ] Conectado con la parcelación, el programa y la habilitación si es de un periodo.
