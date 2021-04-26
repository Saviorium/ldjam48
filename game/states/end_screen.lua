local endScreen = {}

function endScreen:enter(prev_state, world)
    self.world = world
    self.highScore = self.world.drill.gold
    for i = self.world.drill.damage, 20 , -2 do
        self.highScore = self.highScore + i * self.world.drill.upgradeKoef
    end
    self.highScore = math.floor(self.highScore)
    self.font = love.graphics.newFont(fonts.bigPixelated.file, fonts.bigPixelated.size)
end

function endScreen:draw()
    self.world:draw()
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(self.font)
    love.graphics.printf("Your high score: "..self.highScore, love.graphics.getWidth()/2 - 500, love.graphics.getHeight()/2 - 120, 1000, 'center')
    love.graphics.setFont(love.graphics.newFont(12))
end

function endScreen:update(dt)
end

return endScreen