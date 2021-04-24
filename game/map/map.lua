local MapGenerator = require "game.map.map_generator"
local Voxel = require "game.map.voxel"

local log = require "engine.utils.logger"("map")

local Map = Class {
    init = function(self)
        self.mapGenerator = MapGenerator() -- generates layers of dirt
        self.chunkCache = {} -- generated chunks around player
        self.changedChunksData = {} -- only chunkDiffs
        self.centerChunk = nil
        self.chunkSize = config.map.chunkSize
        self.renderRadius = config.map.renderRadius
        self.unloadChunkRadius = config.map.renderRadius * config.map.renderRadius * 1.1
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
                local chunkDiff = self:getChunkChangedData(position)
                self.chunkCache[i][j] = self.mapGenerator:getChunk(position, chunkDiff)
                log(3, "Genrated new chunk at" .. i .. ", " .. j)
                log(5, self.chunkCache[i][j])
            end
        end
    end
    for i, row in pairs(self.chunkCache) do
        for j, chunk in pairs(row) do
            if math.abs(self.centerChunk.x - i) + math.abs(self.centerChunk.y - j) > self.unloadChunkRadius then
                self:unloadChunk(Vector(i, j))
            end
        end
    end
    -- for each chunk in cache check if it outside self.unloadChunkRadius and unload it
    -- merge new chunkDiff into saved
    -- save unloaded chunks
end

function Map:getVoxel(position)
    local chunk = self:getChunk(self:getChunkCoords(position))
    if not chunk then
        log(1, "Error: can't get voxel " .. position:__tostring() .. ", chunk is unloaded")
        return
    end
    return chunk:getVoxel(self:getLocalChunkCoords(position))
end

function Map:digVoxel(position)
    local chunk = self:getChunk(self:getChunkCoords(position))
    if not chunk then
        log(1, "Error: can't get voxel " .. position:__tostring() .. ", chunk is unloaded")
        return
    end
    local voxel = chunk:getVoxel(self:getLocalChunkCoords(position))
    local damageToVoxel = math.clamp(0, 1 - voxel.resource.density, 1)
    voxel.health = voxel.health - damageToVoxel
    if voxel.health <= 0 then
        chunk:changeVoxel(self:getLocalChunkCoords(position), Voxel(Resources.getByName("air"), 1))
    end
    return damageToVoxel * voxel.resource.cost
end

function Map:unloadChunk(chunkCoords)
    log(3, "Unloading chunk at " .. chunkCoords:__tostring())
    local chunk = self:getChunk(chunkCoords)
    if not chunk then
        return
    end
    self.chunkCache[chunkCoords.x][chunkCoords.y] = nil
    local newChunkDiff = chunk:save()
    local oldChunkDiff = self:getChunkChangedData(chunkCoords)
    if oldChunkDiff then
        newChunkDiff = oldChunkDiff:getMerged(newChunkDiff)
    end
    self:setChunkChangedData(chunkCoords, newChunkDiff)
    chunk:destroy()
end

function Map:getChunk(chunkCoords)
    if self.chunkCache[chunkCoords.x] and self.chunkCache[chunkCoords.x][chunkCoords.y] then
        return self.chunkCache[chunkCoords.x][chunkCoords.y]
    end
end

function Map:getChunkChangedData(chunkCoords)
    if self.changedChunksData[chunkCoords.x] and self.changedChunksData[chunkCoords.x][chunkCoords.y] then
        return self.changedChunksData[chunkCoords.x][chunkCoords.y]
    end
end

function Map:setChunkChangedData(chunkCoords, data)
    if data:isEmpty() then
        return
    end
    if not self.changedChunksData[chunkCoords.x] then
        self.changedChunksData[chunkCoords.x] = {}
    end
    self.changedChunksData[chunkCoords.x][chunkCoords.y] = data
    return data
end

function Map:getChunkCoords(worldVoxelCoords)
    local chunkPos = worldVoxelCoords / self.chunkSize
    return Vector(math.floor(chunkPos.x), math.floor(chunkPos.y))
end

function Map:getLocalChunkCoords(worldVoxelCoords)
    return Vector(math.floor(worldVoxelCoords.x % self.chunkSize + 1), math.floor(worldVoxelCoords.y % self.chunkSize + 1))
end

function Map:draw() -- pass world origin at (0, 0)
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

    self:debugDraw()
end

function Map:debugDraw()
    if not Debug or Debug.mapDraw < 1 then
        return
    end
    love.graphics.setColor(0,0,1)
    love.graphics.setLineWidth(0.1)
    for i = self.centerChunk.x - self.renderRadius, self.centerChunk.x + self.renderRadius, 1 do
        for j = self.centerChunk.y - self.renderRadius, self.centerChunk.y + self.renderRadius, 1 do
            love.graphics.push()
            love.graphics.translate(i * self.chunkSize, j * self.chunkSize)
            if self.chunkCache[i] and self.chunkCache[i][j] then
                love.graphics.rectangle('line', 0, 0, self.chunkSize, self.chunkSize)
            end
            love.graphics.pop()
        end
    end
    love.graphics.setColor(1,0,0)
    for i, row in pairs(self.changedChunksData) do
        for j, chunk in pairs(row) do
            love.graphics.push()
            love.graphics.translate(i * self.chunkSize, j * self.chunkSize)
            love.graphics.rectangle('line', 2, 2, self.chunkSize-4, self.chunkSize-4)
            love.graphics.pop()
        end
    end
    love.graphics.setColor(1,0.5,0)
    for i, row in pairs(self.chunkCache) do
        for j, chunk in pairs(row) do
            love.graphics.push()
            love.graphics.translate(i * self.chunkSize, j * self.chunkSize)
            love.graphics.rectangle('line', 1, 1, self.chunkSize-2, self.chunkSize-2)
            love.graphics.pop()
        end
    end
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(1)
end


return Map
