local Assets = {}

Assets.bboxes = {
    tent = {24, 32, 16},
    jeep = {32, 32, 16},
    compound = {32, 32, 16},
    station = {45, 45, 45}
}

Assets.collisionBoxes = {
    tent = {24, 28},
    jeep = {26, 26},
    compound = {32, 32},
    station = {45, 455}
}

Assets.cache = {
    meshes = {},
    textures = {},
}

Assets.ids = {
    tent = Entities.Building,
    jeep = Entities.Building,
    road = Entities.Road,
    soldier = Entities.Human,
}

function Assets.bbox(name)
    return unpack(Assets.bboxes[name])
end

function Assets.collisionBox(name)
    return unpack(Assets.collisionBoxes[name])
end

function Assets.mesh(name)
    if not Assets.cache.meshes[name] then
        local mesh = Core.Model.buildMesh(name)
        Assets.cache.meshes[name] = mesh
    end

    return Assets.cache.meshes[name]
end

function Assets.texture(name)
    if not Assets.cache.textures[name] then
        local texture = love.graphics.newImage("assets/models/" .. name .. ".png", {mipmaps = false})
        texture:setFilter("nearest", "nearest")
        Assets.cache.textures[name] = texture
    end

    return Assets.cache.textures[name]
end

function Assets.factory(...)
    local name = select(1, ...)

    return Assets.ids[name](...)
end

return Assets