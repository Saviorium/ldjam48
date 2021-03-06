config = {
    inputs = {
        controls = {
            left = {'key:left', 'key:a', 'axis:leftx-', 'button:dpleft'},
            right = {'key:right', 'key:d', 'axis:leftx+', 'button:dpright'},
            up = {'key:up', 'key:w', 'axis:lefty-', 'button:dpup'},
            down = {'key:down', 'key:s', 'axis:lefty+', 'button:dpdown'},
            action = {'key:space', 'button:a'}
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
    },
    map = {
        viewScale = 3,
        chunkSize = 32,
        renderRadius = 8, -- in chunks
        loadChunksRadius = 9,
        unloadChunksRadius = 15,
    },
    colors = {
        white = {1,1,1},
        black = {0,0,0},
        health = {0.862, 0.125, 0.125},
        fuel = {0.623, 0.984, 0.984},
        gold = { 0.9, 0.8, 0.1 }
    }
}

settings = {
    -- user settings that are saved to disk
}

Debug = {
    LogLevel = 0,
    showFps = 0,
    drill = 0,
    drawUiDebug = false,
    drawDrillUIDebug = false,
    unlockMoney = false,
    map = 0,
    mapDraw = 0,
    mapGenerator = 0,
    mapGeneratorDraw = 0,
    chunk = 0,
    chunkDraw = 0,
    resourceDisplay = 0,
    teleport = 0,
}
