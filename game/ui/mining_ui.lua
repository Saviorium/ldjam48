local UIobject = require "engine.ui.uiparents.uiobject"
local Label = require "engine.ui.label"
local ResourceBar = require "engine.ui.resource_bar"

local UI =
    Class {
    __includes = UIobject,
    init = function(self, drill)
        local font = love.graphics.newFont(fonts.bigPixelated.file, fonts.bigPixelated.size)

        UIobject.init(self, nil, {tag = "UI of mining state"})
        self:registerObject(
            "goldCounter",
            {left = 10, up = 10},
            Label(
                self,
                {
                    tag = "goldCounter",
                    text = "Gold = " .. 0,
                    width = 100,
                    height = 50,
                    font = font
                }
            )
        )
        self:registerObject(
            "fuelCounter",
            {left = 10, up = 60},
            Label(
                self,
                {
                    tag = "fuelCounter",
                    text = "Fuel = " .. 0,
                    width = 100,
                    height = 50,
                    font = font
                }
            )
        )
        self:getObjectByIndex("fuelCounter").entity:registerObject(
            "fuelBar",
            {left = 0, up = 10},
            ResourceBar(
                self:getObjectByIndex("fuelCounter").entity,
                {
                    tag = "fuelBar",
                    max = drill.maxFuel,
                    color = {0, 1, 1},
                    bgColor = {1, 1, 1},
                    getValue = function()
                        return drill.fuel or 0
                    end
                }
            )
        )
        self:registerObject(
            "healthCounter",
            {left = 10, up = 120},
            Label(
                self,
                {
                    tag = "healthCounter",
                    text = "Health = " .. 0,
                    width = 100,
                    height = 50,
                    font = font
                }
            )
        )

        self:getObjectByIndex("healthCounter").entity:registerObject(
            "healthBar",
            {left = 0, up = 10},
            ResourceBar(
                self:getObjectByIndex("healthCounter").entity,
                {
                    tag = "healthBar",
                    max = drill.maxHP,
                    color = {1, 0, 0},
                    bgColor = {1, 1, 1},
                    getValue = function()
                        return drill.HP or 0
                    end
                }
            )
        )
    end
}

return UI
