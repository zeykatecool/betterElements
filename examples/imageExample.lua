local ui = require("ui")
require("canvas")
local tween = require("modules.tween")
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
    bgcolor = 0xFFFFFFFF;
})



local image = betterElements:newImage(canvas,{
    x = 10;
    y = 10;
    image = "home.png";
    visible = true;
    transparency = 0;
    width = 50;
    height = 50;
    zindex = 1;
})
-- Original file is 32x32 but we are making width and height 50.
-- WARNING:  This reduces image quality. 


function mainWindow:onKey(k)
    if k == "VK_ESCAPE" then
        program_config.Running = false
    end
end

function mainWindow:onClose()
    program_config.Running = false
end
while program_config.Running do
    ui.update()
    tween:UpdateAll()
end

