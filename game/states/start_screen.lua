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
    self.world:startDrilling()
    self.load = false
end


function startScreen:keypressed(key)
end

function startScreen:draw()

    love.graphics.draw(self.newspaper, 0, 0, 0, 1, 1)

    local x, y = love.graphics:getWidth()/2, love.graphics:getHeight()/2
    self.drill:draw(x - 150 , y - 225, math.pi/2, 8, 8, 8, 8)

end

function startScreen:update(dt)
    self.drill:update(dt)
    if not self.load then
        self.load = not self.load
    else
        self.world.map:setCenter(self.world.drill:getPosition())
    end
    local inputs = UserInputManager:getInputSnapshot()
    if inputs.action > 0 then
        love.graphics.setFont(self.defFont)
        StateManager.switch(states.mining, self.world)
    end
end

return startScreen