local Voxel = Class {
    init = function(self, resource, health, colorId)
        self.resource = resource
        self.health = health
        self.colorId = colorId
    end
}

return Voxel
