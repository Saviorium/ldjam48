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
        renderRadius = 4, -- in chunks
    }
}

settings = {
    -- user settings that are saved to disk
}

Debug = {
    LogLevel = 3,
    ShowFps = 0,
    drill = 0,
    drawUiDebug = false,
    map = 1,
    mapDraw = 0,
    chunk = 1,
    chunkDraw = 0,
}
