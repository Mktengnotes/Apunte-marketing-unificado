# AGENTS.md — Apunte de Marketing Engineering

## Propósito

Este directorio contiene el proyecto unificado del apunte de Ingeniería de
Marketing, que fusiona los repositorios `MarketingEngineering` (apunte
principal) y `ApunteEjercicios` (banco de ejercicios y solucionarios) en
una línea editorial y técnica común.

`MarketingEngineering` es la referencia principal de tono, estructura
conceptual y profundidad.

## Cómo trabajar aquí

- Antes de editar, revisar `index.Rmd`, el capítulo vecino y
  `_bookdown.yml`.
- Tratar `*.Rmd`, `*.bib`, `custom-style.css`, `_bookdown.yml` y
  `preamble.tex` como la fuente de verdad.
- No editar `docs/` salvo que se pida explícitamente regenerar la salida.
- Si se crea o renombra un capítulo, actualizar `_bookdown.yml`.

## Lineamientos de escritura

- Escribir en español académico formal.
- Usar cursivas como recurso de énfasis sobrio para conceptos, términos
  técnicos, definiciones y observaciones importantes, sin abusar del
  resaltado.
- En listas e itemizaciones, preferir una sintaxis formal y uniforme,
  más cercana a un texto académico que a apuntes informales.
- Priorizar precisión conceptual, notación consistente y explicaciones
  pedagógicas sin perder rigor.
- Cuando se introduzca un modelo, cubrir en este orden si aplica:
  intuición, supuestos, formulación matemática, identificación,
  estimación, interpretación e implicancias gerenciales.
- Explicar con claridad la diferencia entre heterogeneidad observada y
  no observada, así como la conexión entre comportamiento individual y
  distribución agregada.
- Usar ejemplos de marketing realistas: retención, churn, elección,
  respuesta a campañas, adopción, demanda, CLV y segmentación.
- Evitar tono coloquial, afirmaciones grandilocuentes o relleno.

## Enfoque de econometría bayesiana

- Dar prioridad a formulaciones bayesianas cuando el contexto lo permita.
- Explicitar prior, likelihood, posterior y posterior predictiva.
- Cuando exista conjugación, mostrarla y explicar por qué simplifica el
  análisis.
- Cuando no exista solución cerrada, indicar el método computacional
  apropiado (MCMC, Gibbs, Metropolis-Hastings, HMC o aproximaciones
  variacionales).
- Incluir interpretación de intervalos creíbles y, cuando ayude,
  contrastar con la lectura frecuentista.
- Si se presentan resultados empíricos, mencionar diagnósticos,
  sensibilidad al prior y validación predictiva.

## Prioridades editoriales para ejercicios

- Mantener consistencia de notación con el apunte principal.
- Para cada ejercicio: enunciado preciso, estrategia de resolución,
  desarrollo, resultado e interpretación.
- Si el ejercicio es bayesiano, incluir prior, likelihood, posterior,
  posterior predictiva y lectura de resultados cuando corresponda.
- Si hay solucionario, evitar saltos algebraicos innecesarios.

## Convenciones técnicas

- El proyecto usa `bookdown` con fuente en R Markdown.
- Preferir ejemplos de código en R, salvo razón justificada.
- Respetar el estilo de encabezados, ecuaciones y tablas del proyecto.
- Si se agregan referencias, usar `book.bib` o `packages.bib`.
- Mantener el texto razonablemente envuelto para legibilidad del diff.

## Estilo visual

- Fuente: Source Serif Pro (serif) para cuerpo; Source Code Pro para
  código.
- Color principal: `#1565C0`. Texto: `#404040`.
- Texto justificado. Tablas centradas.
- Sin íconos de compartir en redes sociales (sharing: no en `_output.yml`).
- TOC colapsable por sección (`toc.collapse: section`).
- Figuras centradas con caption debajo, referenciadas con
  `\@ref(fig:label)`.

## Flujo de build

```
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
```

Verificar que no se rompan referencias cruzadas, ecuaciones, figuras o
bibliografía.

## Libros de referencia

En `Libros/` se encuentran los PDFs de referencia:
- Train — Discrete Choice Methods with Simulation
- Wooldridge — Introductory Econometrics
- James et al. — An Introduction to Statistical Learning (ISLR)

Usar la skill `apunte-retrieval` para consultar fragmentos indexados.

## Git y autoría

- La identidad de commit debe ser local por repositorio, no global.
- Preferir commitear con el usuario personal de GitHub autenticado en `gh`.
- Antes de hacer push, confirmar que el remoto y la cuenta tengan los
  permisos correctos.
- **Nunca incluir Co-Authored-By de Claude ni referenciarse como autor o
  coautor.** El apunte es obra del equipo docente; Claude solo asiste en
  refactorización, formateo y resúmenes.
