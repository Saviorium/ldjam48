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
        self.loadRadius = config.map.loadChunksRadius
        self.unloadRadius = config.map.unloadChunksRadius
    end
}

function Map:setCenter(center)
    local newCenter = self:getChunkCoords(center)
    if self.centerChunk == newCenter then
        return
    end
    self.centerChunk = newCenter
    log(3, "Set center to", self.centerChunk)
    for i = 0, self.renderRadius, 1 do
        self:loopAroundCoords(self.centerChunk, i,
            function(position, args)
                if not self.chunkCache[position.x] then
                    self.chunkCache[position.x] = {}
                end
                if not self.chunkCache[position.x][position.y] then
                    local chunkDiff = self:getChunkChangedData(position)
                    self.chunkCache[position.x][position.y] = self.mapGenerator:getChunk(position, chunkDiff)
                end
            end
        )
    end
    for i = self.renderRadius, self.loadRadius, 1 do
        self:loopAroundCoords(self.centerChunk, i,
            function(position, args)
                if not self.chunkCache[position.x] then
                    self.chunkCache[position.x] = {}
                end
                if not self.chunkCache[position.x][position.y] then
                    local chunkDiff = self:getChunkChangedData(position)
                    self.mapGenerator:prepareChunk(position, chunkDiff)
                end
            end
        )
    end
    self.mapGenerator:cleanOutsideRadius(self.centerChunk, self.unloadRadius)
    for i, row in pairs(self.chunkCache) do
        for j, chunk in pairs(row) do
            if math.abs(self.centerChunk.x - i) > self.unloadRadius or math.abs(self.centerChunk.y - j) > self.unloadRadius then
                self:unloadChunk(Vector(i, j))
            end
        end
    end
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
    print(voxel.damage)
    local HP = voxel.health
    local dens = voxel.resource.density

    voxel.health = HP - damageToVoxel
    if voxel.health <= 0 and voxel.resource.density > 0 then
        chunk:changeVoxel(self:getLocalChunkCoords(position), Voxel(Resources.getByName("air"), 1))
    end
    local result = {damage = damageToVoxel, health = HP, density = dens, money = damageToVoxel * voxel.resource.cost, damageToDrill = 0}
    return result
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

function Map:loopAroundCoords(position, radius, func, args)
    if radius == 0 then
        func(position, args)
    end
    local currentPos = position:clone()
    currentPos.y = position.y + radius
    for i = position.x - radius, position.x + radius - 1, 1 do -- down ->
        currentPos.x = i
        func(currentPos, args)
    end
    currentPos.x = position.x + radius
    for i = position.y + radius, position.y - (radius - 1), -1 do -- right ^
        currentPos.y = i
        func(currentPos, args)
    end
    currentPos.x = position.x - radius
    for i = position.y + radius - 1, position.y - (radius - 1), -1 do -- left ^
        currentPos.y = i
        func(currentPos, args)
    end
    currentPos.y = position.y - radius
    for i = position.x - radius, position.x + radius, 1 do -- up ->
        currentPos.x = i
        func(currentPos, args)
    end
end

function Map:update(dt)
    self.mapGenerator:update(dt)
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
    self.mapGenerator:draw()
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
