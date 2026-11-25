# Modo de trabajo del docente (perfil pedagógico)

**Perfil de ejemplo: el modo de trabajo de Juan Pablo Lugo, autor del kit** (docente de Filosofía,
Tecnología y Ética en Colombia). Viene activado para que el flujo funcione desde el primer día;
**cada docente lo ajusta al suyo**:

- los números (entregables, talleres, quices, evaluaciones, duración de la clase) en la sección
  `perfil` de `config/docente.yaml`: la plantilla avisa al compilar si una parcelación no los cumple;
- lo cualitativo (cómo da la clase, criterios de diseño) editando este archivo: las skills lo leen
  antes de planear, hacer un taller o una evaluación.

Es la base de toda planeación: la malla, la parcelación, el programa del periodo y las evaluaciones
deben reflejarlo.

## Cómo da la clase

- **No dicta ni llena el tablero.** Explica, y los estudiantes **toman sus propios apuntes** en el
  cuaderno. Al final, el docente **firma los apuntes**.
- **Un entregable por clase**, aunque sea corto, en el cuaderno: mantiene el interés y una presión
  sana sobre los estudiantes. El docente lo registra con **sellos** (los entregables pesan más que los
  calificables sueltos).
- **Actividades que motiven e interesen**: «cosas extrañas» que, aunque den más trabajo para
  planear o hacer, eviten que las clases sean aburridas (juicios, simulaciones, retos, recreaciones
  históricas, objetos y casos inesperados, juegos de rol, etc.).

## Evaluación en un periodo

| Elemento | Cuántos | Notas |
|---|---|---|
| Entregable con **sello** | 1 por clase | Corto, en el cuaderno; seguimiento continuo |
| **Apuntes firmados** | Clases de explicación | El docente firma los apuntes que cada estudiante tomó |
| **Taller** | 1 a 3 (**máximo 3**) | No es uno por clase: solo las clases marcadas como taller; actividad evaluativa más larga (skill `talleres`) |
| **Quiz** | 1 | Uno solo en el periodo |
| **Evaluación de periodo** | 1, al final | Abarca todo el periodo (se hace con la skill `evaluaciones-latex`) |

## Cómo se traduce en los documentos

- **Parcelación**: cada clase indica su entregable con `\sello{…}` (o `\firma{…}` cuando el
  entregable son los apuntes de una explicación). La plantilla cuenta sellos, firmas, quiz y
  talleres, los muestra en el resumen y **avisa al compilar** si una clase no tiene entregable, si
  no hay exactamente 1 quiz, si no hay entre 1 y 3 talleres, o si falta la evaluación de periodo.
- **Programa del periodo**: explica a estudiantes y acudientes el sistema (apuntes firmados,
  sellos, taller, quiz, evaluación final) y cada fila del cronograma dice qué se entrega.
- **Actividades**: proponer al menos una actividad «fuera de lo común» por semana; el docente decide.
- **Recursos en Drive**: cada planeación tiene su carpeta con lecturas, guías, talleres y los PDF;
  el programa lleva su QR (ver la skill `planeacion`).

## Criterios pedagógicos (cómo se diseña cada periodo)

 Se aplican a toda planeación y temario.

### 1. Pensar también en el docente
- **Cada clase dura una hora** (unos 55 minutos efectivos: el Decreto 277 de 2025 descuenta 5 minutos
  de descanso pedagógico por hora). Toda actividad cabe en **una sola clase** con su cierre y su
  entregable; nada de «mega actividades».
- **Preparación realista**: materiales sencillos, reutilizables o ya disponibles (fotocopias,
  proyector, tarjetas). Si una actividad exige preparar mucho, debe valer la pena y reutilizarse en
  otros grupos o años.
- Las actividades «fuera de lo común» son **giros sencillos** (un rol, una pregunta inesperada, un
  objeto, un reto corto), no montajes.

### 2. Hilo conductor (criterio de diseño)

Es para pensar la planeación, no un texto que se imprime: el resultado debe notarse en cómo se
encadenan las clases.

- El periodo tiene **una pregunta problematizadora** y **un punto de llegada**: una respuesta
  argumentada, un producto o una evaluación que reúne lo trabajado.
- **Cada clase se apoya en la anterior y prepara la siguiente**: retoma lo visto en 2–3 minutos y
  deja planteada la pregunta que abre la próxima. Los entregables con sello son los pasos de ese
  camino, no tareas sueltas.

### 3. Secuencia didáctica
- **En el periodo**: exploración (despertar la pregunta, ideas previas) → conceptualización
  (explicación, apuntes firmados, lectura de fuentes) → aplicación (casos, debates, talleres) →
  producción y evaluación (producto final, quiz, evaluación de periodo).
- **En cada clase**: inicio (enganche y conexión con la clase anterior), desarrollo (explicación o
  actividad), cierre (síntesis y entregable con sello).
- **Alineación**: cada desempeño (D1…) tiene actividades que lo trabajan, entregables que lo muestran
  y preguntas que lo evalúan.

### 4. Orden con sentido epistemológico
- Enseñar **en orden y con criterio**: primero lo que hace falta para entender lo siguiente
  (prerrequisitos conceptuales), sin saltos.
- Cada concepto o autor entra **como respuesta a un problema** (enseñanza por problemas, Documento 14);
  en filosofía, cada autor dialoga con los anteriores (qué hereda, qué critica, qué propone).
- Conectar las ideas de forma juiciosa: no enseñar temas sueltos «por enseñar», sino mostrar cómo
  una cosa lleva a la otra.

### 5. Pedagogía por proyectos cuando el caso lo amerite
- Usarla cuando hay un **producto auténtico** que da sentido al periodo (sobre todo en Tecnología,
  y en Ética o Filosofía cuando hay un problema real de la comunidad).
- El proyecto se divide en **hitos de una clase**: cada hito es el entregable con sello; los
  talleres son los momentos de avance mayor; el producto final se presenta antes de la evaluación.
- Si no hay un producto que lo justifique, se trabaja por secuencia de problemas.

## Actividades para los tiempos de la IA (regla obligatoria)

Hoy un estudiante puede resolver casi cualquier tarea con inteligencia artificial. Toda planeación,
taller, tarea, habilitación y evaluación **parte de ese hecho**: ni se ignora ni se prohíbe sin más;
se diseña teniéndolo presente.

1. **La evidencia se produce en clase.** Lo que se hace en casa es preparación; lo que demuestra el
   desempeño se hace en el aula, a mano y en la hoja (sellos, talleres, quiz, evaluación).
2. **Proceso, no solo producto.** Apuntes firmados, borradores y pasos sellados en clase; el
   producto final vale si se ve el camino.
3. **Anclar en lo que la IA no sabe:** lo que pasó en *esta* clase (el veredicto del juicio, el
   reto de traducción), la vida del estudiante, el municipio y el colegio, sus propios apuntes.
4. **La IA como objeto de análisis:** dar una respuesta de IA con errores plausibles y pedir que se
   detecten y corrijan con evidencias; comparar una respuesta de IA con la fuente; mejorarla.
5. **Pensamiento que no se delega:** posturas propias con razones, objeciones en vivo, defender en
   voz alta, responder a la objeción de otro (intercambio de hojas, disputa, juicio).
6. **Transparencia:** en lo que se hace en casa, el estudiante puede consultar (incluida la IA),
   pero escribe a mano, con sus palabras y declara para qué usó la IA. La verificación es
   presencial (evaluación o pregunta breve en clase).
7. **Señal de alarma:** si una actividad se puede entregar perfecta copiando la respuesta de un
   chatbot sin haber estado en clase, rediseñarla.
