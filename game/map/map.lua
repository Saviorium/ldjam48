local MapGenerator = require "game.map.map_generator"

local log = require "engine.utils.logger"("map")

local Map = Class {
    init = function(self)
        self.mapGenerator = MapGenerator() -- generates layers of dirt
        self.chunkCache = {} -- generated chunks around player
        self.changedChunks = {} -- only chunkDiffs
        self.centerChunk = nil
        self.chunkSize = config.map.chunkSize
        self.renderRadius = config.map.renderRadius
        self.unloadChunkRadius = config.map.unloadChunksRadius
    end
}

function Map:setCenter(center)
    local newCenter = self:getChunkCoords(center)
    if self.centerChunk == newCenter then
        return
    end
    self.centerChunk = newCenter
    log(3, "Set center to", self.centerChunk)
    for i = self.centerChunk.x - self.renderRadius, self.centerChunk.x + self.renderRadius, 1 do
        for j = self.centerChunk.y - self.renderRadius, self.centerChunk.y + self.renderRadius, 1 do -- square of size self.renderRadius*2+1 around center
            local position = Vector(i, j)
            if not self.chunkCache[i] then
                self.chunkCache[i] = {}
            end
            if not self.chunkCache[i][j] then
                local chunkDiff = self:getChangedChunk(position)
                self.chunkCache[i][j] = self.mapGenerator:getChunk(position, chunkDiff)
                log(3, "Genrated new chunk at" .. i .. ", " .. j)
                log(5, self.chunkCache[i][j])
            end
        end
    end
    -- for each chunk in cache check if it outside self.unloadChunkRadius and unload it
    -- save unloaded chunks
end

function Map:getVoxel(position)
    return love.math.random()
end

function Map:digVoxel(position)
    -- mark that voxel as dug out
    -- prepare to draw that pixel
end

function Map:getChangedChunk(chunkCoords)
    if self.changedChunks[chunkCoords.x] and self.changedChunks[chunkCoords.x][chunkCoords.y] then
        return self.changedChunks[chunkCoords.x][chunkCoords.y]
    end
end

function Map:getChunkCoords(worldVoxelCoords)
    local chunkPos = worldVoxelCoords / self.chunkSize
    return Vector(math.floor(chunkPos.x), math.floor(chunkPos.y))
end

function Map:update(dt)
    -- load/unload chunks here?
    -- or send/receive chunks to thread?
end

function Map:draw() -- pass world origin at (0, 0)
    love.graphics.push()
    for i = self.centerChunk.x - self.renderRadius, self.centerChunk.x + self.renderRadius, 1 do
        for j = self.centerChunk.y - self.renderRadius, self.centerChunk.y + self.renderRadius, 1 do
            love.graphics.push()
            love.graphics.translate(i * self.chunkSize, j * self.chunkSize)
            if self.chunkCache[i] and self.chunkCache[i][j] then
                self.chunkCache[i][j]:draw()
            end
            love.graphics.pop()
        end
    end
    love.graphics.pop()
end

return Map
