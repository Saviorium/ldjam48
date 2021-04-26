local startScreen = {}

function startScreen:enter()
    self.drill = AssetManager:getAnimation("drill")
end

function startScreen:mousepressed(x, y)
end

function startScreen:mousereleased(x, y)
end

function startScreen:keypressed(key)
    if key == 'space' then
        StateManager.switch(states.mining)
    end
end

function startScreen:draw()
    self.drill:draw()
end

function startScreen:update(dt)
end

return startScreen