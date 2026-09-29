# API Reference

Everything dmc-kolor provides. The [Quick Start](../README.md#quick-start) shows it in use.

## Quick Reference

| Name | In short |
|---|---|
| [Color formats](#color-formats) | `dRGBA` (0-1), `hRGBA` (0-255), `hRGBdA` (0-255, alpha 0-1) |
| [`Kolor.translateColor()`](#kolortranslatecolor-color-) | a color in any form, as the 0-1 values Solar2D uses |
| [`Kolor.translateAlpha()`](#kolortranslatealpha-alpha-) | an alpha in the current format, as 0-1 |
| [`Kolor.setColorFormat()`, `getColorFormat()`](#kolorsetcolorformat-format-) | the format `translateColor()` expects |
| [`Kolor.initializeKolorSet()`](#kolorinitializekolorset-func--format-) | run code with another format |
| [Named colors](#named-colors) | the X11 color file, `importColorFile()`, `addColors()`, `getNamedColor()`, `purgeNamedColors()` |
| [Configuration](#configuration) | `DEFAULT_COLOR_FORMAT`, `NAMED_COLOR_FILE` |
| [`Kolor.VERSION`](#kolorversion) | the version, `'2.1.0'` |
| [Errors](#errors) | what raises an error, and where |

## The Module

```lua
local Kolor = require 'dmc_corona.dmc_kolor'
```

The module is a table of functions, shared by the whole app: a format set in one file applies everywhere. It reads its [configuration](#configuration) when it is first required.

### Kolor.VERSION

The version, a string: `'2.1.0'`.

## Color Formats

The format says how `translateColor()` reads numbers. Hex strings and names don't depend on it; the alpha that goes with them does.

| Constant | Red, green, blue | Alpha | Example (orange, half transparent) |
|---|---|---|---|
| `Kolor.dRGBA` (default) | 0-1 | 0-1 | `1, 0.71, 0.13, 0.5` |
| `Kolor.hRGBA` | 0-255 | 0-255 | `255, 180, 34, 128` |
| `Kolor.hRGBdA` | 0-255 | 0-1 | `255, 180, 34, 0.5` |

`dRGBA` is Solar2D's own format: `translateColor()` checks the values and returns them unchanged, which is useful when the other forms (hex, names) are mixed in. The constants are the strings `'dRGBA'`, `'hRGBA'` and `'hRGBdA'`, the values [`DEFAULT_COLOR_FORMAT`](#configuration) takes.

### Kolor.setColorFormat( format )

Sets the format for all later calls of `translateColor()` and `translateAlpha()`. An unknown format is an error.

### Kolor.getColorFormat()

Returns the current format.

### Kolor.initializeKolorSet( func [, format] )

Sets `format` (default `Kolor.dRGBA`), calls `func()`, then sets the format back, also when `func()` raises an error (the error is then raised again). For code, such as a library, that uses a different format than the rest of the app:

```lua
Kolor.initializeKolorSet( function()
	line.fill = Kolor.translateColor( 1, 0.84, 0 )
end, Kolor.dRGBA )
```

## Translating Colors

### Kolor.translateColor( color )

Returns the color as a new table of 0-1 values, `{ red, green, blue [, alpha] }`, or a new gradient table with translated colors. The tables you pass in are left as they are. Use the table as a `fill` or `stroke`, or `unpack()` it for a method:

```lua
rect.fill = Kolor.translateColor( 255, 180, 34 )
rect.stroke = Kolor.translateColor( 'Dark Magenta' )
text:setFillColor( unpack( Kolor.translateColor( '#FFD700' ) ) )
```

`color` is one of these, given as separate arguments or as one table (`translateColor{ 255, 180, 34 }` is the same as `translateColor( 255, 180, 34 )`):

| Form | Example (in `hRGBA`) | Result |
|---|---|---|
| red, green, blue [, alpha], in the current format | `255, 180, 34` | `{ 1, 0.71, 0.13 }` |
| grey [, alpha], in the current format | `200` | `{ 0.78, 0.78, 0.78 }` |
| a hex string: `#` and 3, 4, 6 or 8 digits (`#RGB`, `#RGBA`, `#RRGGBB`, `#RRGGBBAA`), upper or lower case | `'#8A2BE2'` | `{ 0.54, 0.17, 0.89 }` |
| a hex string and an alpha in the current format, which replaces a hex alpha | `'#8A2BE2', 128` | `{ 0.54, 0.17, 0.89, 0.5 }` |
| a [color name](#named-colors) [, alpha in the current format] | `'Steel Blue'` | `{ 0.27, 0.51, 0.71 }` |
| a gradient: a table with `type='gradient'` | `{ type='gradient', color1={ 255, 0, 0 }, color2='Navy', direction='down' }` | a copy of the table, `color1` and `color2` translated |
| another paint: a table with any other `type`, such as `{ type='image', filename='wood.png' }` | | the same table, unchanged |

No arguments return `nil`. A gradient's `color1` and `color2` take any of the forms above. A hex alpha is always 0-255 (`80` is about `0.5`), whatever the format.

A value outside the format's range (300 in `hRGBA`, 1.5 in `dRGBA`), a name that isn't loaded, a malformed hex string (a string without `#` is read as a name), or a form it doesn't know, such as a boolean, [raises an error](#errors).

### Kolor.translateAlpha( alpha )

Returns `alpha`, in the current format, as a 0-1 value: `128` in `hRGBA` is `0.5`. `nil` returns `nil`; a value outside the format's range raises an error.

## Named Colors

Names are looked up without regard to case: `'Steel Blue'`, `'steel blue'` and `'STEEL BLUE'` are the same. Until a color file is loaded (or colors are added), looking up a name is an error: `no named colors are loaded` from `translateColor()`, `there are no named colors loaded` from `getNamedColor()`.

### The Color File

dmc-kolor comes with the X11 colors in one file, `dmc_corona/dmc_kolor/named_colors_hex.lua`, module name `dmc_kolor.named_colors_hex`. The colors are written as hex strings, `"#F0F8FF"`.

`dmc_kolor.named_colors_rgb` and `dmc_kolor.named_colors_hdr`, which had the same colors as 0-255 and 0-1 values, are now deprecated names for the hex file, kept so that existing configurations keep working. Colors are translated when they are loaded, so the format a file is written in never made a difference to the result.

The names are the X11 ones, with spaces: `'Alice Blue'`, `'Dark Magenta'`, `'Light Gray'`. Where X11 and the web (W3C) colors differ, both are there with a suffix, and the plain name is the X11 one: `'Gray'` is `'Gray-X11'`, and there are `'Gray-W3C'`, `'Green-X11'`, `'Green-W3C'`, `'Maroon-X11'`, `'Maroon-W3C'`, `'Purple-X11'` and `'Purple-W3C'`. `'Lime'` and `'Silver'`, web colors only, are also there as `'Lime-W3C'` and `'Silver-W3C'`.

Load a file with [`NAMED_COLOR_FILE`](#configuration) in `dmc_corona.cfg`, or in code:

### Kolor.importColorFile( module_name )

Loads a color file with `require( module_name )`: `Kolor.importColorFile( 'dmc_kolor.named_colors_hex' )`. Colors are added to those already loaded; a name loaded twice keeps the last color.

A color file is a Lua module that returns a table with an `initialize( Kolor )` function, which adds the colors. Its colors can be hex strings, or values in any of the [formats](#color-formats) (the `format` passed to `addColors()`). To make your own, copy `named_colors_hex.lua` and change its `data` table, or write:

```lua
-- my_colors.lua, in the project folder
local data = {
	["Brand Blue"] = "#0055A4",
	["Brand Sand"] = { 225, 200, 160 },
}

return {
	initialize = function( Kolor )
		Kolor.addColors( data, { format=Kolor.hRGBA } )
	end
}
```

Then `NAMED_COLOR_FILE = my_colors` in `dmc_corona.cfg`, or `Kolor.importColorFile( 'my_colors' )`.

### Kolor.addColors( colors [, params] )

Adds named colors from a table of `name = color`. Each color is a hex string (`"#0055A4"`, any of the four hex forms) or a table of values, `{ red, green, blue [, alpha] }` or grey, in `params.format` (the alpha too). That defaults to `Kolor.dRGBA` (0-1), whatever the current format is: pass `{ format=Kolor.hRGBA }` for 0-255 values.

```lua
Kolor.addColors( { ["Brand Blue"] = { 0, 85, 164 } }, { format=Kolor.hRGBA } )
```

The colors are translated when they are added, so a later change of format doesn't affect them. A color that isn't one raises an error.

### Kolor.getNamedColor( name )

Returns a copy of the named color's 0-1 values, `{ red, green, blue [, alpha] }`, or `nil` if there is no such name. `translateColor( name )` does the same, but raises an error for a name that isn't there.

### Kolor.purgeNamedColors()

Removes all named colors.

## Configuration

The `[DMC_KOLOR]` section of `dmc_corona.cfg`. Both settings are read once, when dmc-kolor is first required. For the file format, see [dmc-corona-boot Configuration](https://github.com/dmccuskey/dmc-corona-boot/blob/master/docs/configuration.md).

| Setting | Type | Default | Effect |
|---|---|---|---|
| `DEFAULT_COLOR_FORMAT` | string | `dRGBA` | the starting [color format](#color-formats): `dRGBA`, `hRGBA` or `hRGBdA` (case matters). An unknown value is an error when dmc-kolor loads. |
| `NAMED_COLOR_FILE` | string | none | a [color file](#the-color-file) to load, as a Lua module name, such as `dmc_kolor.named_colors_hex` |

```ini
[DMC_KOLOR]

DEFAULT_COLOR_FORMAT = hRGBA
NAMED_COLOR_FILE = dmc_kolor.named_colors_hex
```

The settings in the old dmc-kolor 1.x `dmc_library.cfg` (`NAMED_COLOR_FORMAT`, `DEFAULT_COLOR_SPACE`, `CACHE_IS_ACTIVE`, `MAKE_GLOBAL`, JSON color files) no longer exist.

## Errors

A color dmc-kolor can't translate raises an error that starts with `dmc_kolor:` and names the value, from `translateColor()`, `translateAlpha()` and `addColors()`. It is raised at your line, the call of the function, rather than inside dmc-kolor:

```text
main.lua:12: dmc_kolor: unknown color name 'Stel Blue'
main.lua:13: dmc_kolor: color value must be a number from 0 to 255, got 300
main.lua:14: dmc_kolor: hex color must be #RGB, #RGBA, #RRGGBB or #RRGGBBAA, got '#8A2BE'
```

A call written as `return Kolor.translateColor( ... )` is a tail call, which Lua doesn't keep: the error then has no line.

dmc-kolor 2.0 and earlier gave `nil` for an unknown name, and let 0-255 values above 255 through; see the [changelog](../CHANGELOG.md).
