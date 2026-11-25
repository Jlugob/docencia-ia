# Diseño pedagógico: cómo se piensa un periodo

Fuente de verdad: `curriculo/MODO-DE-TRABAJO.md` y la sección `perfil` de
`curriculo/config/docente.yaml`. Aquí está convertido en un procedimiento de diseño. Los números
(talleres, quices, entregables) son los del perfil que viene de ejemplo: si el docente cambió su
perfil, mandan los de `docente.yaml`. Se aplica a **toda** malla, parcelación y programa.

## 1. Cómo trabaja el docente en el aula (perfil de ejemplo; lo que diga su perfil no se negocia)

- **No dicta ni llena el tablero.** Explica; los estudiantes toman sus propios apuntes y el docente los
  **firma** al final de la clase.
- **Un entregable corto por clase** en el cuaderno, registrado con **sello** (pesa más que los
  calificables sueltos y mantiene el interés).
- **1 a 3 talleres (máximo 3 por periodo)**, **1 solo quiz** y **1 evaluación de periodo al final** que abarca todo.
- **Actividades que motiven**, con algo inesperado, pero **de una hora y fáciles de preparar**.

## 2. Pasos para diseñar el periodo

1. **Partir de lo real.** Qué se vio o qué se va a ver (el docente lo dice; nunca inventar temas) y el
   referente oficial de la materia (`curriculo/referentes/`).
2. **Pregunta del periodo y punto de llegada.** Una pregunta problematizadora que dé sentido a
   todos los temas y un punto de llegada concreto (una respuesta argumentada, un producto, la
   evaluación). Es un **criterio de diseño**: no se imprime salvo que el docente lo pida.
3. **Desempeños (D1…D5 aprox.).** Uno por bloque de tema, redactado como algo observable
   (interpreta, explica, evalúa, propone…), con su competencia del referente.
4. **Ordenar con sentido epistemológico.** Primero lo que hace falta para entender lo siguiente.
   Cada concepto o autor entra como **respuesta a un problema** y en diálogo con lo anterior (qué
   hereda, qué critica, qué propone). Nada suelto «por enseñar».
5. **Secuencia del periodo.** Exploración (despertar la pregunta) → conceptualización (explicación
   con apuntes firmados, fuentes) → aplicación (casos, debates, talleres) → producción y evaluación
   (taller final o producto, quiz, evaluación de periodo).
6. **Repartir en clases** según `clases_por_semana` del grado y `semanas_por_periodo`
   (`docente.yaml`): típicamente cada bloque = 1 clase de explicación (firma) + 1–2 de aplicación (sello).
7. **Diseñar cada clase** (una hora, ≈55 min efectivos):
   - inicio (2–5 min): retomar la clase anterior y enganchar con una pregunta o un objeto;
   - desarrollo: explicación o actividad;
   - cierre: síntesis y **entregable con sello** (o firma de apuntes); dejar planteado lo que
     abre la clase siguiente.
8. **Ubicar talleres, quiz y evaluación.** Talleres en los momentos de aplicación más fuertes; el
   quiz cuando ya hay material para evaluar (p. ej. semana 6); la evaluación de periodo al final.
9. **Alinear.** Cada desempeño tiene actividades que lo trabajan, entregables que lo muestran y
   preguntas que lo evalúan (columna de evaluación con `[D1]`…).
10. **Proyecto solo si lo amerita**: si hay un producto auténtico (frecuente en Tecnología), el
    periodo se organiza como proyecto; cada hito de una clase es un sello; los talleres son
    avances mayores; el producto se presenta antes de la evaluación.

## 3. Pensar también en el docente

- Toda actividad cabe en **una sola clase** con su cierre y su entregable. Nada de montajes de
  varias clases salvo un debate o juicio preparado una clase y realizado la siguiente.
- **Preparación realista**: fotocopias, proyector, tarjetas, objetos comunes. Si algo exige mucho
  trabajo, que se pueda reutilizar en otros grupos o años y dejarlo en Drive.
- Lo «fuera de lo común» es un **giro sencillo**: un rol, una pregunta inesperada, un objeto, un
  reto con tiempo, un caso de hoy.

## 4. Banco de giros sencillos (ideas para adaptar)

| Giro | Ejemplo | Preparación |
|---|---|---|
| Rol | Juicio a una época, «el autor responde preguntas de hoy», jurado | Fichas de rol (reutilizables) |
| Recreación breve | Disputa medieval, asamblea, consejo de sabios | Una pregunta y reglas de turno |
| Reto con tiempo | Traducir una frase por tres lenguas; carrera copista vs. imprenta | Una hoja |
| Objeto o caso inesperado | Caja cerrada (fe y razón), un artefacto para desarmar o analizar | Un objeto |
| Carta o respuesta | Carta a un autor desde 2027; el autor «responde» a un problema actual | Ninguna |
| Imagen o fragmento | «¿Quién es quién?» en una obra de arte; un fragmento para descifrar | Proyector |
| Producto mínimo | Mapa, ficha, veredicto, prototipo de papel, diagrama | Papel |

Por materia:
- **Filosofía**: fuentes cortas con referencia, preguntas filosóficas desde la vida de los
  estudiantes, debate argumentado, autores en diálogo (Documento 14: competencias crítica,
  dialógica y creativa).
- **Tecnología**: aprender haciendo (diseño, construcción, análisis de productos, CTS;
  Orientaciones 2022); proyectos con hitos; seguridad.
- **Ética y Cátedra Emocional**: dilemas, casos, juegos de rol; cuidado con la vida privada de
  los estudiantes (no exponerla); informar a las familias de contenidos (Ley 2503, art. 4).

## 5. Señales de una mala planeación (corregir)

- Una clase sin entregable o un entregable que no sirve para el paso siguiente.
- Temas en orden de índice de libro, sin pregunta que los una.
- Actividades vistosas que no trabajan ningún desempeño o que no caben en una hora.
- Más de un quiz, ningún taller o más de dos, evaluación de periodo antes del final.
- El programa promete algo que la parcelación no hace.

## Tiempos de la IA

Al diseñar cada clase, taller o tarea, preguntarse: ¿se podría entregar perfecto copiando un
chatbot sin haber estado en clase? Si sí, rediseñar (regla completa en
`curriculo/MODO-DE-TRABAJO.md`). Giros útiles: «la IA dijo esto: encuentra los errores», «responde
a la objeción de tu compañero», «usa lo que pasó en el juicio».
