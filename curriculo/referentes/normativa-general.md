# Marco normativo general (Colombia) para mallas y parcelaciones

Revisado el 15/11/2026 en el **Gestor Normativo de Función Pública** (texto vigente con notas de
modificación). ✔ = verificado en el texto vigente; ⚠ = falta cotejar. Extractos literales en
`fuentes/ley-115-1994-extractos.txt` y `fuentes/decreto-1075-2015-extractos.txt`. Para bajar
otra norma: `python3 scripts/gestor_normativo.py <id>` (el script explica el arreglo del
certificado del sitio).

## 1. Contexto del colegio (llenar para cada colegio)

- Nombre, municipio y logo: `../config/colegio.yaml`. Naturaleza (oficial o privado) y entidad
  que ejerce la vigilancia (Secretaría de Educación certificada que corresponda).
- Documentos institucionales que mandan sobre todo esto y que Claude pide cuando los necesita:
  **PEI** (resumen en `../institucional/pei.md`), **SIEE** (escala, porcentajes, número de
  periodos), plan de estudios con **intensidad horaria** por área y grado, manual de convivencia.

## 2. Leyes y decretos que enmarcan el currículo

| Norma | Qué dice (lo que nos importa) | Estado |
|---|---|---|
| **Ley 115 de 1994**, art. 14 (mod. Leyes 1013 y 1029 de 2006, 1503 de 2011) | Enseñanza obligatoria: Constitución e instrucción cívica, tiempo libre, ambiente, educación para la justicia, la paz, la democracia… y **la formación de los valores humanos**, educación sexual. **Parágrafo 1: salvo a) y b), estos temas no exigen asignatura específica: se incorporan a todo el plan de estudios** | ✔ |
| Ley 115, **art. 23** | Áreas obligatorias de la básica (mín. 80 % del plan): entre ellas **4. Educación ética y en valores humanos** y **9. Tecnología e informática** | ✔ |
| Ley 115, **art. 31** | Media académica: las mismas áreas en nivel más avanzado **más ciencias económicas, políticas y la filosofía** → **Filosofía es obligatoria en 10.° y 11.°**; en 6.°–9.° es decisión del PEI | ✔ |
| Ley 115, **arts. 76–79** | Currículo, **autonomía escolar**, regulación del currículo (el MEN da lineamientos; el colegio fija su plan de estudios; los cambios significativos se presentan a la Secretaría de Educación), **plan de estudios**: objetivos por niveles, grados y áreas, metodología, distribución del tiempo, criterios de evaluación | ✔ |
| **Decreto 1075 de 2015** (Único Reglamentario; compila 1860, 1290, 1850, 1038, 1421…) | Es la norma que se cita hoy. En el Gestor Normativo, con modificaciones hasta 2025 | ✔ |
| D. 1075, **arts. 2.3.3.1.6.1–2** (antes D. 1860 arts. 34–35) | Plan de estudios con las áreas del art. 23 + optativas (≤ 20 %); áreas por asignaturas y proyectos; cada asignatura con **contenido, intensidad y duración que determine el PEI**; métodos **activos y vivenciales** | ✔ |
| D. 1075, **art. 2.4.3.1.2** (antes D. 1850 de 2002, mod. **Decreto 277 de 2025**) | **40 semanas lectivas**; mínimos en horas de 60 min: **secundaria y media académica 30 h semanales / 1 200 anuales** (80 % para áreas obligatorias). **Parágrafo 3 (2025): descanso pedagógico de 5 minutos por cada periodo de 60 minutos** → una «hora» de clase rinde unos 55 minutos | ✔ |
| D. 1075, **arts. 2.3.3.3.3.4–5** (antes D. 1290 de 2009) | **SIEE** debe contener: criterios de evaluación y promoción, escala institucional y su equivalencia, estrategias de valoración integral, seguimiento, autoevaluación, apoyo, cumplimiento docente, periodicidad y estructura de informes, instancias de reclamación, participación. **Escala nacional: Superior, Alto, Básico, Bajo**; «básico» = superar los desempeños necesarios teniendo como referentes **los estándares, las orientaciones y lineamientos del MEN y el PEI** | ✔ |
| D. 1075, **arts. 2.3.3.4.5.1 y ss.** (Ley 1732 de 2014, D. 1038 de 2015) | **Cátedra de la Paz** obligatoria (oficiales y privados) como **asignatura adscrita a Ciencias Sociales, Ciencias Naturales o Ética**; el colegio fija los contenidos y debe desarrollar **al menos dos** de: justicia y DD. HH., recursos naturales, riquezas culturales, resolución pacífica de conflictos, prevención del acoso escolar, diversidad, participación política, memoria histórica, **dilemas morales**, proyectos de impacto social, acuerdos de paz, **proyectos de vida y prevención de riesgos** | ✔ |
| D. 1075, **art. 2.3.3.5.2.3.5** (antes D. 1421 de 2017) | **PIAR**: ajustes curriculares, didácticos, evaluativos y metodológicos para estudiantes con discapacidad, complemento del Diseño Universal para el Aprendizaje | ✔ |
| **Ley 1620 de 2013** y Decreto 1965 de 2013 | Sistema Nacional de Convivencia Escolar; la Ley 2503 le añade funciones sobre educación emocional | ✔ (la cita la Ley 2503) / ⚠ resto |
| **Ley 2503 de 2025** | **Cátedra de Educación Emocional** obligatoria (ver `educacion-emocional.md`). En el Gestor Normativo figura **sin vigencias ni reglamentación** registradas, y el Decreto 1075 no tiene aún ninguna sección sobre educación emocional (15/11/2026) | ✔ |

## 3. Referentes de calidad del MEN por tipo

- **Lineamientos curriculares** (1998–2002): enfoques y fundamentos por área. Hay para Ética.
- **Estándares básicos de competencias** (2003–2006): Lenguaje, Matemáticas, Ciencias,
  **Competencias ciudadanas** (Guía 6) e Inglés. No hay para Filosofía ni Tecnología (Tecnología
  tuvo los de la Guía 30 de 2008, reemplazada como referente por las Orientaciones de 2022).
- **Orientaciones pedagógicas / curriculares**: Filosofía (Doc. 14, 2010), Tecnología e
  Informática (2022), entre otras.
- **DBA (Derechos Básicos de Aprendizaje)**: existen para Lenguaje, Matemáticas, Ciencias
  Naturales, Ciencias Sociales, Inglés y Transición (⚠ lista de memoria; verificar si salió alguno
  nuevo). Ojo: el D. 1075 (art. 2.3.3.3.3.5) define el desempeño básico frente a «estándares,
  orientaciones y lineamientos» del MEN, **no** frente a DBA: por eso es legítimo usar las
  orientaciones como referente en nuestras materias. **No existen DBA para Filosofía, Tecnología, Ética ni Educación emocional.**

## 4. Consecuencia práctica

El formato de malla del colegio tiene columnas «ESTÁNDARES» y «DBA», pensadas para las áreas que
sí los tienen. Para las materias del docente hay que reemplazarlas por el referente oficial
equivalente de cada una y explicarlo en la nota aclaratoria: ver `../plantilla/README.md` (columnas por materia).

## 5. Pruebas externas (Saber 11)

Filosofía no tiene prueba propia desde la reforma del examen de 2014: se evalúa a través de
**Lectura crítica** (textos filosóficos) y **Sociales y ciudadanas** (⚠ verificar en la guía de
orientación vigente del ICFES). La Ley 2503 (art. 9) ordena evaluar competencias emocionales en las
pruebas Saber, sin fecha ni diseño definidos aún.
