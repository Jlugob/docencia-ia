# Referentes y datos del colegio

Leer antes de diseñar. El módulo de referentes que viene con el kit es el de **Colombia** (MEN);
para otro país se reemplaza `curriculo/referentes/` con el mismo esquema. Todo está verificado en fuentes oficiales (Gestor Normativo de Función
Pública, MEN); lo no verificado está marcado con ⚠ en los archivos.

| Archivo | Qué contiene |
|---|---|
| `curriculo/config/docente.yaml` | Materias, grados, códigos, clases por semana, semanas por periodo, modo de trabajo |
| `curriculo/referentes/normativa-general.md` | Ley 115, Decreto 1075 (40 semanas, 30 h, descanso de 5 min por hora, SIEE, escala, Cátedra de la Paz, PIAR), Ley 2503 |
| `curriculo/referentes/tecnologia.md` | Orientaciones curriculares MEN 2022: 4 componentes y competencias por grados |
| `curriculo/referentes/filosofia.md` | Documento 14 (2010): competencias crítica, dialógica y creativa; núcleos de problemas |
| `curriculo/referentes/etica.md` | Lineamientos 1998 (componentes) + Estándares de competencias ciudadanas (Guía 6) |
| `curriculo/referentes/educacion-emocional.md` | Ley 2503 de 2025 (sin reglamentar) |
| `curriculo/institucional/pei.md` | Resumen del PEI del colegio (enfoque pedagógico, modelo); llenarlo al adaptar el kit |

## Rótulos que pone `\materia{…}`

| Materia | Fila superior | Componente | Última columna |
|---|---|---|---|
| Tecnología | Competencias de referencia (MEN 2022) | Componente (4) | Evidencias de aprendizaje (MEN 2022) |
| Filosofía | Pregunta problematizadora | Núcleo de problemas | Desempeños (Doc. 14) |
| Ética | Estándares (competencias ciudadanas) | Componente (1998) | Estándares específicos (Guía 6) |
| Emocional | Fines de la cátedra (Ley 2503, art. 7) | Competencia emocional | Desempeños |

Materias que no están en la tabla (Matemáticas, Lenguaje, Ciencias…): `\materia{Matemáticas}` usa
las columnas estándar con estándares y DBA; copiar los estándares y DBA literalmente de los
documentos del MEN.

## Datos que faltan

Lo que en `docente.yaml` está en `null` (clases por semana, grados) y lo que no está en el
repositorio (SIEE, calendario real, lo visto en periodos anteriores): preguntarlo al docente cuando
se necesite. **Nunca inventarlo.**
