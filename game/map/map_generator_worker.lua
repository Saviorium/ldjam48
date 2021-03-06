local Chunk = require "game.map.chunk"
local ChunkData = require "game.map.chunk_data"
local Resources = require "game.map.resources"

local ResourceGenerator = require "game.map.resource_generator"

local log = require 'engine.utils.logger' ("mapGenerator", function(msg) return "[MapGeneratorWorker]: " .. msg end)

local MapGeneratorWorker = Class {
    init = function(self, seed)
        self.seed = seed or love.timer.getTime()
        self.oreGenerators = {
            ResourceGenerator(Resources.getByName("air"), self.seed),
            ResourceGenerator(Resources.getByName("oil"), self.seed),
            ResourceGenerator(Resources.getByName("surface_dirt"), self.seed),
            ResourceGenerator(Resources.getByName("grass"), self.seed),
            ResourceGenerator(Resources.getByName("coal"), self.seed),
            ResourceGenerator(Resources.getByName("iron"), self.seed),
            ResourceGenerator(Resources.getByName("gold"), self.seed),
            ResourceGenerator(Resources.getByName("lava"), self.seed),
            ResourceGenerator(Resources.getByName("titan"), self.seed),
            ResourceGenerator(Resources.getByName("mythril"), self.seed),
            ResourceGenerator(Resources.getByName("diamond"), self.seed),
            ResourceGenerator(Resources.getByName("uranium"), self.seed),
            ResourceGenerator(Resources.getByName("granite"), self.seed),
            ResourceGenerator(Resources.getByName("stone_dark"), self.seed),
            ResourceGenerator(Resources.getByName("stone_gray"), self.seed),
            ResourceGenerator(Resources.getByName("limestone"), self.seed),
            ResourceGenerator(Resources.getByName("sandstone"), self.seed),
            ResourceGenerator(Resources.getByName("malachite"), self.seed),
            ResourceGenerator(Resources.getByName("dirt"), self.seed),
            ResourceGenerator(Resources.getByName("bedrock"), self.seed),
            ResourceGenerator(Resources.getByName("obsidian"), self.seed),
            ResourceGenerator(Resources.getByName("ash"), self.seed),
            ResourceGenerator(Resources.getByName("surface"), self.seed),
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
    for i = 0, self.chunkSize-1, 1 do
        for j = 0, self.chunkSize-1, 1 do
            local voxelLocalPos = Vector(i, j)
            local savedVoxel = chunkDiff:getVoxel(voxelLocalPos)
            if savedVoxel == nil then
                chunk:setVoxel(voxelLocalPos, self:generateVoxel(self:getGlobalVoxelCoords(chunkPosition, voxelLocalPos)))
            else
                chunk:setVoxel(voxelLocalPos, savedVoxel.resourceId, savedVoxel.health)
            end
        end
    end
    log(3, "Done generating " .. chunkPosition:__tostring())
    chunk:generateImageData()
    return chunk
end

function MapGeneratorWorker:getGlobalVoxelCoords(chunkPosition, voxelPosition)
    return chunkPosition * self.chunkSize + voxelPosition
end

function MapGeneratorWorker:generateVoxel(voxelGlobalPosition)
    local resource, value, colorId
    for _, generator in pairs(self.oreGenerators) do
        value = generator:getValue(voxelGlobalPosition)
        if value > 0 then
            resource = generator:getResource()
            if resource.colorGeneration then
                colorId = generator:getColor(voxelGlobalPosition)
            end
            break
        end
    end
    log(5, "Voxel generated: ", resource.id, value, colorId)
    return resource.id, value, colorId
end

return MapGeneratorWorker