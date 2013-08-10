---
-- @module libMap
module( "libMap", package.seeall)
---
-- @field[parent = #libMap] #Map Map
Map = {}
Map.__index = Map

---
-- @function [parent=#Map] new
-- @return #Map Map
function Map:new()
	local self = {}
	setmetatable(self, Map)
	return self
end  
---
-- @function [parent=#Map] init
-- @param #number x
-- @param #number y
function Map:init( x , y )
	self.x = x;
	self.y = y;
	print( "mapInit" )
end
---
-- @function [parent=#Map] addPlayer
-- @param #Player player
function Map:addPlayer( player )
	print( "addPlayer" )
end
---
--@field [parent=#Map] #number x
function Map:x()
	return self.x;
end
---
--@field [parent=#Map] #number y
function Map:y()
	return self.y;
end