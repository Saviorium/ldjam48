local ChunkData = require "game.map.chunk_data"
local Resources = require "game.map.resources"

local log = require "engine.utils.logger"("chunk")

local Chunk = Class {
    init = function(self)
        self.imageData = nil
        self.image = nil
        self.data = ChunkData()
        self.chunkSize = config.map.chunkSize
        self.changed = ChunkData() -- only changed voxels
        self.finalized = false
    end
}

function Chunk:setVoxel(position, resourceId, health, colorId)
    self.data:setVoxel(position, resourceId, health, colorId)
end

function Chunk:changeVoxel(position, resourceId, health, colorId)
    self.changed:setVoxel(position, resourceId, health, colorId)
end

function Chunk:__serialize()
    self.data = self.data:__serialize()
    self.changed = self.changed:__serialize()
    return self
end

function Chunk.__deserialize(chunkSerialized)
    log(4, "Chunk finalized")
    log(5, chunkSerialized)
    local chunk = Chunk()
    chunk.imageData = chunkSerialized.imageData
    chunk.data = ChunkData.__deserialize(chunkSerialized.data)
    chunk.chunkSize = chunkSerialized.chunkSize
    chunk.changed = ChunkData.__deserialize(chunkSerialized.changed)
    chunk.finalized = chunkSerialized.finalized
    if chunk.finalized == true then
        vardump(chunk)
        error("trying to double finalize chunk")
    end
    return chunk
end

function Chunk:finalize()
    self.image = self:generateImage()
    self.finalized = true
end

function Chunk:save()
    return self.changed
end

function Chunk:getVoxel(position)
    return self.changed:getVoxel(position) or self.data:getVoxel(position)
end

function Chunk:generateImageData()
    log(4, "start generating imageData".. love.timer.getTime( ))
    local imageData = love.image.newImageData(self.chunkSize, self.chunkSize)
    for i = 0, self.chunkSize-1, 1 do
        for j = 0, self.chunkSize-1, 1 do
            local voxelLocalPos = Vector(i, j)
            local voxel = self:getVoxel(voxelLocalPos)
            local resource = Resources[voxel.resourceId]
            local color = resource.color or resource.colorGeneration.colors[voxel.colorId]
            imageData:setPixel(i, j, color)
        end
    end
    log(4, "finish generating imageData".. love.timer.getTime( ))
    self.imageData = imageData
    return imageData
end


function Chunk:generateImage()
    log(4, "start generating image".. love.timer.getTime( ))
    local image = love.graphics.newImage(self.imageData)
    image:setFilter("nearest", "nearest")
    log(4, "finish generating image".. love.timer.getTime( ))
    return image
end

function Chunk:destroy()
    self.image:release()
end

function Chunk:draw()
    if not self.finalized then
        print("Ignored attempt to draw not finalized chunk")
        return
    end
    love.graphics.draw(self.image)
    self.changed:iterateOverVoxels(
        function(x, y, voxel)
            local resource = Resources[voxel.resourceId]
            love.graphics.setColor(resource.color)
            love.graphics.rectangle('fill', x-1, y-1, 1, 1)
        end
    )
    love.graphics.setColor(1,1,1)

    self:debugDraw()
end

function Chunk:debugDraw()
    if not Debug or not (Debug.chunkDraw > 0) then
        return
    end
    love.graphics.setColor(0,0,1)
    love.graphics.setLineWidth(0.1)
    love.graphics.rectangle('line', 0, 0, self.chunkSize, self.chunkSize)
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(1)
end

return Chunk
