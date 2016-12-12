local state = {}

function state:init()
    self.renderer = Core.Renderer()
    self.scene = Core.Scene()
    self.renderList = {}
    self.camera = Core.Camera()

    self.scene:loadLevel(Levels.Dev)
    self.player = Core.Assets.factory("soldier", -30, -30)
    self.scene:addModels(self.player)

    self.mouseMoved = false

    local joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
end

function state:mousepressed(x, y, mouse_btn)
    local wx, wy = self.camera:worldCoords(x, y, self.renderer.resolution)
    local px, py = self.player.x, self.player.y
    local dx, dy = wx - px, wy - py
    local a = math.atan2(dy, dx)
    local bullet = Entities.Bullet(px, py, a)

    self.scene:addModels(bullet)
end

function state:mousemoved(x, y)
    x, y = self.camera:worldCoords(x, y, self.renderer.resolution)
    local dx, dy = x - self.player.x, y - self.player.y
    local a = math.atan2(dy, dx)
    local dir = math.floor((a + math.pi) / (math.pi * 2) * 4 + 1)
    self.player:rotate(dir)
    self.mouseMoved = true
end

function state:wheelmoved(x, y)
end

function state:mousereleased(x, y, mouse_btn)
end

function state:keypressed(code, scan, isRepeat)
    if code == "w" then
        self.player:rotate(1)
    elseif code == "d" then
        self.player:rotate(2)
    elseif code == "s" then
        self.player:rotate(3)
    elseif code == "a" then
        self.player:rotate(4)
    end
end

function state:textinput(t)
end

function state:keyreleased(code, scan, isRepeat)
end

function state:update(dt)
    -- input
    local isDown = love.keyboard.isDown

    if isDown("w") then
        self.player:move(0, -1)
    elseif isDown("d") then
        self.player:move(1, 0)
    elseif isDown("s") then
        self.player:move(0, 1)
    elseif isDown("a") then
        self.player:move(-1, 0)
    else
        self.player:move(0, 0)
    end

    self.mouseMoved = false

    -- if joystick ~= nil then
    --     local jx = joystick:getGamepadAxis("leftx")
    --     local jy = joystick:getGamepadAxis("lefty")
    --     local a = math.atan2(jy, jx)
    --     self.player:setRotation(a)

    --     if joystick:isGamepadDown("a") then
    --         self.player.running = true
    --     else
    --         self.player.running = false
    --     end
    -- end

    -- scene update
    self.scene:update(dt, self.renderer.viewPort)
    -- print("scene count: ", self.scene.modelCount)

    -- camera
    self.camera:lockPosition(self.player.px, self.player.py)

    -- render list
    self.renderList = self.renderer:getEntitiesInViewport(self.camera)
end

function love.gamepadpressed(joystick, button)
    print(joystick, button)
end

function state:draw()
    self.renderer:draw(self.scene.static, self.camera, self.player.px, self.player.py)
    self.renderer:draw(self.renderList, self.camera, self.player.px, self.player.py)

    -- stats
    love.graphics.print("Mem: ~" .. math.floor(collectgarbage('count')) .. "kb", 10, 10)
    love.graphics.print("Fps: " .. love.timer.getFPS(), 200, 10)
end

return state
