local endScreen = {}

function endScreen:enter()
end

function endScreen:mousepressed(x, y)
end

function endScreen:mousereleased(x, y)
end

function endScreen:keypressed(key)
end

function endScreen:draw()
    love.graphics.print("Hello, Ludum Dare 48")
end

function endScreen:update(dt)
end

return endScreen