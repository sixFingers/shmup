local Human = Class{}

function Human:init(x, y)
    self.x = x ~= nil and x or 0
    self.y = y ~= nil and y or 0
    self.bodySize = 3
    self.bodyOffsetX = 4
    self.bodyOffsetY = 12
    self.px = self.x
    self.py = self.y
    self.bodyDir = 3
    self.legsDir = 3
    self.previousBodyDir = nil
    self.previousLegsDir = nil
    self.dx = 0
    self.dy = 0
    self.speed = .5
    self.running = false

    self.body = HC.circle(0, 0, self.bodySize)
    self.body.entity = self
    self.body:moveTo(self.x, self.y)

    self.bodyTexture = love.graphics.newImage("assets/models/body.png")
    local bg = Anim8.newGrid(8, 16, self.bodyTexture:getWidth(), self.bodyTexture:getHeight())
    local ba = Anim8.newAnimation
    self.legsTexture = love.graphics.newImage("assets/models/legs.png")
    local lg = Anim8.newGrid(8, 16, self.legsTexture:getWidth(), self.legsTexture:getHeight())
    local la = Anim8.newAnimation
    local rate = 0.15

    self.bodyStates = {{
            idle = ba(bg(1, 3), rate),
            running = ba(bg("2-5", 3), rate)
        }, {
            idle = ba(bg(1, 2), rate),
            running = ba(bg("2-5", 2), rate)
        }, {
            idle = ba(bg(1, 1), rate),
            running = ba(bg("2-5", 1), rate)
        }, {
            idle = ba(bg(1, 2), rate):flipH(),
            running = ba(bg("2-5", 2), rate):flipH()
        }
    }

    self.legsStates = {{
            idle = la(lg(1, 3), rate),
            running = la(lg("2-5", 3), rate)
        }, {
            idle = la(lg(1, 2), rate),
            running = la(lg("2-5", 2), rate)
        }, {
            idle = la(lg(1, 1), rate),
            running = la(lg("2-5", 1), rate)
        }, {
            idle = la(lg(1, 2), rate):flipH(),
            running = la(lg("2-5", 2), rate):flipH()
        }
    }

    self.bodyState = self.bodyStates[3].idle
    self.legsState = self.legsStates[3].idle
end

function Human:rotate(dir)
    dir = math.min(dir, 4)

    self.bodyDir = dir
end

function Human:move(dx, dy)
    self.dx, self.dy = dx, dy

    if dy < 0 then self.legsDir = 1
    elseif dx > 0 then self.legsDir = 2
    elseif dy > 0 then self.legsDir = 3
    elseif dx < 0 then self.legsDir = 4
    end
end

function Human:update(dt)
    local substate = "idle"

    -- direction and animation state
    if self.dx ~= 0 or self.dy ~= 0 then
        self.x = self.x + self.dx * self.speed
        self.y = self.y + self.dy * self.speed
        substate = "running"
    else
        substate = "idle"
    end

    -- animation
    self.legsState = self.legsStates[self.legsDir][substate]
    if self.previousLegsDir ~= self.legsDir then self.legsState:gotoFrame(1) end
    self.legsState:update(dt)

    self.bodyState = self.bodyStates[self.bodyDir][substate]
    self.bodyState:gotoFrame(self.legsState.position)
    self.bodyState:update(dt)


    -- collisions
    self.body:moveTo(self.x, self.y)
    local collisions = HC.collisions(self.body)

    for other, separatingVector in pairs(collisions) do
        local entity = other.entity

        if entity and entity.isWall then
            self.x = self.x + separatingVector.x
            self.y = self.y + separatingVector.y
            self.dx = 0
            self.dy = 0
        end
    end

    -- pixel-perfect position
    self.px = self.dx > 0 and math.floor(self.x) or math.ceil(self.x)
    self.py = math.floor(self.y)

    self.previousBodyDir = self.bodyDir
    self.previousLegsDir = self.legsDir
end

function Human:draw()
    love.graphics.setColor(100, 100, 100, 50)
    local ox = self.legsDir == 2 and -1 or self.legsDir == 4 and 1 or 0
    love.graphics.circle("fill", self.px + ox, self.py + 1, 2)
    love.graphics.setColor(255, 255, 255, 255)

    self.legsState:draw(self.legsTexture, self.px - self.bodyOffsetX, self.py - self.bodyOffsetY)
    self.bodyState:draw(self.bodyTexture, self.px - self.bodyOffsetX, self.py - self.bodyOffsetY)
end

function Human:remove()
    HC.hash():remove(self.body)
end

return Human
