
AS3_API = nil

function main( AS3 )

	AS3_API = AS3
	print( "luaMain  ready")

	local libCore = require( "libCore" )
	--	libCore.var_dump( package.loaded , 1 )

	local luaLoadList = { "libPlayer" , "libMap" }
	libCore.loadLuaScripts( luaLoadList )
end

function update( delta )

end

function onLoadLuaScript()
	local libCore = require( "libCore" )
	libCore.onLoadLuaScriptComplete()
	
	local mapLib = require( "libMap" )
	local mapClass = mapLib.Map
	
	local mapA = mapClass.new()
	mapA.init( mapA , 0 , 0 )
	
	local playerLib = require( "libPlayer" )
	local playerClass = playerLib.Player

	local playerA = playerClass.new()
	playerA.init( playerA , 1 , 2 )
	mapA.addPlayer( playerA )

	local playerB = playerClass.new()
	playerB.init( playerB , 2 , 4 )
	mapA.addPlayer( playerB )
	
end

if flash == nil then
	main()
end


