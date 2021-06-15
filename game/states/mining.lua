local World = require "game.world.world"

local MiningUI = require "game.ui.mining_ui"

local Mining = {}

function Mining:enter( prev_state, world )
    self.world = world and world or World()
    self.world:startDrilling()
    self.UI = MiningUI(self.world.drill)
end

function Mining:keypressed(key)
    self.world:keypressed(key)
end

function Mining:draw()
    self.UI:draw()
    self.world:draw()
end

function Mining:update(dt)
    self.UI:update(dt)
    self.world:update(dt)
end

function Mining:mousepressed(x, y)
    self.UI:mousepressed(x, y)
    self.world:mousepressed(x, y)
end

function Mining:mousereleased(x, y)
    self.UI:mousereleased(x, y)
    self.world:mousereleased(x, y)
end

function Mining:keypressed(key)
    self.UI:keypressed(key)
    self.world:keypressed(key)
end

return Mining