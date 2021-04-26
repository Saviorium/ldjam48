return {
    digLow = {
        files = {
            { name = "dig3-4" },
            --{ name = "dig1-2" },
        },
        options = {
            maxSources = 1,
            volumeVariation = 0.1,
            pitchVariation = 0,
        }
    },
    digMedium = {
        files = {
            { name = "dig3-5" },
            -- { name = "dig2-3" },
            -- { name = "dig2-4" },
        },
        options = {
            maxSources = 1,
            volumeVariation = 0.2,
            pitchVariation = 0.2,
        }
    },
    digHigh = {
        files = {
            -- { name = "dig3-1" },
            -- { name = "dig3-2" },
            -- { name = "dig3-3" },
            -- { name = "dig3-4" },
            -- { name = "dig3-5" },
            { name = "dig3-6" },
        },
        options = {
            maxSources = 1,
            volumeVariation = 0.2,
            pitchVariation = 0.2,
        }
    },
}