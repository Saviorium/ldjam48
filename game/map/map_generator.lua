local Chunk = require "game.map.chunk"

local controlChannel = love.thread.getChannel("mapGeneratorControl")
local outputChannel = love.thread.getChannel("mapGeneratorOutput")

local mapGeneratorThread = love.thread.newThread("game/map/map_generator_thread.lua")
mapGeneratorThread:start()

local log = require 'engine.utils.logger' ("mapGenerator")

local MapGenerator = Class { -- FIXME: do not instance it more than once
    init = function(self, seed)
        self.seed = seed or love.timer.getTime()
        self.generatedCache = {}
        self.chunkSize = config.map.chunkSize
    end
}

function MapGenerator:prepareChunk(chunkPosition, chunkDiff, priority)
    local state = self:getChunkState(chunkPosition)
    if state == "done" then
        return false
    end
    if state == "generating" then
        if priority ~= nil then
            self:setPriority(chunkPosition, priority)
        end
        return false
    end
    if chunkDiff then
        chunkDiff = chunkDiff:__serialize()
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

function MapGenerator:setPriority(chunkPosition, priority)
    controlChannel:push({
        command = "priority",
        priority = priority,
        chunkPosition = chunkPosition
    })
end

function MapGenerator:getChunk(chunkPosition, chunkDiff)
    local chunk = self:getChunkFromCache(chunkPosition)
    if not chunk then
        self:prepareChunk(chunkPosition, chunkDiff, 1)
        log(2, "Waiting for chunk " .. chunkPosition:__tostring())
        chunk = self:waitForChunk(chunkPosition)
        if not chunk then -- thread died, try to catch error from that thread
            local err = mapGeneratorThread:getError( )
            if err then
                error(err)
            else
                error("Got nil chunk from thread")
            end
        end
    end
    self:removeChunk(chunkPosition)
    chunk = Chunk.__deserialize(chunk)
    chunk:finalize()
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
    local timeStart = love.timer.getTime()
    while not chunk do
        self:getOneChunkFromWorker()
        chunk = self:getChunkFromCache(chunkCoords)
        if love.timer.getTime() - timeStart > 3 then
            log(1, "Chunk generator is dead. Exiting...")
            break
        end
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
            if math.abs(chunkPosition.x - i) > radius or math.abs(chunkPosition.y - j) > radius then
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
    -- chunk.chunk:destroy()
end

function MapGenerator:update(dt)
    self:getChunksFromWorker()
end

function MapGenerator:draw()
    self:debugDraw()
end

function MapGenerator:debugDraw()
    if not Debug or Debug.mapGeneratorDraw < 1 then
        return
    end
    local r = 10
    love.graphics.setLineWidth(0.1)
    for i, row in pairs(self.generatedCache) do
        for j, chunk in pairs(row) do
            love.graphics.push()
            love.graphics.translate(i * self.chunkSize, j * self.chunkSize)
            if chunk.state == "generating" then
                love.graphics.setColor(1,0.7,0)
            elseif chunk.state == "done" then
                love.graphics.setColor(0.2,0.9,0.3)
            end
            love.graphics.circle('fill', self.chunkSize/2, self.chunkSize/2, self.chunkSize/2-r)
            love.graphics.pop()
        end
    end
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(1)
end

return MapGenerator