#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

FORMAT=${1:-gitbook}
RSCRIPT="${RSCRIPT:-}"

if [ -z "$RSCRIPT" ] && command -v Rscript >/dev/null 2>&1; then
  RSCRIPT="$(command -v Rscript)"
fi

# Auto-detect pandoc from micromamba env
PANDOC_DIR="$(dirname "$RSCRIPT")"
PANDOC_ENV="Sys.setenv(RSTUDIO_PANDOC='$PANDOC_DIR');"

case $FORMAT in
  gitbook|html)
    echo "Renderizando GitBook (HTML)..."
    "$RSCRIPT" -e "${PANDOC_ENV} bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
    echo "GitBook creado en: docs/index.html"
    ;;
  pdf)
    echo "Renderizando PDF..."
    "$RSCRIPT" -e "${PANDOC_ENV} bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
    echo "PDF creado en docs/"
    ;;
  all)
    echo "Renderizando todos los formatos..."
    "$RSCRIPT" -e "${PANDOC_ENV} bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
    "$RSCRIPT" -e "${PANDOC_ENV} bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
    echo "Todos los formatos creados en: docs/"
    ;;
  *)
    echo "Formato no reconocido: $FORMAT"
    echo "Formatos disponibles: gitbook, pdf, all"
    exit 1
    ;;
esac
