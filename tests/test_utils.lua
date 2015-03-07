--====================================================================--
-- tests/test_utils.lua
--====================================================================--


--====================================================================--
--== Imports


--====================================================================--
--== Setup, Constants


local sformat = string.format



--====================================================================--
--== Support Functions


--====================================================================--
--== DMC Widgets Test TestUtils
--====================================================================--


local TestUtils = {}


function TestUtils.outputMarker()
	print( "\n\n\n MARKER \n\n\n" )
end


function TestUtils.colorsAreEqual( c1, c2 )
	local result = true
	if c1==nil and c2==nil then
		result=true
	elseif c1==nil or c2==nil then
		result=false
	else
		if c1[1]~=c2[1] then result=false end
		if c1[2]~=c2[2] then result=false end
		if c1[3]~=c2[3] then result=false end
		if c1[4]==nil and c2[4]==nil then
			-- pass
		elseif c1[4]==nil or c2[4]==nil then
			result=false
		elseif c1[4]~=c2[4] then
			result=false
		end
	end
	return result
end


function TestUtils.formatColor( value )
	local str = ""
	if value==nil then
		str = sformat( "(nil, nil, nil, nil)" )
	elseif value.type=='gradient' then
		str = sformat( "(gradient)" )
	elseif #value==3 then
		str = sformat( "(%s, %s, %s, nil)", unpack( value ) )
	else
		str = sformat( "(%s, %s, %s, %s)", unpack( value ) )
	end
	return str
end



return TestUtils
