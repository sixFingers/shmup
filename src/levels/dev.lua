local Level = {}

Level.models = {
    {"tent", 0, 0, math.pi + .5},
    {"jeep", -30, 50, math.pi / 4 * 3},
    {"tent", 50, 40, math.pi / 4 * 3},
}

Level.statics = {
    {"road", {{0, 0}, {100, 30}, {120, 130}, {70, 150}, {30, 90}}}
}

return Level