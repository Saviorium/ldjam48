local ResourceGenerator = Class {
    init = function(self, resource, seed)
        self.resource = resource
        local seedSalt = resource.seed or resource.id
        self.seed = seed + seedSalt
        self.random = love.math.newRandomGenerator(self.seed)
        self.noiseStart = {
            x = self.random:random(999999),
            y = self.random:random(999999),
        }
    end
}

function ResourceGenerator:getValue(position)
    return self.getNoiseValue(position.y, self.noiseStart+position, self.resource.generation)
end

function ResourceGenerator:getColor(position)
    local colorParams = self.resource.colorGeneration
    local frequency = colorParams.noiseFrequency
    if not frequency then
        frequency = 1
    end
    local frequencyX = colorParams.aspectRatio and frequency*colorParams.aspectRatio or frequency
    local value = ResourceGenerator.getRawNoise(
        self.noiseStart.x+position.x,
        self.noiseStart.y+position.y,
        frequencyX,
        frequency,
        0
    )
    local colorId
    for i, threshold in pairs(colorParams.thresholds) do
        if value < threshold then
            colorId = i
            break
        end
    end
    return colorId
end

function ResourceGenerator:getResource()
    return self.resource
end

function ResourceGenerator.getNoiseValue(depth, position, noiseParams)
    if noiseParams.from and depth < noiseParams.from then return 0 end
    if noiseParams.to and depth > noiseParams.to then return 0 end

    local subnoise, value
    if noiseParams.subnoise then
        subnoise = ResourceGenerator.getNoiseValue(depth, position*2, noiseParams.subnoise)
    end

    local threshold = ResourceGenerator.mapLinear(depth, noiseParams.threshold)
    if not threshold then
        return 0 -- spawn nothing
    end
    if threshold <= 0 then
        value = 1
    elseif threshold >= 1 then
        value = 0
    else
        local frequency = ResourceGenerator.mapGetLast(depth, noiseParams.frequency)
        if not frequency then
            frequency = 1
        end
        local frequencyX = noiseParams.aspectRatio and frequency*noiseParams.aspectRatio or frequency

        value = ResourceGenerator.getRawNoise(
            position.x,
            position.y,
            frequencyX,
            frequency,
            threshold
        )
    end
    if subnoise then
        if noiseParams.subnoise.type == "add" then
            value = value + subnoise
        elseif noiseParams.subnoise.type == "sub" then
            value = value - subnoise
        elseif noiseParams.subnoise.type == "mult" then
            value = value * subnoise
        end
        math.clamp(0, value, 1)
    end
    return value
end

function ResourceGenerator.mapLinear(depth, depthTable)
    local startPoint, endPoint
    for _, v in pairs(depthTable) do
        endPoint = v
        if v.depth >= depth then
            break
        end
        startPoint = v
    end
    if not startPoint then
        startPoint = endPoint
    end
    if not endPoint then
        return
    end
    if startPoint.value == endPoint.value then return endPoint.value end
    depth = math.clamp(startPoint.depth, depth, endPoint.depth)
    local pointPlace
    if endPoint.depth == startPoint.depth then
        pointPlace = 1
    else
        pointPlace = (depth-startPoint.depth) / (endPoint.depth-startPoint.depth) -- 0 = startPoint, 1 = endPoint
    end
    return startPoint.value + ((endPoint.value-startPoint.value) * pointPlace)
end

function ResourceGenerator.mapGetLast(depth, depthTable)
    local point
    for _, v in pairs(depthTable) do
        point = v
        if v.depth >= depth then
            break
        end
    end
    return point.value
end

function ResourceGenerator.getRawNoise(x, y, freqX, freqY, threshold)
    return math.max(0, love.math.noise(x * freqX, y * freqY) - threshold ) / (1 - threshold)
end

return ResourceGenerator