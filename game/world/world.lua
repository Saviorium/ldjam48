local Resources = require "game.map.resources"
local Drill = require "game.player.drill"
local Map = require "game.map.map"
local Surface = require "game.surface.surface"
local MiningUI = require "game.ui.mining_ui"
local Camera = require "game.world.camera"


local World =
    Class {
    init = function(self)
        self.map = Map()
        self.viewScale = config.map.viewScale
        self.surface = Surface()
        self.base = self.surface.base
        self.cheatUpgradeTimer = 0
        self.camera = Camera()
    end
}

function World:startDrilling()
    self.drill = Drill(0, 0)
    self:changeCameraTarget(self.drill)
    self.UI = MiningUI(self.drill)
end

function World:backToBase()
    self.drill = Drill(0, 0)
    self:changeCameraTarget(self.base)
end


function World:update(dt)
    self.UI:update(dt)
    self.map:update(dt)
    self.map:setCenter(self.drill:getPosition())
    self.drill:update(dt)
    self.drill:dig(self.map)
    self.surface:update(dt, self.drill.position)

    if self.drill.HP < 0 then
        StateManager.switch(states.end_screen, self)
    end

    self.cheatUpgradeTimer = self.cheatUpgradeTimer + dt
    local upgradeCost = self.drill.damage * self.drill.upgradeKoef
    if self.drill.gold >= upgradeCost or (self.cheatUpgradeTimer > 1 and Debug.unlockMoney) then
        self:upgradeDrill(upgradeCost)
        self.cheatUpgradeTimer = 0
    end

    self.camera:update(dt)
end

function World:draw()
	local cx,cy = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    love.graphics.setColor(135/255,206/255,250/255)
    love.graphics.rectangle('fill', 0 , 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1)

	love.graphics.push()
	love.graphics.translate(cx,cy)
    love.graphics.scale(self.viewScale)
	self.camera:applyTransform()
    if self.drill.damaged then
        love.graphics.translate(math.random(2) - 1, math.random(2) - 1)
    end

    self.surface:draw(self.drill.position)
    self.map:draw()
    self.drill:draw()

	love.graphics.pop()

    if Debug and Debug.resourceDisplay and Debug.resourceDisplay > 0 then
        local mouseCoords = self:getWorldCoords(Vector(love.mouse.getPosition()))
        local voxel = self.map:getVoxel(mouseCoords)
        local resource = Resources[voxel.resourceId]
        if voxel then
            love.graphics.print(
                string.format("Resource at (%5d,%-5d) %-10.10s: %d", mouseCoords.x, mouseCoords.y, resource.name, voxel.health),
                2,
                16
            )
        end
    end
    self.UI:draw()
end

function World:getWorldCoords(screenPoint)
    local unitsPerPixel = 1 / self.viewScale
	local screenCenter = Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    return self.camera.position + (screenPoint - screenCenter) * unitsPerPixel
end

function World:changeCameraTarget(target)
    self.camera:setTarget(target)
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

function World:upgradeDrill(upgradeCost)
    self.drill:upgrade(upgradeCost)
end

return World
