local ChunkData = require "game.map.chunk_data"

local log = require "engine.utils.logger"("chunk")

local Chunk = Class {
    init = function(self)
        self.image = nil
        self.data = ChunkData()
        self.chunkSize = config.map.chunkSize
        self.changed = ChunkData() -- only changed voxels
        self.finalized = false
    end
}

function Chunk:setVoxel(position, voxel)
    self.data:setVoxel(position, voxel)
end

function Chunk:changeVoxel(position, voxel)
    self.changed:setVoxel(position, voxel)
end

function Chunk:finalize()
    log(4, "Chunk finalized")
    log(5, self)
    if self.finalized == true then
        vardump(self)
        error("trying to double finalize chunk")
    end
    self.image = self:generateImage()
    self.finalized = true
end

function Chunk:save()
    return self.changed
end

function Chunk:getVoxel(position)
    return self.changed:getVoxel(position) or self.data:getVoxel(position)
end

function Chunk:generateImage()
    local imageData = love.image.newImageData(self.chunkSize, self.chunkSize)
    for i = 1, self.chunkSize, 1 do
        for j = 1, self.chunkSize, 1 do
            local voxelLocalPos = Vector(i, j)
            local voxel = self:getVoxel(voxelLocalPos)
            imageData:setPixel(i-1, j-1, voxel.resource.color)
        end
    end
    local image = love.graphics.newImage(imageData)
    image:setFilter("nearest", "nearest")
    return image
end

function Chunk:update(dt)
    -- load/unload chunks here?
    -- or send/receive chunks to thread?
end

function Chunk:draw()
    if not self.finalized then
        print("Ignored attempt to draw not finalized chunk")
        return
    end
    love.graphics.draw(self.image)
end

return Chunk
