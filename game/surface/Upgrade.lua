local Base =
    Class {
    init = function(self, position, image)
        self.image = image
        self.position = position
    end
}

function Base:update(dt)
    if self.image.update then
        self.image:update(dt)
    end
end

function Base:draw()
    if self.image.draw then
        self.image:draw()
    else
        love.graphics.draw(self.image, self.position.x, self.position.y)
    end
end

function Base:drawDebug()
end

return Base