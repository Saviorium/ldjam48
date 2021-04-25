local PlayerController = require "game.player.player_controller"
local log = require "engine.utils.logger" ("drill")

local Base =
    Class {
    init = function(self, x, y, image)
        self.position = Vector(x,y)
        self.image = image
        self.width, self.height = 4, 4
    end
}

function Base:update(dt)
    if self.image.update then
        self.image:update(dt)
    else
end

function Base:draw()
    if self.image.draw then
        self.image:draw(self.position.x, self.position.y, self.angle, 1, 1, self.width, self.height)
    else
        love.graphics.draw(self.image, self.position.x, self.position.y, self.angle, 1, 1, self.width, self.height)
    end
end

function Base:drawDebug()
end

return Drill