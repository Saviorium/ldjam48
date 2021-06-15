local Base =
    Class {
    init = function(self, position)
        self.image = AssetManager:getImage('base')
        self.position = position
        self.gold = 0
        self.upgrades = {
            MaxFuel =
                {
                    level = 0
                },
            GoldFromOre =
                {
                    level = 0
                },
            MaxHP =
                {
                    level = 0
                },
            FieldOfView =
                {
                    level = 0
                },
            Speed =
                {
                    level = 0
                },
            Dig =
                {
                    level = 0
                }
        }
        self.mapOfUpgrades = {
            name = {
                start = name,
                next = name
            }
        }
    end
}

function Base:update(dt)
    --self.image:update(dt)
    -- for _, upd in pairs(self.upgrades) do
    --     upd:update(dt)
    -- end
end

function Base:draw()
    -- for _, upd in pairs(self.upgrades) do
    --     upd:draw()
    -- end
    love.graphics.setColor(1, 1, 1, 0.5)
    -- for _, upd in pairs(self.upgrades) do
    --     upd:draw()
    -- end
    if self.image.draw then
        self.image:draw(0, 0, self.angle, 1, 1, self.image:getWidth(), self.image:getHeight())
    else
        love.graphics.draw(self.image, 0, 0, self.angle, 1, 1, self.image:getWidth()/2, self.image:getHeight())
    end
end

function Base:drawDebug()
end

return Base