local MiningUI = require "game.ui.mining_ui"

local World =
    Class {
    init = function(self)
        self.map = nil
        self.drill = Drill(100, 100, AssetManager:getImage("drill"))
        self.veiwScale = 4
        local font = love.graphics.newFont(fonts.bigPixelated.file, fonts.bigPixelated.size)
        self.UI = MiningUI(self.drill)
    end
}

function World:update(dt)
    self.UI:update(dt)
    self.drill:update(dt)
end

function World:draw()
    self.UI:draw()
	local cx,cy = love.graphics.getWidth()/(2*self.veiwScale), love.graphics.getHeight()/(2*self.veiwScale)
	love.graphics.push()
	love.graphics.scale(self.veiwScale)
	love.graphics.translate(cx,cy)
	love.graphics.translate(-self.drill.position.x, -self.drill.position.y)

    self.drill:draw()
    
	love.graphics.pop()

end

function World:keypressed(key)
end

return World
