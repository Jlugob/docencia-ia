# Plantilla del taller: referencia rápida

`\documentclass[taller,borrador]{planeacion}` carga `curriculo/plantilla/taller-recursos.sty`.
**Estilo del taller** (criterio del perfil): letra **solo en negro**, con negrita para
destacar (color solo si es necesario, como las respuestas en vino de la versión del docente);
**tablas y ficha en negro con cabecera gris**, como los formatos del colegio, sin verde ni rayado;
el verde queda solo en la **barra de los textos citados** (como el contexto de las evaluaciones);
**sin tiempos impresos** (mostrarlos puede jugarle en contra al docente); sin estrellas; puntos que suman
5,0 (la nota); textos en párrafo, no en recuadros; pistas al derecho; Caladea para leer y sans en títulos.
Ni exceso de recuadros («hecho por IA») ni una hoja sin ningún decorado. Esqueleto: `assets/esqueleto-taller.tex`.

## Compilar

```bash
bash curriculo/plantilla/compilar.sh curriculo/<materia>/<grado>/taller-<…>.tex
```

Salen `taller-….pdf` (estudiante) y `taller-…-docente.pdf` (respuestas en vino, encabezado «VERSIÓN
DEL DOCENTE», marca DOCENTE si es borrador).

## Comandos

| Comando | Para qué |
|---|---|
| `\fichataller{número o nombre}{semana y clase}{duración}{modalidad}` | Ficha con nombres y fecha a mano (la duración no se imprime) |
| `\titulotaller{Tema}{indicación corta}` | «Taller: Tema» centrado y la indicación (modalidad, dónde se resuelve). Así empieza la hoja |
| `\destacado{Rótulo}{texto}` | Párrafo con rótulo en negrita |
| (desempeños) | **No se imprimen** en el taller: van en el comentario inicial del `.tex` |
| `\seccion{n}{Título}` | Franja de sección (disponible; en talleres se prefieren los puntos numerados) |
| `\texto{Rótulo}{contenido}{referencia}` | Texto citado como el contexto de las evaluaciones: fondo gris claro y barra verde a la izquierda (rótulo opcional: `{}`) |
| `\fuente{texto}{referencia}` | Cita simple |
| `dialogo` + `\habla{Personaje}{…}` | Escena o diálogo |
| `\figura[ancho]{archivo}{pie}` · `\imagenmarcada[ancho]{archivo}{pie}{x/y/n,…}` | Imágenes (pie con crédito) |
| `\imagenlado[fracción]{archivo}{texto}` | Imagen a la izquierda y su explicación a la derecha (obra, manuscrito, mapa) |
| `\euler{TikZ}{leyenda}` | Diagrama de Euler pequeño con leyenda; varios en fila separados por `\hfill` |
| `\recurso{TIPO}{título}{tarea}{enlace}` | QR a canción, video, podcast… |
| `\recuerda[Título]{explicación}` | Explicación breve con ejemplo para resolver sin depender de la memoria (recuadro gris con barra verde; título por defecto «Para recordar») |
| `\concepto{término}{definición}` | Glosario breve |
| `\respuestaia{texto}` | Respuesta de una IA para analizar |
| `\reto{0}{título}{tiempo}{puntos}` | Punto numerado «1. Título» con su puntaje a la derecha. **El tiempo no se imprime** (queda en el `.tex` para planear la hora). Los puntajes suman 5,0 |
| `\apartado{título}` | Apartado sin número (p. ej. «Cómo se valora») |
| `tareas` + `\tarea{…}` | **Lo que deben hacer**, siempre en viñetas de número por punto (2.1, 2.2…) |
| `\enlahoja` · `\encuaderno` · `\enhojaaparte` · `\envozalta` | Inicio de tarea que dice dónde se resuelve («**En esta hoja,** …») |
| `\pista{texto}` | Pista breve en letra pequeña (al derecho) |
| `pasos` + `\paso{min}{…}` | Pasos con tiempo (preferir puntos con `\reto{0}{…}{min}{}` y `tareas`) |
| `tablataller[altura]{colspec}` + `\cabecera\tit{…} & …` | Tabla para llenar a mano (altura de fila: 1.55 por defecto; más para escribir más) |
| `\sol{…}` | Solución que solo aparece en la versión del docente |
| `\hueco[solución]{ancho}` | Espacio en línea para completar |
| `\respuesta[renglones]{respuesta modelo}` | Renglones (docente: respuesta modelo) |
| `verdaderofalso` + `\vf{V/F}{enunciado}` | Verdadero o falso |
| `opciones` + `\op{…}` / `\op*{correcta}` | Selección |
| `\relacionar{{a},{b}}{{x},{y}}[1/b,2/a]` | Unir columnas (docente: líneas de solución) |
| TikZ `nodo`, `nodovacio`, `enlace`, `etiqueta` | Diagramas y mapas para completar |
| `\lineas{n}` · `\casilla` | Renglones y casillas |
| `rubrica` + `\criterio{…}{…}{…}{…}{…}` | Rúbrica de 4 niveles (talleres de producto) |
| `\cierre{5,0}{\logro{…}…}` | Autoevaluación + nota sobre 5,0 + sello |
| `\cierretaller{5,0}` | Nota sobre 5,0 y sello (talleres con rúbrica) |

## Estructura («menos es más»)

Directo: ficha → `\titulotaller{Tema}{indicación}` (dice si todo va en la hoja, el cuaderno o una hoja
aparte) → puntos numerados (`\reto`), cada uno con material y **tareas numeradas** (`tareas` +
`\tarea`, empezando por dónde se resuelve) → cierre. Sin
«Lo que vas a demostrar», sin propósito largo, sin secciones anidadas.

## Reglas y trampas

- Hasta **4 páginas**, sin páginas casi vacías (criterio del perfil). Si queda una página casi vacía: columnas más anchas para que las filas no partan, menos renglones,
  diagramas más bajos, quitar lo accesorio; nunca letra más pequeña.
- Para que unas tareas no queden en una página y el diagrama al que se refieren en la otra, poner
  `\needspace{12\baselineskip}` antes de las tareas.
- `\reto` reserva espacio para no quedar solo al pie; una tabla (`tablataller`) no se parte.
- Dentro de `\recuerda` o `\texto` no poner tablas (`tabular`): impiden cortar la página donde
  corresponde y el punto entero salta a la otra cara. Usar líneas con `\\`.
- `\sol` al inicio de una celda ya lleva `\leavevmode` (si no, la respuesta baja una línea).
- Columnas `p{…}` con ancho suficiente para escribir a mano; en `tablataller` las filas son altas.
- Textos en párrafo, no en recuadros; tablas solo donde se escribe; nada de sombras, esquinas
  redondeadas, iconos ni mayúsculas espaciadas en todo. Decorados sí, pero pocos y con función.
