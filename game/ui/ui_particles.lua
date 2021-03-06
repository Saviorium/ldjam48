return {
    money = {
        spawnType = "Gold",
        drawType = "circle",
        color = config.colors.gold,
        size = 5,
        gravity = 0.5,
        friction = 0.998,
        translate = Vector(70, 15),
        angle = -90,
        speed = 5,
        timeToLive = 0.5,
        maxIntensity = 60,
        random = {
            color = 0,
            size = 0,
            translate = 10,
            angle = 90,
            speed = 2,
            timeToLive = 0.05,
            intensity = 5,
        }
    },
    fuel = {
        spawnType = "Fuel",
        drawType = "circle",
        color = config.colors.fuel,
        size = 2,
        gravity = 0.05,
        friction = 0.998,
        translate = Vector(130, 8),
        angle = 0,
        speed = 2,
        timeToLive = 0.5,
        maxIntensity = 60,
        random = {
            color = 0,
            size = 0,
            translate = 6,
            angle = 45,
            speed = 2,
            timeToLive = 0.05,
            intensity = 5,
        }
    },
    fuelAdd = {
        spawnType = "Fuel",
        drawType = "circle",
        color = config.colors.white,
        size = 2,
        gravity = 0,
        friction = 0.99,
        translate = Vector(10, 10),
        angle = 0,
        speed = 2,
        timeToLive = 0.7,
        maxIntensity = 60,
        random = {
            color = 0,
            size = 0,
            translate = 8,
            angle = 2,
            speed = 0.5,
            timeToLive = 0.05,
            intensity = 5,
        }
    },
    HP = {
        spawnType = "Health",
        drawType = "circle",
        color = config.colors.health,
        size = 2,
        gravity = 0.01,
        friction = 0.998,
        translate = Vector(70, 15),
        angle = 0,
        speed = 5,
        timeToLive = 0.5,
        maxIntensity = 60,
        random = {
            color = 0,
            size = 0,
            translate = 10,
            angle = 10,
            speed = 2,
            timeToLive = 0.05,
            intensity = 5,
        }
    }
}
