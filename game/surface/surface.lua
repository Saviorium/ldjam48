local Surface =
    Class {
    init = function(self)
        self.base = AssetManager:getImage('base')
        self.trees = {AssetManager:getImage('tree1'), AssetManager:getImage('tree2') }
        self.clouds = {AssetManager:getImage('cloud1'), AssetManager:getImage('cloud2') }
        self.treesObjects = {}
        self.cloudObjects = {}
        self.cloudsOnScreen = 100
        self.treesOnScreen = 100
        self:generateSurface()
    end
}

function Surface:generateSurface()
    for i = 1, self.cloudsOnScreen, 1 do
        table.insert(
            self.cloudObjects,
            {
                x = math.random(love.graphics.getWidth()*2) - love.graphics.getWidth(),
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
                x = math.random(love.graphics.getWidth()*2) - love.graphics.getWidth(),
                distance = math.random()/2,
                image = self.trees[math.random(2)]
            }
        )
    end
end

function Surface:update(dt)
    if self.base.update then
        self.base:update(dt)
    end
end

function Surface:draw(drillPos)
    if drillPos.y < 100 then

        for ind, img in pairs(self.treesObjects) do
            love.graphics.draw( img.image,
                                img.x + drillPos.x * img.distance,
                                -2,
                                0, 1, 1, img.image:getWidth(), img.image:getHeight())
            if img.x < drillPos.x - love.graphics.getWidth() or img.x > drillPos.x + love.graphics.getWidth()  then
                self.treesObjects[ind] = 
                {
                    x = math.random(love.graphics.getWidth()*2 + drillPos.x) - love.graphics.getWidth(),
                    distance = math.random()/2,
                    image = self.trees[math.random(2)]
                }
            end
        end

        for ind, img in pairs(self.cloudObjects) do
            love.graphics.draw( img.image,
                                img.x + drillPos.x * img.distance,
                                -img.y)
            if img.x < drillPos.x - love.graphics.getWidth() or img.x > drillPos.x + love.graphics.getWidth()  then
                self.cloudObjects[ind] = 
                {
                    x = math.random(love.graphics.getWidth()*2 + drillPos.x) - love.graphics.getWidth(),
                    y = math.random(10) + 50,
                    distance = math.random()/2,
                    image = self.clouds[math.random(2)]
                }
            end
        end

        if self.base.draw then
            self.base:draw(0, 0, self.angle, 1, 1, self.base:getWidth(), self.base:getHeight())
        else
            love.graphics.draw(self.base, 0, 0, self.angle, 1, 1, self.base:getWidth()/2, self.base:getHeight())
        end
    end
end

function Surface:drawDebug()
end

return Surface