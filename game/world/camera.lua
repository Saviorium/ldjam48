local Camera = Class {
    init = function(self, smoothness, prediction)
        self.smoothness = smoothness or 7
        self.prediction = prediction or 2
        self.position = Vector(0, 0)
    end
}

function Camera:setTarget(target)
    self.target = target
    self.position = self.target.position:clone()
    self.speed = Vector(0, 0)
end

function Camera:update(dt)
    if self.target then
        local predictedPosition = self.target.position + self.speed * self.prediction
        self.speed = (predictedPosition - self.position) / self.smoothness
        self.position = self.position + self.speed
    end
end

function Camera:applyTransform()
    love.graphics.translate(-self.position.x, -self.position.y)
end

return Camera