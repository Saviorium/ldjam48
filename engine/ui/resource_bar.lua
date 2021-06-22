
local UIobject = require "engine.ui.uiparents.uiobject"

local ResourceBar =
Class {
    __includes = UIobject,
    init = function(self, parent, parameters)

        parameters.width = parameters.width or 20

        UIobject.init(self, parent, parameters)

        self.height = parent.width
        self.color = parameters.color
        self.bgColor = parameters.bgColor
        self.getMax = parameters.getMax
        self.max = self.getMax()
        self.getValue = parameters.getValue
        self.borders = parameters.borders or 3
        self.textColor = parameters.textColor or {1, 1, 1}
        self.particles = parameters.particles
    end
}

function ResourceBar:draw()

    local leftSpaceInPercents = (1 - (self.getValue() / self.max)) > 0 and (1 - (self.getValue() / self.max)) or 0
    local resultheight = self.height * leftSpaceInPercents
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.height , self.width)
    love.graphics.setColor(self.bgColor)
    local height = self.height - (resultheight > 0 and resultheight or 0)
    local realHeight = height > 0 and height or 0
    love.graphics.rectangle("fill", self.x + realHeight + self.borders, self.y + 3, resultheight > self.borders*2 and (resultheight - self.borders*2) or 0 , self.width - self.borders*2)
    love.graphics.setColor(self.textColor)
    love.graphics.printf(self.tag, self.x + 3, self.y-5, self.height, 'center')
    love.graphics.setColor(1, 1, 1)
    self.particles:draw(self.tag)
    self.max = self.getMax()

end

return ResourceBar
