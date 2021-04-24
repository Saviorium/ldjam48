local PlayerController = require "game.player.player_controller"

Drill =
    Class {
    init = function(self, x, y, image)
        self.speed = 10
        self.rotationSpeed = 0.1
        self.position = Vector(x,y)
        self.angle = 0
        self.image = image
        self.controller = PlayerController(self, UserInputManager)
    end
}

function Drill:update(dt)
    self:move(dt)
    self.controller:update(dt)
end

function Drill:draw()
    love.graphics.draw(self.image, self.position.x, self.position.y, self.angle, 1, 1, 4, 4)
    self:drawDebug()
end

function Drill:drawDebug()
    if Debug.drill > 0 then
        local x, y = self.position.x, self.position.y
        love.graphics.circle( 'line', x, y, 3)
        love.graphics.setColor(255, 0, 0)
        love.graphics.line(x, y, x + math.cos(self.angle) * 10, y + math.sin(self.angle) * 10)
        love.graphics.setColor(255, 255, 255)
    end
end

function Drill:move(dt)
    self.position = self.position + Vector(math.cos(self.angle), math.sin(self.angle)) * self.speed * dt
end

function Drill:turn( direction )
    self.angle = self.angle + self.rotationSpeed * direction
end

return Drill
