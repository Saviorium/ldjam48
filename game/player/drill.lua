local PlayerController = require "game.player.player_controller"

local Drill =
    Class {
    init = function(self, x, y, image)
        self.speed = 0
        self.acceleration = 2
        self.rotationSpeed = 0.1
        self.position = Vector(x,y)
        self.angle = 0
        self.image = image
        self.controller = PlayerController(self, UserInputManager)
        self.maxHP = 100
        self.maxFuel = 100
        self.HP = 80
        self.fuel = 80
        self.circleRange = 4
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
        love.graphics.circle( 'line', x, y, self.circleRange)
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
    local x, y = self.position.x, self.position.y
    for i = -self.circleRange-searchCellsRadius, (self.circleRange+searchCellsRadius), 1 do
        for j = -self.circleRange-searchCellsRadius, (self.circleRange+searchCellsRadius), 1 do
            local qx, qy = i + math.floor(x), j + math.floor(y)
            local len = self.position.dist(Vector(qx, qy), self.position)
            local angle = Vector( math.cos(self.angle) * 10, math.sin(self.angle) * 10):angleTo(Vector(i, j))*180/math.pi
            if len < self.circleRange + searchRadius and len > self.circleRange and (math.abs(angle) < 90 or math.abs(angle) > 270) then
                table.insert(result, Vector(qx, qy))
            end
        end
    end
    return result
end

function Drill:useVoxels( map )
    self.speed = 0
    for ind, pos in pairs(self:getCollisionSquares(1, 1)) do
        self.speed = self.speed + self.acceleration - map:getVoxel(pos)
        map:digVoxel(pos)
    end
end

return Drill
