#!/bin/sh
#
# Run the lunatest unit specs with plain Lua 5.1.
#
# usage: tests/run_unit.sh
#   override the interpreter with LUA=

set -e

HERE=$(cd "$(dirname "$0")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
LUA=${LUA:-$ROOT/../tools/lua51/bin/lua}

cd "$ROOT"
# dmc_corona/ for the color files' module names, dmc_kolor.named_colors_*,
# which the boot loader would add in Solar2D
LUA_PATH="$ROOT/?.lua;$ROOT/dmc_corona/?.lua;$($LUA -e 'io.write(package.path)')"
export LUA_PATH

"$LUA" -e "
require 'tests.lunatest'
lunatest.suite( 'tests.dmc_kolor_spec' )
lunatest.run()
"
