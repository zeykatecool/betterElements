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
local button = betterElements:newButton(canvas,{
    x = 0;
    y = 0;
    width = 110;
    height = 25;
    radius = 7;
    textcolor = 0x5395faFF;
    fontsize = 14;
    color = 0xEAEDF6FF;
    cursorSet = true;
    text = "Button";
    visible = true;
})

local a = true
frame:addChild(button)
button.onClick = function()
    if a then
        a = false
        frame:removeChild(button)
    else
        a = true
        frame:addChild(button)
    end
end



function mainWindow:onClose()
    program_config.Running = false
end
while program_config.Running do
    ui.update()
end

