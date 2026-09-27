--====================================================================--
-- Kolor Basic
--
-- Every kind of color dmc-kolor translates: 0-255 values, hex strings,
-- named colors, gradients, and a switch of format for a block of code.
-- The default format (hRGBA) and the named-color file are set in
-- dmc_corona.cfg.
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2013-2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--===================================================================--
--== Imports


local Kolor = require 'dmc_corona.dmc_kolor'



--===================================================================--
--== Setup, Constants


display.setStatusBar( display.HiddenStatusBar )

local W, H = display.contentWidth, display.contentHeight
local tc = Kolor.translateColor

local SIZE = 56
local COLUMNS = { W*0.14, W*0.38, W*0.62, W*0.86 }



--====================================================================--
--== Support Functions


local function newHeading( text, y )
	local o = display.newText( text, 16, y, native.systemFontBold, 14 )
	o.anchorX = 0
	o:setFillColor( unpack( tc( 'White Smoke' ) ) )
	return o
end

-- a swatch filled with color, with the value it was made from below it
local function newSwatch( column, y, color, label )
	local o = display.newRoundedRect( COLUMNS[ column ], y, SIZE, SIZE, 8 )
	o.fill = color
	local t = display.newText( label, COLUMNS[ column ], y+SIZE/2+10, native.systemFont, 10 )
	t:setFillColor( unpack( tc( 'Light Gray' ) ) )
	return o
end



--====================================================================--
--== Main


print( "default color format:", Kolor.getColorFormat() )

display.newRect( W/2, H/2, W, H ).fill = tc( 30, 30, 36 )

local title = display.newText( 'dmc-kolor', W/2, 28, native.systemFontBold, 24 )
title:setFillColor( unpack( tc( 'Gold' ) ) )


--== 0-255 values, the default format here (hRGBA)

newHeading( 'hRGBA: 0-255, alpha too', 64 )
newSwatch( 1, 106, tc( 255, 99, 71 ), '255,99,71' )
newSwatch( 2, 106, tc( 60, 179, 113 ), '60,179,113' )
newSwatch( 3, 106, tc( 70, 130, 180, 128 ), '70,130,180,128' )
newSwatch( 4, 106, tc( 200 ), '200 (grey)' )


--== hex strings, with an optional alpha

newHeading( 'Hex strings', 166 )
newSwatch( 1, 208, tc( '#FF6347' ), '#FF6347' )
newSwatch( 2, 208, tc( '#3cb371' ), '#3cb371' )
newSwatch( 3, 208, tc( '#4682B4', 128 ), "'#4682B4', 128" )
newSwatch( 4, 208, tc( '#FFD700' ), '#FFD700' )


--== named colors, from the file in dmc_corona.cfg

newHeading( 'Named colors (X11)', 268 )
newSwatch( 1, 310, tc( 'Tomato' ), 'Tomato' )
newSwatch( 2, 310, tc( 'Medium Sea Green' ), 'Medium Sea Green' )
newSwatch( 3, 310, tc( 'steel blue' ), 'steel blue' )
newSwatch( 4, 310, tc( 'Orchid' ), 'Orchid' )


--== gradients: both colors are translated

newHeading( 'Gradients', 370 )
local bar = display.newRoundedRect( W/2, 406, W-32, 36, 8 )
bar.fill = tc{
	type='gradient',
	color1={ 255, 99, 71 },
	color2='Steel Blue',
	direction='right',
}


--== another format for a block of code

newHeading( 'dRGBA (0-1) inside initializeKolorSet()', 442 )
Kolor.initializeKolorSet( function()
	local line = display.newRect( W/2, 464, W-32, 6 )
	line.fill = tc( 1, 0.84, 0 )
end, Kolor.dRGBA )
