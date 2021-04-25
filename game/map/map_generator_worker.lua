local Chunk = require "game.map.chunk"
local ChunkData = require "game.map.chunk_data"
local Voxel = require "game.map.voxel"

local ResourceGenerator = require "game.map.resource_generator"

local MapGeneratorWorker = Class {
    init = function(self, seed)
        self.seed = seed or love.timer.getTime()
        self.oreGenerators = {
            ResourceGenerator(Resources.getByName("iron"), self.seed),
            ResourceGenerator(Resources.getByName("gold"), self.seed),
            ResourceGenerator(Resources.getByName("stone"), self.seed),
            ResourceGenerator(Resources.getByName("dirt"), self.seed),
            ResourceGenerator(Resources.getByName("grass"), self.seed),
            ResourceGenerator(Resources.getByName("surface"), self.seed),
        }
        self.chunkSize = config.map.chunkSize
    end
}

function MapGeneratorWorker:generateChunk(chunkPosition, chunkDiff)
    chunkPosition = Vector(chunkPosition.x, chunkPosition.y)
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