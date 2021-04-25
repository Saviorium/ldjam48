local Chunk = require "game.map.chunk"
local ChunkData = require "game.map.chunk_data"
local Voxel = require "game.map.voxel"

local ResourceGenerator = require "game.map.resource_generator"

local log = require 'engine.utils.logger' ("mapGenerator", function(msg) return "[MapGeneratorWorker]: " .. msg end)

local MapGeneratorWorker = Class {
    init = function(self, seed)
        self.seed = seed or love.timer.getTime()
        self.oreGenerators = {
            ResourceGenerator(Resources.getByName("air"), self.seed),
            ResourceGenerator(Resources.getByName("oil"), self.seed),
            ResourceGenerator(Resources.getByName("iron"), self.seed),
            ResourceGenerator(Resources.getByName("gold"), self.seed),
            ResourceGenerator(Resources.getByName("titan"), self.seed),
            ResourceGenerator(Resources.getByName("malachite"), self.seed),
            ResourceGenerator(Resources.getByName("mythril"), self.seed),
            ResourceGenerator(Resources.getByName("diamond"), self.seed),
            ResourceGenerator(Resources.getByName("stone_gray"), self.seed),
            ResourceGenerator(Resources.getByName("limestone"), self.seed),
            ResourceGenerator(Resources.getByName("sandstone"), self.seed),
            ResourceGenerator(Resources.getByName("dirt_light"), self.seed),
            ResourceGenerator(Resources.getByName("dirt_dark"), self.seed),
            ResourceGenerator(Resources.getByName("dirt"), self.seed),
            ResourceGenerator(Resources.getByName("lava1"), self.seed),
            ResourceGenerator(Resources.getByName("lava2"), self.seed),
            ResourceGenerator(Resources.getByName("lava3"), self.seed),
            ResourceGenerator(Resources.getByName("granite1"), self.seed),
            ResourceGenerator(Resources.getByName("granite2"), self.seed),
            ResourceGenerator(Resources.getByName("granite3"), self.seed),
            ResourceGenerator(Resources.getByName("grass"), self.seed),
            ResourceGenerator(Resources.getByName("surface"), self.seed),
            ResourceGenerator(Resources.getByName("air_fill"), self.seed),
        }
        self.chunkSize = config.map.chunkSize
    end
}

function MapGeneratorWorker:generateChunk(chunkPosition, chunkDiff)
    chunkPosition = Vector(chunkPosition.x, chunkPosition.y)
    log(3, "Generating " .. chunkPosition:__tostring())
    chunkDiff = ChunkData.__deserialize(chunkDiff)

    if not chunkDiff then
        chunkDiff = ChunkData()
    end
    local chunk = Chunk()
    for i = 1, self.chunkSize, 1 do
        for j = 1, self.chunkSize, 1 do
            local voxelLocalPos = Vector(i, j)
            local savedVoxel = chunkDiff:getVoxel(voxelLocalPos)
            if savedVoxel == nil then
                chunk:setVoxel(voxelLocalPos, self:generateVoxel(self:getGlobalVoxelCoords(chunkPosition, voxelLocalPos)))
            else
                chunk:setVoxel(voxelLocalPos, Voxel(savedVoxel.resource.id, savedVoxel.health))
            end
        end
    end
    log(3, "Done generating " .. chunkPosition:__tostring())
    return chunk
end

function MapGeneratorWorker:getGlobalVoxelCoords(chunkPosition, voxelPosition)
    return chunkPosition * self.chunkSize + voxelPosition
end

function MapGeneratorWorker:generateVoxel(voxelGlobalPosition)
    local resource, value
    for _, generator in pairs(self.oreGenerators) do
        value = generator:getValue(voxelGlobalPosition)
        if value > 0 then
            resource = generator:getResource()
            break
        end
    end
    return Voxel(resource.id, value)
end

return MapGeneratorWorker