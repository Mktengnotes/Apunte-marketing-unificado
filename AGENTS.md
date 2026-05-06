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

### Ecuaciones (matemática)

- Usar **siempre** `$$...$$` para display math; **nunca** `\[...\]`. La
  combinación `\[ ... \tag{} \]` es frágil con la versión actual de pandoc:
  pierde los backslashes y produce texto plano en HTML (`<p>[P(T t) = ...]</p>`)
  y `\begin{aligned} allowed only in math mode` en PDF.
- Numeración manual con `\tag{X.Y}` dentro de `$$...$$`. Ejemplo:

  ```latex
  $$P(T \leq t) = 1 - e^{-\lambda t} \tag{2.14}$$
  ```

- Para variantes de una misma ecuación, usar sufijos de letra: `2.14a`,
  `2.14b`, `2.14c`. Es la convención del capítulo 2.
- **`align` vs `aligned`:**
  - `\begin{align}...\end{align}` ya es entorno math: NO envolver en `$$`.
  - Cuando se quiere agrupar dentro de `$$...$$`, usar `\begin{aligned}...\end{aligned}`
    (sí va dentro de math mode).
  - Mezclar (e.g. `$$ \begin{align} ... \end{align} $$`) produce el error
    *Erroneous nesting of equation structures* en PDF.
- Math inline: `$ ... $` o `\( ... \)`.
- Referencias cruzadas en texto: `(2.14)` literal o `\@ref(eq:label)` si la
  ecuación se etiquetó con `(\#eq:label)`. El capítulo 2 usa numeración
  manual con `\tag`; capítulos 1 y 3 usan principalmente `(\#eq:...)`.

### Inserción y renumerado de ecuaciones

- Si se inserta una nueva ecuación en medio del capítulo, todas las
  posteriores deben renumerarse.
- Hacerlo en orden **descendente** para evitar colisiones intermedias
  (renombrar `\tag{2.64}` → `\tag{2.65}` antes de `\tag{2.63}` → `\tag{2.64}`,
  etc.). Un script Python con `re.sub` sobre `\tag\{2\.(\d+)([a-z]?)\}` y
  un guard de "no tocar antes de la nueva ecuación" es lo más rápido.
- Después del renumerado, actualizar las referencias inline en el texto
  (`(2.27)` → `(2.28)`, etc.). Buscar con `grep -nE '\(2\.[0-9]+[a-z]?\)'`.

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

Usar siempre el script `render_book.sh` del repo, no llamar a `Rscript` a
mano. El script auto-detecta `Rscript` desde `PATH` y configura
`RSTUDIO_PANDOC` para que pandoc resuelva bien.

```bash
# HTML (gitbook):
bash render_book.sh gitbook

# PDF:
bash render_book.sh pdf

# Ambos (deja docs/ con HTML + PDF):
bash render_book.sh all
```

Si `Rscript` no está en el `PATH` (caso típico en Git Bash en Windows
porque el instalador de R no lo agrega), exportar `RSCRIPT` antes:

```bash
RSCRIPT="/c/Program Files/R/R-4.4.1/bin/Rscript.exe" bash render_book.sh pdf
```

### Pre-requisitos de PDF (TinyTeX + TeXLive)

`bookdown::pdf_book` invoca `xelatex` vía TinyTeX. Si TinyTeX está
desactualizado, va a fallar pidiendo paquetes (`microtype.sty`,
`tcolorbox.sty`, `tabu.sty`, etc.) y el `tlmgr install` falla por
"Local TeX Live older than remote repository". Solución: hacer que
TinyTeX consulte adicionalmente el árbol completo de TeXLive 2025
(que sí tiene los paquetes) editando
`~/AppData/Roaming/TinyTeX/texmf.cnf`:

```cnf
TEXMFAUXTREES = C:/PROGRA~1/R/R-44~1.1/share/texmf,C:/texlive/2025/texmf-dist,C:/texlive/2025/texmf-var,
```

Después correr `texhash` (`~/AppData/Roaming/TinyTeX/bin/windows/texhash`)
para refrescar el índice. Esto se hace una sola vez por máquina.

### Verificación post-build

- HTML: revisar que no haya bloques `<p>[ ... ]</p>` con backslashes
  perdidos en `docs/cap-*.html`. Indica display math no reconocido.
- HTML: revisar que `<span class="math display">` envuelve cada
  ecuación numerada.
- PDF: revisar que no aparezcan `! Missing $ inserted.` ni
  `! Package amsmath Error: \begin{aligned} allowed only in math mode`
  en el log.
- Verificar referencias cruzadas, figuras, tablas y bibliografía.

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
