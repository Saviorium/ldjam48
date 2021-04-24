local GroundGenerator = Class {
    init = function(self)
    end
}

function GroundGenerator:getVoxel(x, y)
    return 1 -- generate with noise
end

function GroundGenerator:getChunkData(coordinates)
    return {}
end

return GroundGenerator