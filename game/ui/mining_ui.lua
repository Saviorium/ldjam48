local UIobject = require "engine.ui.uiparents.uiobject"
local Label = require "engine.ui.label"
local ResourceBar = require "engine.ui.resource_bar"
local Button = require "engine.ui.button"

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
                    font = font,
                    getText = function() return "Gold = " .. (drill.gold > 0 and drill.gold or 0) end,
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
                    font = font,
                    getText = function() return "Fuel = " .. (drill.fuel > 0 and math.floor(drill.fuel) or 0) end,
                }
            )
        )
        self:getObjectByIndex("fuelCounter").entity:registerObject(
            "fuelBar",
            {left = 0, up = 15},
            ResourceBar(
                self:getObjectByIndex("fuelCounter").entity,
                {
                    tag = "fuelBar",
                    max = drill.maxFuel,
                    color = {0, 1, 1},
                    bgColor = {1, 1, 1},
                    getValue = function()
                        return drill.fuel > 0 and drill.fuel or 0
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
                    font = font,
                    getText = function() return "Health = " .. (drill.HP > 0 and drill.HP or 0) end,
                }
            )
        )

        self:getObjectByIndex("healthCounter").entity:registerObject(
            "healthBar",
            {left = 0, up = 15},
            ResourceBar(
                self:getObjectByIndex("healthCounter").entity,
                {
                    tag = "healthBar",
                    max = drill.maxHP,
                    color = {1, 0, 0},
                    bgColor = {1, 1, 1},
                    getValue = function()
                        return drill.HP > 0 and drill.HP or 0
                    end
                }
            )
        )
        local SpeedUi = UIobject( self, { tag = "Speed UI", width = 150, height = 165, } )
        self:registerObject( "Speed", {right = 200, up = 10}, SpeedUi )
        SpeedUi:registerObject(
            "blocksInFrame",
            { },
            Label(
                SpeedUi,
                {
                    tag = "blocksInFrame",
                    text = "BlocksInFrame = " .. 0,
                    height = 50,
                    font = font,
                    getText = function() return "BlocksInFrame = " .. (drill.blocksInFrame) end,
                }
            )
        )
        SpeedUi:registerObject(
            "last turn speed",
            { up = 50 },
            Label(
                SpeedUi,
                {
                    tag = "Last turn speed",
                    text = "Last turn speed = " .. 0,
                    height = 50,
                    font = font,
                    getText = function() return "Last turn speed \n" .. (math.floor(drill.blocksMoved or 0)) end,
                }
            )
        )
        SpeedUi:registerObject(
            "Speed Up button",
            { up = 115 },
            Button(
                SpeedUi,
                {
                    tag = "Speed Up button", height = 50,
                    callback = function()
                        drill.blocksInFrame = drill.blocksInFrame + 1
                    end
                }
            )
        )
        SpeedUi:registerObject(
            "Speed Down",
            { up = 165 },
            Button(
                SpeedUi,
                {
                    tag = "Speed Down button", height = 50,
                    callback = function()
                        drill.blocksInFrame = drill.blocksInFrame - 1
                    end
                }
            )
        )

        local damageUi = UIobject( self, { tag = "Damage UI", width = 150, height = 165,  } )
        self:registerObject( "Damage", {right = 200, up = 230}, damageUi )
        damageUi:registerObject(
            "damage",
            { },
            Label(
                damageUi,
                {
                    tag = "damage",
                    text = "Damage = " .. 0,
                    height = 50,
                    font = font,
                    getText = function() return "Damage = " .. (drill.damage) end,
                }
            )
        )
        damageUi:registerObject(
            "Damage Up",
            {up =55},
            Button(
                damageUi,
                {
                    tag = "Damage Up button", height = 50,
                    callback = function()
                        drill.damage = drill.damage + 5
                    end
                }
            )
        )
        damageUi:registerObject(
            "Damage Down",
            { up = 110 },
            Button(
                damageUi,
                {
                    tag = "Damage Down button", height = 50,
                    callback = function()
                        drill.damage = drill.damage - 5
                    end
                }
            )
        )

        local altitudeUI = UIobject( self, { tag = "Altitude UI", width = 100, height = 50,  } )
        self:registerObject( "Altitude", {right = 200, up = 400}, altitudeUI )
        altitudeUI:registerObject(
            "damage",
            { },
            Label(
                altitudeUI,
                {
                    tag = "atitude",
                    text = "Alt = " .. 0,
                    height = 50,
                    font = font,
                    getText = function() return "Alt = " .. (math.floor(drill.position.y)) end,
                }
            )
        )

    end
}

return UI
