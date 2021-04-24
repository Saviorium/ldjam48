local Resources = {
    [1] = {
        id = 1,
        name = "air",
        density = 0,
        cost = 0,
        color = { 0.2, 0.1, 0.0, 1 },
    },
    [2] = {
        id = 2,
        name = "dirt",
        density = 0.9,
        cost = 0,
        color = { 0.5, 0.3, 0.2, 1 },
    },
    [3] = {
        id = 3,
        name = "stone",
        density = 0.99,
        cost = 0,
        color = { 0.7, 0.7, 0.7, 1 },
    },
    [4] = {
        id = 4,
        name = "iron",
        density = 0.95,
        cost = 10,
        color = { 0.8, 0.5, 0.4, 1 },
        generation = {
            frequency = 0.01,
            threshold = 0.97, -- 0 < threshold <= 1
            subnoise = {
                frequency = 0.05,
                threshold = 0.7,
            }
        }
    },
    [5] = {
        id = 5,
        name = "gold",
        density = 0.8,
        cost = 1000,
        color = { 1, 0.8, 0.3, 1 },
        generation = {
            frequency = 0.03,
            threshold = 0.98,
            subnoise = {
                frequency = 0.1,
                threshold = 0.95,
            }
        }
    },
    [6] = {
        id = 6,
        name = "surface",
        density = 0,
        cost = 0,
        color = { 0, 0, 0, 0 },
    },
}

Resources.nameToId = Utils.reverseMap(Resources, function(v) return v.name end )

function Resources.getByName(name)
    return Resources[Resources.nameToId[name]]
end

return Resources