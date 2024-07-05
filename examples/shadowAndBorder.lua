local ui = require("ui")
require("canvas")
local program_config = {
    Running = true;
}


local mainWindow = ui.Window("ZEN","raw",750,600)
mainWindow.bgcolor = 0x242424
mainWindow:center() mainWindow:show()
local function print(...)
    require("console").writeln(...)
end


local betterElements = require("betterElements")

local canvas = betterElements:newCanvas(mainWindow,{
    bgcolor = 0x242424;
})


local frame = betterElements:newFrame(canvas,{
    x = 10;
    y = 10;
    width = 250;
    height = 180;
    radius = 10;
    bgcolor = 0xC9C9C9FF;
    visible = true;
    childs = {}
})

local borderFrame = betterElements:setBorder(frame,{
    color = 0xeb4034FF;
    thickness = 1;
    visible = true;
})

local shadowFrame = betterElements:setShadow(frame,{
    color = 0x000000FF;
    thickness = 3;
    visible = true;
    offsetX = 2;
    offsetY = 1;
})



function mainWindow:onClose()
    program_config.Running = false
end
while program_config.Running do
    ui.update()
end

