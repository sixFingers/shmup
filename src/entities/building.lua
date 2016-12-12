local Building = Class{}

function Building:init(name, x, y, a)
    self.x = x ~= nil and x or 0
    self.y = y ~= nil and y or 0
    self.a = a ~= nil and a or math.pi * 1.5
    self.isWall = true

    self.model = Core.Model(name)
    self.modelRotation = self.a

    -- collision body
    local collisionBoxWidth, collisionBoxHeight = Core.Assets.collisionBox(name)
    self.body = HC.rectangle(self.x - collisionBoxWidth / 2, self.y - collisionBoxHeight / 2, collisionBoxWidth, collisionBoxHeight)
    self.body:setRotation(self.a)
    self.body.entity = self
    self.body.isSolid = true

    -- visual body
    local w, h = self.model.w * 1.5, self.model.d * 1.5
    self.cull = HC.rectangle(self.x - w / 2, self.y - h / 2, w, h)
    self.cull.entity = self
    self.cull.isCull = true
end

function Building:update(dt)
end

function Building:draw(debug)
    if debug then
        self.body:draw()
        self.cull:draw()
    end

    love.graphics.draw(self.model.mesh, self.x, self.y, self.modelRotation)
end

function Building:remove()
    HC.hash():remove(self.body)
end

return Building