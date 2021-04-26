local Resources = {
    [1] = {
        id = 1,
        name = "air",
        density = 0,
        cost = 0,
        color = { 0.2, 0.1, 0.0, 1 },
        generation = {
            from = 0,
            frequency = {
                { depth = 0, value = 0.007 },
            },
            threshold = {
                { depth = -2, value = 1 },
                { depth = 0, value = 1 },
                { depth = 3000, value = 0.8 },
                { depth = 7000, value = 0.7 },
                { depth = 10000, value = 0.9 },
            },
        }
    },
    [2] = {
        id = 2,
        name = "surface",
        density = 0,
        cost = 0,
        color = { 0, 0, 0, 0 },
        generation = {
            frequency = {
                { depth = 0, value = 1 },
            },
            threshold = {
                { depth = -2, value = 0 },
            },
        }
    },
    [3] = {
        id = 3,
        name = "dirt",
        density = 0.01,
        cost = 0,
        color = { 0.3, 0.18, 0.15, 1 },
        generation = {
            from = -5, to = 3000,
            frequency = {
                { depth = 0, value = 0.008 },
            },
            threshold = {
                { depth = -2, value = 1 },
                { depth = 0, value = 0 },
                { depth = 1000, value = 0.1 },
                { depth = 2000, value = 0.3 },
                { depth = 3000, value = 0.6 },
                { depth = 4000, value = 0.7 },
                { depth = 5000, value = 1   },
            },
        }
    },
    [4] = {
        id = 4,
        name = "dirt_light",
        density = 0.01,
        cost = 0,
        color = { 0.37, 0.273, 0.18, 1 } ,
        generation = {
            from = -5, to = 3000,
            frequency = {
                { depth = 0, value = 0.98   },
            },
            threshold = {
                { depth = -2, value = 1 },
                { depth = 0, value = 0 },
                { depth = 1000, value = 0.1 },
                { depth = 2000, value = 0.3 },
                { depth = 3000, value = 0.6 },
                { depth = 4000, value = 0.7 },
                { depth = 5000, value = 1   },
            },
        }
    },
    [5] = {
        id = 5,
        name = "dirt_dark",
        density = 0.01,
        cost = 0,
        color = { 0.18, 0.114, 0.09, 1 },
        generation = {
            from = -5, to = 3000,
            frequency = {
                { depth = 0, value = 0.01 },
            },
            threshold = {
                { depth = -2, value = 1 },
                { depth = 0, value = 0 },
                { depth = 1000, value = 0.1 },
                { depth = 2000, value = 0.3 },
                { depth = 3000, value = 0.6 },
                { depth = 4000, value = 0.7 },
                { depth = 5000, value = 1   },
            },
        }
    },
    [6] = {
        id = 6,
        name = "stone_gray",
        density = 0.8,
        cost = 0,
        color = { 0.7, 0.7, 0.7, 1 },
        generation = {
            from = -5,
            aspectRatio = 2,
            frequency = {
                { depth = 0,   value = 0.005 }
            },
            threshold = {
                { depth = 0,    value = 1 },
                { depth = 1000, value = 0.7 },
                { depth = 2000, value = 0.6 },
                { depth = 3000, value = 0.3 },
                { depth = 4000, value = 0.6 },
                { depth = 5000, value = 1   },
            },
            subnoise = {
                type = "add",
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
    [7] = {
        id = 7,
        name = "limestone",
        density = 0.8,
        cost = 0,
        color = { 0.92, 0.85, 0.76, 1 },
        generation = {
            from = 0, to = 500,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.007 },
            },
            threshold = {
                { depth = 3000, value = 1   },
                { depth = 4000, value = 0.6 },
                { depth = 5000, value = 0.2 },
                { depth = 6000, value = 0.4 },
                { depth = 7000, value = 0.7 },
                { depth = 8000, value = 1   },
            },
        }
    },
    [8] = {
        id = 8,
        name = "sandstone",
        density = 0.8,
        cost = 0,
        color = { 0.75, 0.60, 0.49, 1 },
        generation = {
            from = 0, to = 500,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.01 },
            },
            threshold = {
                { depth = 0,    value = 1 },
                { depth = 1000, value = 0.4 },
                { depth = 2000, value = 0.3 },
                { depth = 3000, value = 0.6 },
                { depth = 4000, value = 0.7 },
                { depth = 5000, value = 1   },
            },
        }
    },
    [9] = {
        id = 9,
        name = "granite1",
        density = 0.8,
        cost = 0,
        color = { 0.89, 0.83, 0.80, 1 },
        generation = {
            from = 50, to = 4000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.07 },
            },
            threshold = {
                { depth = 0,    value = 1 },
                { depth = 1000, value = 0.4 },
                { depth = 2000, value = 0.3 },
                { depth = 3000, value = 0.6 },
                { depth = 4000, value = 0.7 },
                { depth = 5000, value = 1   },
            },
        }
    },
    [10] = {
        id = 10,
        name = "granite2",
        density = 0.8,
        cost = 0,
        color = { 0.47, 0.22, 0.19, 1 },
        generation = {
            from = 50, to = 4000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.97 },
            },
            threshold = {
                { depth = 0,    value = 1 },
                { depth = 1000, value = 0.4 },
                { depth = 2000, value = 0.3 },
                { depth = 3000, value = 0.6 },
                { depth = 4000, value = 0.7 },
                { depth = 5000, value = 1   },
            },
        }
    },
    [11] = {
        id = 11,
        name = "granite3",
        density = 0.8,
        cost = 0,
        color = { 0.23, 0.21, 0.2, 1 },
        generation = {
            from = 50, to = 4000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.9 },
            },
            threshold = {
                { depth = 0,    value = 1 },
                { depth = 1000, value = 0.4 },
                { depth = 2000, value = 0.3 },
                { depth = 3000, value = 0.6 },
                { depth = 4000, value = 0.7 },
                { depth = 5000, value = 1   },
            },
        }
    },
    [12] = {
        id = 12,
        name = "iron",
        density = 0.9,
        cost = 10,
        color = { 0.8, 0.5, 0.4, 1 },
        generation = {
            from = 0, to = 3100,
            frequency = {
                { depth = 0, value = 0.7 },
            },
            threshold = {
                { depth = 0, value = 1 },
                { depth = 1000, value = 0.98 },
                { depth = 2000, value = 0.97 },
                { depth = 3000, value = 0.96 },
                { depth = 4000, value = 0.9 },
                { depth = 5000, value = 1   },
            },
            -- subnoise = {
            --     type = "sub",
            --     aspectRatio = 1,
            --     frequency = {
            --         { depth = 0, value = 0.1 },
            --     },
            --     threshold = {
            --         { depth = 0, value = 0.7 },
            --     },
            -- }
        }
    },
    [13] = {
        id = 13,
        name = "titan",
        density = 0.8,
        cost = 0,
        color = { 0.77, 0.87, 0.9, 1 },
        generation = {
            from = 2800, to = 7100,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.6 },
            },
            threshold = {
                { depth = 3000, value = 1   },
                { depth = 4000, value = 0.96 },
                { depth = 5000, value = 0.92 },
                { depth = 6000, value = 0.94 },
                { depth = 7000, value = 0.97 },
                { depth = 8000, value = 1   },
            },
        }
    },
    [14] = {
        id = 14,
        name = "mythril",
        density = 0.8,
        cost = 0,
        color = { 0.3, 0.66, 0.48, 1 },
        generation = {
            from = 7000, to = 10000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.8 },
            },
            threshold = {
                { depth = 6000, value = 1   },
                { depth = 7000, value = 0.96 },
                { depth = 8000, value = 0.92 },
                { depth = 9000, value = 0.94 },
                { depth = 10000, value = 1 },
            },
        }
    },
    [15] = {
        id = 15,
        name = "malachite",
        density = 0.8,
        cost = 0,
        color = { 0.27, 0.68, 0.51, 1 },
        generation = {
            from = 500, to = 3000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.3 },
            },
            threshold = {
                { depth = 0, value = 1 },
                { depth = 1000, value = 0.95 },
                { depth = 2000, value = 0.85 },
                { depth = 3000, value = 0.9 },
                { depth = 4000, value = 1 },
            },
            subnoise = {
                type = "sub",
                aspectRatio = 1,
                frequency = {
                    { depth = 0, value = 0.1 },
                },
                threshold = {
                    { depth = 0, value = 0.2 },
                },
            }
        }
    },
    [16] = {
        id = 16,
        name = "gold",
        density = 0.4,
        cost = 1000,
        color = { 1, 0.8, 0.3, 1 },
        generation = {
            from = 300, to = 7100,
            aspectRatio = 0.2,
            frequency = {
                { depth = 0, value = 0.95 },
            },
            threshold = {
                { depth = 3000, value = 1   },
                { depth = 4000, value = 0.9 },
                { depth = 5000, value = 0.85 },
                { depth = 6000, value = 0.9 },
                { depth = 7000, value = 0.95 },
                { depth = 8000, value = 1   },
            },
            subnoise = {
                type = "sub",
                aspectRatio = 1,
                frequency = {
                    { depth = 0, value = 0.1 },
                },
                threshold = {
                    { depth = 0, value = 0.2 },
                },
            }
        }
    },
    [17] = {
        id = 17,
        name = "diamond",
        density = 0.4,
        cost = 50,
        color = { 0.33, 0.93, 0.85, 1 },
        generation = {
            from = 7000, to = 10000,
            aspectRatio = 0.5,
            frequency = {
                { depth = 0, value = 0.95 },
            },
            threshold = {
                { depth = 6000, value = 1   },
                { depth = 7000, value = 0.96 },
                { depth = 8000, value = 0.92 },
                { depth = 9000, value = 0.94 },
                { depth = 10000, value = 1 },
            },
            subnoise = {
                type = "sub",
                aspectRatio = 1,
                frequency = {
                    { depth = 0, value = 0.1 },
                },
                threshold = {
                    { depth = 0, value = 0.7 },
                },
            }
        }
    },
    [18] = {
        id = 18,
        name = "oil",
        density = 0.4,
        cost = 0,
        color = { 0.102, 0.1, 0.095, 1 },
        generation = {
            from = 0, to = 3000,
            aspectRatio = 0.5,
            frequency = {
                { depth = 0, value = 0.02 },
            },
            threshold = {
                { depth = 0, value = 1 },
                { depth = 1000, value = 0.98 },
                { depth = 2000, value = 0.95 },
                { depth = 3000, value = 0.97 },
                { depth = 4000, value = 1 },
            },
            -- subnoise = {
            --     type = "add",
            --     aspectRatio = 1,
            --     frequency = {
            --         { depth = 0, value = 0.1 },
            --     },
            --     threshold = {
            --         { depth = 0, value = 0.7 },
            --     },
            -- }
        }
    },
    [19] = {
        id = 19,
        name = "coal",
        density = 0.4,
        cost = 0,
        color = { 0.1, 0.1, 0.1, 1 },
        generation = {
            from = 2900, to = 7100,
            aspectRatio = 0.5,
            frequency = {
                { depth = 0, value = 0.1 },
            },
            threshold = {
                { depth = 3000, value = 1   },
                { depth = 4000, value = 0.9 },
                { depth = 5000, value = 0.85 },
                { depth = 6000, value = 0.9 },
                { depth = 7000, value = 0.95 },
                { depth = 8000, value = 1   },
            }
        }
    },
    [20] = {
        id = 20,
        name = "uranium",
        density = 0,
        cost = 0,
        color = { 0.2, 1, 0.25, 1 },
        generation = {
            from = 6500, to = 10000,
            frequency = {
                { depth = 0, value = 0.95 },
            },
            threshold = {
                { depth = 6000, value = 1   },
                { depth = 7000, value = 0.96 },
                { depth = 8000, value = 0.92 },
                { depth = 9000, value = 0.94 },
                { depth = 10000, value = 1 },
            },
        }
    },
    [21] = {
        id = 21,
        name = "lava1",
        density = 0.01,
        cost = 0,
        color = { 0.8, 0.1, 0.0, 1 },
        generation = {
            from = 3000, to = 10000,
            frequency = {
                { depth = 0, value = 0.2 },
            },
            threshold = {
                { depth = 3000, value = 1   },
                { depth = 4000, value = 0.9 },
                { depth = 5000, value = 0.85 },
                { depth = 6000, value = 0.9 },
                { depth = 7000, value = 0.95 },
                { depth = 8000, value = 0.7   },
                { depth = 9000, value = 0.94 },
                { depth = 10000, value = 1 },
            },
        }
    },
    [22] = {
        id = 22,
        name = "lava2",
        density = 0.01,
        cost = 0,
        color = { 0.4, 0.0, 0.05, 1 },
        generation = {
            from = 3000, to = 10000,
            frequency = {
                { depth = 0, value = 0.96 },
            },
            threshold = {
                { depth = 3000, value = 1   },
                { depth = 4000, value = 0.9 },
                { depth = 5000, value = 0.85 },
                { depth = 6000, value = 0.9 },
                { depth = 7000, value = 0.95 },
                { depth = 8000, value = 0.7   },
                { depth = 9000, value = 0.94 },
                { depth = 10000, value = 1 },
            },
        }
    },
    [23] = {
        id = 23,
        name = "lava3",
        density = 0.01,
        cost = 0,
        color = { 0.96, 0.75, 0.15, 1 },
        generation = {
            from = 3000, to = 10000,
            frequency = {
                { depth = 0, value = 0.98 },
            },
            threshold = {
                { depth = 3000, value = 1   },
                { depth = 4000, value = 0.9 },
                { depth = 5000, value = 0.85 },
                { depth = 6000, value = 0.9 },
                { depth = 7000, value = 0.95 },
                { depth = 8000, value = 0.7   },
                { depth = 9000, value = 0.94 },
                { depth = 10000, value = 1 },
            },
        }
    },
    [25] = {
        id = 25,
        name = "obsidian",
        density = 0,
        cost = 0,
        color = { 0.3, 0.2, 0.3, 1 },
        generation = {
            from = 7000, to = 10000,
            frequency = {
                { depth = 0, value = 0.08 },
            },
            threshold = {
                { depth = 7000, value = 1 },
                { depth = 8000, value = 0.7   },
                { depth = 9000, value = 0.94 },
                { depth = 10000, value = 1 },
            },
        }
    },
    [26] = {
        id = 26,
        name = "bedrock",
        density = 0,
        cost = 0,
        color = { 0, 0, 0, 1 },
        generation = {
            from = 10000,
            frequency = {
                { depth = 0, value = 1 },
            },
            threshold = {
                { depth = 9999, value = 1 },
                { depth = 10000, value = 0 },
            },
        }
    },
    [27] = {
        id = 27,
        name = "grass",
        density = 0,
        cost = 0,
        color = { 0.6, 0.9, 0.3, 1 },
        generation = {
            from = -10, to = 10,
            frequency = {
                { depth = 0, value = 1 },
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
}

Resources.nameToId = Utils.reverseMap(Resources, function(v) return v.name end )

function Resources.getByName(name)
    return Resources[Resources.nameToId[name]]
end

return Resources