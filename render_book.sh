#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

FORMAT=${1:-gitbook}
RSCRIPT="${RSCRIPT:-}"

if [ -z "$RSCRIPT" ] && command -v Rscript >/dev/null 2>&1; then
  RSCRIPT="$(command -v Rscript)"
fi

if [ -z "$RSCRIPT" ]; then
  echo "No se encontró Rscript. Define RSCRIPT=/ruta/a/Rscript o instala Rscript." >&2
  exit 1
fi

# Auto-detect pandoc from micromamba env
PANDOC_DIR="$(dirname "$RSCRIPT")"
PANDOC_ENV="Sys.setenv(RSTUDIO_PANDOC='$PANDOC_DIR');"
PANDOC_WARNING='^\[WARNING\] Deprecated: --highlight-style\. Use --syntax-highlighting instead\.$'

run_render() {
  "$RSCRIPT" -e "$1" 2> >(grep -Ev "$PANDOC_WARNING" >&2)
}

cleanup_build_artifacts() {
  rm -f \
    "docs/apunte-marketing-engineering.tex" \
    "docs/apunte-marketing-engineering.log" \
    "docs/apunte-marketing-engineering.aux" \
    "docs/apunte-marketing-engineering.toc" \
    "docs/apunte-marketing-engineering.fdb_latexmk" \
    "docs/apunte-marketing-engineering.fls" \
    "docs/apunte-marketing-engineering.synctex.gz"
}

case $FORMAT in
  gitbook|html)
    echo "Renderizando GitBook (HTML)..."
    run_render "${PANDOC_ENV} bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
    cleanup_build_artifacts
    echo "GitBook creado en: docs/index.html"
    ;;
  pdf)
    echo "Renderizando PDF..."
    run_render "${PANDOC_ENV} bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
    cleanup_build_artifacts
    echo "PDF creado en docs/"
    ;;
  all)
    echo "Renderizando todos los formatos..."
    run_render "${PANDOC_ENV} bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
    run_render "${PANDOC_ENV} bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
    cleanup_build_artifacts
    echo "Todos los formatos creados en: docs/"
    ;;
  *)
    echo "Formato no reconocido: $FORMAT"
    echo "Formatos disponibles: gitbook, pdf, all"
    exit 1
    ;;
esac
