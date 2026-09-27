# dmc-kolor Documentation

New here? The [Quick Start](../README.md#quick-start) draws shapes in 0-255, hex and named colors in about 10 minutes.

## Start

- [Quick Start](../README.md#quick-start): copy the library in, colors in 0-255 and hex, named colors and the config file

## Use

- [API reference](api.md): the color formats, `translateColor()`, named colors and color files, configuration, known issues
- [Examples](../examples/): every kind of color dmc-kolor translates, on one screen

## Contribute

- [Development](development.md): which files are generated, building, testing, possible future changes
- [Issues](https://github.com/dmccuskey/dmc-kolor/issues)

## Project Structure

```text
README.md                   landing page and Quick Start
LICENSE
docs/                       this documentation
└── images/                 screenshots for the README
dmc_corona/                 what apps copy
├── dmc_kolor.lua           the library (source)
└── dmc_kolor/              the X11 named colors (source)
dmc_corona_boot.lua         loader, from dmc-corona-boot (generated copy)
dmc_corona.cfg              library configuration
main.lua                    runs the unit tests
tests/                      unit tests (lunatest)
examples/                   sample app, with its own generated dmc_corona/
└── screenshots/            one per app, for examples/README.md
Snakefile                   build rules for the generated copies
```
