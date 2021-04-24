
local Mining = {}

function Mining:enter( lastState, world )
    self.world = world and world or World()
end

function Mining:keypressed(key)
    self.world:keypressed(key)
end

function Mining:draw()
    self.world:draw()
end

function Mining:update(dt)
    self.world:update(dt)
end

return Mining