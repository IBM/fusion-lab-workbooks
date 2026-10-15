# PDF Lab Guides

This directory contains the PDF assembly files, theme, and build script for generating
standalone IBM Fusion lab guide PDFs from the AsciiDoc source.

Each PDF is a complete, self-contained document — it includes the TechZone Quick Start,
environment access instructions, and all relevant lab content so learners can download
a single file and work through the exercises without needing access to the web site.

## Available guides

| File | Description |
|---|---|
| `ibm-fusion-demo-guide.pdf` | General Demo Guide — Fusion install, FDF, Storage Scale, Fusion Data Access |
| `ibm-fusion-backup-restore-guide.pdf` | Backup & Restore Lab Guide |
| `ibm-fusion-ocp-virt-guide.pdf` | OpenShift Virtualization Lab Guide |
| `ibm-fusion-hcp-guide.pdf` | Hosted Control Planes Lab Guide |
| `ibm-fusion-rdr-guide.pdf` | Regional Disaster Recovery Lab Guide |
| `ibm-fusion-access-guide.pdf` | Fusion Access for SAN Lab Guide |

---

## First-time setup

Complete these three steps once after cloning the repository before building PDFs.

### Step 1: Update `.gitignore`

The root `.gitignore` excludes all `*.pdf` files globally. Add a negation rule so the
published PDFs in this directory are tracked by Git. Edit `.gitignore` at the repository
root and add the following two lines anywhere after the `*.pdf` entry:

```
# Allow published PDFs in the pdf/ directory to be committed
!pdf/*.pdf
```

Without this change, rebuilt PDFs will not be staged for commit.

### Step 2: Install `asciidoctor-pdf`

```bash
gem install asciidoctor-pdf
```

Verify the installation (version 2.3 or later required):

```bash
asciidoctor-pdf --version
```

### Step 3: Install IBM Plex fonts

The theme uses IBM Plex Sans and IBM Plex Mono. The font TTF files are excluded from
the repository via `.gitignore` (`pdf/fonts/*.ttf`) and must be downloaded once.

From the repository root:

```bash
cd pdf/fonts

# IBM Plex Sans (body text and headings)
curl -sL "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip" \
  -o IBMPlexSans.zip
unzip -j IBMPlexSans.zip \
  "ibm-plex-sans/fonts/complete/ttf/IBMPlexSans-Regular.ttf" \
  "ibm-plex-sans/fonts/complete/ttf/IBMPlexSans-Bold.ttf" \
  "ibm-plex-sans/fonts/complete/ttf/IBMPlexSans-Italic.ttf" \
  "ibm-plex-sans/fonts/complete/ttf/IBMPlexSans-BoldItalic.ttf" -d .
rm IBMPlexSans.zip

# IBM Plex Mono (code blocks)
curl -sL "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip" \
  -o IBMPlexMono.zip
unzip -j IBMPlexMono.zip \
  "ibm-plex-mono/fonts/complete/ttf/IBMPlexMono-Regular.ttf" \
  "ibm-plex-mono/fonts/complete/ttf/IBMPlexMono-Bold.ttf" \
  "ibm-plex-mono/fonts/complete/ttf/IBMPlexMono-Italic.ttf" \
  "ibm-plex-mono/fonts/complete/ttf/IBMPlexMono-BoldItalic.ttf" -d .
rm IBMPlexMono.zip
```

The eight TTF files will be present in `pdf/fonts/` but will not appear in
`git status` because they match the `pdf/fonts/*.ttf` rule in `.gitignore`.
You will need to repeat this step after cloning on a new machine.

---

## Building the PDFs

From the repository root, run the build script:

```bash
# Build all five guides
bash pdf/build-pdf.sh

# Build a single guide
bash pdf/build-pdf.sh demo      # General Demo Guide
bash pdf/build-pdf.sh backup    # Backup & Restore
bash pdf/build-pdf.sh virt      # OpenShift Virtualization
bash pdf/build-pdf.sh hcp       # Hosted Control Planes
bash pdf/build-pdf.sh rdr       # Regional Disaster Recovery
bash pdf/build-pdf.sh fasan     # Fusion Access for SAN
```

PDFs are written directly into the `pdf/` directory. After a successful build, commit
and push the updated PDF files so they are available for download from the repository.

---

## Keeping PDFs up to date

The assembly files in this directory use `include::` directives to pull content from
the same source pages as the Antora web site. No content is duplicated.

**When a source page is edited:** both the web site and the PDF pick up the change
automatically on the next build — no extra steps needed.

**When a new page is added to a guide:**

1. Add the new `.adoc` page under `modules/ROOT/pages/` as normal.
2. Add a corresponding `include::` line and a `<<<` page break to the relevant
   assembly file in `pdf/` (e.g. `pdf/backup-restore-guide.adoc`).
3. Re-run `bash pdf/build-pdf.sh <guide>` and commit both the updated assembly
   file and the regenerated PDF.

---

## Directory structure

```
pdf/
├── README.md                        # This file
├── build-pdf.sh                     # Build script
├── cover.adoc                       # Legal notice inside-cover partial
├── lib/
│   └── antora-partial-resolver.rb   # Resolves partial$ and example$ Antora paths
├── themes/
│   └── ibm-theme-theme.yml          # Carbon Design System IBM theme
├── fonts/
│   ├── README.md                    # Detailed font download instructions
│   └── *.ttf                        # IBM Plex fonts (gitignored — download separately)
├── fusion-demo-guide.adoc           # Assembly: General Demo Guide
├── backup-restore-guide.adoc        # Assembly: Backup & Restore
├── ocp-virt-guide.adoc              # Assembly: OpenShift Virtualization
├── hcp-guide.adoc                   # Assembly: Hosted Control Planes
├── rdr-guide.adoc                   # Assembly: Regional Disaster Recovery
├── fusion-access-guide.adoc         # Assembly: Fusion Access for SAN
├── ibm-fusion-demo-guide.pdf
├── ibm-fusion-backup-restore-guide.pdf
├── ibm-fusion-ocp-virt-guide.pdf
├── ibm-fusion-hcp-guide.pdf
├── ibm-fusion-rdr-guide.pdf
└── ibm-fusion-access-guide.pdf
```
