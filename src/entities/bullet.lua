local Bullet = Class{}

function Bullet:init(x, y, a)
    self.x, self.y = x, y
    self.a = a
    self.dx, self.dy = math.cos(self.a), math.sin(self.a)
    self.speed = 200
    self.radius = 2
    self.isBullet = true
    self.hasCollided = false
    self.life = .2
    self.isRemoved = false

    self.body = HC.rectangle(x, y, 2, 1)
    self.body.entity = self
    self.body:setRotation(self.a)
end

function Bullet:update(dt, viewPort)
    local x = self.x + self.dx * dt * self.speed
    local y = self.y + self.dy * dt * self.speed

    self.x, self.y = x, y
    self.body:moveTo(self.x, self.y)

    if self.hasCollided then
        self.life = self.life - dt
        self.body:rotate(dt * 20)
        self.speed = 80
        if self.life <= 0 then self.isRemoved = true end
    else
        local collisions = HC.collisions(self.body)
        for collision, separating_vector in pairs(collisions) do
            if collision.entity and collision.entity.isWall then
                local vx, vy = Vec.normalize(separating_vector.x, separating_vector.y)
                self.dx, self.dy = vx, vy
                self.hasCollided = true
            end
        end
    end

    self.isRemoved = self.isRemoved or not viewPort:collidesWith(self.body)
end

function Bullet:draw()
    self.body:draw()
end

function Bullet:remove()
    HC.hash():remove(self.body)
end

return Bullet