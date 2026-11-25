# Adaptar el kit a tu colegio

Todo lo que identifica al colegio y al docente vive en **`curriculo/config/`**. Las plantillas
(malla, parcelación, programa, taller, habilitación y evaluaciones) lo leen al compilar: **no hay
que tocar código LaTeX**. Se hace una sola vez, en unos 10 minutos.

> Atajo: en Claude Code basta decir «configura el kit para mi colegio». Las skills detectan que la
> configuración sigue con los datos de demostración y te preguntan todo lo de abajo.

## 1. Identidad del colegio — `curriculo/config/colegio.yaml`

```yaml
colegio:
  nombre: Institución Educativa San José
  municipio: Chía, Cundinamarca
  logo: logo-colegio.png          # copia tu logo (PNG o PDF) en curriculo/config/
  leyenda: ""                     # vacío = «Este documento es propiedad intelectual del <nombre>»
  firma_institucional: COORDINACIÓN ACADÉMICA
```

El logo se ve mejor en PNG con fondo transparente y unos 600 px de alto. Si falta, las plantillas
ponen un recuadro «LOGO» del mismo tamaño (no fallan).

## 2. Formato — misma sección `formato:`

| Clave | Opciones | Qué cambia |
|---|---|---|
| `encabezado` | `tabla` · `sencillo` | `tabla`: logo, colegio, nombre del formato, leyenda y página en una tabla (formato tipo Word, el más común en colegios). `sencillo`: logo y nombre a la izquierda, formato y página a la derecha, una línea debajo |
| `color_institucional` | hexadecimal sin `#` | Nombre del colegio y bordes del encabezado |
| `color_programa`, `color_programa_2` | hexadecimal | Franjas y títulos del programa, taller y habilitación (los tonos claros se derivan solos) |
| `color_evaluacion` | hexadecimal | Acento de las evaluaciones |
| `fuente` | cualquier fuente instalada | Por defecto DejaVu Sans (de la familia de Verdana/Tahoma) |
| `papel_planeacion` | `oficio` · `carta` | Papel horizontal de malla y parcelación |

Si el colegio tiene un formato de Word muy distinto (otras columnas, otro encabezado), el punto de
partida es `curriculo/plantilla/planeacion.cls`: el encabezado está en `\@encabezadotabla` y
`\@encabezadosencillo`, y las columnas de la malla en `\materia{…}`.

## 3. Docente y materias — `curriculo/config/docente.yaml`

```yaml
docente: María Fernanda Rojas
anio: 2027
periodos: 4
semanas_por_periodo: 10
materias:
  matematicas:
    nombre: Matemáticas
    codigo: MAT
    grados: [6, 7]
    clases_por_semana: {6: 5, 7: 5}
```

- Las claves `filosofia`, `tecnologia`, `etica` y `emocional` ya traen el referente del MEN: la
  malla rotula sus columnas y agrega la nota aclaratoria de por qué no hay DBA.
- Cualquier otra materia (`\materia{Matemáticas}`) usa las columnas estándar con estándares y DBA.
- Lo que no sepas todavía, déjalo en `null`: Claude lo pregunta cuando lo necesite.

## 4. Perfil pedagógico — sección `perfil:` de `docente.yaml` y `curriculo/MODO-DE-TRABAJO.md`

El kit trae como ejemplo el perfil de su autor: sin dictado (apuntes firmados), un entregable corto
con sello por clase, 1 a 3 talleres, 1 quiz y 1 evaluación por periodo, actividades de una hora y
la regla de los **tiempos de la IA**. Cámbialo al tuyo:

```yaml
perfil:
  entregable_por_clase: false     # sin aviso por clases sin \sello o \firma
  quices_por_periodo: [2, 3]      # mínimo y máximo
  talleres_por_periodo: [2, 4]
  evaluaciones_de_periodo: 1
```

La plantilla avisa al compilar («⚠ MODO DE TRABAJO …») si una parcelación no cumple estos
números. Lo cualitativo (cómo das la clase, qué valoras) va en `curriculo/MODO-DE-TRABAJO.md`, que
las skills leen antes de diseñar.

## 5. Institución y referentes

- `curriculo/institucional/pei.md`: resumen del PEI (enfoque pedagógico, SIEE, habilitación).
- `curriculo/referentes/`: el módulo por defecto es el de **Colombia** (Ley 115, Decreto 1075,
  orientaciones del MEN, Saber 11). Para otro país, reemplázalo con el mismo esquema: un archivo por
  materia con su referente oficial y extractos literales en `fuentes/`.

## 6. Google Drive (opcional)

Con el conector de Google Drive, las skills dejan los PDF y recursos en
`Planeación/<Materia>/<Grado>°/<Año> – Periodo <n>` y `Evaluaciones/<Materia>`. La primera vez crean
esas carpetas y guardan sus ids en `curriculo/config/drive.json` y `evaluaciones/drive.json`.

## Comprobar

```bash
python3 curriculo/config/configurar.py
```

```bash
bash curriculo/plantilla/compilar.sh curriculo/filosofia/10/malla-P4.tex
```

El primer comando valida la configuración (colores, estilo, logo); el segundo compila el piloto
con tu encabezado.
