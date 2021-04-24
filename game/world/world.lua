Resources = require "game.map.resources" -- yes, global
local Drill = require "game.player.drill"
local Map = require "game.map.map"

local MiningUI = require "game.ui.mining_ui"

local World =
    Class {
    init = function(self)
        self.map = Map()
        self.drill = Drill(100, 100, AssetManager:getImage("drill1"))
        self.voxelSize = config.map.voxelSize
        self.veiwScale = 4
        self.UI = MiningUI(self.drill)
    end
}

function World:update(dt)
    self.UI:update(dt)
    self.drill:update(dt)
    self.drill:useVoxels(self.map)
    self.map:setCenter(self.drill:getPosition())
end

function World:draw()
	local cx,cy = love.graphics.getWidth()/2, love.graphics.getHeight()/2
	love.graphics.push()
	love.graphics.translate(cx,cy)
    love.graphics.scale(self.veiwScale)
	love.graphics.translate(-self.drill.position.x, -self.drill.position.y)

    self.map:draw()
    self.drill:draw()

	love.graphics.pop()

    self.UI:draw()
end

function World:keypressed(key)
end

return World
