local Chunk = require "game.map.chunk"
local ChunkData = require "game.map.chunk_data"
local Voxel = require "game.map.voxel"

local ResourceGenerator = require "game.map.resource_generator"

local MapGenerator = Class {
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

function MapGenerator:getChunk(chunkPosition, chunkDiff)
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
                chunk:setVoxel(voxelLocalPos, chunkDiff:getVoxel(voxelLocalPos))
            end
        end
    end
    chunk:finalize()
    return chunk
end

function MapGenerator:getGlobalVoxelCoords(chunkPosition, voxelPosition)
    return chunkPosition * self.chunkSize + voxelPosition
end

function MapGenerator:generateVoxel(voxelGlobalPosition)
    local resource, value
    for _, generator in pairs(self.oreGenerators) do
        value = generator:getValue(voxelGlobalPosition)
        if value > 0 then
            resource = generator:getResource()
            break
        end
    end
    return Voxel(resource, value)
end

return MapGenerator