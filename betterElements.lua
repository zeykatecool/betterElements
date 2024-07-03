local ui = require("ui")
local BetterElements = {}
local elements = {}
local borders = {}
local mainWindow = nil

local module_config = {
    drawingAll = false;
    extraOnPaintFunc = function(element) end;
    isHoverChangingMouseCursor = {
        changer = nil;
        changing = false;
    }
}

local function randomName()
    local chars = {}
    for i=1,5 do
        local num = math.random(97,122)
        table.insert(chars, string.char(num))
    end
    return table.concat(chars)
end

local function drawRectangle(canvas, x, y, width, height, radiusx, radiusy, brush)
    canvas:fillroundrect(x , y , x + width , y + height, radiusx, radiusy, brush)
end

local function drawBorder(canvas, x, y, width, height, radiusx, radiusy, brush, thickness)
    canvas:roundrect(x , y , x + width , y + height, radiusx, radiusy, brush, thickness)
end

function BetterElements:newButton(canvas,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newButton' (table expected, got "..type(tbl)..")")
    end
    if canvas.type ~= "BetterElement_Canvas" then
        error("TypeError: bad argument #1 to 'newButton' (BetterElement_Canvas expected, got "..type(canvas)..")")
    end
    local button = {}
    button.name = tbl.name or randomName()
    button.x,button.y = tbl.x or 0,tbl.y or 0
    button.width = tbl.width or 0
    button.height = tbl.height or 0
    button.radius = tbl.radius or 0
    button.text = tbl.text or "Button"
    button.color = tbl.color or 0x000000FF
    button.font = tbl.font or "Consolas"
    button.fontweight = tbl.fontweight or 200
    button.fontstyle = tbl.fontstyle or "normal"
    button.fontsize = tbl.fontsize or 10
    button.textcolor = tbl.textcolor or 0x000000FF
    if not button.cursorSet then
        button.cursorSet = true
    end
    button.cursorSet = tbl.cursorSet
    button.visible = tbl.visible
    button.type = "BetterElement_Button"
    button.isMouseHovering = false;
    button.onClick = tbl.onClick or function() end
    button.onHover = tbl.onHover or function() end
    button.onLeave = tbl.onLeave or function() end
    table.insert(elements,button)
    return button
end

function BetterElements:newCheckBox(canvas,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newCheckBox' (table expected, got "..type(tbl)..")")
    end
    if canvas.type ~= "BetterElement_Canvas" then
        error("TypeError: bad argument #1 to 'newCheckBox' (BetterElement_Canvas expected, got "..type(canvas)..")")
    end
    local checkbox = {}
    checkbox.name = tbl.name or randomName()
    checkbox.x,checkbox.y = tbl.x or 0,tbl.y or 0
    checkbox.width = tbl.width or 20
    checkbox.height = tbl.height or 20
    checkbox.radius = tbl.radius or 0
    checkbox.checked = tbl.checked or false
    checkbox.color = tbl.color or 0x000000FF
    checkbox.checkedColor = tbl.checkedColor or 0x0000FF00
    checkbox.type = "BetterElement_CheckBox"
    checkbox.onClick = tbl.onClick or function() end
    checkbox.onHover = tbl.onHover or function() end
    checkbox.onLeave = tbl.onLeave or function() end
    checkbox.checkerThickness = tbl.checkerThickness or 2
    checkbox.isMouseHovering = false;
    checkbox.visible = tbl.visible
    table.insert(elements,checkbox)
    return checkbox
end

function BetterElements:newLabel(canvas,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newLabel' (table expected, got "..type(tbl)..")")
    end
    if canvas.type ~= "BetterElement_Canvas" then
        error("TypeError: bad argument #1 to 'newLabel' (BetterElement_Canvas expected, got "..type(canvas)..")")
    end
    local label = {}
    label.name = tbl.name or randomName()
    label.x,label.y = tbl.x or 0,tbl.y or 0
    label.text = tbl.text or "Label"
    label.font = tbl.font or "Consolas"
    label.fontweight = tbl.fontweight or 200
    label.fontstyle = tbl.fontstyle or "normal"
    label.fontsize = tbl.fontsize or 10
    label.textcolor = tbl.textcolor or 0x000000FF
    label.visible = tbl.visible
    label.onHover = tbl.onHover or function() end
    label.onLeave = tbl.onLeave or function() end
    label.type = "BetterElement_Label"
    table.insert(elements,label)
    return label
end

local function checkIfPictureExists(icon)
local sys = require("sys")
    local file = sys.File(icon)
    if file.exists then
        return true
    else
        error("TypeError: bad argument #1 to 'newButton' (File not found: "..icon..")")
    end
end

function BetterElements:newIconButton(canvas,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newIconButton' (table expected, got "..type(tbl)..")")
    end
    if canvas.type ~= "BetterElement_Canvas" then
        error("TypeError: bad argument #1 to 'newIconButton' (BetterElement_Canvas expected, got "..type(canvas)..")")
    end
    local iconbutton = {}
    iconbutton.name = tbl.name or randomName()
    iconbutton.x,iconbutton.y = tbl.x or 0,tbl.y or 0
    iconbutton.width = tbl.width or 20
    iconbutton.height = tbl.height or 20
    iconbutton.radius = tbl.radius or 0
    iconbutton.color = tbl.color or 0x000000FF
    checkIfPictureExists(tbl.icon)
    iconbutton.icon = tbl.icon
    iconbutton.type = "BetterElement_IconButton"
    iconbutton.onClick = tbl.onClick or function() end
    iconbutton.onHover = tbl.onHover or function() end
    iconbutton.onLeave = tbl.onLeave or function() end
    if not iconbutton.cursorSet then
        iconbutton.cursorSet = true
    end
    iconbutton.cursorSet = tbl.cursorSet
    iconbutton.isMouseHovering = false;
    iconbutton.visible = tbl.visible
    table.insert(elements,iconbutton)
    return iconbutton
end

function BetterElements:newFrame(canvas, tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newFrame' (table expected, got "..type(tbl)..")")
    end
    if canvas.type ~= "BetterElement_Canvas" then
        error("TypeError: bad argument #1 to 'newFrame' (BetterElement_Canvas expected, got "..type(canvas)..")")
    end

    local frame = {}
    frame.name = tbl.name or randomName()
    frame.width = tbl.width or 0
    frame.height = tbl.height or 0
    frame.radius = tbl.radius or 0
    frame.bgcolor = tbl.bgcolor or 0x000000FF
    if tbl.visible == nil then
        tbl.visible = true
    end
    frame.visible = tbl.visible
    frame.onHover = tbl.onHover or function() end
    frame.onLeave = tbl.onLeave or function() end
    frame.onClick = tbl.onClick or function() end
    frame.childs = tbl.childs or {}

    local originalPositionOfChild = {}
    function frame:addChild(element)
        if not element.type then
            error("TypeError: bad argument #1 to 'newFrame' (BetterElement_ELEMENT expected for child, got " .. type(element) .. ")")
        else
            table.insert(frame.childs,element)
            originalPositionOfChild[element] = {x = element.x, y = element.y}
            local value = element
            local positionaccordingtoFrameAndWindowX, positionaccordingtoFrameAndWindowY = value.x + frame.x, value.y + frame.y
            value.x, value.y = positionaccordingtoFrameAndWindowX, positionaccordingtoFrameAndWindowY
        end
    end

    function frame:removeChild(element)
        if not element.type then
            error("TypeError: bad argument #1 to 'newFrame' (BetterElement_ELEMENT expected for child, got " .. type(element) .. ")")
        else
            for i, v in ipairs(frame.childs) do
                if v == element then
                    table.remove(frame.childs, i)
                    table.remove(originalPositionOfChild, element)
                end
            end
        end
    end

    local function checkIfAlreadyIsAChild(element)
        for i, v in ipairs(frame.childs) do
            if v == element then
                return true
            end
        end
        return false
    end

    for i, v in ipairs(frame.childs) do
        if not v.type then
            error("TypeError: bad argument #1 to 'newFrame' (BetterElement_ELEMENT expected for child, got " .. type(v) .. ")")
        else
            if not checkIfAlreadyIsAChild(v) then
                local positionaccordingtoFrameAndWindowX, positionaccordingtoFrameAndWindowY = v.x + frame.x, v.y + frame.y
                v.x, v.y = positionaccordingtoFrameAndWindowX, positionaccordingtoFrameAndWindowY
            end
        end
    end

    frame.isMouseHovering = false
    frame.type = "BetterElement_Frame"

    local frame_data = { x = tbl.x or 0, y = tbl.y or 0 }
    
    local metatable = {
        __index = function(t, k)
            return frame_data[k]
        end,
        __newindex = function(t, k, v)
            if k == "x"  then
                frame_data[k] = v
                for ab,ba in pairs(frame.childs) do
                    local relativeXOfChild = originalPositionOfChild[ba].x
                    frame.childs[ab].x = v + relativeXOfChild
                end
            elseif k == "y" then
                frame_data[k] = v
                for ab,ba in pairs(frame.childs) do
                    local relativeYOfChild = originalPositionOfChild[ba].y
                    frame.childs[ab].y = v + relativeYOfChild
                end
            else
                rawset(t, k, v)
            end
        end
    }
    setmetatable(frame, metatable)
    table.insert(elements, frame)
    return frame
end

function BetterElements:newLoadBar(canvas,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newLoadBar' (table expected, got "..type(tbl)..")")
    end
    if canvas.type ~= "BetterElement_Canvas" then
        error("TypeError: bad argument #1 to 'newLoadBar' (BetterElement_Canvas expected, got "..type(canvas)..")")
    end
    local loadbar = {}
    loadbar.name = tbl.name or randomName()
    loadbar.x,loadbar.y = tbl.x or 0,tbl.y or 0
    loadbar.width = tbl.width or 0
    loadbar.height = tbl.height or 0
    loadbar.radius = tbl.radius or 0
    loadbar.bgcolor = tbl.bgcolor or 0x000000FF
    loadbar.color = tbl.color or 0xFFFFFFFF
    if tbl.visible == nil then
        tbl.visible = true
    end
    loadbar.visible = tbl.visible
    loadbar.percent = tbl.percent or 0
    loadbar.onHover = tbl.onHover or function() end
    loadbar.onLeave = tbl.onLeave or function() end
    loadbar.onClick = tbl.onClick or function() end
    loadbar.onChanged = tbl.onChanged or function() end

    loadbar.userCanChange = tbl.userCanChange or false;
    loadbar.userChanging = false;
    loadbar.type = "BetterElement_LoadBar"
    table.insert(elements,loadbar)
    return loadbar
end

function BetterElements:newRotatedLoadBar(canvas,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newRotatedLoadBar' (table expected, got "..type(tbl)..")")
    end
    if canvas.type ~= "BetterElement_Canvas" then
        error("TypeError: bad argument #1 to 'newRotatedLoadBar' (BetterElement_Canvas expected, got "..type(canvas)..")")
    end
    local loadbar = {}
    loadbar.name = tbl.name or randomName()
    loadbar.x,loadbar.y = tbl.x or 0,tbl.y or 0
    loadbar.width = tbl.width or 0
    loadbar.height = tbl.height or 0
    loadbar.radius = tbl.radius or 0
    loadbar.bgcolor = tbl.bgcolor or 0x000000FF
    loadbar.color = tbl.color or 0xFFFFFFFF
    if tbl.visible == nil then
        tbl.visible = true
    end
    loadbar.visible = tbl.visible
    loadbar.percent = tbl.percent or 0
    loadbar.onHover = tbl.onHover or function() end
    loadbar.onLeave = tbl.onLeave or function() end
    loadbar.onClick = tbl.onClick or function() end
    loadbar.onChanged = tbl.onChanged or function() end

    loadbar.userCanChange = tbl.userCanChange or false;
    loadbar.userChanging = false;
    loadbar.type = "BetterElement_RotatedLoadBar"
    table.insert(elements,loadbar)
    return loadbar
end

function BetterElements:setBorder(element,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'setBorder' (table expected, got "..type(tbl)..")")
    end
    if not element.type then
        error("TypeError: bad argument #1 to 'setBorder' (BetterElement_Element expected, got "..type(element)..")")
    end
    local border = {}
    border.color = tbl.color or 0x000000FF
    border.thickness = tbl.thickness or 1
    border.element = element
    element.border = border
    if tbl.visible == nil then
        tbl.visible = true
    end
    border.visible = tbl.visible
    table.insert(elements,border)
    return border
end

local function isMouseOnHitBox(x,y,window,obj)
    local windowx,windowy,windoww,windowh = window.x,window.y,window.width,window.height
    local mousexaccordingToWindow,mouseyaccordingToWindow = x - windowx,y - windowy
    local mousex,mousey = x,y
    local hitboxx,hitboxy,hitboxw,hitboxh = obj.x,obj.y,obj.width,obj.height
    if mousex > windowx and mousex < windowx + windoww and mousey > windowy and mousey < windowy + windowh then
        if hitboxx < mousexaccordingToWindow and hitboxx + hitboxw > mousexaccordingToWindow and hitboxy < mouseyaccordingToWindow and hitboxy + hitboxh > mouseyaccordingToWindow then
            return true
        end
    end
    return false
end

function BetterElements:addToPaint(func)
    module_config.extraOnPaintFunc = func
end

function BetterElements:Destroy(element)
    for i, v in ipairs(elements) do
        if v == element then
            table.remove(elements,i)
        end
    end
end

function BetterElements:newCanvas(window,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newCanvas' (table expected, got "..type(tbl)..")")
    end
    local canvas = ui.Canvas(window)
    canvas.align = "all"
    canvas.bgcolor = tbl.bgcolor or 0x000000FF
    canvas.type = "BetterElement_Canvas"
    canvas:show()

    local function updateChildsOfFrame(frame)
        for i, v in ipairs(frame.childs) do
            local positionaccordingtoFrameAndWindowX, positionaccordingtoFrameAndWindowY = v.x + frame.x, v.y + frame.y
            v.x, v.y = positionaccordingtoFrameAndWindowX, positionaccordingtoFrameAndWindowY
        end
    end
    function canvas:onPaint()
        module_config.extraOnPaintFunc(elements)
        self:clear(canvas.bgcolor)
        for k,v in ipairs(elements) do
            if v.type == "BetterElement_Frame" then
                if v.visible then
                    drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.bgcolor)
                    if v.border then
                        if  v.border.visible then
                        drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                    end
                end
                end
            end
            if v.type == "BetterElement_Button" then
                if v.visible then
                    drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.color)
                    local text = v.text
                    local size = self:measure(text)
                    canvas.font = v.font
                    canvas.fontsize = v.fontsize
                    canvas.fontstyle = v.fontstyle
                    canvas.fontweight = v.fontweight
                    local middleOfButtonXforText, middleOfButtonYforText = v.x + v.width/2, v.y + v.height/2
                    self:print(text, middleOfButtonXforText - size.width/2, middleOfButtonYforText - size.height/2, v.textcolor)
                    if v.border then
                        if  v.border.visible then
                        drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                    end
                end
                end
            end
            if v.type == "BetterElement_IconButton" then
                if v.visible then
                    drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.color)
                    local Image = canvas:Image(v.icon)
                    Image.width, Image.height = 32,32
                    Image.x, Image.y = v.x + v.width/2 - Image.width/2, v.y + v.height/2 - Image.height/2
                    Image:draw(Image.x,Image.y)

                    if v.border then
                        if  v.border.visible then
                        drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                    end
                end
                end
            end
            if v.type == "BetterElement_CheckBox" then
                if v.visible then
                    if v.border then
                        if  v.border.visible then
                        drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                    end
                    end
                    if v.checked then
                        local checkerWidth = v.width-v.checkerThickness
                        local checkerHeight = v.height - v.checkerThickness
                        local centerOfCheckerX = v.x + v.width/2
                        local centerOfCheckerY = v.y + v.height/2
                        drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.color)
                        drawRectangle(canvas, centerOfCheckerX - checkerWidth/2, centerOfCheckerY - checkerHeight/2, checkerWidth, checkerHeight, v.radius, v.radius, v.checkedColor)
                    else
                        drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.color)
                    end
                end
            end
            if v.type == "BetterElement_Label" then
                if v.visible then
                    local oldFontSettings = {
                        font = canvas.font;
                        fontsize = canvas.fontsize;
                        fontstyle = canvas.fontstyle;
                        fontweight = canvas.fontweight
                    }
                    local text = v.text
                    canvas.font = v.font
                    canvas.fontsize = v.fontsize
                    canvas.fontstyle = v.fontstyle
                    canvas.fontweight = v.fontweight
                    self:print(text, v.x, v.y, v.textcolor)

                    canvas.font = oldFontSettings.font
                    canvas.fontsize = oldFontSettings.fontsize
                    canvas.fontstyle = oldFontSettings.fontstyle
                    canvas.fontweight = oldFontSettings.fontweight
                end
            end
            if v.type == "BetterElement_LoadBar" then
                if v.visible then
                    if v.border then
                        if  v.border.visible then
                        drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                    end
                end
                    drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.bgcolor)
                    local percent = v.percent / 100 
                    local widthAccordingToPercent = v.width * percent
                    local height = v.height
                    drawRectangle(canvas, v.x, v.y, widthAccordingToPercent, height, v.radius, v.radius, v.color)
                end
            end
            if v.type == "BetterElement_RotatedLoadBar" then
                if v.visible then
                    if v.border then
                        if  v.border.visible then
                        drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                    end
                end
                drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.bgcolor)
                local percent = v.percent / 100 
                local heightAccordingToPercent = v.height * percent
                local yStart = v.y + (v.height - heightAccordingToPercent)
                drawRectangle(canvas, v.x, yStart, v.width, heightAccordingToPercent, v.radius, v.radius, v.color)
                end
            end
        end
    end
    function canvas:onMouseUp()
        for k,v in pairs(elements) do
            if v.type == "BetterElement_LoadBar" then
                if v.visible then
                    v.userChanging = false
                end
            end
            if v.type == "BetterElement_RotatedLoadBar" then
                if v.visible then
                    v.userChanging = false
                end
            end
        end
    end
    function canvas:onClick()
        for k,v in pairs(elements) do
            if v.type == "BetterElement_Frame" then
                if v.visible then
                    local mousex, mousey = ui.mousepos()
                    if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                        v.onClick()
                    end
                end
            end
            if v.type == "BetterElement_Button" then
                local mousex,mousey = ui.mousepos()
                if isMouseOnHitBox(mousex,mousey,mainWindow,v) then
                    v.onClick()
                end
            end
            if v.type == "BetterElement_CheckBox" then
                if v.visible then
                    local mousex,mousey = ui.mousepos()
                    if isMouseOnHitBox(mousex,mousey,mainWindow,v) then
                        v.checked = not v.checked
                        v.onClick()
                    end
                end
            end
            if v.type == "BetterElement_IconButton" then
                if v.visible then
                    local mousex,mousey = ui.mousepos()
                    if isMouseOnHitBox(mousex,mousey,mainWindow,v) then
                        v.onClick()
                    end
                end
            end
            if v.type == "BetterElement_LoadBar" then
                if v.visible then
                    local mousex, mousey = ui.mousepos()
                    if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                        v.onClick()
                        if v.userCanChange then
                            v.userChanging = true
                        end
                    end
                end
            end
            if v.type == "BetterElement_RotatedLoadBar" then
                if v.visible then
                    local mousex, mousey = ui.mousepos()
                    if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                        v.onClick()
                        if v.userCanChange then
                            v.userChanging = true
                        end
                    end
                end
            end
        end
    end
    function canvas:onHover()
        local cursorSet = false
        local mousex, mousey = ui.mousepos()
        for k,v in pairs(elements) do
            if v.type == "BetterElement_Button" then
                if v.visible then
                    if  isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                        if v.cursorSet then
                            canvas.cursor = "hand"
                        end
                    v.onHover()
                    cursorSet = true
                    v.isMouseHovering = true;
                    else
                        if v.isMouseHovering then
                        v.onLeave()
                        v.isMouseHovering = false;
                        end
                    end
                end
             elseif v.type == "BetterElement_CheckBox" then
                if v.visible  then
                    if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                            canvas.cursor = "hand"
                    v.onHover()
                    cursorSet = true
                    v.isMouseHovering = true;
                    else
                        if v.isMouseHovering then
                        v.onLeave()
                        v.isMouseHovering = false;
                        end
                end
                end
            elseif v.type == "BetterElement_Frame" then
                if v.visible then
                    if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                  --  canvas.cursor = "hand"
                    v.onHover()
                  --  cursorSet = true
                    v.isMouseHovering = true;
                    else
                        if v.isMouseHovering then
                        v.onLeave()
                        v.isMouseHovering = false;
                        end
                    end

                end
            elseif v.type == "BetterElement_IconButton" then
                if v.visible then
                    if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                        if v.cursorSet then
                            canvas.cursor = "hand"
                        end
                    v.onHover()
                    cursorSet = true
                    v.isMouseHovering = true;
                    else
                        if v.isMouseHovering then
                        v.onLeave()
                        v.isMouseHovering = false;
                        end
                    end
                end
                elseif v.type == "BetterElement_LoadBar" then
                    if v.visible then
                        if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                        v.onHover()
                        v.isMouseHovering = true;
                            if v.userChanging then
                                if mainWindow then
                                    local winX = mainWindow.x
                                    local relativeMouseX = mousex - winX
                                    local relativeX = relativeMouseX - v.x
                                    v.percent = math.max(0, math.min((relativeX / v.width) * 100, 100))
                                    v.percent = math.floor(v.percent)
                                    v.onChanged()
                                end
                            end
                        else
                            if v.isMouseHovering then
                            v.onLeave()
                            v.isMouseHovering = false;
                            end
                        end
                    end
                elseif v.type == "BetterElement_RotatedLoadBar" then
                    if v.visible then
                        if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                            v.onHover()
                            v.isMouseHovering = true
                            if v.userChanging then
                                if mainWindow then
                                    local winY = mainWindow.y
                                    local relativeMouseY = mousey - winY
                                    local relativeY = relativeMouseY - v.y
                                    local inverseRelativeY = v.height - relativeY
                                    v.percent = math.max(0, math.min((inverseRelativeY / v.height) * 100, 100))
                                    v.percent = math.floor(v.percent)
                                    v.onChanged()
                                end
                            end
                        else
                            if v.isMouseHovering then
                                v.onLeave()
                                v.isMouseHovering = false
                            end
                        end
                    end
            end
        end
        if not cursorSet then
            canvas.cursor = "arrow"
        end
    end
    mainWindow = window
    return canvas
end



return BetterElements
