local OreGenerator = Class {
    init = function(self, resource, seed)
        self.resource = resource
        self.seed = seed + resource.id
        self.random = love.math.newRandomGenerator(self.seed)
        self.noiseStart = {
            x = self.random:random(999999),
            y = self.random:random(999999),
        }
    end
}

function OreGenerator:getValue(position)
    if position.y < 0 then return 0 end
    local value =
        self:getNoise(
            self.noiseStart.x + position.x,
            self.noiseStart.y + position.y,
            self.resource.generation.frequency,
            self.resource.generation.threshold
        ) * self:getNoise(
            self.noiseStart.x - position.x,
            self.noiseStart.y - position.y,
            self.resource.generation.subnoise.frequency,
            self.resource.generation.subnoise.threshold
        )
    return value
end

function OreGenerator:getResource()
    return self.resource
end

function OreGenerator:getNoise(x, y, freq, threshold)
    return math.max(0, love.math.noise(x * freq, y * freq) - threshold ) / (1 - threshold)
end

return OreGenerator