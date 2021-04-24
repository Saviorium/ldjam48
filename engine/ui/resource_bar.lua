
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
        self.max = parameters.max
        self.getValue = parameters.getValue
    end
}

function ResourceBar:draw()

    local leftSpaceInPercents = 1 - (self.getValue() / self.max)
    local resultheight = self.height * leftSpaceInPercents
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.height , self.width)
    love.graphics.setColor(self.bgColor)
    love.graphics.rectangle("fill", self.x + (self.height - (resultheight > 0 and resultheight - 4 or 0)), self.y + 3, resultheight > 0 and resultheight - 2 or 0 , self.width - 6)
    love.graphics.setColor(1, 1, 1)

end

return ResourceBar
