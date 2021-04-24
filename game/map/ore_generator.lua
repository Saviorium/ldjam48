-- parameters = {
--     density = 0.3,
--     frequency = 0.1,
-- }

local OreGenerator = Class {
    init = function(self, name, parameters)
        self.name = name
        self.params = parameters
        self.seed = nil
    end
}

function OreGenerator:getVoxel(x, y)
    return 1 -- generate with noise
end

function OreGenerator:getChunkData(coordinates)
    return {}
end

return OreGenerator