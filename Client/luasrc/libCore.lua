---
-- @module libCore
module( "libCore", package.seeall)
-------------------------------------------------------------------------------
-- @function [parent = #libCore] var_dump
-- @param data
-- @param max_level
-- @param prefix
function var_dump(data, max_level, prefix)   
	if type(prefix) ~= "string" then   
		prefix = ""  
	end   
	if type(data) ~= "table" then   
		print(prefix .. tostring(data))   
	else  
		print(data)   
		if max_level ~= 0 then   
			local prefix_next = prefix .. "    "  
			print(prefix .. "{")   
			for k,v in pairs(data) do  
				io.stdout:write(prefix_next .. k .. " = ")   
				if type(v) ~= "table" or (type(max_level) == "number" and max_level <= 1) then   
					print(v)   
				else  
					if max_level == nil then   
						var_dump(v, nil, prefix_next)   
					else  
						var_dump(v, max_level - 1, prefix_next)   
					end   
				end   
			end   
			print(prefix .. "}")   
		end   
	end   
end  

currentLuaPathList = nil
---
--@function [parent = #libCore] loadLuaScripts
--@param luaPathList
function loadLuaScripts( luaPathList )
	print( "loadLuaScripts..." )
	currentLuaPathList = luaPathList
	if AS3_API ~= nil then
		local len = #luaPathList
		for i= 1, len do
			AS3_API:API_ADD_LUA_PATH( luaPathList[i] )
			print( "AddLuaPath " .. luaPathList[i] )
		end
		AS3_API:API_LoadLuaScript()
	else
		--just for console test
		local len = #luaPathList
		for i= 1, len do
			require( luaPathList[i] )
			print( "onLoadLuaScript: " .. currentLuaPathList[i] )
			i = i + 1
		end
		onLoadLuaScript()
	end
end

---
--@function [parent = #libCore] onLoadLuaScriptComplete
function onLoadLuaScriptComplete()
	print( "onLoadLuaScriptComplete" )
	if AS3_API ~= nil then
		AS3_API:API_onLoadLuaScriptComplete()
	end
end
