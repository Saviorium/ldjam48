local Base =
    Class {
    init = function(self, position)
        self.image = AssetManager:getImage('base')
        self.position = position
    end
}

function Base:update(dt)
end

function Base:draw()
    love.graphics.setColor(1, 1, 1)
    if self.image.draw then
        self.image:draw(0, 0, self.angle, 1, 1, self.image:getWidth(), self.image:getHeight())
    else
        love.graphics.draw(self.image, 0, 0, self.angle, 1, 1, self.image:getWidth()/2, self.image:getHeight())
    end
end

function Base:drawDebug()
end

return Base