ctx3d = nil
rootsprite = nil
_width = 0
_height = 0

function main( starlingMain, _ctx3d, w, h )

	print( "lua ready")
	
	local libCore = require( "libCore" )
--	libCore.var_dump( package.loaded , 1 )
	
	local playerLib = require( "libPlayer" )
	local playerClass = playerLib.Player
	local objA = playerClass.new()
	objA.init( objA , 1 , 2 )
	print(objA.x , objA.y)
	--
	--	local objB = playerClass.new()
	--	objB.init( objB , 2 , 4 )
	--	print(objB.x , objB.y)
end

function update( delta )

end

if flash == nil then
	main()
end


