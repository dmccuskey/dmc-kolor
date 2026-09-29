--====================================================================--
-- Test: TextField Widget
--====================================================================--

module(..., package.seeall)


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local Kolor = require 'dmc_corona.dmc_kolor'
local TestUtils = require 'tests.test_utils'



--====================================================================--
--== Setup, Constants


local sfmt = string.format



--====================================================================--
--== Support Functions


local formatColor = TestUtils.formatColor

local marker = TestUtils.outputMarker


local function colorsAreEqual( c1, c2 )
	assert( type(c1)=='string' or type(c1)=='table', "got "..tostring(type(c1)) )
	assert( type(c2)=='table' )
	--==--
	local trans
	if type(c1)=='string' then
		trans = Kolor.translateColor( c1 )
	elseif c1.type=='gradient' then
		trans = Kolor.translateColor( c1 )
	else
		trans = Kolor.translateColor( unpack(c1) )
	end
	assert_true(
		TestUtils.colorsAreEqual( trans, c2 ),
		sfmt( "%s<>%s", formatColor( trans ), formatColor( c2 ) )
	)
end

local function colorsAreNotEqual( c1, c2 )
	assert( type(c1)=='string' or type(c1)=='table' )
	assert( type(c2)=='table' )
	--==--
	local trans
	if type(c1)=='string' then
		trans = Kolor.translateColor( c1 )
	elseif c1.type=='gradient' then
		trans = Kolor.translateColor( c1 )
	else
		trans = Kolor.translateColor( unpack(c1) )
	end
	assert_false(
		TestUtils.colorsAreEqual( trans, c2 ),
		sfmt( "%s==%s", formatColor( trans ), formatColor( c2 ) )
	)
end

local function alphasAreEqual( c1, c2 )
	assert( type(c1)=='number' )
	assert( type(c2)=='number' )
	--==--
	local trans = Kolor.translateAlpha( c1 )
	assert_true( trans==c2,
		sfmt( "%s<>%s", trans, c2 )
	)
end


--====================================================================--
--== Module Testing
--====================================================================--


--====================================================================--
--== Test Setup/Teardown


function suite_setup()
end

function setup()
	Kolor.purgeNamedColors()
end


--====================================================================--
--== Test Functions


function test_colorFormat()
	-- print( "test_colorFormat" )

	Kolor.setColorFormat( Kolor.hRGBA )
	assert_equal( Kolor.getColorFormat(), Kolor.hRGBA, "incorrect format" )

	Kolor.setColorFormat( Kolor.dRGBA )
	assert_equal( Kolor.getColorFormat(), Kolor.dRGBA, "incorrect format" )

end

function test_colorFormatError()
	-- print( "test_colorFormatError" )

	assert_error( function() Kolor.setColorFormat( nil ) end, "bad set format" )
	assert_error( function() Kolor.setColorFormat( 'hello' ) end, "bad set format" )

end


--======================================================--
-- dRGBA Tests

function test_dRGBA_colorConversions()
	-- print( "test_dRGBA_colorConversions" )

	local c1, c2

	Kolor.setColorFormat( Kolor.dRGBA )
	assert_equal( Kolor.getColorFormat(), Kolor.dRGBA, "incorrect format" )

	c1 = { 0.25, 0.25, 0.25 }
	c2 = { 0.25, 0.25, 0.25 }
	colorsAreEqual( c1, c2 )

	c1 = { 0, 0.5, 0.25, 0.5 }
	c2 = { 0, 0.5, 0.25, 0.5 }
	colorsAreEqual( c1, c2 )

	c1 = '#FF00FF'
	c2 = { 255/255, 0/255, 255/255 }
	colorsAreEqual( c1, c2 )

	c1 = { '#0F00FF', 0.12 }
	c2 = { 15/255, 0/255, 255/255, 0.12 }
	colorsAreEqual( c1, c2 )

	alphasAreEqual( 0.25, 0.25 )

end


function test_dRGBA_colorConversionErrors()
	-- print( "test_dRGBA_colorConversionErrors" )

	local c1, c2

	Kolor.setColorFormat( Kolor.dRGBA )
	assert_equal( Kolor.getColorFormat(), Kolor.dRGBA, "incorrect format" )

	assert_error( function()
		c1 = { '#0F00FF', 255 }
		c2 = { 15/255, 0/255, 255/255, 0.12 }
		colorsAreNotEqual( c1, c2 )
	end, "bad set format" )

end


--======================================================--
-- hRGBA Tests

function test_hRGBA_colorConversions()
	-- print( "test_hRGBA_colorConversions" )

	local c1, c2

	Kolor.setColorFormat( Kolor.hRGBA )
	assert_equal( Kolor.getColorFormat(), Kolor.hRGBA, "incorrect format" )

	c1 = { 255, 255, 255 }
	c2 = { 1, 1, 1 }
	colorsAreEqual( c1, c2 )

	c1 = { 255, 255, 255, 255 }
	c2 = { 1, 1, 1, 1 }
	colorsAreEqual( c1, c2 )

	c1 = { 0, 0, 0, 255 }
	c2 = { 0, 0, 0, 1 }
	colorsAreEqual( c1, c2 )

	c1 = { 128, 28, 230, 120 }
	c2 = { 128/255, 28/255, 230/255, 120/255 }
	colorsAreEqual( c1, c2 )

	c1 = '#FF00FF'
	c2 = { 255/255, 0/255, 255/255 }
	colorsAreEqual( c1, c2 )

	c1 = { '#0F00FF', 12 }
	c2 = { 15/255, 0/255, 255/255, 12/255 }
	colorsAreEqual( c1, c2 )

	alphasAreEqual( 155, 155/255 )

end

function test_hRGBA_colorConversionsErrors()
	-- print( "test_hRGBA_colorConversionsErrors" )

	local c1, c2

	Kolor.setColorFormat( Kolor.hRGBA )
	assert_equal( Kolor.getColorFormat(), Kolor.hRGBA, "incorrect format" )

	assert_error( function()
		c1 = { '#0F00FF', -34 }
		c2 = { 15/255, 0/255, 255/255, 12/255 }
		colorsAreEqual( c1, c2 )
	end, "bad set format" )

end


--======================================================--
-- hRGBdA Tests

function test_hRGBdA_colorConversions()
	-- print( "test_hRGBdA_colorConversions" )

	local c1, c2

	Kolor.setColorFormat( Kolor.hRGBdA )
	assert_equal( Kolor.getColorFormat(), Kolor.hRGBdA, "incorrect format" )

	c1 = { 255, 255, 255 }
	c2 = { 1, 1, 1 }
	colorsAreEqual( c1, c2 )

	c1 = { 255, 255, 255, 0.5 }
	c2 = { 1, 1, 1, 0.5 }
	colorsAreEqual( c1, c2 )

	c1 = { 0, 0, 0, 0.1 }
	c2 = { 0, 0, 0, 0.1 }
	colorsAreEqual( c1, c2 )

	c1 = { 128, 28, 230, 0.23 }
	c2 = { 128/255, 28/255, 230/255, 0.23 }
	colorsAreEqual( c1, c2 )

	c1 = '#FF00FF'
	c2 = { 255/255, 0/255, 255/255 }
	colorsAreEqual( c1, c2 )

	c1 = { '#0F00FF', 0.125 }
	c2 = { 15/255, 0/255, 255/255, 0.125 }
	colorsAreEqual( c1, c2 )


	alphasAreEqual( 0.25, 0.25 )

end

function test_hRGBdA_colorConversionsErrors()
	-- print( "test_hRGBdA_colorConversionsErrors" )

	local c1, c2

	Kolor.setColorFormat( Kolor.hRGBdA )
	assert_equal( Kolor.getColorFormat(), Kolor.hRGBdA, "incorrect format" )

	assert_error( function()
		c1 = { '#0F00FF', 255 } -- alpha is wrong for color format
		c2 = { 15/255, 0/255, 255/255, 0.12 }
		colorsAreNotEqual( c1, c2 )
	end, "bad set format" )

end


--======================================================--
-- Color File Tests


function test_hexRgbColorFile()
	-- print( "test_hexRgbColorFile" )

	local c1, c2

	assert_error( function()
		c1 = Kolor.getNamedColor( "Dim Gray" )
	end, "bad set format" )

	Kolor.importColorFile( 'dmc_kolor.named_colors_rgb' )

	c1 = Kolor.getNamedColor( "Dim Gray" )
	c2 = { 105/255, 105/255, 105/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

	c1 = Kolor.getNamedColor( "Navy" )
	c2 = { 0/255, 0/255, 128/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

	c1 = Kolor.translateColor( "Navy" )
	c2 = { 0/255, 0/255, 128/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

end


function test_hexColorFile()
	-- print( "test_hexColorFile" )

	local c1, c2

	assert_error( function()
		c1 = Kolor.getNamedColor( "Dim Gray" )
	end, "bad set format" )

	Kolor.importColorFile( 'dmc_kolor.named_colors_hex' )

	c1 = Kolor.getNamedColor( "Dim Gray" )
	c2 = { 105/255, 105/255, 105/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

	c1 = Kolor.getNamedColor( "dim gray" )
	c2 = { 105/255, 105/255, 105/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

	c1 = Kolor.getNamedColor( "Navy" )
	c2 = { 0/255, 0/255, 128/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

	c1 = Kolor.translateColor( "Navy" )
	c2 = { 0/255, 0/255, 128/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

end


function test_hdrColorFile()
	-- print( "test_hdrColorFile" )

	local c1, c2

	assert_error( function()
		c1 = Kolor.getNamedColor( "Dim Gray" )
	end, "bad set format" )

	Kolor.importColorFile( 'dmc_kolor.named_colors_hdr' )

	c1 = Kolor.getNamedColor( "Dim Gray" )
	c2 = { 105/255, 105/255, 105/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

	c1 = Kolor.getNamedColor( "Navy" )
	c2 = { 0/255, 0/255, 128/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

	c1 = Kolor.getNamedColor( "navy" )
	c2 = { 0/255, 0/255, 128/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

	c1 = Kolor.translateColor( "Navy" )
	c2 = { 0/255, 0/255, 128/255 }
	assert_true(
		TestUtils.colorsAreEqual( c1, c2 ),
		sfmt( "%s<>%s", formatColor( c1 ), formatColor( c2 ) )
	)

end




--======================================================--
-- Fixes, Sept 2026

function test_greyscaleWithAlpha()
	-- print( "test_greyscaleWithAlpha" )

	Kolor.setColorFormat( Kolor.hRGBA )
	colorsAreEqual( { 128 }, { 128/255, 128/255, 128/255 } )
	colorsAreEqual( { 128, 64 }, { 128/255, 128/255, 128/255, 64/255 } )

	Kolor.setColorFormat( Kolor.hRGBdA )
	colorsAreEqual( { 128, 0.25 }, { 128/255, 128/255, 128/255, 0.25 } )

end

function test_coral()
	-- print( "test_coral" )

	local c2 = { 255/255, 127/255, 80/255 }
	for _, file in ipairs{ 'hex', 'rgb', 'hdr' } do
		Kolor.purgeNamedColors()
		Kolor.importColorFile( 'dmc_kolor.named_colors_'..file )
		local c1 = Kolor.getNamedColor( 'Coral' )
		assert_true(
			TestUtils.colorsAreEqual( c1, c2 ),
			sfmt( "%s: %s<>%s", file, formatColor( c1 ), formatColor( c2 ) )
		)
	end

end

function test_noGlobalLeak()
	-- print( "test_noGlobalLeak" )

	Kolor.importColorFile( 'dmc_kolor.named_colors_hex' )
	assert_nil( rawget( _G, 'color' ), "global 'color' set" )

end

function test_runMode()
	-- print( "test_runMode" )

	Kolor.setColorFormat( Kolor.hRGBA )
	Kolor.setRunMode( 'test' )
	colorsAreEqual( { 255, 0, 0 }, { 255, 0, 0 } )
	Kolor.setRunMode( 'run' )
	colorsAreEqual( { 255, 0, 0 }, { 1, 0, 0 } )

end

function test_version()
	assert_equal( Kolor.VERSION, '2.1.0' )
end

function test_colorFileAliases()
	-- print( "test_colorFileAliases" )

	local function load( file )
		Kolor.purgeNamedColors()
		Kolor.importColorFile( 'dmc_kolor.named_colors_'..file )
		local colors = Kolor._NAMED_COLORS
		Kolor._NAMED_COLORS = nil
		return colors
	end

	local hex = load( 'hex' )
	for _, file in ipairs{ 'rgb', 'hdr' } do
		local colors, count = load( file ), 0
		for name, c1 in pairs( hex ) do
			assert_true(
				TestUtils.colorsAreEqual( c1, colors[ name ] ),
				sfmt( "%s: %s", file, name )
			)
			count = count + 1
		end
		assert_equal( 149, count )
	end

end


--======================================================--
-- Fixes, 2.1.0

-- an error raised by func, its message; fails if there is none
local function errorOf( func )
	local ok, err = pcall( func )
	assert_false( ok, "expected an error" )
	return tostring( err )
end

-- the error is raised at the caller's line: this file
local function assertCallerError( func, text )
	local err = errorOf( func )
	assert_match( 'dmc_kolor_spec.lua:%d+: dmc_kolor: ', err )
	if text then
		assert_true( err:find( text, 1, true )~=nil, sfmt( "'%s' not in '%s'", text, err ) )
	end
end

function test_plainNames()
	-- print( "test_plainNames" )

	Kolor.importColorFile( 'dmc_kolor.named_colors_hex' )
	for plain, full in pairs{
		Green='Green-X11', Maroon='Maroon-X11', Purple='Purple-X11',
		Lime='Lime-W3C', Silver='Silver-W3C', Gray='Gray-X11',
	} do
		local c1, c2 = Kolor.translateColor( plain ), Kolor.getNamedColor( full )
		assert_true( TestUtils.colorsAreEqual( c1, c2 ), plain )
	end

end

function test_unknownName()
	-- print( "test_unknownName" )

	Kolor.setColorFormat( Kolor.dRGBA )
	assertCallerError( function()
		Kolor.translateColor( 'Navy' )
	end, "no named colors are loaded" )

	Kolor.importColorFile( 'dmc_kolor.named_colors_hex' )
	assertCallerError( function()
		Kolor.translateColor( 'Nvy' )
	end, "unknown color name 'Nvy'" )
	-- a hex string without '#' is a name
	assertCallerError( function()
		Kolor.translateColor( 'FF00FF' )
	end, "unknown color name 'FF00FF'" )
	assertCallerError( function()
		Kolor.translateColor( true )
	end, "unknown RGB color type 'boolean'" )

	-- a lookup still gives nil
	assert_nil( Kolor.getNamedColor( 'Nvy' ) )

end

function test_nameWithAlpha()
	-- print( "test_nameWithAlpha" )

	Kolor.importColorFile( 'dmc_kolor.named_colors_hex' )

	Kolor.setColorFormat( Kolor.hRGBA )
	colorsAreEqual( { 'Navy', 51 }, { 0, 0, 128/255, 51/255 } )
	colorsAreEqual( { 'Navy' }, { 0, 0, 128/255 } )

	Kolor.setColorFormat( Kolor.dRGBA )
	colorsAreEqual( { 'navy', 0.5 }, { 0, 0, 128/255, 0.5 } )
	assertCallerError( function()
		Kolor.translateColor( 'Navy', 128 )
	end, "alpha must be a number from 0 to 1" )

end

function test_greyInDRGBA()
	-- print( "test_greyInDRGBA" )

	Kolor.setColorFormat( Kolor.dRGBA )
	colorsAreEqual( { 0.5 }, { 0.5, 0.5, 0.5 } )
	colorsAreEqual( { 0.5, 0.25 }, { 0.5, 0.5, 0.5, 0.25 } )

end

function test_hexForms()
	-- print( "test_hexForms" )

	Kolor.setColorFormat( Kolor.hRGBA )
	colorsAreEqual( { '#F0F' }, { 1, 0, 1 } )
	colorsAreEqual( { '#f0f8' }, { 1, 0, 1, 0x88/255 } )
	colorsAreEqual( { '#FF00FF80' }, { 1, 0, 1, 128/255 } )
	-- an alpha given replaces the hex one
	colorsAreEqual( { '#FF00FF80', 51 }, { 1, 0, 1, 51/255 } )

	for _, hex in ipairs{ '#', '#12', '#12345', '#1234567', '#GG0000', '# FF00FF' } do
		assertCallerError( function()
			Kolor.translateColor( hex )
		end, sfmt( "got '%s'", hex ) )
	end

end

function test_gradientCopy()
	-- print( "test_gradientCopy" )

	Kolor.setColorFormat( Kolor.hRGBA )
	local grad = {
		type='gradient',
		color1={ 255, 0, 0 },
		color2={ '#0000FF', 128 },
		direction='down',
	}
	local g1 = Kolor.translateColor( grad )
	local g2 = Kolor.translateColor( grad )

	assert_not_equal( grad, g1 )
	assert_equal( 'down', g1.direction )
	for _, g in ipairs{ g1, g2 } do
		assert_true( TestUtils.colorsAreEqual( g.color1, { 1, 0, 0 } ) )
		assert_true( TestUtils.colorsAreEqual( g.color2, { 0, 0, 1, 128/255 } ) )
	end
	-- the caller's table is left as it was
	assert_true( TestUtils.colorsAreEqual( grad.color1, { 255, 0, 0 } ) )
	assert_equal( '#0000FF', grad.color2[1] )

	-- an error in a gradient's color is raised at the caller's line too
	assertCallerError( function()
		Kolor.translateColor{ type='gradient', color1={ 300, 0, 0 }, color2='#000' }
	end, "got 300" )

end

function test_otherPaint()
	-- print( "test_otherPaint" )

	local paint = { type='image', filename='wood.png' }
	assert_equal( paint, Kolor.translateColor( paint ) )

end

function test_copies()
	-- print( "test_copies" )

	Kolor.importColorFile( 'dmc_kolor.named_colors_hex' )
	local c1 = Kolor.getNamedColor( 'Navy' )
	c1[1] = 1
	Kolor.translateColor( 'Navy' )[2] = 1
	colorsAreEqual( 'Navy', { 0, 0, 128/255 } )

	Kolor.setColorFormat( Kolor.dRGBA )
	local t = { 0.1, 0.2, 0.3 }
	assert_not_equal( t, Kolor.translateColor( t ) )

end

function test_rangeChecks()
	-- print( "test_rangeChecks" )

	Kolor.setColorFormat( Kolor.hRGBA )
	for _, c in ipairs{ { 300, 0, 0 }, { 0, -1, 0 }, { 0, 0, 256 }, { 256 } } do
		assertCallerError( function()
			Kolor.translateColor( c )
		end, "color value must be a number from 0 to 255" )
	end
	assertCallerError( function()
		Kolor.translateColor( 0, 0, 0, 300 )
	end, "alpha must be a number from 0 to 255" )
	assertCallerError( function()
		Kolor.translateColor( 0, '0', 0 )
	end, "got 0" )

	Kolor.setColorFormat( Kolor.hRGBdA )
	assertCallerError( function()
		Kolor.translateColor( 0, 0, 0, 2 )
	end, "alpha must be a number from 0 to 1" )

	Kolor.setColorFormat( Kolor.dRGBA )
	assertCallerError( function()
		Kolor.translateColor( 1.5, 0, 0 )
	end, "color value must be a number from 0 to 1" )
	assertCallerError( function()
		Kolor.translateAlpha( 2 )
	end, "alpha must be a number from 0 to 1" )

end

function test_initializeKolorSetError()
	-- print( "test_initializeKolorSetError" )

	Kolor.setColorFormat( Kolor.hRGBA )
	local err = errorOf( function()
		Kolor.initializeKolorSet( function() error( "boom" ) end, Kolor.dRGBA )
	end )
	assert_match( 'boom', err )
	assert_equal( Kolor.hRGBA, Kolor.getColorFormat() )

end

function test_addColorsAlpha()
	-- print( "test_addColorsAlpha" )

	-- the alpha is read in the colors' format, not the current one
	Kolor.setColorFormat( Kolor.dRGBA )
	Kolor.addColors( { Brand={ 0, 85, 170, 51 } }, { format=Kolor.hRGBA } )
	colorsAreEqual( 'brand', { 0, 85/255, 170/255, 51/255 } )

	assertCallerError( function()
		Kolor.addColors( { Bad=true } )
	end, "color 'Bad' must be a hex string or a table" )

end
