
local Base = require "game.surface.base"

local Surface =
    Class {
    init = function(self)
        self.trees = {AssetManager:getImage('tree1'), AssetManager:getImage('tree2') }
        self.clouds = {AssetManager:getImage('cloud1'), AssetManager:getImage('cloud2') }
        self.treesObjects = {}
        self.cloudObjects = {}
        self.cloudsOnScreen = 20
        self.treesOnScreen = 20
        self:generateSurface()
        self.x = 0
        self.base = Base()
    end
}

function Surface:generateSurface()
    for i = 1, self.cloudsOnScreen, 1 do
        table.insert(
            self.cloudObjects,
            {
                x = math.random(love.graphics.getWidth()) - love.graphics.getWidth()/2,
                y = math.random(50) + 50,
                distance = math.random()/2,
                image = self.clouds[math.random(2)]
            }
        )
    end
    for i = 1, self.treesOnScreen, 1 do
        table.insert(
            self.treesObjects,
            {
                x = math.random(love.graphics.getWidth()) - love.graphics.getWidth()/2,
                distance = math.random()/2,
                image = self.trees[math.random(2)]
            }
        )
    end
end

function Surface:update(dt, drillPos)
    if self.base.update then
        self.base:update(dt)
    end

    if drillPos.y < 100 then
        for ind, img in pairs(self.treesObjects) do
            if img.x < (drillPos.x - love.graphics.getWidth()) or img.x > (drillPos.x + love.graphics.getWidth())  then
                local dist = math.random(love.graphics.getWidth()) + love.graphics.getWidth()
                self.treesObjects[ind] =
                {
                    x = math.random(2) == 1
                        and  dist + drillPos.x
                         or -dist + drillPos.x,
                    distance = math.random()/2,
                    image = self.trees[math.random(2)]
                }
            else
                self.treesObjects[ind].x = self.treesObjects[ind].x + (drillPos.x - self.x) * img.distance
            end
        end

        for ind, img in pairs(self.cloudObjects) do
            if img.x < (drillPos.x- love.graphics.getWidth()) or img.x > (drillPos.x + love.graphics.getWidth())  then
                local dist = math.random(love.graphics.getWidth()) + love.graphics.getWidth()
                self.cloudObjects[ind] =
                {
                    x = math.random(2) == 1
                        and  dist + drillPos.x
                         or -dist + drillPos.x,
                    y = math.random(50) + 50,
                    distance = math.random()/2,
                    image = self.clouds[math.random(2)]
                }
            else
                img.x = img.x + (drillPos.x - self.x) * img.distance
            end
        end
    end
    self.x = drillPos.x
end

function Surface:draw(drillPos)
    if drillPos.y < 100 then
        for ind, img in pairs(self.treesObjects) do
            love.graphics.draw( img.image,
                                img.x,
                                -2,
                                0, 1, 1, img.image:getWidth(), img.image:getHeight())
        end

        for ind, img in pairs(self.cloudObjects) do
            love.graphics.draw( img.image,
                                img.x,
                                -img.y)
        end

        if self.base.draw then
            self.base:draw()
        end
    end
end

function Surface:drawDebug()
end

return Surface