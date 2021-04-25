Class = require "lib.hump.class"
-- Абстрактный класс любого атомарного объекта для UI, сожержит зародыши умений объектов, такие как DragAndDrop и Кликабельность, также позиционирование

local UIobject = Class {
    init = function(self, parent, parameters)

        self.parent = parent
        self.tag = parameters.tag

        self.clickInteraction   = parameters.clickInteraction or {}
        self.releaseInteraction = parameters.releaseInteraction or {}
        self.wheelInteraction   = parameters.wheelInteraction or {}
        self.keyInteraction     = parameters.keyInteraction or {}


        self:addMousePressedEvent(   'mouspressed',
                                function (object, x, y) return true end,
                                self.mousepressed
        )

        self:addMouseReleasedEvent(  'mousereleased',
                                function (object, x, y) return true end,
                                self.mousereleased
        )

        self:addWheelMovedEvent(     'wheelmoved',
                                function (object, x, y) return true end,
                                self.wheelmoved
        )

        self:addKeyPressedEvent(     'keypressed',
                                function (object, x, y) return true end,
                                self.keypressed
        )

        self.x, self.y = 0, 0
        self.width = parameters.width or (self.parent and self.parent.width or love.graphics.getWidth())
        self.height = parameters.height or (self.parent and self.parent.height or love.graphics.getHeight())

        self.objects = parameters.objects or {}
        self.background = parameters.background

        self.columns = parameters.columns or 1
        self.rows = parameters.rows or 1
        self.margin = parameters.margin or 10
        self.calculatePositionMethods = {
                                            one  = self.calculateRelationalPosition,
                                            two  = self.calculatePositionWithAlign,
                                            tree = self.calculateFixedPosition,
                                        }

        self.cell_width = (self.width - self.margin*(self.columns-1))/self.columns
        self.cell_height = (self.height - self.margin*(self.rows-1))/self.rows
        if self.columns > 1 or self.rows > 1 then
            for ind = 0, self.columns * self.rows - 1, 1 do
                local x = (self.cell_width + self.margin) * (ind % self.columns)
                local y = (self.cell_height + self.margin) * (ind/self.columns - (ind / self.columns)%1)
                self:registerNewObject(ind, {fixedX = x, fixedY = y}, {width = self.cell_width, height = self.cell_height}, self)
            end
        end
        if parent then
            print(self.height, self.parent.height, self.parent.tag, self.tag)
        end
    end
}

-- Регистрация объекта в окошке, для его отображения и считывания действий
function UIobject:registerNewObject(index, position, parameters, parent)
    local object = UIobject(parent, parameters)
    if (self.rows == 1 and self.columns == 1) or not(position.row and position.column) then
        self:calculateCoordinatesAndWriteToObject(position)
        object.x, object.y = position.x, position.y
        self.objects[index] = {
                                position = position,
                                parameters = parameters,
                                entity = object,
                              }
    else
        local row, column = position.row, position.column
        position.row, position.column = nil, nil
        self.objects[ (row - 1) * self.columns + (column - 1) ].entity:registerObject(index, position, object)
    end
end

function UIobject:registerObject(index, position, object)
    if (self.rows == 1 and self.columns == 1) or not(position.row and position.column) then
        self:calculateCoordinatesAndWriteToObject(position)
        object.x, object.y = position.x, position.y
        self.objects[index] = {
                                position = position,
                                parameters = nil,
                                entity = object,
                              }
    else
        local row, column = position.row, position.column
        position.row, position.column = nil, nil
        local ind = (row - 1) * self.columns + (column - 1)
        if self.objects[ind] then
            self.objects[ind].entity:registerObject(index, position, object)
        else
            local x = (self.cell_width + self.margin) * (ind % self.columns)
            local y = (self.cell_height + self.margin) * (ind/self.columns - (ind / self.columns)%1)
            self:registerNewObject(ind, {fixedX = x, fixedY = y}, {width = self.cell_width, height = self.cell_height}, self)
            self.objects[ind].entity:registerObject(index, position, object)
        end
    end
end

-- Всем объектам надо уметь понимать случилась ли коллизия, причем не важно с мышкой или чем-то ещё
function UIobject:getCollision(x, y)
    return 	self.x < x and
            (self.x + self.width) > x and
            self.y < y and
            (self.y + self.height) > y
end

function UIobject:getObjectByIndex(index)
    local result
    for ind, obj in pairs(self.objects) do
        if ind == index then
            result = obj
        else
            if obj.entity.getObjectByIndex and obj.entity:getObjectByIndex(index) then
                result = obj.entity:getObjectByIndex(index) or result
            end
        end
    end
    return result
end

-- Указан отдельный объект чтобы логика указанная в Draw была сквозной, а опциональная была в render
function UIobject:changePosition(x, y)
    self.x, self.y = x, y
end

function UIobject:calculateFixedPosition(position, x, y)
    x = position.fixedX or x
    y = position.fixedY or y
    return x, y
end

function UIobject:calculateRelationalPosition(position, x, y)
    if position.left or position.right or position.up or position.down then
        x = x + (position.left or 0) + (self.width - (position.right or self.width))
        y = y + (position.up or 0) + (self.height - (position.down or self.height))
    end
    return x, y
end

function UIobject:calculatePositionWithAlign(position, x, y)
    if position.align == 'center' then
        x = self.width/2
        y = self.height/2
    elseif  position.align == 'right' then
        x = self.width
        y = self.height/2
    elseif  position.align == 'left' then
        x = x
        y = self.height/2
    elseif  position.align == 'up' then
        x = self.width/2
        y = y
    elseif  position.align == 'down' then
        x = self.width/2
        y = self.height
    end
    return x, y
end

function UIobject:calculateCoordinatesAndWriteToObject(position)
    position.x, position.y = 0, 0
    for ind, func in pairs(self.calculatePositionMethods) do
        position.x, position.y = func(self, position, position.x, position.y)
    end
end

-- Указан отдельный объект чтобы логика указанная в Draw была сквозной, а опциональная была в render
function UIobject:render()
end

-- Указан отдельный объект чтобы логика указанная в Draw была сквозной, а опциональная была в render
function UIobject:drawCells(color)
    local cell_width = (self.width - self.margin*(self.columns-1))/self.columns
    local cell_height = (self.height - self.margin*(self.rows-1))/self.rows
    love.graphics.setColor( color.r, color.g, color.b, 1 )
    for ind = 0, self.columns * self.rows - 1, 1 do
        local x = (cell_width + self.margin) * (ind % self.columns)
        local y = (cell_height + self.margin) * (ind/self.columns - (ind / self.columns)%1)
        love.graphics.rectangle( 'line', x, y, cell_width, cell_height )
    end
    love.graphics.setColor( 1, 1, 1, 1 )
end

function UIobject:drawBoxAroundObject(color, lineWidth, x, y)
    local x, y = x and x or 0, y and y or 0
    love.graphics.setColor( color.r, color.g, color.b, 1 )
    love.graphics.setLineWidth( lineWidth )
    love.graphics.rectangle( 'line', x, y, self.width, self.height )
    love.graphics.setLineWidth( 1 )
    love.graphics.setColor( 1, 1, 1, 1 )
end

function UIobject:showOriginalPoint(color)
    love.graphics.setColor( color.r, color.g, color.b, 1 )
    love.graphics.circle( 'fill', 0, 0, 4, 4 )
    love.graphics.setColor( 1, 1, 1, 1 )
end

function UIobject:debugDraw()
    self:showOriginalPoint({r = 1, g = 0, b = 0 })
    self:drawBoxAroundObject({r = 0, g = 1, b = 0 }, 4)
    self:drawCells({r = 0, g = 0, b = 1 })
end


function UIobject:getObject(id)
    return self.objects[id].entity
end

function UIobject:update(dt)
    for _, object in pairs(self.objects) do
        object.entity:update(dt)
    end
end

function UIobject:drawBackground()
    if self.background then
        local width, height = self.background:getDimensions()
        love.graphics.draw(self.background, 0, 0, 0, self.width/width, self.height/height )
    end
end

function UIobject:draw()
    self:drawBackground()
    self:render()
    for _, object in pairs(self.objects) do
        local transform = love.math.newTransform()
        transform = transform:translate(object.position.x - ( object.position.align and object.entity.width/2 or 0),
                                        object.position.y - ( object.position.align and object.entity.height/2 or 0))
        love.graphics.applyTransform( transform )
        object.entity:draw()
        local inverse = transform:inverse()
        love.graphics.applyTransform( inverse )
    end
    if Debug.drawUiDebug then
        self:debugDraw()
    end
end

function UIobject:addMousePressedEvent(index, condition, event)
    self.clickInteraction[index] = { condition = condition, func = event}
end

function UIobject:addMouseReleasedEvent(index, condition, event)
    self.releaseInteraction[index] = { condition = condition, func = event}
end

function UIobject:addWheelMovedEvent(index, condition, event)
    self.wheelInteraction[index] = { condition = condition, func = event}
end

function UIobject:addKeyPressedEvent(index, condition, event)
    self.keyInteraction[index] = { condition = condition, func = event}
end

function UIobject:mousepressed(x, y)
    local gx, gy = x, y
    for ind, object in pairs(self.objects) do
        local targetObject = object.entity
        local lx,ly = object.position.x - ( object.position.align and object.entity.width/2 or 0),
                      object.position.y - ( object.position.align and object.entity.height/2 or 0)
        for funcName, callback in pairs(targetObject.clickInteraction) do
            x, y = gx - lx, gy - ly
            if callback.condition(targetObject, gx, gy) then
                callback.func(targetObject, x, y)
            end
        end
    end
end

function UIobject:mousereleased(x, y)
    local gx, gy = x, y
    for ind, object in pairs(self.objects) do

        local targetObject = object.entity
        local lx,ly = object.position.x - ( object.position.align and object.entity.width/2 or 0),
                      object.position.y - ( object.position.align and object.entity.height/2 or 0)
        for funcName, callback in pairs(targetObject.releaseInteraction) do
            if callback.condition(targetObject, x, y) then
                x, y = gx - lx, gy - ly
                callback.func(targetObject, x, y)
            end
        end
    end
end

function UIobject:wheelmoved(x, y)
    for ind, object in pairs(self.objects) do
        local targetObject = object.entity
        for funcName, callback in pairs(targetObject.wheelInteraction) do
            if callback.condition(targetObject, x, y) then
                callback.func(targetObject, x, y)
            end
        end
    end
end

function UIobject:keypressed(key)
    for ind, object in pairs(self.objects) do
        local targetObject = object.entity
        for funcName, callback in pairs(targetObject.keyInteraction) do
            if callback.condition(targetObject, key) then
                callback.func(targetObject, key)
            end
        end
    end
end

return UIobject