local PixelCamera = Class{__includes = Camera}

function PixelCamera:init()
    self.camera = Camera(0, 0)
end

function PixelCamera:position()
    return self.camera:position()
end

function PixelCamera:worldCoords(x, y, resolution)
    local wx, wy = self.camera:worldCoords(x, y)
    local px, py = self:position()
    local dx, dy = wx - px, wy - py
    dx, dy = dx / resolution, dy / resolution
    px, py = px + dx, py + dy
    return px, py
end

function PixelCamera:lookAt(x, y)
    return self.camera:lookAt(x, y)
end

function PixelCamera:attach(x, y, w, h)
    return self.camera:attach(x, y, w, h)
end

function PixelCamera:detach()
    return self.camera:detach()
end

return PixelCamera