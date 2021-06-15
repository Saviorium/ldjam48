local Resources = require "game.map.resources"
local Drill = require "game.player.drill"
local Map = require "game.map.map"
local Surface = require "game.surface.surface"


local World =
    Class {
    init = function(self)
        self.map = Map()
        self.viewScale = config.map.viewScale
        self.surface = Surface()
        self.base = self.surface.base
    end
}

function World:startDrilling()
    self.drill = Drill(0, 0)
    self.target = self.drill
end

function World:backToBase()
    self.drill = Drill(0, 0)
    self.target = self.base
end


function World:update(dt)
    self.map:update(dt)
    self.map:setCenter(self.drill:getPosition())
    self.drill:update(dt)
    self.drill:dig(self.map)
    self.surface:update(dt, self.drill.position)

    if self.drill.HP < 0 then
        StateManager.switch(states.end_screen, self)
    end
end

function World:draw()
	local cx,cy = love.graphics.getWidth()/2, love.graphics.getHeight()/2
    love.graphics.setColor(135/255,206/255,250/255)
    love.graphics.rectangle('fill', 0 , 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1)

	love.graphics.push()
	love.graphics.translate(cx,cy)
    love.graphics.scale(self.viewScale)
	love.graphics.translate(-self.target.position.x + (self.drill.damaged and (math.random(2) - 1) or 0), -self.target.position.y + (self.drill.damaged and (math.random(2) - 1) or 0))

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
end

function World:getWorldCoords(screenPoint)
    local unitsPerPixel = 1 / self.viewScale
	local screenCenter = Vector(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    return self.target.position + (screenPoint - screenCenter) * unitsPerPixel
end

function World:changeCameraTarget(target)
    self.target = target
end

function World:mousepressed(x, y)
end

function World:mousereleased(x, y)
end

function World:keypressed(key)
    if Debug and Debug.teleport == 1 then
        if key == "x" then
            self.drill.position.y = self.drill.position.y + 1000
        end
        if key == "z" then
            self.drill.position.y = self.drill.position.y - 1000
        end
    end
    if key == 'space' then
        self:upgradeDrill()
    end
end

function World:upgradeDrill()
    local upgradeCost = self.drill.damage * self.drill.upgradeKoef
    if Debug.unlockMoney or self.drill.gold >= upgradeCost then
        self.drill.blocksInFrame = self.drill.blocksInFrame + (self.drill.blocksInFrame == self.drill.maxSpeed and 0 or self.drill.speedUpgrade)
        self.drill.damage = self.drill.damage + self.drill.damageUpgrade
        self.drill.gold = self.drill.gold - upgradeCost
        SoundManager:play('levelUp')
    else
        SoundManager:play('doNotLevelUp')
    end
end

return World
