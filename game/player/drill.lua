local PlayerController = require "game.player.player_controller"

local Drill =
    Class {
    init = function(self, x, y, image)
        self.speed = 100
        self.rotationSpeed = 0.1
        self.position = Vector(x,y)
        self.angle = 0
        self.image = image
        self.controller = PlayerController(self, UserInputManager)
        self.maxHP = 100
        self.maxFuel = 100
        self.HP = 80
        self.fuel = 80
    end
}

function Drill:update(dt)
    self:move(dt)
    self.controller:update(dt)
end

function Drill:draw()
    love.graphics.draw(self.image, self.position.x, self.position.y, self.angle, 1, 1, 4, 4)
    self:drawDebug()
end

function Drill:drawDebug()
    if Debug.drill > 0 then
        local x, y = self.position.x, self.position.y
        local circleRadius = 3
        local searchRadius = 1 
        local searchCellsRadius = 1
        love.graphics.circle( 'line', x, y, circleRadius)
        love.graphics.setColor(255, 0, 0)
        love.graphics.line(x, y, x + math.cos(self.angle) * 10, y + math.sin(self.angle) * 10)
        love.graphics.setColor(255, 255, 255)

        love.graphics.setColor(255, 0, 0)
        for i = -circleRadius-searchCellsRadius, (circleRadius+searchCellsRadius), 1 do
            for j = -circleRadius-searchCellsRadius, (circleRadius+searchCellsRadius), 1 do
                local qx, qy = i + math.floor(x), j + math.floor(y)
                local len = self.position.dist(Vector(qx, qy), self.position)
                if len < circleRadius + searchRadius and len > circleRadius then
                    love.graphics.rectangle( 'fill', qx, qy, 1, 1)
                end
            end
        end
        love.graphics.setColor(255, 255, 255)

    end
end

function Drill:move(dt)
    self.position = self.position + Vector(math.cos(self.angle), math.sin(self.angle)) * self.speed * dt
end

function Drill:turn( direction )
    self.angle = self.angle + self.rotationSpeed * direction
end

function Drill:getPosition()
    return self.position
end

return Drill
