# Revisión antes de entregar: el «segundo cerebro»

Tres capas, de la más mecánica a la más humana. Se hacen **siempre**, en este orden, antes de
enviarle los PDF al docente.

## 1. Verificación mecánica

```bash
S=.claude/skills/evaluaciones-latex/scripts
python3 $S/verificar_clave.py <archivo>.tex "1-B 2-C ..."
```
Clave sorteada, distribución, rachas, rangos de los `\grupo`, correcta más larga, absolutos,
imágenes faltantes. **Cero avisos** antes de seguir.

## 2. Revisión cognitiva automática

```bash
python3 $S/revisar_prueba.py <archivo>.tex --informe <scratchpad>/revision-<grado>.md
```
Usa los perfiles de `perfiles-cognitivos.md`. Informa:
- **Tiempo estimado** (lectura según el grado + decisión + escritura). Meta: 60–90 % del tiempo.
- **Legibilidad** de cada contexto frente al mínimo del grado.
- **Pistas** que permiten acertar sin entender: la correcta más larga o única matizada, absolutos
  solo en los distractores, eco del enunciado, copia literal del contexto, convergencia, negación
  sin resaltar.
- **Variedad** de formatos y distribución de competencias.

Cada pista se corrige o se justifica. Correcciones típicas: alargar o matizar también los
distractores; parafrasear la correcta en vez de copiar el texto; poner absolutos también en una
opción correcta cuando son verdaderos; resaltar el **no**.

## 3. Estudiante simulado (subagente)

Un agente independiente resuelve la prueba **sin la clave**, como lo haría un estudiante del
grado, en dos pasadas. Sirve para detectar lo que ningún script ve: preguntas con dos respuestas
defendibles, preguntas que se responden sin leer el contexto, vocabulario fuera del alcance.

1. Extraer el texto del estudiante (sin la página de la clave):
   ```bash
   bash $S/texto_estudiante.sh <archivo>.pdf <scratchpad>/prueba-<grado>.txt
   ```
2. Lanzar un subagente (herramienta Agent, tipo `general-purpose`) con este encargo, adaptando
   grado y ruta. **No** le pases el `.tex` ni la versión docente: contienen la clave.

   > Eres un estudiante colombiano de <grado> grado (<edad> años). Lee el perfil de tu grado en
   > `.claude/skills/evaluaciones-latex/referencias/perfiles-cognitivos.md`. Vas a presentar la
   > evaluación que está en `<ruta del .txt>`. No abras ningún otro archivo de la evaluación.
   >
   > **Pasada 1 (intuición).** Para cada pregunta de selección (1–16), lee SOLO el enunciado y las
   > opciones, sin leer los textos de contexto, y elige la opción que parezca más probable por
   > intuición o por la forma de las opciones. Anota la letra y por qué la elegiste.
   >
   > **Pasada 2 (completa).** Ahora lee todo, como un buen estudiante de tu grado, y responde de
   > nuevo. Para cada pregunta anota: letra, seguridad (alta/media/baja), segundos que te tomaría,
   > si otra opción también te parece defendible (cuál y por qué), y palabras o ideas que un
   > estudiante de tu edad no entendería.
   >
   > Para las abiertas (17–20): ¿la consigna es clara?, ¿cuánto escribirías y en cuánto tiempo?
   >
   > Devuelve una tabla por pregunta con ambas pasadas y, al final, el tiempo total estimado y las
   > tres preguntas más problemáticas.
3. Comparar sus respuestas con la clave:
   - **Acierta en la pasada 1** (sin leer el contexto): la pregunta tiene pistas o es obvia →
     reescribir distractores o el enunciado. Más de 4 aciertos por intuición es mala señal.
   - **Falla en la pasada 2 con seguridad alta**: posible ambigüedad o error de la clave → revisar.
   - **«Otra opción también es defendible»**: reformular la opción o el enunciado hasta que haya
     una sola respuesta.
   - Palabras no comprendidas: explicarlas en el contexto o cambiarlas.
   - Tiempo total del subagente muy distinto del estimado por el script: revisar la extensión.

Al entregar, incluir en el resumen para el docente una línea con el resultado: «Tiempo estimado: X min;
aciertos por intuición: N de 16; ajustes hechos tras la revisión: …».
