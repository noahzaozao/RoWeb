
AS3_API = nil

function main( AS3 )

	AS3_API = AS3
	print( "luaMain  ready")

	local libCore = require( "libCore" )
	--	libCore.var_dump( package.loaded , 1 )

	local luaLoadList = { "libPlayer" , "libMap" }
	libCore.loadLuaScripts( luaLoadList )

	--	local playerLib = require( "libPlayer" )
	--	local playerClass = playerLib.Player
	--
	--	local objA = playerClass.new()
	--	objA.init( objA , 1 , 2 )
	--	print(objA.x , objA.y)
	--
	--	local objB = playerClass.new()
	--	objB.init( objB , 2 , 4 )
	--	print(objB.x , objB.y)
end

function update( delta )

end

function onLoadLuaScript()
	local libCore = require( "libCore" )
	libCore.onLoadLuaScriptComplete()
end

if flash == nil then
	main()
end


