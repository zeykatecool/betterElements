local ui = require("ui")
require("canvas")
local tween = require("tween")
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
    bgcolor = 0x242424FF;
})


local frame = betterElements:newFrame(canvas,{
    x = 10;
    y = 10;
    width = 250;
    height = 180;
    radius = 10;
    bgcolor = 0xC9C9C9FF;
    visible = true;
    transparency = 0;
    childs = {}
})

local rotatedLoadBar = betterElements:newRotatedLoadBar(canvas,{
    x = 270;
    y = 10;
    width = 10;
    height = 180;
    radius = 5;
    color = 0x5395faFF;
    bgcolor = 0xEAEDF6FF;
    percent = 0;
    visible = true;
    transparency = 1;
    userCanChange = true;
})

local checkBox = betterElements:newCheckBox(canvas,{
    x = 15;
    y = 15;
    width = 30;
    height = 30;
    radius = 25;
    checkedColor = 0x5395faFF;
    color = 0xEAEDF6FF;
    checkerThickness = 15;
    visible = true;
})
frame:addChild(checkBox)
frame:addChild(rotatedLoadBar)

checkBox.onClick = function()
    if rotatedLoadBar.transparency == 1 then
        tween.new(rotatedLoadBar,50,{transparency = 0},function ()
            
        end,tween.Easings.Linear):Play()
    else
        tween.new(rotatedLoadBar,50,{transparency = 1},function ()
            
        end,tween.Easings.Linear):Play()
    end
end


function mainWindow:onClose()
    program_config.Running = false
end
while program_config.Running do
    ui.update()
    tween:UpdateAll()
end

