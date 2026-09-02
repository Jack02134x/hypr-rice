------------------------------------------------------------
-- Workspace Swipe
------------------------------------------------------------

hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace",
})

------------------------------------------------------------
-- Network Workspace
------------------------------------------------------------

hl.gesture({
    fingers = 4,
    direction = "up",
    action = "special",
    workspace_name = "network_social",
})

------------------------------------------------------------
-- Resize
------------------------------------------------------------

hl.gesture({
    fingers = 3,
    direction = "left",
    mods = "SUPER",
    action = "resize",
})

hl.gesture({
    fingers = 3,
    direction = "right",
    mods = "SUPER",
    action = "resize",
})

hl.gesture({
    fingers = 3,
    direction = "up",
    mods = "SUPER",
    action = "resize",
})

hl.gesture({
    fingers = 3,
    direction = "down",
    mods = "SUPER",
    action = "resize",
})

------------------------------------------------------------
-- Move Window
------------------------------------------------------------

hl.gesture({
    fingers = 3,
    direction = "left",
    action = "move",
})

hl.gesture({
    fingers = 3,
    direction = "right",
    action = "move",
})

hl.gesture({
    fingers = 3,
    direction = "up",
    action = "move",
})

hl.gesture({
    fingers = 3,
    direction = "down",
    action = "move",
})

------------------------------------------------------------
-- Cursor Zoom
------------------------------------------------------------

-- hl.gesture({ fingers = 2, direction = "pinch", action = "cursorZoom", zoom_level = 2 })
-- hl.gesture({ fingers = 2, direction = "pinch", action = "cursorZoom", zoom_level = 1.2, mode = "mult" })
hl.gesture({ fingers = 2, direction = "pinch", mods = "SUPER", action = "cursorZoom", zoom_level = 1, mode = "live" })