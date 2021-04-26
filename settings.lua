config = {
    inputs = {
        controls = {
            left = {'key:left', 'axis:leftx-', 'button:dpleft'},
            right = {'key:right', 'axis:leftx+', 'button:dpright'},
            up = {'key:up', 'axis:lefty-', 'button:dpup'},
            down = {'key:down', 'axis:lefty+', 'button:dpdown'},
            action = {'key:space'}
        },
        pairs = {
            move = {'left', 'right', 'up', 'down'}
        },
    },
    map = {
        chunkSize = 32,
        renderRadius = 6, -- in chunks
        unloadChunksRadius = 14,
        loadChunksRadius = 7,
    }
}

settings = {
    -- user settings that are saved to disk
}

Debug = {
    LogLevel = 3,
    showFps = 1,
    drill = 0,
    drawUiDebug = false,
    map = 0,
    mapDraw = 0,
    mapGenerator = 0,
    chunk = 0,
    chunkDraw = 0,
    resourceDisplay = 1,
    teleport = 1,
}
