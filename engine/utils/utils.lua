function math.clamp(min, value, max)
    if min > max then min, max = max, min end
    return math.max(min, math.min(max, value))
end

local Utils = {}

function Utils.reverseMap(map, valueMapper)
    local reversed = {}
    for k, v in pairs(map) do
        reversed[valueMapper(v)] = k
    end
    return reversed
end

return Utils