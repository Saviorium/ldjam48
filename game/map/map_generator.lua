local Chunk = require "game.map.chunk"
local ChunkData = require "game.map.chunk_data"
local Voxel = require "game.map.voxel"

local MapGenerator = Class {
    init = function(self)
        self.oreGenerators = {} -- different with different parameters
        self.groundGenerator = nil -- generates layers of dirt
        self.chunkSize = config.map.chunkSize
    end
}

function MapGenerator:getChunk(chunkPosition, chunkDiff)
    if not chunkDiff then
        chunkDiff = ChunkData()
    end
    local chunk = Chunk(chunkDiff)
    for i = 1, self.chunkSize, 1 do
        for j = 1, self.chunkSize, 1 do
            local voxelLocalPos = Vector(i, j)
            if chunkDiff:getVoxel(voxelLocalPos) == nil then
                chunk:setVoxel(voxelLocalPos, self:generateVoxel(self:getGlobalVoxelCoords(chunkPosition, voxelLocalPos)))
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
    -- todo: go through generators to get resource by noise
    local resourceId = love.math.random(4)
    local quantity = love.math.random()
    return Voxel(Resources[resourceId], quantity)
end

return MapGenerator