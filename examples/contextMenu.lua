local ui = require("ui")
require("canvas")
local betterElements = require("betterElements")
local program_config = {
    Running = true;
}


local mainWindow = ui.Window("ZEN","raw",700,600)
mainWindow.bgcolor = betterElements:HEXtoColor("#383838",0)
mainWindow:center() mainWindow:show()

function mainWindow:onKey(k)
    if k == "VK_ESCAPE" then
        program_config.Running = false
    end
end

local canvas = betterElements:newCanvas(mainWindow,{
    bgcolor = betterElements:HEXtoColor("#4B4B4B",0);
})

local offsetX, offsetY = 0, 0
local mwe = {}

local frame = betterElements:newFrame(canvas,{
    name = "frame",
    x = 0,
    y = 0,
    width = 250,
    height = 100,
    radius = 10,
    bgcolor = betterElements:HEXtoColor("#292929",0),
    visible = true,
    user_moving = false,
})
table.insert(mwe,frame)



frame.onClick = function()
    frame.user_moving = true
    local mx, my = ui.mousepos()
    offsetX = mx - frame.x - mainWindow.x
    offsetY = my - frame.y - mainWindow.y
end

frame.onMouseUp = function()
    frame.user_moving = false
end

local cm = nil
function canvas:onContext()
    if betterElements:isMouseOnElement(mainWindow, frame) then
        if cm then
            betterElements:Destroy(cm)
        end
        local x,y = ui.mousepos()
        x,y = x - mainWindow.x, y - mainWindow.y
        local contextMenu = betterElements:newFrame(canvas, {
            name = "contextMenu",
            x = x,
            y = y,
            width = 100,
            height = 100,
            radius = 10,
            bgcolor = betterElements:HEXtoColor("#BEBEBE",0),
            visible = true,
            user_moving = false,
        })
        cm = contextMenu
    end
end

canvas.onSignal = function(signal)
    if signal == "click" then
        if cm then
            betterElements:Destroy(cm)
        end
    end
end

local function updateMovingElements()
    for _, v in ipairs(mwe) do
        if v.user_moving then
            local mx, my = ui.mousepos()
            v.x = mx - offsetX - mainWindow.x
            v.y = my - offsetY - mainWindow.y
        end
    end
end

function mainWindow:onClose()
    program_config.Running = false
end

while program_config.Running do
    ui.update()
    updateMovingElements()
end
