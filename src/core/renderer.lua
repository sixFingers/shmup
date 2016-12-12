local Renderer = Class{}

function Renderer:init()
    love.graphics.setLineStyle("rough")
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setBackgroundColor(166, 164, 139)

    self.shader = love.graphics.newShader("assets/shaders/default.glsl")
    self.canvas = love.graphics.newCanvas(CANVAS_WIDTH, CANVAS_HEIGHT)
    self.resolution = math.floor(SCREEN_HEIGHT / CANVAS_HEIGHT)
    self.ox = (SCREEN_WIDTH - CANVAS_WIDTH * self.resolution) / 2
    self.oy = (SCREEN_HEIGHT - CANVAS_HEIGHT * self.resolution) / 2
    self.viewPort = HC.rectangle(0, 0, CANVAS_WIDTH - 1, CANVAS_HEIGHT - 1)
    self.debug = true

    print("Pixel resolution: ", self.resolution)
end

function Renderer:getEntitiesInViewport(camera)
    self.viewPort:moveTo(camera:position())

    local entities = {}
    local collisions = HC.collisions(self.viewPort)
    local c = 0

    for other in pairs(collisions) do
        if other.isCull then
            local entity = other.entity
            c = c + 1

            if entity then
                table.insert(entities, entity)
            end
        end
    end

    return entities
end

function Renderer:draw(entities, camera, x, y)
    -- canvas clear
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()

    -- shader
    love.graphics.setShader(self.shader)

    -- camera
    camera:attach(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT)

    -- print("Culled: ", c)

    -- depth sorting
    table.sort(entities, function(a, b)
        return a.y * 1000 + a.x < b.y * 1000 + b.x
    end)

    -- draw
    for e, entity in ipairs(entities) do
        entity:draw(self.debug)
    end

    -- print("Draws: ", #list)

    -- debug
    self.viewPort:draw()

    -- reset state
    camera:detach()
    love.graphics.setShader()

    -- blit
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.ox, self.oy, 0, self.resolution, self.resolution)
end

return Renderer