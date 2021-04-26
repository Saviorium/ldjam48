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
                { depth = 0, value = 1 },
                { depth = 3000, value = 0.8 },
                { depth = 7000, value = 0.7 },
                { depth = 9950, value = 0.9 },
                { depth = 9960, value = 1 },
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
        colorGeneration = {
            colors = {
                { 0.3, 0.18, 0.15, 1 },
                { 0.37, 0.273, 0.18, 1 },
                { 0.18, 0.114, 0.09, 1 },
            },
            noiseFrequency = 0.07,
            thresholds = {
                0.2, 0.7, 1
            }
        },
        generation = {
            from = -5, to = 3000,
            frequency = {
                { depth = 0, value = 1 },
            },
            threshold = {
                { depth = 0, value = 1 },
                { depth = 1, value = 0 },
                { depth = 3000, value = 0   },
                { depth = 4000, value = 1   },
            },
        }
    },
    [6] = {
        id = 6,
        name = "stone_gray",
        density = 0.75,
        cost = 0,
        colorGeneration = {
            colors = {
                { 0.7, 0.7, 0.7, 1 },
                { 0.72, 0.72, 0.72, 1 },
                { 0.68, 0.68, 0.68, 1 },
            },
            noiseFrequency = 1,
            thresholds = {
                0.4, 0.7, 1
            }
        },
        generation = {
            from = -5,
            aspectRatio = 2,
            frequency = {
                { depth = 0,   value = 0.005 }
            },
            threshold = {
                { depth = 0,    value = 1 },
                { depth = 1000, value = 0.9 },
                { depth = 2000, value = 0.6 },
                { depth = 3000, value = 0.5 },
                { depth = 4000, value = 1   },
            },
            subnoise = {
                type = "add",
                frequency = {
                    { depth = 0, value = 0.02 },
                },
                threshold = {
                    { depth = 0,    value = 1 },
                    { depth = 1000, value = 0.9 },
                    { depth = 2000, value = 0.8 },
                    { depth = 3000, value = 1   },
                },
            }
        }
    },
    [7] = {
        id = 7,
        name = "limestone",
        density = 0.65,
        cost = 0,
        colorGeneration = {
            colors = {
                { 0.90, 0.87, 0.78, 1 },
                { 0.94, 0.87, 0.78, 1 },
                { 0.90, 0.83, 0.74, 1 },
            },
            noiseFrequency = 1,
            thresholds = {
                0.4, 0.7, 1
            }
        },
        generation = {
            from = 2500, to = 8000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.0001 },
            },
            threshold = {
                { depth = 2500, value = 1 },
                { depth = 3000, value = 0 },
                { depth = 6999, value = 0 },
                { depth = 7000, value = 1 },
            },
        }
    },
    [28] = {
        id = 28,
        name = "stone_dark",
        density = 0.95,
        cost = 0,
        colorGeneration = {
            colors = {
                { 0.22, 0.2, 0.2, 1 },
                { 0.25, 0.23, 0.23, 1 },
                { 0.35, 0.3, 0.3, 1 },
                { 0.4, 0.3, 0.3, 1 },
            },
            noiseFrequency = 0.07,
            thresholds = {
                0.2, 0.5, 0.6, 1
            }
        },
        seed = 1337,
        generation = {
            from = 3000, to = 8000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.0005 }
            },
            threshold = {
                { depth = 3000, value = 1 },
                { depth = 4000, value = 0.6 },
                { depth = 5000, value = 0.4 },
                { depth = 6000, value = 0.1 },
                { depth = 7500, value = 1   },
            },
            subnoise = {
                type = "sub",
                aspectRatio = 1,
                frequency = {
                    { depth = 0, value = 0.01 },
                },
                threshold = {
                    { depth = 0, value = 0.7 },
                },
            },
        }
    },
    [8] = {
        id = 8,
        name = "sandstone",
        density = 0.65,
        cost = 0,
        colorGeneration = {
            colors = {
                { 0.75, 0.60, 0.49, 1 },
                { 0.74, 0.56, 0.47, 1 },
                { 0.7, 0.55, 0.44, 1 },
            },
            noiseFrequency = 0.05,
            thresholds = {
                0.2, 0.7, 1
            }
        },
        generation = {
            from = 0, to = 4000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.01 },
            },
            threshold = {
                { depth = 0,    value = 1 },
                { depth = 1000, value = 0.4 },
                { depth = 2000, value = 0.3 },
                { depth = 3000, value = 1   },
            },
        }
    },
    [9] = {
        id = 9,
        name = "granite",
        density = 0.9,
        cost = 0,
        colorGeneration = {
            colors = {
                { 0.89, 0.83, 0.80, 1 },
                { 0.47, 0.22, 0.19, 1 },
                { 0.23, 0.21, 0.2, 1 },
            },
            noiseFrequency = 1,
            thresholds = {
                0.4, 0.7, 1
            }
        },
        generation = {
            from = 0, to = 4000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.02 },
            },
            threshold = {
                { depth = 1000, value = 1 },
                { depth = 2000, value = 0.8 },
                { depth = 3000, value = 0.9 },
                { depth = 4000, value = 1   },
            },
            subnoise = {
                type = "add",
                aspectRatio = 0.9,
                frequency = {
                    { depth = 0, value = 0.9 },
                },
                threshold = {
                    { depth = 0,    value = 1 },
                    { depth = 1000, value = 0.1 },
                    { depth = 2000, value = 0.9 },
                    { depth = 3000, value = 1   },
                },
            }
        }
    },
    [12] = {
        id = 12,
        name = "iron",
        density = 0.8,
        cost = 10,
        color = { 0.8, 0.5, 0.4, 1 },
        generation = {
            from = 0, to = 3100,
            frequency = {
                { depth = 0, value = 0.01 },
            },
            threshold = {
                { depth = 0, value = 1 },
                { depth = 1000, value = 0.95 },
                { depth = 2000, value = 0.93 },
                { depth = 3000, value = 0.96 },
                { depth = 4000, value = 1   },
            },
            subnoise = {
                type = "mult",
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
    [13] = {
        id = 13,
        name = "titan",
        density = 0.8,
        cost = 100,
        color = { 0.77, 0.87, 0.9, 1 },
        generation = {
            from = 2800, to = 8000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.01 },
            },
            threshold = {
                { depth = 3000, value = 1   },
                { depth = 4000, value = 0.98 },
                { depth = 5000, value = 0.93 },
                { depth = 6000, value = 1   },
            },
            subnoise = {
                type = "add",
                aspectRatio = 0.9,
                frequency = {
                    { depth = 0, value = 0.009 },
                },
                threshold = {
                    { depth = 6000,    value = 1 },
                    { depth = 7000, value = 0.90 },
                    { depth = 8000, value = 1 },
                },
                subnoise = {
                    type = "sub",
                    frequency = {
                        { depth = 0, value = 0.1 },
                    },
                    threshold = {
                        { depth = 0, value = 0.7 },
                    },
                }
            },
        }
    },
    [14] = {
        id = 14,
        name = "mythril",
        density = 0.8,
        cost = 500,
        color = { 0.3, 0.66, 0.48, 1 },
        generation = {
            from = 6000, to = 10000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.01 },
            },
            threshold = {
                { depth = 6500, value = 1   },
                { depth = 7000, value = 0.99 },
                { depth = 8000, value = 0.95 },
                { depth = 9000, value = 0.96 },
                { depth = 10000, value = 1 },
            },
            subnoise = {
                type = "sub",
                frequency = {
                    { depth = 0, value = 0.08 },
                },
                threshold = {
                    { depth = 0, value = 0.6 },
                },
            },
        }
    },
    [15] = {
        id = 15,
        name = "malachite",
        density = 0.5,
        cost = 50,
        color = { 0.27, 0.68, 0.51, 1 },
        generation = {
            from = 500, to = 3000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.03 },
            },
            threshold = {
                { depth = 0, value = 1 },
                { depth = 1000, value = 0.96 },
                { depth = 2000, value = 0.92 },
                { depth = 3000, value = 0.99 },
                { depth = 4000, value = 1 },
            },
            subnoise = {
                type = "mult",
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
    [16] = {
        id = 16,
        name = "gold",
        density = 0.4,
        cost = 1000,
        color = { 1, 0.8, 0.3, 1 },
        seed = 1337,
        generation = {
            from = 300, to = 7100,
            aspectRatio = 1,
            frequency = {
                { depth = 0, value = 0.001 },
            },
            threshold = {
                { depth = 3000, value = 1 },
                { depth = 4000, value = 0.85 },
                { depth = 5000, value = 0.7 },
                { depth = 6000, value = 0.9 },
                { depth = 8000, value = 1   },
            },
            subnoise = {
                type = "mult",
                aspectRatio = 0.4,
                frequency = {
                    { depth = 0, value = 0.015 },
                },
                threshold = {
                    { depth = 0, value = 0.985 },
                },
                subnoise = {
                    type = "sub",
                    aspectRatio = 1,
                    frequency = {
                        { depth = 0, value = 0.07 },
                    },
                    threshold = {
                        { depth = 0, value = 0.5 },
                    },
                }
            }
        }
    },
    [17] = {
        id = 17,
        name = "diamond",
        density = 0.4,
        cost = 50,
        color = { 0.33, 0.93, 0.85, 1 },
        seed = 1336,
        generation = {
            from = 7000, to = 11000,
            aspectRatio = 0.5,
            frequency = {
                { depth = 0, value = 0.0005 },
            },
            threshold = {
                { depth = 6000, value = 1   },
                { depth = 7000, value = 0.999 },
                { depth = 8000, value = 0.995 },
                { depth = 9000, value = 0.99 },
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
                { depth = 0, value = 0.01 },
            },
            threshold = {
                { depth = 0, value = 1 },
                { depth = 1000, value = 0.9 },
                { depth = 2000, value = 0.95 },
                { depth = 3000, value = 0.9 },
                { depth = 4000, value = 0.98 },
                { depth = 5000, value = 1 },
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
            aspectRatio = 1,
            frequency = {
                { depth = 0, value = 0.01 },
            },
            threshold = {
                { depth = 3000, value = 1   },
                { depth = 4000, value = 0.96 },
                { depth = 5000, value = 0.92 },
                { depth = 6000, value = 0.94 },
                { depth = 7000, value = 0.96 },
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
        seed = 1336,
        generation = {
            from = 6500, to = 10000,
            frequency = {
                { depth = 0, value = 0.005 },
            },
            threshold = {
                { depth = 6000, value = 1   },
                { depth = 7000, value = 0.99 },
                { depth = 8000, value = 0.98 },
                { depth = 9000, value = 0.97 },
                { depth = 10000, value = 1 },
            },
        }
    },
    [21] = {
        id = 21,
        name = "lava",
        density = 0.05,
        cost = 0,
        colorGeneration = {
            colors = {
                { 0.580, 0.019, 0.050, 1 },
                { 0.788, 0.019, 0.054, 1 },
                { 0.996, 0.972, 0.180, 1 },
                { 0.996, 0.796, 0.160, 1 },
                { 0.719, 0.205, 0, 1 },
            },
            noiseFrequency = 0.07,
            thresholds = {
                0.2, 0.35, 0.5, 0.70, 1
            }
        },
        generation = {
            from = 3000, to = 10000,
            aspectRatio = 0.5,
            frequency = {
                { depth = 0, value = 0.008 },
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
        density = 0.995,
        cost = 0,
        seed = 1336,
        colorGeneration = {
            colors = {
                { 0.219, 0.141, 0.215, 1 },
                { 0.4, 0.25, 0.4, 1 },
                { 0.1, 0.09, 0.1, 1 },
                { 0.3, 0.2, 0.3, 1 },
            },
            noiseFrequency = 0.09,
            thresholds = {
                0.2, 0.35, 0.55, 1
            }
        },
        generation = {
            from = 6000, to = 11000,
            frequency = {
                { depth = 0, value = 0.0005 },
            },
            threshold = {
                { depth = 6500, value = 1 },
                { depth = 7000, value = 0.95 },
                { depth = 8000, value = 0.7   },
                { depth = 9000, value = 0.4 },
                { depth = 10000, value = 0.9 },
                { depth = 10500, value = 1 },
            },
            subnoise = {
                type = "sub",
                aspectRatio = 1,
                frequency = {
                    { depth = 0, value = 0.01 },
                },
                threshold = {
                    { depth = 0, value = 0.7 },
                },
            },
        }
    },
    [30] = {
        id = 30,
        name = "ash",
        density = 0.5,
        cost = 0,
        colorGeneration = {
            colors = {
                { 0.4, 0.4, 0.4, 1 },
                { 0.3, 0.3, 0.3, 1 },
                { 0.2, 0.2, 0.2, 1 },
                { 0.1, 0.1, 0.1, 1 },
            },
            noiseFrequency = 0.09,
            thresholds = {
                0.2, 0.35, 0.5, 1
            }
        },
        generation = {
            from = 6000, to = 11000,
            aspectRatio = 1,
            frequency = {
                { depth = 0,   value = 0.0001 },
            },
            threshold = {
                { depth = 6500, value = 1 },
                { depth = 7000, value = 0 },
                { depth = 9999, value = 0 },
                { depth = 10500, value = 1 },
            },
        }
    },
    [26] = {
        id = 26,
        name = "bedrock",
        density = 9999,
        cost = 0,
        color = { 0, 0, 0, 1 },
        generation = {
            from = 9980,
            frequency = {
                { depth = 0, value = 0.1 },
            },
            threshold = {
                { depth = 9980, value = 1 },
                { depth = 9985, value = 0.4 },
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
                { depth = 0, value = 0 },
                { depth = 10, value = 1 },
            },
        }
    },
}

Resources.nameToId = Utils.reverseMap(Resources, function(v) return v.name end )

function Resources.getByName(name)
    return Resources[Resources.nameToId[name]]
end

return Resources