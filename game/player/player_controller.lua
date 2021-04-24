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
    print(inputs.left, inputs.right)
    self.player:turn( inputs.left > 0 and 1 or (inputs.right > 0 and -1 or 0) )
end

return PlayerController
