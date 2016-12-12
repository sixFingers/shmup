local Model = Class{}

Model.blueprints = {
    tent = {24, 32, 16},
    jeep = {32, 32, 16},
    compound = {32, 32, 16},
    station = {45, 45, 45}
}

Model.cache = {}
Model.textures = {}

function Model.buildMesh(name, width, height)
    if not Model.textures[name] then
        local texture = love.graphics.newImage("assets/models/" .. name .. ".png", {mipmaps = false})
        texture:setFilter("nearest", "nearest")
        Model.textures[name] = texture
    end

    local texture = Model.textures[name]
    local box = Model.blueprints[name]
    local half_tex_width, half_tex_height = box[1] / 2, box[2] / 2
    local depth = box[3]
    local half_width = width ~= nil and width / 2 or half_tex_width
    local half_height = height ~= nil and height / 2 or half_tex_height

    local format = {
        {"VertexPosition", "float", 3},
        {"VertexTexCoord", "float", 2},
        {"VertexNormal", "float", 3},
        {"VertexColor", "byte", 4}
    }
    local vertices = {}
    local perspective = 2
    local u_offset = 1 / depth
    local u_pixel = 1 / CANVAS_HEIGHT * perspective

    for l = 0, depth - 1 do
        local u = u_offset * l
        local ny = l / (depth - 1)
        local z = l * u_pixel
        local d = (l / (depth - 1) + .2) * 255
        -- enable for depth shading
        -- d = math.min(d, 255)
        d = 255

        table.insert(vertices, {
            -half_width, -half_height, z,
            u + u_offset, 0,
            -.5, ny, -.5,
            d, d, d, 255,
            })

        table.insert(vertices, {
            half_width, -half_height, z,
            u, 0,
            .5, ny, -.5,
            d, d, d, 255,
        })

        table.insert(vertices, {
            half_width, half_height, z,
            u, 1,
            .5, ny, .5,
            d, d, d, 255,
        })

        table.insert(vertices, {
            -half_width, -half_height, z,
            u + u_offset, 0,
            -.5, ny, -.5,
            d, d, d, 255,
        })

        table.insert(vertices, {
            half_width, half_height, z,
            u, 1,
            .5, ny, .5,
            d, d, d, 255,
        })

        table.insert(vertices, {
            -half_width, half_height, z,
            u + u_offset, 1,
            -.5, ny, .5,
            d, d, d, 255,
        })
    end

    local mesh = love.graphics.newMesh(format, vertices, "triangles")
    mesh:setTexture(texture)

    return mesh
end

function Model:init(name)
    if not Model.cache[name] then
        local mesh = Model.buildMesh(name)
        Model.cache[name] = mesh
    end

    self.mesh = Model.cache[name]
    self.w, self.d, self.h = unpack(Model.blueprints[name])
    self.rotation = 0
end

return Model