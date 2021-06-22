local UIobject = require "engine.ui.uiparents.uiobject"
local Label = require "engine.ui.label"
local ResourceBar = require "engine.ui.resource_bar"
local Button = require "engine.ui.button"

local ParticleSystem = require "game.particle_system.particle_system"
local ParticleTypes = require "game.ui.ui_particles"

local UI =
    Class {
    __includes = UIobject,
    init = function(self, drill)
        local font = love.graphics.newFont(fonts.bigPixelated.file, fonts.bigPixelated.size)
        local UIPng = AssetManager:getImage('UI')

        self.particles = ParticleSystem(ParticleTypes)

        UIobject.init(self, nil, {tag = "UI of mining state"})

        local ParametersUI = UIobject( self, { tag = "Parameters UI", width = 128, height = 64, background = UIPng } )
        self:registerObject( "Parameters", { up = 0, left = 624 }, ParametersUI )

        ParametersUI:registerObject(
            "particleSystem",
            {},
            self.particles
        )

        ParametersUI:registerObject(
            "1goldBar",
            {left = 0, up = 20},
            ResourceBar(
                ParametersUI,
                {
                    tag = "Gold",
                    max = drill.damage * drill.upgradeKoef > 0 and drill.damage * drill.upgradeKoef or 0,
                    color = { 1, 0.733, 0.133, 1 },
                    bgColor = {0, 0, 0},
                    textColor = {1, 1, 1, 0},
                    particles = self.particles,
                    width = 22,
                    getValue = function()
                        return drill.gold > 0 and drill.gold or 0
                    end
                }
            )
        )
        ParametersUI:registerObject(
            "2currentUpgrades",
            {left = 10, up = 35},
            Label(
                ParametersUI,
                {
                    tag = "currentUpgrades",
                    text = "Level: " .. 0,
                    width = 100,
                    height = 16,
                    font = font,
                    align = 'left',
                    textColor = {1, 1, 1, 1},
                    getText =
                        function()
                            return "Level: " .. ((drill.damage - 20)/2 > 0 and (drill.damage - 20)/2 or 0)
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
                    color = config.colors.fuel,
                    bgColor = config.colors.white,
                    textColor = config.colors.black,
                    particles = self.particles,
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
                    color = config.colors.health,
                    bgColor = config.colors.white,
                    textColor = config.colors.black,
                    particles = self.particles,
                    getValue = function()
                        return drill.HP > 0 and drill.HP or 0
                    end
                }
            )
        )

        ParametersUI:registerObject(
            "altitude",
            { up = 64 },
            Label(
                ParametersUI,
                {
                    tag = "altitude",
                    text = "Alt: " .. 0,
                    height = 16,
                    font = font,
                    getText = function() return "Alt: " .. (math.floor(drill.position.y)) end,
                }
            )
        )
        if Debug.drawDrillUIDebug then
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
                "damage",
                { up = 110 },
                Label(
                    SpeedUi,
                    {
                        tag = "damage",
                        text = "Damage = " .. 0,
                        height = 50,
                        font = font,
                        getText = function() return "Damage = " .. (drill.damage) end,
                    }
                )
            )
        end

        love.handlers['money'] = function(count) self.particles:spawn('money', count) end
        love.handlers['damaged'] = function() self.particles:spawn('HP', 2) end
        love.handlers['turn'] = function() self.particles:spawn('fuel', 0.3) end
        love.handlers['refuel'] = function(count) self.particles:spawn('fuelAdd', count) end
    end
}

return UI
