local Resources = {
    [1] = {
        id = 1,
        name = "air",
        density = 0,
        cost = 0,
        color = { 0.2, 0.1, 0.0, 1 },
        generation = {
            frequency = {
                { depth = 0, value = 1 },
                { depth = 500, value = 0.008 },
            },
            threshold = {
                { depth = -2, value = 1 },
                { depth = 0, value = 1 },
                { depth = 500, value = 0.8 },
                { depth = 1000, value = 0.7 },
                { depth = 2000, value = 0.9 },
                { depth = 3000, value = 1 },
            },
        }
    },
    [2] = {
        id = 2,
        name = "dirt",
        density = 0.01,
        cost = 0,
        color = { 0.5, 0.3, 0.2, 1 },
        generation = {
            frequency = {
                { depth = 0, value = 1 },
            },
            threshold = {
                { depth = -2, value = 1 },
                { depth = 0, value = 0 },
            },
        }
    },
    [8] = {
        id = 8,
        name = "dirt2",
        density = 0.01,
        cost = 0,
        color = { 0.5, 0.4, 0.3, 1 },
        generation = {
            frequency = {
                { depth = 0, value = 0.01 },
            },
            threshold = {
                { depth = -2, value = 1 },
            },
        }
    },
    [9] = {
        id = 9,
        name = "dirt3",
        density = 0.01,
        cost = 0,
        color = { 0.5, 0.4, 0.4, 1 },
        generation = {
            frequency = {
                { depth = 0, value = 0.01 },
            },
            threshold = {
                { depth = -2, value = 1 },
            },
        }
    },
    [3] = {
        id = 3,
        name = "stone",
        density = 0.8,
        cost = 0,
        color = { 0.7, 0.7, 0.7, 1 },
        generation = {
            aspectRatio = 3,
            frequency = {
                { depth = 100, value = 0.03 },
            },
            threshold = {
                { depth = 0, value = 1 },
            },
            subnoise = {
                type = "sub",
                aspectRatio = 0.9,
                frequency = {
                    { depth = 500, value = 0.01 },
                },
                threshold = {
                    { depth = 500, value = 1 },
                },
            }
        }
    },
    [4] = {
        id = 4,
        name = "iron",
        density = 0.9,
        cost = 10,
        color = { 0.8, 0.5, 0.4, 1 },
        generation = {
            frequency = {
                { depth = 0, value = 0.1 },
            },
            threshold = {
                { depth = 0, value = 1 },
            },
            subnoise = {
                type = "sub",
                aspectRatio = 0.4,
                frequency = {
                    { depth = 0, value = 0.1 },
                },
                threshold = {
                    { depth = 0, value = 0.7 },
                },
            }
        }
    },
    [5] = {
        id = 5,
        name = "gold",
        density = 0.4,
        cost = 1000,
        color = { 1, 0.8, 0.3, 1 },
        generation = {
            aspectRatio = 0.2,
            frequency = {
                { depth = 0, value = 0.03 },
            },
            threshold = {
                { depth = 0, value = 1 },
            },
            subnoise = {
                type = "sub",
                frequency = {
                    { depth = 0, value = 0.1 },
                },
                threshold = {
                    { depth = 0, value = 0 },
                },
            }
        }
    },
    [6] = {
        id = 6,
        name = "surface",
        density = 0,
        cost = 0,
        color = { 0, 0, 0, 0 },
        generation = {
            frequency = {
                { depth = 0, value = 1 },
            },
            threshold = {
                { depth = 0, value = 0 },
            },
        }
    },
    [7] = {
        id = 7,
        name = "grass",
        density = 0.01,
        cost = 0,
        color = { 0.6, 0.9, 0.3, 1 },
        generation = {
            frequency = {
                { depth = 0, value = 0.5 },
            },
            threshold = {
                { depth = -5, value = 1 },
                { depth = -2, value = 0 },
                { depth = 4, value = 0 },
                { depth = 5, value = 1 },
            },
        }
    },
}

Resources.nameToId = Utils.reverseMap(Resources, function(v) return v.name end )

function Resources.getByName(name)
    return Resources[Resources.nameToId[name]]
end

return Resources