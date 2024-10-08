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
    userCanChange = true;
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

local checkBox = betterElements:newCheckBox(canvas,{
    x = 135;
    y = 15;
    width = 30;
    height = 30;
    radius = 25;
    checkedColor = 0x5395faFF;
    color = 0xEAEDF6FF;
    checkerThickness = 15;
    visible = true;
})

local checkBox2 = betterElements:newCheckBox(canvas,{
    x = 170;
    y = 15;
    width = 30;
    height = 30;
    radius = 25;
    checkedColor = 0x5395faFF;
    color = 0xEAEDF6FF;
    checkerThickness = 15;
    visible = true;
})

local label = betterElements:newLabel(canvas,{
    x = 10;
    y = 60;
    text = "Better Elements";
    font = "Segoe UI";
    fontweight = 200;
    fontstyle = "normal";
    fontsize = 28;
    textcolor = 0x5395faFF;
    visible = true;
})

local loadBar = betterElements:newLoadBar(canvas,{
    x = 8;
    y = 100;
    width = 230;
    height = 15;
    radius = 5;
    color = 0x5395faFF;
    bgcolor = 0xEAEDF6FF;
    percent = 0;
    visible = true;
    userCanChange = true;
})

betterElements:setBorder(loadBar,{
    color = 0xEAEDF6FF;
    thickness = 4;
    visible = true;
})

local iconButton = betterElements:newIconButton(canvas,{
    x = 10;
    y = 130;
    width = 40;
    height = 40;
    radius = 10;
    icon = "home.png";
    visible = true;
    color = 0xEAEDF6FF;
    cursorSet = true;
})


frame:addChild(checkBox)
frame:addChild(checkBox2)
frame:addChild(label)
frame:addChild(loadBar)
frame:addChild(iconButton)
frame.zindex = 1



local button = betterElements:newButton(canvas,{
    x = 10;
    y = 18;
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




local newFrame = betterElements:newFrame(canvas,{
    x = 10;
    y = 10;
    width = 250;
    height = 180;
    radius = 10;
    bgcolor = 0xC9C9C9FF;
    visible = true;
    childs = {}
})

newFrame.zindex = 5



frame:addChild(button)

local newBorder = betterElements:setBorder(checkBox,{
    color = 0x000000FF;
    thickness = 1;
})
local shadowOfButton = betterElements:setShadow(button,{
    color = 0x000000FF;
    thickness = 1;
    visible = true;
    offsetX = 0;
    offsetY = 1;
})




rotatedLoadBar.onChanged = function()
    betterElements:Destroy(newFrame)
end



function mainWindow:onClose()
    program_config.Running = false
end
while program_config.Running do
    ui.update()
end

