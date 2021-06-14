ignore = {
   "212",  -- unused argument 'self'
   "213",  -- Unused loop variable
}

std = 'luajit+love'
max_line_length = 160

globals = {
  -- love and libs
  "Class",
  "Vector",
  "serpent", -- todo: include by demand only

  -- engine
  "StateManager",
  "AssetManager",
  "SoundManager",
  "UserInputManager",
  "states",
  "config",
  "settings",
  "Debug",
  "vardump",
  -- utils
  "Utils",
  math = {
    fields = {
      "clamp"
    }
  },

  -- game
  "fonts",
}
