local ffi = require("ffi")
ffi.cdef[[
typedef struct { char resourceId; float health; char colorId; } voxel;
]]
local voxelSizeInBytes = ffi.sizeof(ffi.new("voxel"))

local ChunkData = Class { -- DTO
    init = function(self, other)
        if other then
            self.size = other.size
            self.voxelsData = other.voxelsData
        else
            self.size = { x = config.map.chunkSize, y = config.map.chunkSize }
            self.voxelsData = love.data.newByteData(self.size.x*self.size.y*voxelSizeInBytes)
        end
        self.voxels = ffi.cast("voxel*", self.voxelsData:getFFIPointer())
    end
}

function ChunkData:setVoxel(position, resourceId, health, colorId)
    if position.x < 0 or position.y < 0 or position.x >= self.size.x or position.y >= self.size.y then
        vardump(position, resourceId, health, colorId)
        error("Voxel is outside chunk")
    end
    local voxel = self.voxels[position.x * self.size.y + position.y]
    voxel.resourceId = resourceId
    voxel.health = health
    voxel.colorId = colorId or 1
end

function ChunkData:getVoxel(position)
    if position.x < 0 or position.y < 0 or position.x >= self.size.x or position.y >= self.size.y then
        vardump(position)
        error("Voxel is outside chunk")
    end
    if self.voxels[position.x * self.size.y + position.y].resourceId ~= 0 then
        return self.voxels[position.x * self.size.y + position.y]
    else
        return nil
    end
end

function ChunkData:iterateOverVoxels(func)
    for i = 0, self.size.x-1, 1 do
        for j = 0, self.size.y-1, 1 do
            local voxel = self:getVoxel(Vector(i, j))
            if voxel then
                func(i, j, voxel)
            end
        end
    end
end

function ChunkData:isEmpty()
    for i = 0, self.size.x-1, 1 do
        for j = 0, self.size.y-1, 1 do
            if self.voxels[i * self.size.y + j].resourceId ~= 0 then
                return false
            end
        end
    end
    return true
end

function ChunkData:getMerged(newData)
    local mergedData = ChunkData()
    self:iterateOverVoxels(
        function(x, y, voxel)
            mergedData:setVoxel(Vector(x, y), voxel.resourceId, voxel.health, voxel.colorId)
        end
    )
    newData:iterateOverVoxels(
        function(x, y, voxel)
            mergedData:setVoxel(Vector(x, y), voxel.resourceId, voxel.health, voxel.colorId)
        end
    )
    return mergedData
end

function ChunkData:__serialize()
    local serialized = ChunkData(self)
    serialized.voxels = nil
    return serialized
end

function ChunkData.__deserialize(data)
    return ChunkData(data)
end

return ChunkData
