local Model = Class{}

Model.cache = {}
Model.textures = {}

function Model.buildMesh(name, width, depth)
    local texture = Core.Assets.texture(name)
    local tex_width, tex_height, height = Core.Assets.bbox(name)
    local half_tex_width, half_tex_height = tex_width / 2, tex_height / 2
    local half_width = width ~= nil and width / 2 or half_tex_width
    local half_depth = depth ~= nil and depth / 2 or half_tex_height

    local format = {
        {"VertexPosition", "float", 3},
        {"VertexTexCoord", "float", 2},
        {"VertexNormal", "float", 3},
        {"VertexColor", "byte", 4}
    }
    local vertices = {}
    local perspective = 2
    local u_offset = 1 / height
    local u_pixel = 1 / CANVAS_HEIGHT * perspective

    for l = 0, height - 1 do
        local u = u_offset * l
        local ny = l / (height - 1)
        local z = l * u_pixel
        local d = (l / (height - 1) + .2) * 255
        -- enable for height shading
        -- d = math.min(d, 255)
        d = 255

        table.insert(vertices, {
            -half_width, -half_depth, z,
            u + u_offset, 0,
            -.5, ny, -.5,
            d, d, d, 255,
            })

        table.insert(vertices, {
            half_width, -half_depth, z,
            u, 0,
            .5, ny, -.5,
            d, d, d, 255,
        })

        table.insert(vertices, {
            half_width, half_depth, z,
            u, 1,
            .5, ny, .5,
            d, d, d, 255,
        })

        table.insert(vertices, {
            -half_width, -half_depth, z,
            u + u_offset, 0,
            -.5, ny, -.5,
            d, d, d, 255,
        })

        table.insert(vertices, {
            half_width, half_depth, z,
            u, 1,
            .5, ny, .5,
            d, d, d, 255,
        })

        table.insert(vertices, {
            -half_width, half_depth, z,
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
    self.mesh = Core.Assets.mesh(name)
    self.w, self.d, self.h = Core.Assets.bbox(name)
    self.rotation = 0
end

return Model