# IBM Plex Fonts

Place the following IBM Plex TTF files in this directory before running `build-pdf.sh`.

IBM Plex is open source and available at https://github.com/IBM/plex/releases

## Required files

### IBM Plex Sans (body text and headings)
- `IBMPlexSans-Regular.ttf`
- `IBMPlexSans-Bold.ttf`
- `IBMPlexSans-Italic.ttf`
- `IBMPlexSans-BoldItalic.ttf`

### IBM Plex Mono (code blocks)
- `IBMPlexMono-Regular.ttf`
- `IBMPlexMono-Bold.ttf`
- `IBMPlexMono-Italic.ttf`
- `IBMPlexMono-BoldItalic.ttf`

## Quick download (macOS / Linux)

```bash
cd pdf/fonts

# Download and extract IBM Plex Sans
curl -sL "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-sans%401.1.0/ibm-plex-sans.zip" -o IBMPlexSans.zip
unzip -j IBMPlexSans.zip \
  "ibm-plex-sans/fonts/complete/ttf/IBMPlexSans-Regular.ttf" \
  "ibm-plex-sans/fonts/complete/ttf/IBMPlexSans-Bold.ttf" \
  "ibm-plex-sans/fonts/complete/ttf/IBMPlexSans-Italic.ttf" \
  "ibm-plex-sans/fonts/complete/ttf/IBMPlexSans-BoldItalic.ttf" -d .
rm IBMPlexSans.zip

# Download and extract IBM Plex Mono
curl -sL "https://github.com/IBM/plex/releases/download/%40ibm%2Fplex-mono%401.1.0/ibm-plex-mono.zip" -o IBMPlexMono.zip
unzip -j IBMPlexMono.zip \
  "ibm-plex-mono/fonts/complete/ttf/IBMPlexMono-Regular.ttf" \
  "ibm-plex-mono/fonts/complete/ttf/IBMPlexMono-Bold.ttf" \
  "ibm-plex-mono/fonts/complete/ttf/IBMPlexMono-Italic.ttf" \
  "ibm-plex-mono/fonts/complete/ttf/IBMPlexMono-BoldItalic.ttf" -d .
rm IBMPlexMono.zip
```

> The `*.ttf` files in this directory are listed in `.gitignore` and are not committed to the repository.
> Run the download commands above once after cloning.
