local UIobject = require "engine.ui.uiparents.uiobject"
local Label = require "engine.ui.label"

Button = Class {
    __includes = UIobject,
    init = function(self, parent, parameters)
        UIobject.init(self, parent, parameters)
        self.clickInteraction['click'] =
        {
            condition = function (object, x, y)
                            return object:getCollision(x, y)
                        end,
            func =  parameters.callback
        }
        self:registerObject('Label',
                               { up = self.height/4 },
                               Label(self, {
                                            align = parameters.align,
                                            font = parameters.font,
                                             tag = self.tag..' Label',
                                             text = self.tag,
                                             width = self.width*0.8,
                                             height = self.height*0.8
                                           }
                                    )
                            )
    end
}

return Button