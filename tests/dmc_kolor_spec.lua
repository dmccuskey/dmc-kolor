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
		c1 = { '#0F00FF', 255 }
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


