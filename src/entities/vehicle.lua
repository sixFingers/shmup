local Vehicle = Class{}

function Vehicle:init()
    self.x = 0
    self.y = 0
    self.a = 0
    self.dx = math.cos(self.a)
    self.dy = math.sin(self.a)
    self.rotationSpeed = 0
    self.minRotationSpeed = 1
    self.maxRotationSpeed = 5
    self.thrust = 0
    self.maxThrust = 5
    self.acceleration = 5
    self.friction = 10
    self.thrusting = false

    self.model = Core.Model("jeep")
    self.model.rotation = self.a + math.pi / 2
end

function Vehicle:setRotation(a)
    self.a = a
    self.dx = math.cos(self.a)
    self.dy = math.sin(self.a)
    self.modelRotation = self.a + math.pi / 2
end

function Vehicle:rotate(d)
    local a = self.a + d * self.rotationSpeed
    self:setRotation(a)
end

function Vehicle:update(dt)
    if self.thrusting then
        self.thrust = math.min(self.thrust + self.acceleration * dt, self.maxThrust)
    else
        self.thrust = math.max(self.thrust - self.friction * dt, 0)
    end

    local rotationSpeed = self.maxRotationSpeed * (1 - self.thrust / self.maxThrust)
    self.rotationSpeed = math.max(self.minRotationSpeed, rotationSpeed)

    self.x = self.x + self.dx * self.thrust * 4
    self.y = self.y + self.dy * self.thrust * 4
    self.model.x = self.x
    self.model.y = self.y
end

function Vehicle:draw()
    love.graphics.draw(self.model.mesh, self.x, self.y, self.modelRotation)
end

function Vehicle:remove()
    -- HC.hash():remove(self.body)
end

return Vehicle