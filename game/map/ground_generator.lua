local GroundGenerator = Class {
    init = function(self)
    end
}

function GroundGenerator:getValue(position)
    return 1
end

function GroundGenerator:getResource(position)
    if position.y < 0 then return "air" end
    if position.y > 2000 then return "stone" end
    return "dirt"
end

return GroundGenerator