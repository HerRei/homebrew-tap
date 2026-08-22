# homebrew-localsr

Homebrew tap for [LocalSR](https://github.com/HerRei/local-upscale), a local image super-resolution desktop application.

## Prerequisites

- macOS 12.0 or later
- Apple Silicon (M-series) or Intel Mac
- Homebrew installed

## Installation

```bash
brew tap HerRei/local-upscale
brew install localsr
```

## Usage

```bash
localsr                    # Launch GUI
localsr image.png          # Launch with image
localsr --help             # See all options
```

## Notes

- The formula automatically selects the correct binary for your Apple Silicon or Intel Mac.
- GPU acceleration uses Apple MPS when available.
- No Python installation required - ships as standalone binary.

## Uninstall

```bash
brew uninstall localsr
brew untap HerRei/local-upscale
```
