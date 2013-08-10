---
-- @module libPlayer
module( "libPlayer", package.seeall)
---
-- @field[parent = #libPlayer] #Player Player
Player = {}
Player.__index = Player

---
-- @function [parent=#Player] new
-- @return #Player Player
function Player:new()
	local self = {}
	setmetatable(self, Player)
	return self
end  
---
-- @function [parent=#Player] init
-- @param #number x
-- @param #number y
function Player:init( x , y )
	self.x = x;
	self.y = y;
	print( "playerInit" )
end
---
--@field [parent=#Player] #number x
function Player:x()
	return self.x;
end
---
--@field [parent=#Player] #number y
function Player:y()
	return self.y;
end