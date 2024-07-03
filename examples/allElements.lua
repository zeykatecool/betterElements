local ui = require("ui")
require("canvas")
local program_config = {
    Running = true;
}

local mainWindow = ui.Window("betterElements","raw",270,200)
mainWindow.bgcolor = 0x242424
mainWindow:center() mainWindow:show()

-----EXAMPLES STARTS FROM HERE-----

local betterElements = require("betterElements")

--Creating new BetterElement_Canvas
local canvas = betterElements:newCanvas(mainWindow,{
    bgcolor = 0x242424;
})

--Adding new frame
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

--Adding new button
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

--Adding new checkBox
local checkBox = betterElements:newCheckBox(canvas,{
    x = 135;
    y = 15;
    width = 30;
    height = 30;
    radius = 25;
    checkedColor = 0x5395faFF;
    color = 0xEAEDF6FF;
    checkerThickness = 10;
    visible = true;
})

--Adding new checkBox
local checkBox2 = betterElements:newCheckBox(canvas,{
    x = 170;
    y = 15;
    width = 30;
    height = 30;
    radius = 25;
    checkedColor = 0x5395faFF;
    color = 0xEAEDF6FF;
    checkerThickness = 10;
    visible = true;
})

--Adding new label
local label = betterElements:newLabel(canvas,{
    x = 10;
    y = 60;
    text = "Better Elements";
    font = "Consolas";
    fontweight = 200;
    fontstyle = "normal";
    fontsize = 28;
    textcolor = 0x5395faFF;
    visible = true;
})

--Adding new loadBar
local loadBar = betterElements:newLoadBar(canvas,{
    x = 10;
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

--Adding new iconButton
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

--Adding all elements to frame
frame:addChild(button)
frame:addChild(checkBox)
frame:addChild(checkBox2)
frame:addChild(label)
frame:addChild(loadBar)
frame:addChild(iconButton)


--Adding new border to checBbox
local newBorder = betterElements:setBorder(checkBox,{
    color = 0x000000FF;
    thickness = 1;
})


function mainWindow:onClose()
    program_config.Running = false
end
while program_config.Running do
    ui.update()
end

