local UIobject = require "engine.ui.uiparents.uiobject"

-- Просто лейбл, для удобства выписывания всякого и для единообразности объектов в UI
local Label = Class {
    __includes = UIobject,
    init = function(self, parent, parameters)
        UIobject.init(self, parent, parameters)
        self.text = parameters.text
        self.getText = parameters.getText
        self.font = parameters.font
        self.align = parameters.align or 'center'
    end
}

function Label:render()
    if self.getText then
        self.text = self.getText()
    end
    if self.font then
        love.graphics.setFont(self.font)
    end
    love.graphics.printf(self.text, 0, 0, 128, self.align)
    if self.font then
        --love.graphics.setFont(love.graphics.newFont(12))
    end
end

function Label:setText(text)
    self.text = text
end


return Label