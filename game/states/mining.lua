local World = require "game.world.world"


local Mining = {}

function Mining:enter( prev_state, world )
    self.world = world and world or World()
    self.world:startDrilling()
end

function Mining:draw()
    self.world:draw()
end

function Mining:update(dt)
    self.world:update(dt)
end

function Mining:mousepressed(x, y)
    self.world:mousepressed(x, y)
end

function Mining:mousereleased(x, y)
    self.world:mousereleased(x, y)
end

function Mining:keypressed(key)
    self.world:keypressed(key)
end

return Mining