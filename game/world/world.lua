Resources = require "game.map.resources" -- yes, global
local Drill = require "game.player.drill"
local Map = require "game.map.map"

local MiningUI = require "game.ui.mining_ui"

local World =
    Class {
    init = function(self)
        self.map = Map()
        self.drill = Drill(0, 0, AssetManager:getAnimation("drill"))
        self.voxelSize = config.map.voxelSize
        self.veiwScale = 4
        self.UI = MiningUI(self.drill)
        self.target = self.drill
    end
}

function World:update(dt)
    self.UI:update(dt)
    self.drill:update(dt)
    self.drill:dig(self.map)
    self.map:setCenter(self.drill:getPosition())
end

function World:draw()
	local cx,cy = love.graphics.getWidth()/2, love.graphics.getHeight()/2
	love.graphics.push()
	love.graphics.translate(cx,cy)
    love.graphics.scale(self.veiwScale)
	love.graphics.translate(-self.target.position.x, -self.target.position.y)

    self.map:draw()
    self.drill:draw()

	love.graphics.pop()

    self.UI:draw()
end

function World:changeCameraTarget(target)
    self.target = target
end

function World:mousepressed(x, y)
    self.UI:mousepressed(x, y)
end

function World:mousereleased(x, y)
    self.UI:mousereleased(x, y)
end

function World:keypressed(key)
    self.UI:keypressed(key)
end


return World
