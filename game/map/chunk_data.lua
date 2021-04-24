local ChunkData = Class { -- DTO
    init = function(self)
        self.voxels = {} -- [x][y] = Voxel()
    end
}

function ChunkData:setVoxel(position, voxel)
    if Debug and Debug.chunk > 2 then
        if position.x < 0 or position.y < 0 or position.x > config.map.chunkSize or position.y > config.map.chunkSize then
            print("Voxel is outside chunk")
            vardump(position, voxel)
        end
    end
    if not self.voxels[position.x] then
        self.voxels[position.x] = {}
    end
    self.voxels[position.x][position.y] = voxel
end

function ChunkData:getVoxel(position)
    if self.voxels[position.x] and self.voxels[position.x][position.y] then
        return self.voxels[position.x][position.y]
    else
        return nil
    end
end

function ChunkData:iterateOverVoxels(func)
    for i, row in pairs(self.voxels) do
        for j, voxel in pairs(row) do
            func(i, j, voxel)
        end
    end
end

return ChunkData
