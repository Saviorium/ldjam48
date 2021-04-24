require "settings"
Utils = require "engine.utils.utils"
Vector = require "lib.hump.vector"
Class = require "lib.hump.class"

Debug = require "engine.utils.debug"
serpent = require "lib.serpent.serpent"

StateManager = require "lib.hump.gamestate"

AssetManager = require "engine.utils.asset_manager"

UserInputManager = require "engine.controls.user_input_manager" (config.inputs)

states = {
    game = require "game.states.game",
    mining = require "game.states.mining"
}

fonts = {
    smolPixelated = { file = "data/fonts/m3x6.ttf", size = 16},
    bigPixelated = { file = "data/fonts/m3x6.ttf", size = 32},
}


function love.load()
    AssetManager:load("data")
    StateManager.switch(states.mining)
end

function love.draw()
    StateManager.draw()
end

function love.update(dt)
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
        StateManager.switch(states.game)
    end
end