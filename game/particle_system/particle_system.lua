local Particle = require "game.particle_system.particle"
local function random(n)
    if n <= 0 then return 0 end
    return love.math.random() * 2 * n - n
end

local ParticleSystem = Class {
    init = function(self, particleTypes, getPositionFunc, getAngleFunc)
        self.getPositionFunc = getPositionFunc or function() return Vector(0, 0) end
        self.getAngleFunc = getAngleFunc or function() return 0 end
        self.particles = {}
        self.drawCache = {}
        for type, particleParams in pairs(particleTypes) do
            self.particles[type] = {
                type = particleParams,
                particles = {},
                alive = 0,
                intensity = 0,
                spawn = 0,
            }
            if not self.drawCache[particleParams.spawnType] then
                self.drawCache[particleParams.spawnType] = {}
            end
            self.drawCache[particleParams.spawnType][type] = self.particles[type].particles
        end
    end
}

function ParticleSystem:setIntensity(particleName, value)
    local particlePool = self.particles[particleName]
    if particlePool then
        self.particles[particleName].intensity = math.clamp(0, value, particlePool.type.maxIntensity)
    end
end

function ParticleSystem:spawn(particleName, value)
    local particlePool = self.particles[particleName]
    if particlePool then
        self.particles[particleName].spawn = self.particles[particleName].spawn + math.clamp(0, value, particlePool.type.maxIntensity)
    end
end

function ParticleSystem:update(dt)
    local time = love.timer.getTime()
    for type, particlesOfType in pairs(self.particles) do
        local position = self:getPositionFunc() -- translate for that type of particles
        local angle = self:getAngleFunc()
        position = particlesOfType.type.translate:rotated(angle) + position
        angle = math.deg(angle) + particlesOfType.type.angle

        if particlesOfType.intensity > 0 then
            local intensityRandomness = random(particlesOfType.type.random.intensity)
            local spawnChance = math.max(0, (particlesOfType.intensity + intensityRandomness)/60)
            particlesOfType.spawn = particlesOfType.spawn + spawnChance
        end
        for i, particle in pairs(particlesOfType.particles) do
            if particle.alive then
                particle:update(dt)
                if time > particle.dieAt then
                    particle.alive = false
                end
            elseif particlesOfType.intensity > 0 and particlesOfType.spawn > 0 then -- if dead, respawn
                particle:spawn(position, angle)
                particlesOfType.spawn = particlesOfType.spawn - 1
            end
        end
        while particlesOfType.spawn > 1 do
            local newParticle = Particle(particlesOfType.type)
            newParticle:spawn(position, angle)
            particlesOfType.spawn = particlesOfType.spawn - 1
            table.insert(particlesOfType.particles, newParticle)
        end
    end
end

function ParticleSystem:draw(spawnType)
    if not spawnType or not self.drawCache[spawnType] then
        return
    end
    for type, particlesOfType in pairs(self.drawCache[spawnType]) do
        for i, particle in pairs(particlesOfType) do
            if particle.alive then
                particle:draw()
            end
        end
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(1)
end

return ParticleSystem
