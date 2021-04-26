local UIobject = require "engine.ui.uiparents.uiobject"
local Label = require "engine.ui.label"
local ResourceBar = require "engine.ui.resource_bar"
local Button = require "engine.ui.button"

local UI =
    Class {
    __includes = UIobject,
    init = function(self, drill)
        local font = love.graphics.newFont(fonts.bigPixelated.file, fonts.bigPixelated.size)
        local buttonPng = AssetManager:getImage('button')
        local UIPng = AssetManager:getImage('UI')
        UIobject.init(self, nil, {tag = "UI of mining state"})

        local ParametersUI = UIobject( self, { tag = "Parameters UI", width = 128, height = 64, background = UIPng } )
        self:registerObject( "Parameters", { up = 32, left = 624 }, ParametersUI )

        ParametersUI:registerObject(
            "goldCounter",
            {left = 5, up = 35},
            Label(
                ParametersUI,
                {
                    tag = "goldCounter",
                    text = "Money = " .. 0,
                    width = 100,
                    height = 50,
                    font = font,
                    align = 'left',
                    getText =
                        function()
                            local money = drill.gold > 100000 and math.floor(drill.gold / 1000) or math.floor(drill.gold)
                            return "Money = " .. (drill.gold > 0 and money or 0)..(drill.gold > 100000 and 'K' or '')
                        end,
                }
            )
        )
        ParametersUI:registerObject(
            "currentUpgrades",
            {left = -65, up = -40},
            Label(
                ParametersUI,
                {
                    tag = "currentUpgrades",
                    text = "Upgrades = " .. 0,
                    width = 100,
                    height = 16,
                    font = font,
                    align = 'left',
                    getText =
                        function()
                            return "Upgrades\n" .. ((drill.damage - 20)/2 > 0 and (drill.damage - 20)/2 or 0)
                        end,
                }
            )
        )
        ParametersUI:registerObject(
            "needForUpgrade",
            {left = 130, up = -40},
            Label(
                ParametersUI,
                {
                    tag = "needForUpgrade",
                    text = "Need for upgrade = " .. 0,
                    width = 100,
                    height = 16,
                    font = font,
                    align = 'left',
                    getText =
                        function()
                            return "Need for upgrade\n " .. (drill.damage * drill.upgradeKoef > 0 and drill.damage * drill.upgradeKoef or 0)
                        end,
                }
            )
        )
        ParametersUI:registerObject(
            "fuelBar",
            {left = 0, up = 0},
            ResourceBar(
                ParametersUI,
                {
                    tag = "Fuel",
                    max = drill.maxFuel,
                    color = {0, 1, 1},
                    bgColor = {1, 1, 1},
                    textColor = {0, 0, 0},
                    getValue = function()
                        return drill.fuel > 0 and drill.fuel or 0
                    end
                }
            )
        )
        ParametersUI:registerObject(
            "healthBar",
            {left = 0, up = 10},
            ResourceBar(
                ParametersUI,
                {
                    tag = "Health",
                    max = drill.maxHP,
                    color = {1, 0, 0},
                    bgColor = {1, 1, 1},
                    textColor = {0, 0, 0},
                    getValue = function()
                        return drill.HP > 0 and drill.HP or 0
                    end
                }
            )
        )
        ParametersUI:registerObject(
            "Speed Up button",
            { up = -48 },
            Button(
                ParametersUI,
                {
                    tag = "Upgrade", height = 64, background = buttonPng, font = font, align = 'center',
                    callback = function()
                        local upgradeCost = drill.damage * drill.upgradeKoef
                        if drill.gold <= upgradeCost then
                            drill.blocksInFrame = drill.blocksInFrame + (drill.blocksInFrame == drill.maxSpeed and 0 or drill.speedUpgrade)
                            drill.damage = drill.damage + drill.damageUpgrade
                            drill.gold = drill.gold - upgradeCost
                        end
                    end
                }
            )
        )

        -- local SpeedUi = UIobject( self, { tag = "Upgrade UI 1", width = 128, height = 64, background = UIPng } )
        -- self:registerObject( "Upgrade 1", {left = 496, up = -5}, SpeedUi )
        -- SpeedUi:registerObject(
        --     "Damage Up",
        --     { up = 32 },
        --     Button(
        --         SpeedUi,
        --         {
        --             tag = "Damage Up", height = 64, background = buttonPng, font = font,
        --             callback = function()
        --                 drill.damage = drill.damage + 5
        --             end
        --         }
        --     )
        -- )

        -- local damageUi = UIobject( self, { tag = "Upgrade UI 2", width = 128, height = 64, background = UIPng  } )
        -- self:registerObject( "Upgrade 2", {left = 752, up = 0}, damageUi )
        -- SpeedUi:registerObject(
        --     "Speed Up button",
        --     { up = 0 },
        --     Button(
        --         SpeedUi,
        --         {
        --             tag = "Speed Up", height = 64, background = buttonPng, font = font, align = 'center',
        --             callback = function()
        --                 drill.blocksInFrame = drill.blocksInFrame + 1
        --             end
        --         }
        --     )
        -- )
        -- SpeedUi:registerObject(
        --     "Damage Up",
        --     { up = 32 },
        --     Button(
        --         SpeedUi,
        --         {
        --             tag = "Damage Up", height = 64, background = buttonPng, font = font,
        --             callback = function()
        --                 drill.damage = drill.damage + 5
        --             end
        --         }
        --     )
        -- )

        -- local altitudeUI = UIobject( self, { tag = "Altitude UI", width = 64, height = 16,  } )
        -- self:registerObject( "Altitude", {left = 624, up = 64}, altitudeUI )
        ParametersUI:registerObject(
            "atitude",
            { up = 64 },
            Label(
                ParametersUI,
                {
                    tag = "atitude",
                    text = "Alt = " .. 0,
                    height = 16,
                    font = font,
                    getText = function() return "Alt = " .. (math.floor(drill.position.y)) end,
                }
            )
        )

    end
}

return UI
