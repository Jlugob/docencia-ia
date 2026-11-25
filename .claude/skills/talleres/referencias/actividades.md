# Catálogo de actividades

Elegir por el **propósito** del momento, no por el formato. Cada una cabe en un reto de 10–15 min
y se hace con la plantilla (comando entre paréntesis). Combinar 3–4 por taller.

## Explorar (gancho)

| Actividad | Cómo | Comando |
|---|---|---|
| Escena con trampa | Fragmento de una obra (Alicia, Platón, un cómic) donde alguien razona mal o bien | `\texto` + `dialogo`/`\habla` |
| Canción o coro | Un verso que contiene el concepto (escucharla con el QR) | `\recurso{CANCIÓN}` |
| Imagen que intriga | Obra, foto histórica o meme con marcas numeradas | `\figura`, `\imagenmarcada` |
| Pregunta imposible | Paradoja o dilema breve para votar antes y después | `\opciones` |
| Video corto | ≤ 5 min, con una pregunta concreta para verlo | `\recurso{VIDEO}` |

## Practicar (lo básico)

| Actividad | Cómo | Comando |
|---|---|---|
| Traductores | Pasar frases cotidianas (refranes, coros, titulares) a la forma técnica | `tablataller` + `\sol` |
| Clasificar | Tabla con columnas de rasgos (tipo, cantidad, época, autor…) | `tablataller` |
| Relacionar | Unir conceptos con ejemplos o autores con frases | `\relacionar{…}{…}[1/b,…]` |
| Verdadero o falso razonado | V/F y, en las falsas, corregir | `verdaderofalso` + `\vf` |
| Completar | Texto o esquema con huecos | `\hueco[sol]{ancho}` |
| Ordenar | Secuencia de pasos, hechos o argumentos | `tablataller` con números |

## Aplicar

| Actividad | Cómo | Comando |
|---|---|---|
| Diagrama para completar | Mapa conceptual, cuadro de oposición, línea de tiempo, árbol | TikZ con `nodo`, `nodovacio`, `enlace` |
| Deducir | Dado un dato, sacar consecuencias (tabla de valores, casos) | `tablataller` |
| Detective | Pistas o evidencias para resolver un caso con la herramienta | `\texto` + `tablataller` |
| Analizar una fuente | Preguntas guía sobre un texto o imagen real | `\texto`/`\figura` + `\respuesta` |

## Analizar, crear, transferir

| Actividad | Cómo | Comando |
|---|---|---|
| Corrige a la IA | Respuesta de IA con errores plausibles; encontrarlos y explicar con la regla | `\respuestaia` + `\respuesta` |
| Inventa tu caso | Crear un ejemplo propio (del colegio o del municipio) que cumpla o rompa la regla | `\respuesta` |
| La objeción del otro | Intercambiar hojas: la otra pareja objeta y se responde | `\respuesta` |
| Diseña | Producto con razones y riesgos (ley, isla, prototipo, campaña) | `\respuesta`, hoja aparte |
| Debate relámpago | Postura + razón + contraargumento en 3 líneas | `\respuesta` |

## Juegos sencillos (sin preparación)

- **Puntos con puntaje** que suman 5,0 (la suma es la nota).
- **Pista** (`\pista`): ayuda breve, impresa al derecho, que orienta sin regalar la respuesta.
- **Escape en papel**: cada reto da una letra o un número; al final forman una palabra clave que el
  docente verifica (la palabra va en `\sol`).
- **Bingo o lotería conceptual**: la tabla del estudiante tiene casillas; el docente lee
  definiciones o ejemplos.
- **Duelo de parejas**: dos parejas se ponen retos de la misma forma y se corrigen mutuamente.
- **Carrera contra el reloj**: un punto con tiempo visible; puntos extra por precisión, no por
  velocidad.

## Cierre

Autoevaluación de 2–3 logros, puntaje y sello: `\cierre{puntos}{\logro{…}…}`. Si no es evaluable,
una pregunta de cierre con `\respuesta[2]{…}` y el sello.
