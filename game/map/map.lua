local Map = Class {
    init = function(self)
        self.oreGenerators = {} -- different with different parameters
        self.groundGeneretor = nil -- generates layers of dirt
        self.chunkCache = {} -- generated chunks around player
        self.center = Vector(0, 0)
        self.renderSize = 500 -- pixels to draw around center
        self.canvas = nil
    end
}

function Map:setCenter(center)
    self.center = center
    -- find new chunks we need to render now
    -- generate new chunks
    -- find chunks to unload
    -- save unloaded chunks
end

function Map:getVoxel(position)
    -- return hardness of that voxel and resources
end

function Map:digVoxel(position)
    -- mark that voxel as dug out
    -- prepare to draw that pixel
end

function Map:update(dt)
    -- load/unload chunks here?
    -- or send/receive chunks to thread?
end

function Map:draw()
    -- set pixelated canvas
    -- draw chunkCache
    -- draw changes by player
end

return Map
