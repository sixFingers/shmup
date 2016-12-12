function love.load()
    Class = require("lib/hump/class")
    Gamestate = require("lib/hump/gamestate")
    Camera = require("lib/hump/camera")
    Vec = require("lib/hump/vector-light")
    Anim8 = require("lib/anim8/anim8")
    HC = require("lib/hc")
    Loader = require("src/loader")

    States = Loader.includeNamespace("src/states", "empty", "basic")
    Core = Loader.includeNamespace("src/core", "renderer", "camera", "scene", "model")
    Entities = Loader.includeNamespace("src/entities", "building", "human", "vehicle", "bullet", "road")

    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
    CANVAS_WIDTH, CANVAS_HEIGHT = 320, 240

    Gamestate.registerEvents()
    Gamestate.switch(States.Basic)
end
