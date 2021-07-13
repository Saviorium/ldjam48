return {
    digLow = {
        files = {
            { name = "dig3-4" },
            --{ name = "dig1-2" },
        },
        options = {
            volume = 0.3,
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
            volume = 0.3,
            maxSources = 1,
            volumeVariation = 0.2,
            pitchVariation = 0.2,
        }
    },
    digHigh = {
        files = {
            { name = "dig3-6" },
        },
        options = {
            volume = 0.3,
            maxSources = 1,
            volumeVariation = 0.2,
            pitchVariation = 0.2,
        }
    },
    levelUp = {
        files = {
            { name = "level_up" },
        },
        options = {
            maxSources = 1,
            volumeVariation = 0,
            pitchVariation = 0,
        }
    },
    doNotLevelUp = {
        files = {
            { name = "do_not_level_up" },
        },
        options = {
            maxSources = 1,
            volumeVariation = 0.2,
            pitchVariation = 0.2,
        }
    },
}