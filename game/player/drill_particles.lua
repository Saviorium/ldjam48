return {
    dirtChunk = {
        spawnType = "behind",
        drawType = "circle",
        color = { 0.3, 0.18, 0.15, 1 },
        size = 2,
        gravity = 0.2,
        friction = 0.99,
        translate = Vector(0, 0),
        angle = 180, -- deg, aligned with drill, 0 = forward, clockwise
        speed = 2,
        timeToLive = 0.3, -- seconds
        maxIntensity = 10, -- particles per second
        random = {
            color = 0.01,
            size = 0.5,
            translate = 1,
            angle = 45,
            speed = 2,
            timeToLive = 0,
            intensity = 5,
        }
    },
    stoneChunk = {
        spawnType = "behind",
        drawType = "circle",
        color = { 0.6, 0.6, 0.6, 1 },
        size = 1,
        gravity = 0.2,
        friction = 0.99,
        translate = Vector(0, 0),
        angle = 0,
        speed = 2,
        timeToLive = 0.3,
        maxIntensity = 10,
        random = {
            color = 0,
            size = 0.1,
            translate = 1,
            angle = 45,
            speed = 2,
            timeToLive = 0,
            intensity = 5,
        }
    },
    smoke = {
        spawnType = "behind",
        drawType = "circle",
        color = { 0.6, 0.6, 0.6, .7 },
        size = 3,
        gravity = -0.1,
        friction = 0.98,
        translate = Vector(0, 0),
        angle = 180,
        speed = 0.3,
        timeToLive = 0.7,
        maxIntensity = 50,
        random = {
            color = 0,
            lightness = 0.1,
            size = 1,
            translate = 1,
            angle = 180,
            speed = 0.2,
            timeToLive = 0.3,
            intensity = 2,
        }
    },
    spark = {
        spawnType = "front",
        drawType = "line",
        color = { 0.9, 0.8, 0.1, 1 },
        size = 0.4,
        gravity = 1,
        friction = 0.7,
        translate = Vector(5, 0),
        angle = 0,
        speed = 5,
        timeToLive = 0.1,
        maxIntensity = 60,
        random = {
            color = 0.2,
            size = 0.2,
            translate = 0.5,
            angle = 120,
            speed = 2,
            timeToLive = 0.05,
            intensity = 5,
        }
    },
}
