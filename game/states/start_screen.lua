local World = require "game.world.world"

local startScreen = {}

function startScreen:enter()
    local font = love.graphics.newFont(fonts.bigPixelated.file, fonts.bigPixelated.size)
    self.defFont = love.graphics.newFont(12)
    love.graphics.setFont(font)
    self.drill = AssetManager:getAnimation("drill")
    self.drill:setTag('dig')
    self.drill:play()
    self.newspaper = AssetManager:getImage("newspaper_full")
    self.world = World()
end

function startScreen:mousepressed(x, y)
end

function startScreen:mousereleased(x, y)
end

function startScreen:keypressed(key)
    if key == 'space' then
        love.graphics.setFont(self.defFont)
        StateManager.switch(states.mining, self.world)
    end
end

function startScreen:draw()

    love.graphics.draw(self.newspaper, 0, 0, 0, 1, 1)

    local x, y = love.graphics:getWidth()/2, love.graphics:getHeight()/2
    self.drill:draw(x - 150 , y - 225, math.pi/2, 8, 8, 4, 4)

end

function startScreen:update(dt)
    self.drill:update(dt)
end

return startScreen