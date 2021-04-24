local PlayerController = require "game.player.player_controller"

local log = require "engine.utils.logger" ("drill")

local Drill =
    Class {
    init = function(self, x, y, image)
        self.speed = 0
        self.acceleration = 50
        self.rotationSpeed = 0.1
        self.position = Vector(x,y)
        self.angle = 90*math.pi/180
        self.image = image
        self.controller = PlayerController(self, UserInputManager)
        self.maxHP = 100
        self.maxFuel = 100
        self.HP = 80
        self.fuel = 80
        self.circleRange = 4
        self.maxAngles = 45
        self.fuelReduction = 0.01
        self.launched = false
    end
}

function Drill:update(dt)
    if self.launched then
        self:move(dt)
    end
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
    if self.launched then
        local nextAngle = math.abs(((self.angle + self.rotationSpeed * direction)*180/math.pi) - 90)
        local rotationSpeed = self.rotationSpeed
        if nextAngle > self.maxAngles and self.fuel > 0 then
            rotationSpeed = rotationSpeed * ( 1 - (nextAngle - self.maxAngles)/90 )
            self.fuel = self.fuel - self.fuelReduction
        end
        self.angle = self.angle + rotationSpeed * direction
    else
        self.position.x = self.position.x + direction
    end
end

function Drill:start()
    self.launched = true
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
    local speedAccum = 0.5
    local squaresCollidedNum = 1
    for ind, pos in pairs(self:getCollisionSquares(1, 1)) do
        local voxel = map:getVoxel(pos)
        if voxel then
            speedAccum = speedAccum + voxel.resource.density
            squaresCollidedNum = squaresCollidedNum + 1
            map:digVoxel(pos)
        end
    end
    log(4, "Drill collided with " .. squaresCollidedNum .. " squares, total density is " .. speedAccum)
    log(3, "Drill density multiplier is " .. (1 - speedAccum / squaresCollidedNum))
    self.speed = self.acceleration * (1 - speedAccum / squaresCollidedNum)
end

return Drill
