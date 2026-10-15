#!/usr/bin/env bash
# build-pdf.sh — Generate PDF lab guides from AsciiDoc source
#
# Usage:
#   ./pdf/build-pdf.sh              # build all guides
#   ./pdf/build-pdf.sh demo         # build only the Demo Guide
#   ./pdf/build-pdf.sh backup       # build only the Backup & Restore Guide
#   ./pdf/build-pdf.sh virt         # build only the OCP-Virt Guide
#   ./pdf/build-pdf.sh hcp          # build only the HCP Guide
#   ./pdf/build-pdf.sh rdr          # build only the RDR Guide
#   ./pdf/build-pdf.sh fasan        # build only the Fusion Access for SAN Guide
#
# Output: .build/pdf/<guide-name>.pdf
#
# Requirements:
#   asciidoctor-pdf >= 2.3  (gem install asciidoctor-pdf)
#   IBM Plex fonts in pdf/fonts/ (see pdf/fonts/README.md)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PDF_DIR="${SCRIPT_DIR}"
OUT_DIR="${SCRIPT_DIR}"   # PDFs land in pdf/ so they are committed to the repo
PARTIALS_DIR="${REPO_ROOT}/modules/ROOT/partials"

# ---------------------------------------------------------------------------
# Common asciidoctor-pdf options
# partials-dir: resolves Antora-style include::partial$foo.adoc[] paths
# ---------------------------------------------------------------------------
ADOC_OPTS=(
  --doctype book
  --attribute pdf-theme=ibm-theme
  --attribute "pdf-themesdir=${PDF_DIR}/themes"
  --attribute "pdf-fontsdir=${PDF_DIR}/fonts"
  --attribute "partials-dir=${PARTIALS_DIR}"
  --attribute experimental
  --attribute pdf-output
  --require "${SCRIPT_DIR}/lib/antora-partial-resolver.rb"
  --destination-dir "${OUT_DIR}"
  --backend pdf
)

# ---------------------------------------------------------------------------
# Build functions
# ---------------------------------------------------------------------------
build_demo() {
  echo "→ Building: IBM Fusion General Demo Guide..."
  asciidoctor-pdf "${ADOC_OPTS[@]}" \
    --out-file "ibm-fusion-demo-guide.pdf" \
    "${PDF_DIR}/fusion-demo-guide.adoc"
  echo "  ✓ pdf/ibm-fusion-demo-guide.pdf"
}

build_backup() {
  echo "→ Building: IBM Fusion Backup & Restore Lab Guide..."
  asciidoctor-pdf "${ADOC_OPTS[@]}" \
    --out-file "ibm-fusion-backup-restore-guide.pdf" \
    "${PDF_DIR}/backup-restore-guide.adoc"
  echo "  ✓ pdf/ibm-fusion-backup-restore-guide.pdf"
}

build_virt() {
  echo "→ Building: IBM Fusion OpenShift Virtualization Lab Guide..."
  asciidoctor-pdf "${ADOC_OPTS[@]}" \
    --out-file "ibm-fusion-ocp-virt-guide.pdf" \
    "${PDF_DIR}/ocp-virt-guide.adoc"
  echo "  ✓ pdf/ibm-fusion-ocp-virt-guide.pdf"
}

build_hcp() {
  echo "→ Building: IBM Fusion Hosted Control Planes Lab Guide..."
  asciidoctor-pdf "${ADOC_OPTS[@]}" \
    --out-file "ibm-fusion-hcp-guide.pdf" \
    "${PDF_DIR}/hcp-guide.adoc"
  echo "  ✓ pdf/ibm-fusion-hcp-guide.pdf"
}

build_rdr() {
  echo "→ Building: IBM Fusion Regional Disaster Recovery Lab Guide..."
  asciidoctor-pdf "${ADOC_OPTS[@]}" \
    --out-file "ibm-fusion-rdr-guide.pdf" \
    "${PDF_DIR}/rdr-guide.adoc"
  echo "  ✓ pdf/ibm-fusion-rdr-guide.pdf"
}

build_fasan() {
  echo "→ Building: IBM Fusion Access for SAN Lab Guide..."
  asciidoctor-pdf "${ADOC_OPTS[@]}" \
    --out-file "ibm-fusion-access-guide.pdf" \
    "${PDF_DIR}/fusion-access-guide.adoc"
  echo "  ✓ pdf/ibm-fusion-access-guide.pdf"
}

# ---------------------------------------------------------------------------
# Dispatch
# ---------------------------------------------------------------------------
TARGET="${1:-all}"

case "${TARGET}" in
  demo)    build_demo ;;
  backup)  build_backup ;;
  virt)    build_virt ;;
  hcp)     build_hcp ;;
  rdr)     build_rdr ;;
  fasan)   build_fasan ;;
  all)
    build_demo
    build_backup
    build_virt
    build_hcp
    build_rdr
    build_fasan
    echo ""
    echo "All PDFs written to pdf/"
    ;;
  *)
    echo "Unknown target: ${TARGET}"
    echo "Valid targets: all | demo | backup | virt | hcp | rdr | fasan"
    exit 1
    ;;
esac
