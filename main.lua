require "settings"
Utils = require "engine.utils.utils"
Vector = require "lib.hump.vector"
Class = require "lib.hump.class"

Debug = require "engine.utils.debug"
serpent = require "lib.serpent.serpent"

StateManager = require "lib.hump.gamestate"

AssetManager = require "engine.utils.asset_manager"

UserInputManager = require "engine.controls.user_input_manager" (config.inputs)

local SoundData = require "data.sound.sound_data"
SoundManager = require "engine.sound.sound_manager" (SoundData)

states = {
    mining = require "game.states.mining",
    start_screen = require "game.states.start_screen",
    end_screen = require "game.states.end_screen",
}

fonts = {
    smolPixelated = { file = "data/fonts/m3x6.ttf", size = 16},
    bigPixelated = { file = "data/fonts/m3x6.ttf", size = 32},
}


function love.load()
    AssetManager:load("data")
    StateManager.switch(states.start_screen)
end

function love.draw()
    StateManager.draw()
    if Debug and Debug.showFps == 1 then
        love.graphics.print(""..tostring(love.timer.getFPS( )), 2, 2)
    end
    if Debug and Debug.mousePos == 1 then
        local x, y = love.mouse.getPosition()
        love.graphics.print(""..tostring(x)..","..tostring(y), 2, 32)
    end
end

function love.fixedUpdate(dt)
    UserInputManager:update(dt)
    StateManager.update(dt)
end

function love.mousepressed(x, y)
    if StateManager.current().mousepressed then
        StateManager.current():mousepressed(x, y)
    end
end

function love.mousereleased(x, y)
    if StateManager.current().mousereleased then
        StateManager.current():mousereleased(x, y)
    end
end

function love.keypressed(key)
    if StateManager.current().keypressed then
        StateManager.current():keypressed(key)
    end
    if key == "escape" then
        StateManager.switch(states.mining)
    end
end