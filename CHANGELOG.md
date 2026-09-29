# Changelog

## 2.1.0 (2026-09-29)

### Changed

- A color dmc-kolor can't translate raises an error naming dmc_kolor, at your line: a name that isn't loaded (it gave `nil`, and the error came later, where the color was used), a malformed hex string, a value outside the format's range (in `hRGBA`, 300 became 1.18), a form it doesn't know.
- A gradient is translated as a copy: your table is left as it is, so translating it twice gives the same colors (in `hRGBA`, red became almost black).
- `getNamedColor()` and `translateColor()` return a new table: changing it no longer changes the named color, or the table you passed in.
- A name takes an alpha: `translateColor( 'Navy', 128 )`; the alpha was dropped.
- Grey works in `dRGBA`: `translateColor( 0.5 )` and `( 0.5, 0.25 )` raised an error.
- `initializeKolorSet()` sets the format back when its function raises an error.
- `addColors()` reads the alpha in the colors' format; it used the current one.
- Other paints, such as `{ type='image', filename='wood.png' }`, are returned unchanged; they raised an error.
- Rebuilt with dmc-corona-boot 1.6.0.

### Added

- Hex strings `'#RGB'`, `'#RGBA'` and `'#RRGGBBAA'`.
- The plain names `'Green'`, `'Maroon'` and `'Purple'` (the X11 colors, like `'Gray'`), and `'Lime'` and `'Silver'`.
- Unit tests for each fix, and `tests/run_unit.sh` to run them with plain Lua 5.1.

### Removed

- The copy of `extend()`.

## 2.0.1 (2026-09-26)

### Fixed

- The run-mode flag was inverted: in normal use no color was translated, so `hRGBA` values such as 255 reached Solar2D unchanged. `setRunMode()` re-applies the current format.
- Grey with alpha used the grey value as the alpha.
- Coral had Cadet Blue's value; `'Dark Red'` was listed three times.
- `addColors()` leaked the global `color`.

### Changed

- One color file: `named_colors_rgb` and `named_colors_hdr` are now aliases that load `named_colors_hex`.

### Added

- `Kolor.VERSION`.
