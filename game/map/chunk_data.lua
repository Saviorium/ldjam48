local ChunkData = Class { -- DTO
    init = function(self)
        self.voxels = {} -- [x][y] = Voxel()
    end
}

function ChunkData:setVoxel(position, voxel)
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

return ChunkData
