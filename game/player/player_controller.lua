local Class = require "lib.hump.class"
local ObjectController = require "engine.controls.object_controller"

local PlayerController = Class {
    __includes = ObjectController,
    init = function(self, player, inputManager)
        ObjectController.init(self, inputManager)
        self.player = player
        self.userInputManager = inputManager
    end
}

function PlayerController:reactToInputs(inputs)
    self.player:turn( -inputs.move.x )
    if inputs.action > 0 then
        self.player:start()
    end
end

return PlayerController
