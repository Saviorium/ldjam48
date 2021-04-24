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
    love.graphics.draw(self.image, self.position.x, self.position.y, self.angle, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
    self:drawDebug()
end

function Drill:drawDebug()
    if Debug.drill > 0 then
        local x, y = self.position.x, self.position.y
        local cx, cy = self.position.x + math.cos(self.angle)*4, y + math.sin(self.angle)*4
        love.graphics.circle( 'line', cx, cy, 12)
        love.graphics.setColor(255, 0, 0)
        love.graphics.line(x, y, x + math.cos(self.angle) * 10, y + math.sin(self.angle) * 10)
        love.graphics.setColor(255, 255, 255)

        love.graphics.setColor(255, 0, 0)
        for ind, obj in pairs(self:getCollisionSquares(1, 1)) do
            love.graphics.rectangle( 'fill', obj.x, obj.y, 1, 1)
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

function Drill:getCollisionSquares(searchRadius, searchCellsRadius)
    local result = {}
    local circleRadius = 3
    local x, y = self.position.x, self.position.y
    for i = -circleRadius-searchCellsRadius, (circleRadius+searchCellsRadius), 1 do
        for j = -circleRadius-searchCellsRadius, (circleRadius+searchCellsRadius), 1 do
            local qx, qy = i + math.floor(x), j + math.floor(y)
            local len = self.position.dist(Vector(qx, qy), self.position)
            if len < circleRadius + searchRadius and len > circleRadius then
                table.insert(result, Vector(qx, qy))
            end
        end
    end
    return result
end

return Drill
