Resources = require "game.map.resources" -- yes, global
local Drill = require "game.player.drill"
local Map = require "game.map.map"
local Surface = require "game.surface.surface"

local MiningUI = require "game.ui.mining_ui"

local World =
    Class {
    init = function(self)
        self.map = Map()
        self.drill = Drill(0, 0, AssetManager:getAnimation("drill"))
        self.veiwScale = 4
        self.UI = MiningUI(self.drill)
        self.target = self.drill
        self.surface = Surface()
    end
}

function World:update(dt)
    self.UI:update(dt)
    self.map:update(dt)
    self.map:setCenter(self.drill:getPosition())
    self.drill:dig(self.map)
    self.drill:update(dt)
    self.surface:update(dt, self.drill.position)
end

function World:draw()
	local cx,cy = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    love.graphics.setColor(135/255,206/255,250/255)
    love.graphics.rectangle('fill', 0 , 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1)

	love.graphics.push()
	love.graphics.translate(cx,cy)
    love.graphics.scale(self.veiwScale)
	love.graphics.translate(-self.target.position.x, -self.target.position.y)

    self.surface:draw(self.drill.position)
    self.map:draw()
    self.drill:draw()

	love.graphics.pop()

    self.UI:draw()

    if Debug and Debug.resourceDisplay and Debug.resourceDisplay > 0 then
        local mouseCoords = self:getWorldCoords(Vector(love.mouse.getPosition()))
        local voxel = self.map:getVoxel(mouseCoords)
        if voxel then
            love.graphics.print(
                string.format("Resource at (%5d,%-5d) %-10.10s: %d", mouseCoords.x, mouseCoords.y, voxel.resource.name, voxel.health),
                2,
                16
            )
        end
    end
end

function World:getWorldCoords(screenPoint)
    local unitsPerPixel = 1 / self.veiwScale
	local screenCenter = Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    return self.target.position + (screenPoint - screenCenter) * unitsPerPixel
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
    if Debug and Debug.teleport == 1 then
        if key == "x" then
            self.drill.position.y = self.drill.position.y + 1000
        end
        if key == "z" then
            self.drill.position.y = self.drill.position.y - 1000
        end
    end
end


return World
