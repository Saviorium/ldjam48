local World =
    Class {
    init = function(self)
        self.map = nil
        self.drill = Drill(100, 100)
    end
}

function World:update(dt)
    self.drill:update(dt)
end

function World:draw()
    self.drill:draw()
end

function World:keypressed(key)
end

return World
