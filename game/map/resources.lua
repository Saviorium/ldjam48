local Resources = {
    [1] = {
        id = 1,
        name = "air",
        density = 0,
        color = { 0.2, 0.1, 0.0, 1 },
    },
    [2] = {
        id = 2,
        name = "dirt",
        density = 0.1,
        color = { 0.5, 0.3, 0.2, 1 },
    },
    [3] = {
        id = 3,
        name = "stone",
        density = 0.5,
        color = { 0.7, 0.7, 0.7, 1 },
    },
    [4] = {
        id = 4,
        name = "iron",
        density = 0.6,
        color = { 0.8, 0.5, 0.4, 1 },
    }
}

Resources.nameToId = Utils.reverseMap(Resources, function(v) return v.name end )

function Resources.getIdByName(name)
    return Resources.nameToId[name]
end

return Resources