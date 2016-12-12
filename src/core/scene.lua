local Scene = Class{}

function Scene:init()
    self.models = {}
    self.static = {}
    self.count = 0
end

function Scene:loadLevel(level)
    for _, args in ipairs(level.statics) do
        local static = Core.Assets.factory(unpack(args))
        self:addStatics(static)
    end

    for _, args in ipairs(level.models) do
        local model = Core.Assets.factory(unpack(args))
        self:addModels(model)
    end
end

function Scene:addStatics(...)
    local nargs = select('#', ...)

    for m = 1, nargs do
        local model = select(m, ...)
        table.insert(self.static, model)
    end
end

function Scene:addModels(...)
    local nargs = select('#', ...)

    for m = 1, nargs do
        local model = select(m, ...)
        self.models[model] = model
    end

    self.count = self.count + nargs
end

function Scene:removeModels(...)
    local nargs = select('#', ...)
    for m = 1, nargs do
        local model = select(m, ...)
        model:remove()
        self.models[model] = nil
    end

    self.count = math.max(self.count - nargs, 0)
end

function Scene:update(dt, viewPort)
    for model in pairs(self.models) do
        model:update(dt, viewPort)

        if model.isRemoved then
            self:removeModels(model)
        end
    end
end

return Scene