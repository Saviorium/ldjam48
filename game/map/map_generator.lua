local Chunk = require "game.map.chunk"

local controlChannel = love.thread.getChannel("mapGeneratorControl")
local outputChannel = love.thread.getChannel("mapGeneratorOutput")

local mapGeneratorThread = love.thread.newThread("game/map/map_generator_thread.lua")
mapGeneratorThread:start()

local MapGenerator = Class { -- FIXME: do not instance it more than once
    init = function(self, seed)
        self.seed = seed or love.timer.getTime()
        self.generatedCache = {}
    end
}

function MapGenerator:prepareChunk(chunkPosition, chunkDiff, priority)
    local state = self:getChunkState(chunkPosition)
    if state == "generating" or state == "done" then
        return false
    end
    controlChannel:push({
        command = "generate",
        priority = priority,
        chunkPosition = chunkPosition,
        chunkDiff = chunkDiff
    })
    self:setChunkState(chunkPosition, "generating")
    return true
end

function MapGenerator:getChunk(chunkPosition, chunkDiff)
    local chunk = self:getChunkFromCache(chunkPosition)
    if not chunk then
        self:prepareChunk(chunkPosition, chunkDiff, 1)
        chunk = self:waitForChunk(chunkPosition)
    end
    self:removeChunk(chunkPosition)
    chunk = Chunk.__deserialize(chunk)
    return chunk
end

function MapGenerator:getChunkFromCache(chunkCoords)
    if self:getChunkState(chunkCoords) == "done" then
        return self.generatedCache[chunkCoords.x][chunkCoords.y].chunk
    end
end

function MapGenerator:setChunkState(chunkPosition, state)
    if not self.generatedCache[chunkPosition.x] then
        self.generatedCache[chunkPosition.x] = {}
    end
    if not self.generatedCache[chunkPosition.x][chunkPosition.y] then
        self.generatedCache[chunkPosition.x][chunkPosition.y] = {}
    end
    self.generatedCache[chunkPosition.x][chunkPosition.y].state = state
end

function MapGenerator:getChunkState(chunkCoords)
    if self.generatedCache[chunkCoords.x] and self.generatedCache[chunkCoords.x][chunkCoords.y] then
        return self.generatedCache[chunkCoords.x][chunkCoords.y].state
    end
    return "none"
end

function MapGenerator:waitForChunk(chunkCoords)
    local chunk
    while not chunk do
        self:getOneChunkFromWorker()
        chunk = self:getChunkFromCache(chunkCoords)
    end
    return chunk
end

function MapGenerator:getOneChunkFromWorker()
    if outputChannel:peek() then
        local channelMessage = outputChannel:pop()
        if channelMessage.type == "chunk" then
            self:saveChunk(channelMessage.data.position, channelMessage.data.chunk)
        end
    end
end

function MapGenerator:getChunksFromWorker()
    while outputChannel:peek() do
        local channelMessage = outputChannel:pop()
        if channelMessage.type == "chunk" then
            self:saveChunk(channelMessage.data.position, channelMessage.data.chunk)
        end
    end
end

function MapGenerator:cleanOutsideRadius(chunkPosition, radius)
    for i, row in pairs(self.generatedCache) do
        for j, chunk in pairs(row) do
            if math.abs(self.centerChunk.x - i) > radius or math.abs(self.centerChunk.y - j) > radius then
                self:destroyChunk(Vector(i, j))
            end
        end
    end
end

function MapGenerator:saveChunk(chunkPosition, chunk)
    if not self.generatedCache[chunkPosition.x] then
        self.generatedCache[chunkPosition.x] = {}
    end
    if not self.generatedCache[chunkPosition.x][chunkPosition.y] then
        self.generatedCache[chunkPosition.x][chunkPosition.y] = {}
    end
    self.generatedCache[chunkPosition.x][chunkPosition.y].chunk = chunk
    self:setChunkState(chunkPosition, "done")
end

function MapGenerator:removeChunk(chunkPosition)
    if self.generatedCache[chunkPosition.x] and self.generatedCache[chunkPosition.x][chunkPosition.y] then
        local chunk = self.generatedCache[chunkPosition.x][chunkPosition.y]
        self.generatedCache[chunkPosition.x][chunkPosition.y] = nil
        return chunk
    end
end

function MapGenerator:destroyChunk(chunkPosition)
    local chunk = self:removeChunk(chunkPosition)
    chunk:destroy()
end

function MapGenerator:update(dt)
    self:getOneChunkFromWorker()
end

return MapGenerator