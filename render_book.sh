#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

FORMAT=${1:-gitbook}
RSCRIPT="${RSCRIPT:-}"
MAMBA_ENV_NAME="${MAMBA_ENV_NAME:-}"
MAMBA_EXE="${MAMBA_EXE:-}"

# Si se pide un env de micromamba, usar `micromamba run` para activar
# automaticamente el PATH/DLLs del env (caso tipico Windows).
if [ -n "$MAMBA_ENV_NAME" ]; then
  if [ -z "$MAMBA_EXE" ]; then
    if [ -x "$(dirname "$0")/../.micromamba/micromamba.exe" ]; then
      MAMBA_EXE="$(dirname "$0")/../.micromamba/micromamba.exe"
    elif command -v micromamba >/dev/null 2>&1; then
      MAMBA_EXE="$(command -v micromamba)"
    fi
  fi
  if [ -z "$MAMBA_EXE" ]; then
    echo "MAMBA_ENV_NAME=$MAMBA_ENV_NAME pedido pero no encuentro micromamba. Define MAMBA_EXE." >&2
    exit 1
  fi
  if [ -z "${MAMBA_ROOT_PREFIX:-}" ]; then
    export MAMBA_ROOT_PREFIX="C:/mb"
  fi
fi

if [ -z "$RSCRIPT" ] && [ -z "$MAMBA_ENV_NAME" ] && command -v Rscript >/dev/null 2>&1; then
  RSCRIPT="$(command -v Rscript)"
fi

if [ -z "$RSCRIPT" ] && [ -z "$MAMBA_ENV_NAME" ]; then
  echo "No se encontró Rscript. Define RSCRIPT=/ruta/a/Rscript, MAMBA_ENV_NAME=<env> o instala Rscript." >&2
  exit 1
fi

# Auto-detect pandoc desde el env
if [ -n "$MAMBA_ENV_NAME" ]; then
  PANDOC_DIR="${MAMBA_ROOT_PREFIX}/envs/${MAMBA_ENV_NAME}/Library/bin"
else
  PANDOC_DIR="$(dirname "$RSCRIPT")"
fi
PANDOC_ENV="Sys.setenv(RSTUDIO_PANDOC='$PANDOC_DIR');"
PANDOC_WARNING='^\[WARNING\] Deprecated: --highlight-style\. Use --syntax-highlighting instead\.$'

run_render() {
  if [ -n "$MAMBA_ENV_NAME" ]; then
    "$MAMBA_EXE" run -n "$MAMBA_ENV_NAME" Rscript -e "$1" 2> >(grep -Ev "$PANDOC_WARNING" >&2)
  else
    "$RSCRIPT" -e "$1" 2> >(grep -Ev "$PANDOC_WARNING" >&2)
  fi
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
