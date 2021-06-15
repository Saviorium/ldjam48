local World = require "game.world.world"

local BaseUi = require "game.ui.base_ui"

local Base = {}

function Base:enter( prev_state, world )
    self.world = world and world or World()
    self.world:startDrilling()
    self.UI = BaseUi(self.world)
end

function Base:keypressed(key)
    self.world:keypressed(key)
end

function Base:draw()
    self.UI:draw()
    self.world:draw()
end

function Base:update(dt)
    self.UI:update(dt)
    self.world:update(dt)
end

function Base:mousepressed(x, y)
    self.UI:mousepressed(x, y)
    self.world:mousepressed(x, y)
end

function Base:mousereleased(x, y)
    self.UI:mousereleased(x, y)
    self.world:mousereleased(x, y)
end

function Base:keypressed(key)
    self.UI:keypressed(key)
    self.world:keypressed(key)
end

return Base