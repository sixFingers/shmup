local Building = Class{}

Building.definitions = {
    tent = {24, 32, 16},
    jeep = {32, 32, 32},
    station = {45, 45, 45}
}

function Building:init(name, x, y, a)
    self.x = x ~= nil and x or 0
    self.y = y ~= nil and y or 0
    self.a = a ~= nil and a or math.pi * 1.5
    self.isWall = true

    self.model = Core.Model(name)
    self.modelRotation = self.a

    local definition = Building.definitions[name]
    if not definition then return end

    local w, h = definition[1], definition[2]
    self.body = HC.rectangle(self.x - w / 2, self.y - h / 2, w, h)
    self.body:setRotation(self.a)
    self.body.entity = self
end

function Building:update(dt)
end

function Building:draw()
    love.graphics.draw(self.model.mesh, self.x, self.y, self.modelRotation)
end

function Building:remove()
    HC.hash():remove(self.body)
end

return Building