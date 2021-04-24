local Chunk = require "game.map.chunk"
local ChunkData = require "game.map.chunk_data"
local Voxel = require "game.map.voxel"

local OreGenerator = require "game.map.ore_generator"
local GroundGenerator = require "game.map.ground_generator"

local MapGenerator = Class {
    init = function(self, seed)
        self.seed = seed or love.timer.getTime()
        self.oreGenerators = {
            iron = OreGenerator(Resources.getByName("iron"), self.seed),
            gold = OreGenerator(Resources.getByName("gold"), self.seed),
        } -- different with different parameters
        self.groundGenerator = GroundGenerator() -- generates layers of dirt
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
    local resource, value
    for resourceName, generator in pairs(self.oreGenerators) do
        value = generator:getValue(voxelGlobalPosition)
        if value > 0 then
            resource = Resources.getByName(resourceName)
            break
        end
    end
    if not resource then
        value = self.groundGenerator:getValue(voxelGlobalPosition)
        resource = Resources.getByName(self.groundGenerator:getResource(voxelGlobalPosition))
    end
    return Voxel(resource, value)
end

return MapGenerator