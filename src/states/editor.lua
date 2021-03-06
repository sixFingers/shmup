local state = {}

function state:init()
    self.renderer = Core.Renderer()
    self.scene = Core.Scene()
    self.renderList = {}
    self.camera = Core.Camera()

    self.level = {
        statics = {},
        models = {}
    }
end

function state:mousepressed(x, y, mouse_btn)
end

function state:wheelmoved(x, y)
end

function state:mousereleased(x, y, mouse_btn)
end

function state:keypressed(code, scan, isRepeat)
end

function state:textinput(t)
end

function state:keyreleased(code, scan, isRepeat)
end

function state:update(dt)

end

function state:draw()

end

return state
