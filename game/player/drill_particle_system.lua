local particleTypes = {
    dirtChunk = {
        type = "circle",
        color = { 0.3, 0.18, 0.15, 1 },
        behind = true,
        size = 2,
        gravity = 0.2,
        friction = 0.99,
        spawnAt = Vector(0, 0),
        angle = 0, -- deg, aligned with drill, 0 = back, clockwise
        speed = 2,
        timeToLive = 0.3, -- seconds
        maxIntensity = 10, -- particles per second
        random = {
            color = 0.01,
            size = 0.5,
            translate = 1,
            angle = 45,
            speed = 2,
            timeToLive = 0,
            intensity = 5,
        }
    },
    stoneChunk = {
        type = "circle",
        color = { 0.6, 0.6, 0.6, 1 },
        behind = true,
        size = 1,
        gravity = 0.2,
        friction = 0.99,
        spawnAt = Vector(0, 0),
        angle = 0, -- deg, aligned with drill, 0 = back, clockwise
        speed = 2,
        timeToLive = 0.3, -- seconds
        maxIntensity = 10, -- particles per second
        random = {
            color = 0,
            size = 0.1,
            translate = 1,
            angle = 45,
            speed = 2,
            timeToLive = 0,
            intensity = 5,
        }
    },
    smoke = {
        type = "circle",
        color = { 0.6, 0.6, 0.6, .7 },
        behind = true,
        size = 3,
        gravity = -0.1,
        friction = 0.98,
        spawnAt = Vector(0, 0),
        angle = 0, -- deg, aligned with drill, 0 = back, clockwise
        speed = 0.3,
        timeToLive = 0.7, -- seconds
        maxIntensity = 50, -- particles per second
        random = {
            color = 0,
            lightness = 0.1,
            size = 1,
            translate = 1,
            angle = 180,
            speed = 0.2,
            timeToLive = 0.3,
            intensity = 2,
        }
    },
    spark = {
        type = "line",
        color = { 0.9, 0.8, 0.1, 1 },
        behind = false,
        size = 0.4,
        gravity = 1,
        friction = 0.7,
        spawnAt = Vector(5, 0),
        angle = 180,
        speed = 5,
        timeToLive = 0.1,
        maxIntensity = 30,
        random = {
            color = 0.2,
            size = 0.2,
            translate = 0.5,
            angle = 120,
            speed = 2,
            timeToLive = 0.05,
            intensity = 5,
        }
    }
}

local function random(n)
    if n <= 0 then return 0 end
    return love.math.random() * 2 * n - n
end

local Particle = Class {
    init = function(self, type)
        self.type = type
        self.color = {0, 0, 0, 0}
        self.size = 0
        self.position = Vector(0, 0)
        self.prevPosition = Vector(0, 0)
        self.velocity = Vector(0, 0)
        self.alive = false
        self.dieAt = 0
    end
}

function Particle:spawn(position, angleGlobal) -- angle in deg, from up, clockwise
    local time = love.timer.getTime()
    self.dieAt = time + self.type.timeToLive + random(self.type.random.timeToLive)
    self.color[1] = self.type.color[1] + random(self.type.random.color) -- optimisations, reusing...
    self.color[2] = self.type.color[2] + random(self.type.random.color)
    self.color[3] = self.type.color[3] + random(self.type.random.color)
    self.color[4] = self.type.color[4]
    self.size = self.type.size + random(self.type.random.size)
    self.position.x = position.x + random(self.type.random.translate)
    self.position.y = position.y + random(self.type.random.translate)
    self.prevPosition.x = self.position.x
    self.prevPosition.y = self.position.y
    local angleInRad = math.rad(angleGlobal + random(self.type.random.angle))
    self.velocity = Vector(-1, 0):rotateInplace(angleInRad) * (self.type.speed + random(self.type.random.speed))
    self.alive = true
end

function Particle:update(dt)
    if not self.alive then
        return
    end
    self.prevPosition.x = self.position.x
    self.prevPosition.y = self.position.y
    self.position.x = self.position.x + self.velocity.x
    self.position.y = self.position.y + self.velocity.y
    self.velocity.y = self.velocity.y + self.type.gravity
    self.velocity.x = self.velocity.x * self.type.friction
    self.velocity.y = self.velocity.y * self.type.friction
end

function Particle:draw()
    love.graphics.setColor(self.color)
    if self.type.type == "rectangle" then
        love.graphics.rectangle(
            'fill',
            self.position.x,
            self.position.y,
            self.size,
            self.size
        )
    elseif self.type.type == "line" then
        love.graphics.setLineWidth(self.size)
        love.graphics.line(
            self.position.x,
            self.position.y,
            self.prevPosition.x,
            self.prevPosition.y
        )
    elseif self.type.type == "circle" then
        love.graphics.circle(
            'fill',
            self.position.x,
            self.position.y,
            self.size
        )
    end
end

local DrillParticleSystem = Class {
    init = function(self, drill)
        self.drill = drill
        self.particles = {}
        self.drawCache = {
            behind = {},
            front = {},
        }
        for type, particleParams in pairs(particleTypes) do
            self.particles[type] = {
                type = particleParams,
                particles = {},
                alive = 0,
                intensity = 0,
                spawn = 0,
            }
            if particleParams.behind then
                self.drawCache.behind[type] = self.particles[type].particles
            else
                self.drawCache.front[type] = self.particles[type].particles
            end
        end
    end
}

function DrillParticleSystem:setColor(particleName, color)
    local particlePool = self.particles[particleName]
    if particlePool then
        self.particles[particleName].color = color
    end
end

function DrillParticleSystem:setIntensity(particleName, value)
    local particlePool = self.particles[particleName]
    if particlePool then
        self.particles[particleName].intensity = math.clamp(0, value, particlePool.type.maxIntensity)
    end
end

function DrillParticleSystem:update(dt)
    local time = love.timer.getTime()
    for type, particlesOfType in pairs(self.particles) do
        local drillPosition = self.drill.position:clone() -- translate for that type of particles
        local angle = self.drill.angle
        drillPosition = particlesOfType.type.spawnAt:rotated(angle) + drillPosition
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
                particle:spawn(drillPosition, angle)
                particlesOfType.spawn = particlesOfType.spawn - 1
            end
        end
        if particlesOfType.intensity > 0 and particlesOfType.spawn > 0 then
            local newParticle = Particle(particlesOfType.type)
            newParticle:spawn(drillPosition, angle)
            table.insert(particlesOfType.particles, newParticle)
        end
    end
end

function DrillParticleSystem:drawBehind()
    for type, particlesOfType in pairs(self.drawCache.behind) do
        for i, particle in pairs(particlesOfType) do
            if particle.alive then
                particle:draw()
            end
        end
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(1)
end

function DrillParticleSystem:drawInFront()
    for type, particlesOfType in pairs(self.drawCache.front) do
        for i, particle in pairs(particlesOfType) do
            if particle.alive then
                particle:draw()
            end
        end
    end
    love.graphics.setColor(1,1,1,1)
    love.graphics.setLineWidth(1)
end

return DrillParticleSystem