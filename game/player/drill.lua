local PlayerController = require "game.player.player_controller"
local ParticleSystem = require "game.particle_system.particle_system"
local ParticleTypes = require "game.player.drill_particles"

local log = require "engine.utils.logger" ("drill")

local Drill =
    Class {
    init = function(self, x, y)
        self.speed = 0
        self.circleRange = 8
        self.blocksInFrame = 1.5
        self.blocksInMove = 1.5
        self.rotationSpeed = 0.08
        self.position = Vector(x,y)
        self.angle = 90*math.pi/180
        self.image = AssetManager:getAnimation("drill")
        self.image:setTag('dig')
        self.image:play()

        self.imageHighlight = 0
        self.fadeWhiteShader = love.graphics.newShader("data/shader/fade_white.fs")

        self.controller = PlayerController(self, UserInputManager)
        self.maxHP = 100
        self.maxFuel = 100
        self.HP = 80
        self.fuel = 80
        self.gold = 0

        self.maxAngles = 45
        self.startDegree = 60

        self.fuelReduction = 0.03
        self.launched = false
        self.onAir = true
        self.damaged = false
        self.damage = 20
        self.width, self.height = 8, 8

        self.particles = ParticleSystem(
            ParticleTypes,
            function() return self:getPosition() end,
            function() return self:getAngle() end )
        self.frameDensityAverage = 0

        self.lowNoise = 10
        self.mediumNoise = 250
        self.highNoise = 500

        self.frameDensity = 0

        self.damageUpgrade = 4
        self.speedUpgrade = 0.10
        self.upgradeKoef = 10
        self.maxSpeed = 2
        self.maxBlocksInFrame = 2
    end
}

function Drill:update(dt)
    self.particles:update(dt)
    self.controller:update(dt)
    self.image:update(dt)

    if self.fuel > self.maxFuel then
        self.fuel = self.maxFuel
    end
    if self.HP > self.maxHP then
        self.HP = self.maxHP
    end
end

function Drill:draw()
    self.particles:draw("behind")

    if self.imageHighlight > 0 then
        self.fadeWhiteShader:send("intensity", math.abs(math.sin(self.imageHighlight * 3.14 * 3)))
        love.graphics.setShader(self.fadeWhiteShader)
        self.imageHighlight = self.imageHighlight - 0.075
    end
    self.image:draw(self.position.x, self.position.y, self.angle, 1, 1, self.width, self.height)
    love.graphics.setShader()

    self.particles:draw("front")
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
        for ind, obj in pairs(self:getCollisionSquares(1, 1, self.circleRange-(self.blocksInMove-1), 120)) do
            love.graphics.rectangle( 'fill', obj.x, obj.y, 1, 1)
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.setColor(255, 0, 0)
        for ind, obj in pairs(self:getCollisionSquares(2, 2)) do
            --love.graphics.rectangle( 'fill', obj.x, obj.y, 1, 1)
        end
        love.graphics.setColor(255, 255, 255)

    end
end

function Drill:move()
    self.position = self.position + Vector(math.cos(self.angle), math.sin(self.angle)) * self.blocksInMove
end

function Drill:turn( direction )
    if self.launched then
        local angle = self.angle*180/math.pi
        local startDegree = not self.onAir and self.startDegree or 0
        local maxAngel = 90 + self.maxAngles
        local degradationKoef = angle > (90 + startDegree) and (90 - angle)/maxAngel or (angle < (90 - startDegree) and (angle - 90)/maxAngel or 0)
        if not self.onAir and self.fuel > 0 and direction ~= 0  then
            love.event.push('turn')
            self.fuel = self.fuel - self.fuelReduction
            self.angle = self.angle + self.rotationSpeed * -direction
        end
        self.angle = self.angle + self.rotationSpeed * degradationKoef * (angle > 90 and 1 or -1)
    else
        self.position.x = self.position.x + direction
    end
end

function Drill:start()
    self.launched = true
end

function Drill:upgrade(upgradeCost)
    self.damage = self.damage + self.damageUpgrade
    self.blocksInFrame = self.blocksInFrame + (self.blocksInFrame == self.maxBlocksInFrame and 0 or self.speedUpgrade)
    self.blocksInMove = self.blocksInMove + (self.blocksInMove == self.maxSpeed and 0 or self.speedUpgrade)
    self.gold = self.gold - upgradeCost
    SoundManager:play('levelUp')
    self.imageHighlight = 1
end

function Drill:getPosition()
    return self.position
end

function Drill:getAngle()
    return self.angle
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
        local moneyCollected = 0
        local fuelCollected = 0
        self.blocksMoved = 0
        self.frameDensity = 0
        self.damaged = false

        while ( frameDamage > 0 and (self.blocksMoved + self.blocksInMove) <= self.blocksInFrame ) do
            local squaresDiggedNum = 0
            local digArea = self:getCollisionSquares(1, 1, self.circleRange-(self.blocksInMove), 120)
            for ind, pos in pairs(digArea) do
                local result = map:digVoxel(pos)
                self.frameDensity = self.frameDensity + result.density
                if result.health > 0 and result.density > 0 then
                    fuelCollected = fuelCollected + result.fuel
                    moneyCollected = moneyCollected + result.money
                    self.HP   = self.HP - result.damageToDrill
                    self.damaged = result.damageToDrill > 0 or self.damaged
                    frameDamage = frameDamage - 1
                end
                while (result.health > 0 and result.density > 0 and frameDamage > 0) do
                    result = map:digVoxel(pos)
                    self.fuel = self.fuel + result.fuel
                    moneyCollected = moneyCollected + result.money
                    self.HP   = self.HP - result.damageToDrill
                    frameDamage = frameDamage - 1
                end
                squaresDiggedNum = result.health <= 0 and squaresDiggedNum + 1 or squaresDiggedNum
            end
            if squaresDiggedNum == table.getn(digArea) then
                self:move()
                self.blocksMoved = self.blocksMoved + self.blocksInMove
            end
        end

        self.fuel = self.fuel + fuelCollected
        if fuelCollected > 0 then
            love.event.push('refuel', fuelCollected)
        end

        self.gold = self.gold + moneyCollected
        if moneyCollected > 0 then
            love.event.push('money', moneyCollected)
        end

        self.frameDensityAverage = self.frameDensityAverage + (self.frameDensity - self.frameDensityAverage / 30)
        self.particles:setIntensity("spark", self.frameDensityAverage/5)
        self.particles:setIntensity("dirtChunk", 5)
        if self.damaged then
            self.particles:setIntensity("smoke", 50)
            love.event.push('damaged')
        else
            self.particles:setIntensity("smoke", 0)
        end
        self.onAir = self.frameDensity == 0

        if self.frameDensityAverage < self.lowNoise and self.frameDensityAverage > 0 then
            SoundManager:play('digLow')
        elseif self.frameDensityAverage < self.mediumNoise then
            SoundManager:play('digMedium')
        elseif self.frameDensityAverage < self.highNoise then
            SoundManager:play('digHigh')
        else
            SoundManager:play('digHigh')
        end

        log(4, "Drill collided with " .. squaresCollidedNum .. " squares, total density is " .. sumDensity)
        log(3, "Drill density multiplier is " .. (1 - sumDensity / squaresCollidedNum))
    end
end

return Drill