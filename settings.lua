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
        chunkSize = 64,
        renderRadius = 3, -- in chunks
        unloadChunksRadius = 8,
        loadChunksRadius = 6,
    }
}

settings = {
    -- user settings that are saved to disk
}

Debug = {
    LogLevel = 3,
    showFps = 1,
    drill = 0,
    drawUiDebug = true,
    map = 1,
    mapDraw = 1,
    mapGenerator = 1,
    chunk = 1,
    chunkDraw = 0,
}
