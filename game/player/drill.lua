local PlayerController = require "game.player.player_controller"
local log = require "engine.utils.logger" ("drill")

local Drill =
    Class {
    init = function(self, x, y, image)
        self.speed = 0
        self.circleRange = 3
        self.blocksInFrame = 100
        self.blocksInMove = 4
        self.rotationSpeed = 0.1
        self.position = Vector(x,y)
        self.angle = 90*math.pi/180
        self.image = image
        self.image:setTag('dig')
        self.image:play()
        self.controller = PlayerController(self, UserInputManager)
        self.maxHP = 100
        self.maxFuel = 100
        self.HP = 80
        self.fuel = 80
        self.gold = 0
        self.maxAngles = 45
        self.fuelReduction = 0.01
        self.launched = false
        self.damage = 120
        self.width, self.height = 4, 4
    end
}

function Drill:update(dt)
    self.controller:update(dt)
    self.image:update(dt)
end

function Drill:draw()
    self.image:draw(self.position.x, self.position.y, self.angle, 1, 1, self.width, self.height)
    --love.graphics.draw(self.image, self.position.x, self.position.y, self.angle, 1, 1, self.image:getWidth()/2, self.image:getHeight()/2)
    self:drawDebug()
end

function Drill:drawDebug()
    if Debug.drill > 0 then
        local x, y = self.position.x, self.position.y
        love.graphics.circle( 'line', x, y, self.circleRange)
        love.graphics.setColor(255, 0, 0)
        love.graphics.line(x, y, x + math.cos(self.angle) * 10, y + math.sin(self.angle) * 10)
        love.graphics.setColor(255, 255, 255)

        love.graphics.setColor(255, 255, 0)
        for ind, obj in pairs(self:getCollisionSquares(1, 1, self.circleRange-(self.blocksInMove-1), 90)) do
            love.graphics.rectangle( 'fill', obj.x, obj.y, 1, 1)
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.setColor(255, 0, 0)
        for ind, obj in pairs(self:getCollisionSquares(1, 1)) do
            love.graphics.rectangle( 'fill', obj.x, obj.y, 1, 1)
        end
        love.graphics.setColor(255, 255, 255)

    end
end

function Drill:move()
    self.position = self.position + Vector(math.cos(self.angle), math.sin(self.angle)) * self.blocksInMove/60
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

function Drill:getCollisionSquares(searchRadius, searchCellsRadius, minRadius, sideDegrees )
    local result = {}
    local x, y = self.position.x, self.position.y
    local minRad = minRadius or self.circleRange
    local degrees = sideDegrees or 110
    for i = -self.circleRange-searchCellsRadius, (self.circleRange+searchCellsRadius), 1 do
        for j = -self.circleRange-searchCellsRadius, (self.circleRange+searchCellsRadius), 1 do
            local qx, qy = i + math.floor(x), j + math.floor(y)
            local len = self.position.dist(Vector(qx, qy), self.position)
            local angle = Vector( math.cos(self.angle) * 10, math.sin(self.angle) * 10):angleTo(Vector(i, j))*180/math.pi
            if len < self.circleRange + searchRadius and len > minRad and (math.abs(angle) > degrees and math.abs(angle) < (360 - degrees)) then
                table.insert(result, Vector(qx, qy))
            end
        end
    end
    return result
end

function Drill:dig( map )
    if self.launched then
        local sumDensity = 0
        local squaresCollidedNum = 1
        local frameDamage = self.damage
        local blocksMoved = 0

        while ( frameDamage > 0 and blocksMoved < self.blocksInFrame ) do
            local squaresDiggedNum = 0
            local digArea = self:getCollisionSquares(1, 1, self.circleRange-(self.blocksInMove-1), 90)
            for ind, pos in pairs(digArea) do
                local digged = false
                while (map:getVoxel(pos).resource.density > 0 and frameDamage > 0) do
                    local result = map:digVoxel(pos)
                    self.gold = self.gold + result
                    frameDamage = frameDamage - 1
                    digged = true
                end
                squaresDiggedNum = digged and squaresDiggedNum or squaresDiggedNum + 1
            end

            if squaresDiggedNum == table.getn(digArea) then
                self:move()
                blocksMoved = blocksMoved + self.blocksInMove
            end
        end

        log(4, "Drill collided with " .. squaresCollidedNum .. " squares, total density is " .. sumDensity)
        log(3, "Drill density multiplier is " .. (1 - sumDensity / squaresCollidedNum))
    end
end

return Drill