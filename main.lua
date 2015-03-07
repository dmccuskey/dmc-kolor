--====================================================================--
-- Unit Tests for DMC-Kolor
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--



print( '\n\n##############################################\n\n' )



--====================================================================--
--== Imports


require 'tests.lunatest'



--====================================================================--
--== Setup test suites and run


-- Styles with no children

lunatest.suite( 'tests.dmc_kolor_spec' )

lunatest.run({
	-- verbose=true,
	suite='dmc_kolor_spec',
	-- test=''
})

