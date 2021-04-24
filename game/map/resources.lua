local Resources = {
    [1] = {
        id = 1,
        name = "air",
        density = 0,
    },
    [2] = {
        id = 2,
        name = "dirt",
        density = 0.1,
    },
    [3] = {
        id = 3,
        name = "stone",
        density = 0.5,
    },
    [4] = {
        id = 4,
        name = "iron",
        density = 0.6,
    }
}

Resources.nameToId = Utils.reverseMap(Resources, function(v) return v.name end )

function Resources.getIdByName(name)
    return Resources.nameToId[name]
end

return Resources