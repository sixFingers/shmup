local Road = Class{}

function Road:init(name, points)
    self.pathRadius = 30
    self.path = {}

    for p = 1, #points do
        table.insert(self.path, points[p][1])
        table.insert(self.path, points[p][2])
    end
end

function Road:update()
end

function Road:draw()
    love.graphics.setLineWidth(self.pathRadius * 2)
    love.graphics.setColor(0, 0, 0, 20)
    love.graphics.line(self.path)
    love.graphics.setLineWidth(self.pathRadius * 2 - 3)
    love.graphics.setColor(255, 255, 255, 110)
    love.graphics.line(self.path)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)
end

return Road