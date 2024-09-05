local ui = require("ui")
require("canvas")
local BetterElements = {}
local elements = {}
local zIndexs = {}
local mainWindow = nil

local module_config = {
    extraOnPaintFunc = function(element) end;
}
local function randomName()
    local chars = {}
    for i=1,8 do
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


function BetterElements:HEXtoColor(hex, alpha)
    if type(hex) ~= "string" then
        error("TypeError: bad argument #1 to 'HEXtoColor' (string expected, got " .. type(hex) .. ")")
    end
    if hex:find("#") == 1 then
        hex = hex:sub(2)
    end
    local len = #hex
    if len ~= 6 and len ~= 8 then
        error("ValueError: bad argument #1 to 'HEXtoColor' (invalid hex color length)")
    end
    if len == 6 then
        hex = hex .. "FF"
    end
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    local a = tonumber(hex:sub(7, 8), 16) or 255
    if alpha then
        a = (1 - alpha) * 255
    end
    return (r << 24) | (g << 16) | (b << 8) | math.floor(a)
end

local function transparencyForColor(hex, transparencyValue)
    if type(hex) ~= "number" then
        error("TypeError: bad argument #1 to 'transparencyForColor' (number expected, got " .. type(hex) .. ")")
    end

    -- Separate color and opacity values
    local color = hex >> 8
    local alpha = hex & 0xFF

    -- Calculate new opacity value
    local newAlpha = math.floor((1 - transparencyValue) * 255)

    -- Combine new color and opacity values
    local newHex = (color << 8) | newAlpha

    return newHex
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
    button.zindex = tbl.zindex or 0
    button.transparency = tbl.transparency or 0
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
    button.onMouseUp = tbl.onMouseUp or function() end
    table.insert(elements,button)
    table.insert(zIndexs,button.zindex)
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
    checkbox.onMouseUp = tbl.onMouseUp or function() end
    checkbox.zindex = tbl.zindex or 0
    checkbox.transparency = tbl.transparency or 0
    checkbox.checkerThickness = tbl.checkerThickness or 2
    checkbox.isMouseHovering = false;
    checkbox.visible = tbl.visible
    table.insert(elements,checkbox)
    table.insert(zIndexs,checkbox.zindex)
    return checkbox
end


function BetterElements:newListLayout(frame, tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newListLayout' (table expected, got "..type(tbl)..")")
    end
    if frame.type ~= "BetterElement_Frame" then
        error("TypeError: bad argument #1 to 'newListLayout' (BetterElement_Frame expected, got "..type(frame)..")")
    end

    local listLayout = {}
    listLayout.type = "BetterElement_ListLayout"
    listLayout.direction = tbl.direction or "vertical" -- vertical or horizontal
    listLayout.align = tbl.align or "start" -- start, center, end
    listLayout.justify = tbl.justify or "start" -- start, center, end
    listLayout.spacing = tbl.spacing or 0
    listLayout.frame = frame
    if not mainWindow then
        mainWindow = {}
    end
    local function updateChildsPosition()
        if listLayout.direction == "vertical" then
            local y = frame.y
            for _, child in ipairs(frame.childs) do
                child.x = frame.x
                child.y = y
                y = y + child.height + listLayout.spacing
            end
        elseif listLayout.direction == "horizontal" then
            local x = frame.x
            for _, child in ipairs(frame.childs) do
                child.x = x
                child.y = frame.y
                x = x + child.width + listLayout.spacing
            end
        end
    end

    local function updateChildsAlign()
        if listLayout.align == "center" then
            if listLayout.direction == "vertical" then
                local totalHeight = (#frame.childs * (frame.childs[1].height + listLayout.spacing)) - listLayout.spacing
                local offset = (mainWindow.height - totalHeight) / 2 - frame.y
                for _, child in ipairs(frame.childs) do
                    child.y = child.y + offset
                end
            elseif listLayout.direction == "horizontal" then
                local totalWidth = (#frame.childs * (frame.childs[1].width + listLayout.spacing)) - listLayout.spacing
                local offset = (mainWindow.width - totalWidth) / 2 - frame.x
                for _, child in ipairs(frame.childs) do
                    child.x = child.x + offset
                end
            end
        elseif listLayout.align == "end" then
            if listLayout.direction == "vertical" then
                local totalHeight = (#frame.childs * (frame.childs[1].height + listLayout.spacing)) - listLayout.spacing
                local offset = mainWindow.height - totalHeight - frame.y
                for _, child in ipairs(frame.childs) do
                    child.y = child.y + offset
                end
            elseif listLayout.direction == "horizontal" then
                local totalWidth = (#frame.childs * (frame.childs[1].width + listLayout.spacing)) - listLayout.spacing
                local offset = mainWindow.width - totalWidth - frame.x
                for _, child in ipairs(frame.childs) do
                    child.x = child.x + offset
                end
            end
        end
    end

    local function updateChildsJustify()
        if listLayout.justify == "center" then
            if listLayout.direction == "vertical" then
                for _, child in ipairs(frame.childs) do
                    child.x = frame.x + (frame.width - child.width) / 2
                end
            elseif listLayout.direction == "horizontal" then
                for _, child in ipairs(frame.childs) do
                    child.y = frame.y + (frame.height - child.height) / 2
                end
            end
        elseif listLayout.justify == "end" then
            if listLayout.direction == "vertical" then
                for _, child in ipairs(frame.childs) do
                    child.x = frame.x + frame.width - child.width
                end
            elseif listLayout.direction == "horizontal" then
                for _, child in ipairs(frame.childs) do
                    child.y = frame.y + frame.height - child.height
                end
            end
        end
    end

    function listLayout:updateChilds()
        updateChildsPosition()
        updateChildsAlign()
        updateChildsJustify()
    end

    frame.listLayout = listLayout

    local original_addChild = frame.addChild
    function frame:addChild(element)
        original_addChild(self, element)
        listLayout:updateChilds()
    end

    local original_removeChild = frame.removeChild
    function frame:removeChild(element)
        original_removeChild(self, element)
        listLayout:updateChilds()
    end

    table.insert(elements, listLayout)
    return listLayout
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
    label.transparency = tbl.transparency or 0
    label.onHover = tbl.onHover or function() end
    label.onLeave = tbl.onLeave or function() end
    label.zindex = tbl.zindex or 0
    label.type = "BetterElement_Label"
    table.insert(elements,label)
    table.insert(zIndexs,label.zindex)
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
    iconbutton.onMouseUp = tbl.onMouseUp or function() end
    iconbutton.transparency = tbl.transparency or 0
    iconbutton.zindex = tbl.zindex or 0
    if not iconbutton.cursorSet then
        iconbutton.cursorSet = true
    end
    iconbutton.cursorSet = tbl.cursorSet
    iconbutton.isMouseHovering = false;
    iconbutton.visible = tbl.visible
    table.insert(elements,iconbutton)
    table.insert(zIndexs,iconbutton.zindex)
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
    frame.visible = tbl.visible == nil and true or tbl.visible
    frame.transparency = tbl.transparency or 0
    frame.onHover = tbl.onHover or function() end
    frame.onLeave = tbl.onLeave or function() end
    frame.onClick = tbl.onClick or function() end
    frame.onMouseUp = tbl.onMouseUp or function() end
    frame.childs = {}

    local frame_data = { x = tbl.x or 0, y = tbl.y or 0, zindex = tbl.zindex or 0 }

    local originalPositionOfChild = {}
    function frame:addChild(element)
        if not element.type then
            error("TypeError: bad argument #1 to 'addChild' (BetterElement_ELEMENT expected for child, got " .. type(element) .. ")")
        else
            table.insert(frame.childs, element)
            originalPositionOfChild[element] = { x = element.x, y = element.y }
            element.x, element.y = element.x + frame.x, element.y + frame.y
            element.parentOfSomething = frame
            element.zindex = frame.zindex
        end
    end

    function frame:removeChild(element)
        if not element.type then
            error("TypeError: bad argument #1 to 'removeChild' (BetterElement_ELEMENT expected for child, got " .. type(element) .. ")")
        else
            for i, v in ipairs(frame.childs) do
                if v == element then
                    table.remove(frame.childs, i)
                    element.x = originalPositionOfChild[element].x
                    element.y = originalPositionOfChild[element].y
                    originalPositionOfChild[element] = nil
                    element.parentOfSomething = nil
                    break
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

    for i, v in ipairs(tbl.childs or {}) do
        if not v.type then
            error("TypeError: bad argument #1 to 'newFrame' (BetterElement_ELEMENT expected for child, got " .. type(v) .. ")")
        else
            if not checkIfAlreadyIsAChild(v) then
                frame:addChild(v)
            end
        end
    end

    frame.isMouseHovering = false
    frame.type = "BetterElement_Frame"

    local metatable = {
        __index = function(t, k)
            return frame_data[k]
        end,
        __newindex = function(t, k, v)
            if k == "x" then
                local dx = v - frame_data[k]
                frame_data[k] = v
                for _, child in ipairs(frame.childs) do
                    child.x = child.x + dx
                end
            elseif k == "y" then
                local dy = v - frame_data[k]
                frame_data[k] = v
                for _, child in ipairs(frame.childs) do
                    child.y = child.y + dy
                end
            elseif k == "zindex" then
                frame_data[k] = v
                table.insert(zIndexs, v)
                for _, child in ipairs(frame.childs) do
                    child.zindex = v
                end
            else
                rawset(t, k, v)
            end
        end
    }
    setmetatable(frame, metatable)
    table.insert(elements, frame)
    table.insert(zIndexs, frame.zindex)
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
    loadbar.zindex = tbl.zindex or 0
    if tbl.visible == nil then
        tbl.visible = true
    end
    loadbar.visible = tbl.visible
    loadbar.percent = tbl.percent or 0
    loadbar.onHover = tbl.onHover or function() end
    loadbar.onLeave = tbl.onLeave or function() end
    loadbar.onClick = tbl.onClick or function() end
    loadbar.onChanged = tbl.onChanged or function() end
    loadbar.onMouseUp = tbl.onMouseUp or function() end
    loadbar.transparency = tbl.transparency or 0
    loadbar.userCanChange = tbl.userCanChange or false;
    loadbar.userChanging = false;
    loadbar.type = "BetterElement_LoadBar"
    table.insert(elements,loadbar)
    table.insert(zIndexs,loadbar.zindex)
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
    loadbar.transparency = tbl.transparency or 0
    loadbar.zindex = tbl.zindex or 0
    if tbl.visible == nil then
        tbl.visible = true
    end
    loadbar.visible = tbl.visible
    loadbar.percent = tbl.percent or 0
    loadbar.onHover = tbl.onHover or function() end
    loadbar.onLeave = tbl.onLeave or function() end
    loadbar.onClick = tbl.onClick or function() end
    loadbar.onChanged = tbl.onChanged or function() end
    loadbar.onMouseUp = tbl.onMouseUp or function() end

    loadbar.userCanChange = tbl.userCanChange or false;
    loadbar.userChanging = false;
    loadbar.type = "BetterElement_RotatedLoadBar"
    table.insert(elements,loadbar)
    table.insert(zIndexs,loadbar.zindex)
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
    border.type = "BetterElement_Border"
    border.transparency = tbl.transparency or 0
    border.zindex = element.zindex
    if tbl.visible == nil then
        tbl.visible = true
    end
    border.visible = tbl.visible
    table.insert(elements,border)
    return border
end



function BetterElements:setShadow(element,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'setBorder' (table expected, got "..type(tbl)..")")
    end
    if not element.type then
        error("TypeError: bad argument #1 to 'setBorder' (BetterElement_Element expected, got "..type(element)..")")
    end
    local shadow = {}
    shadow.color = tbl.color or 0x000000FF
    shadow.transparency = tbl.transparency or 0
    shadow.thickness = tbl.thickness or 1
    shadow.element = element
    if shadow.element.type == "BetterElement_Border" then
        error("TypeError: bad argument #1 to 'setBorder' (BetterElement_Border can't have shadow)")
    end
    element.shadow = shadow
    shadow.offsetX = tbl.offsetX or 0
    shadow.offsetY = tbl.offsetY or 0
    shadow.type = "BetterElement_Shadow"
    if tbl.visible == nil then
        tbl.visible = true
    end
    shadow.visible = tbl.visible
    table.insert(elements,shadow)
    return shadow
end

local function checkIfElementUnderOtherElements(element)
    local zIndexOfElement = element.zindex
    for i, v in ipairs(elements) do
        if v ~= element then
            if v.width and v.height then
            if v.type ~= "BetterElement_Border" and v.type ~= "BetterElement_Shadow" and v.type ~= "BetterElement_Label" then
            if v.x < element.x + element.width and v.x + v.width > element.x and v.y < element.y + element.height and v.y + v.height > element.y and v.zindex > zIndexOfElement then
                return true
            end
        end
            end
        end
    end
    return false
end
local function isMouseOnHitBox(x,y,window,obj)
    if checkIfElementUnderOtherElements(obj) then
        return false
    end
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
            if v.type == "BetterElement_Frame" then
                for a,b in ipairs(v.childs) do
                    BetterElements:Destroy(b)
                end
            end
            table.remove(elements,i)
        end
    end
end

function BetterElements:resize(element,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'resize' (table expected, got "..type(tbl)..")")
    end
    if not element.type then
        error("TypeError: bad argument #1 to 'resize' (BetterElement_Element expected, got "..type(element)..")")
    end
    if element.width and element.height then
        if tbl.width and tbl.height then
    element.width = tbl.width
    element.height = tbl.height
        end
    end
end

function BetterElements:move(element,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'move' (table expected, got "..type(tbl)..")")
    end
    if not element.type then
        error("TypeError: bad argument #1 to 'move' (BetterElement_Element expected, got "..type(element)..")")
    end
    if element.x and element.y then
        if tbl.x and tbl.y then
    element.x = tbl.x
    element.y = tbl.y
        end
    end
end

function BetterElements:isMouseOnElement(window,obj)
    local x,y = ui.mousepos()
    return isMouseOnHitBox(x,y,window,obj)
end

function  BetterElements:newImage(canvas,tbl)
    if type(tbl) ~= "table" then
        error("TypeError: bad argument #1 to 'newImage' (table expected, got "..type(tbl)..")")
    end
    if canvas.type ~= "BetterElement_Canvas" then
        error("TypeError: bad argument #1 to 'newImage' (BetterElement_Canvas expected, got "..type(canvas)..")")
    end
    local image = {}
    image.name = tbl.name or randomName()
    image.x,image.y = tbl.x or 0,tbl.y or 0
    image.image = tbl.image
    if not image.image then
        error("TypeError: bad argument #1 to 'newImage' (image_string expected, got "..type(tbl.image)..")")
    end
    local function originalWandH(pic)
        local getPic = ui.Picture(mainWindow,pic)
        getPic.enabled = false
        getPic.visible = false
            local w,h = getPic.width,getPic.height
            getPic = nil
            return {w,h}
    end
    image.width,image.height = tbl.width or originalWandH(tbl.image)[1],tbl.height or originalWandH(tbl.image)[2]
    image.zindex = tbl.zindex or 0
    if tbl.visible == nil then
        tbl.visible = true
    end
   -- require("console").writeln(image.width,image.height)
    image.visible = tbl.visible
    image.transparency = tbl.transparency or 0
    image.onHover = tbl.onHover or function() end
    image.onLeave = tbl.onLeave or function() end
    image.onClick = tbl.onClick or function() end
    image.type = "BetterElement_Image"
    table.insert(elements,image)
    table.insert(zIndexs,image.zindex)
    return image
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
    
  canvas.onSignal = tbl.onSignal or function(signal) end
    function canvas:onClick()
        canvas.onSignal("click")
        for k,v in pairs(elements) do
            if v.type == "BetterElement_Image" then
                local mousex,mousey = ui.mousepos()
                if isMouseOnHitBox(mousex,mousey,mainWindow,v) then
                    v.onClick()
                end
            end
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
    function canvas:onPaint()
        canvas.onSignal("paint")
        module_config.extraOnPaintFunc(elements)
        self:clear(canvas.bgcolor)
        local findSmallestZindex = math.huge
        for k,v in pairs(elements) do
            if v.zindex then
            if v.zindex < findSmallestZindex then
                findSmallestZindex = v.zindex
            end
        end
        end
        local findBiggestZindex = 0
        for k,v in pairs(elements) do
            if v.zindex then
            if v.zindex > findBiggestZindex then
                
                findBiggestZindex = v.zindex
            end
        end
        end
        for i = findSmallestZindex,findBiggestZindex do
            for k,v in ipairs(elements) do
                if v.type then
                    if v.zindex == i then
                if v.type == "BetterElement_Frame" then
                    if v.visible then
                        if v.shadow then
                            if v.shadow.visible then
                                local shadowX, shadowY = v.x + v.shadow.offsetX, v.y + v.shadow.offsetY
                                local shadowThickness = v.shadow.thickness
                                local shadowWidth = v.width + shadowThickness
                                local shadowHeight = v.height + shadowThickness
                                v.shadow.color = transparencyForColor(v.shadow.color,v.shadow.transparency)
                                drawRectangle(canvas, shadowX, shadowY, shadowWidth, shadowHeight, v.radius, v.radius, v.shadow.color)
                            end
                        end
                        v.bgcolor = transparencyForColor(v.bgcolor,v.transparency)
                        drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.bgcolor)
                        if v.border then
                            if  v.border.visible then
                                v.border.color = transparencyForColor(v.border.color,v.border.transparency)
                            drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                        end
                    end
                    end
                end

                if v.type == "BetterElement_Image" then
                    if v.visible then
                        local Image = canvas:Image(v.image)
                        Image.width, Image.height = v.width, v.height
                        local newx, newy = v.x + v.width / 2 - Image.width / 2, v.y + v.height / 2 - Image.height / 2
                        Image.x, Image.y = newx, newy
                     local   function invertTransparency(transparency)
                            return 1 - transparency
                        end
                        Image:drawrect(newx,newy,v.width,v.height,invertTransparency(v.transparency))
                    end
                end
                if v.type == "BetterElement_Button" then
                    if v.visible then
                        if v.shadow then
                            if v.shadow.visible then
                                local shadowX, shadowY = v.x + v.shadow.offsetX, v.y + v.shadow.offsetY
                                local shadowThickness = v.shadow.thickness
                                local shadowWidth = v.width + shadowThickness
                                local shadowHeight = v.height + shadowThickness
                                v.shadow.color = transparencyForColor(v.shadow.color,v.shadow.transparency)
                                drawRectangle(canvas, shadowX, shadowY, shadowWidth, shadowHeight, v.radius, v.radius, v.shadow.color)
                            end
                        end
                        v.color = transparencyForColor(v.color,v.transparency)
                        drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.color)
                        local text = v.text
                        local size = self:measure(text)
                        canvas.font = v.font
                        canvas.fontsize = v.fontsize
                        canvas.fontstyle = v.fontstyle
                        canvas.fontweight = v.fontweight
                        local middleOfButtonXforText, middleOfButtonYforText = v.x + v.width/2, v.y + v.height/2
                        v.textcolor = transparencyForColor(v.textcolor,v.transparency)
                        self:print(text, middleOfButtonXforText - size.width/2, middleOfButtonYforText - size.height/2, v.textcolor)
                        if v.border then
                            if  v.border.visible then
                            v.border.color = transparencyForColor(v.border.color,v.border.transparency)
                            drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                        end
                    end
                    end
                end
                if v.type == "BetterElement_IconButton" then
                    if v.visible then
                        if v.shadow then
                            if v.shadow.visible then
                                local shadowX, shadowY = v.x + v.shadow.offsetX, v.y + v.shadow.offsetY
                                local shadowThickness = v.shadow.thickness
                                local shadowWidth = v.width + shadowThickness
                                local shadowHeight = v.height + shadowThickness
                                v.shadow.color = transparencyForColor(v.shadow.color,v.shadow.transparency)
                                drawRectangle(canvas, shadowX, shadowY, shadowWidth, shadowHeight, v.radius, v.radius, v.shadow.color)
                            end
                        end
                        v.color = transparencyForColor(v.color,v.transparency)
                        drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.color)
                        local Image = canvas:Image(v.icon)
                        Image.width, Image.height = 32,32
                        Image.x, Image.y = v.x + v.width/2 - Image.width/2, v.y + v.height/2 - Image.height/2
                        Image:draw(Image.x,Image.y)
            
                        if v.border then
                            if  v.border.visible then
                            v.border.color = transparencyForColor(v.border.color,v.border.transparency)
                            drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                        end
                    end
                    end
                end
                if v.type == "BetterElement_CheckBox" then
                    if v.visible then
                        if v.shadow then
                            if v.shadow.visible then
                                local shadowX, shadowY = v.x + v.shadow.offsetX, v.y + v.shadow.offsetY
                                local shadowThickness = v.shadow.thickness
                                local shadowWidth = v.width + shadowThickness
                                local shadowHeight = v.height + shadowThickness
                                v.shadow.color = transparencyForColor(v.shadow.color,v.shadow.transparency)
                                drawRectangle(canvas, shadowX, shadowY, shadowWidth, shadowHeight, v.radius, v.radius, v.shadow.color)
                            end
                        end
                        if v.border then
                            if  v.border.visible then
                            v.border.color = transparencyForColor(v.border.color,v.border.transparency)
                            drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                        end
                        end
                        if v.checked then
                            local checkerWidth = v.width-v.checkerThickness
                            local checkerHeight = v.height - v.checkerThickness
                            local centerOfCheckerX = v.x + v.width/2
                            local centerOfCheckerY = v.y + v.height/2
                            v.color = transparencyForColor(v.color,v.transparency)
                            v.checkedColor = transparencyForColor(v.checkedColor,v.transparency)
                            drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.color)
                            drawRectangle(canvas, centerOfCheckerX - checkerWidth/2, centerOfCheckerY - checkerHeight/2, checkerWidth, checkerHeight, v.radius, v.radius, v.checkedColor)
                        else
                            v.color = transparencyForColor(v.color,v.transparency)
                            drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.color)
                        end
                    end
                end
                if v.type == "BetterElement_Label" then
                    if v.visible then
                        if v.shadow then
                            if v.shadow.visible then
                                local shadowX, shadowY = v.x + v.shadow.offsetX, v.y + v.shadow.offsetY
                                local shadowThickness = v.shadow.thickness
                                local shadowWidth = v.width + shadowThickness
                                local shadowHeight = v.height + shadowThickness
                                v.shadow.color = transparencyForColor(v.shadow.color,v.shadow.transparency)
                                drawRectangle(canvas, shadowX, shadowY, shadowWidth, shadowHeight, v.radius, v.radius, v.shadow.color)
                            end
                        end
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
                        v.textcolor = transparencyForColor(v.textcolor,v.transparency)
                        self:print(text, v.x, v.y, v.textcolor)
            
                        canvas.font = oldFontSettings.font
                        canvas.fontsize = oldFontSettings.fontsize
                        canvas.fontstyle = oldFontSettings.fontstyle
                        canvas.fontweight = oldFontSettings.fontweight
                    end
                end
                if v.type == "BetterElement_LoadBar" then
                    if v.visible then
                        if v.shadow then
                            if v.shadow.visible then
                                local shadowX, shadowY = v.x + v.shadow.offsetX, v.y + v.shadow.offsetY
                                local shadowThickness = v.shadow.thickness
                                local shadowWidth = v.width + shadowThickness
                                local shadowHeight = v.height + shadowThickness
                                v.shadow.color = transparencyForColor(v.shadow.color,v.shadow.transparency)
                                drawRectangle(canvas, shadowX, shadowY, shadowWidth, shadowHeight, v.radius, v.radius, v.shadow.color)
                            end
                        end
                        if v.border then
                            if  v.border.visible then
                            v.border.color = transparencyForColor(v.border.color,v.border.transparency)
                            drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                        end
                    end
                        v.bgcolor = transparencyForColor(v.bgcolor,v.transparency)
                        v.color = transparencyForColor(v.color,v.transparency)
                        drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.bgcolor)
                        local percent = v.percent / 100
                        local widthAccordingToPercent = v.width * percent
                        local height = v.height
                        drawRectangle(canvas, v.x, v.y, widthAccordingToPercent, height, v.radius, v.radius, v.color)
                    end
                end
                if v.type == "BetterElement_RotatedLoadBar" then
                    if v.visible then
                        if v.shadow then
                            if v.shadow.visible then
                                local shadowX, shadowY = v.x + v.shadow.offsetX, v.y + v.shadow.offsetY
                                local shadowThickness = v.shadow.thickness
                                local shadowWidth = v.width + shadowThickness
                                local shadowHeight = v.height + shadowThickness
                                v.shadow.color = transparencyForColor(v.shadow.color,v.shadow.transparency)
                                drawRectangle(canvas, shadowX, shadowY, shadowWidth, shadowHeight, v.radius, v.radius, v.shadow.color)
                            end
                        end
                        if v.border then
                            if  v.border.visible then
                            v.border.color = transparencyForColor(v.border.color,v.border.transparency)
                            drawBorder(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.border.color, v.border.thickness)
                        end
                    end
                        v.bgcolor = transparencyForColor(v.bgcolor,v.transparency)
                        v.color = transparencyForColor(v.color,v.transparency)
                    drawRectangle(canvas, v.x, v.y, v.width, v.height, v.radius, v.radius, v.bgcolor)
                    local percent = v.percent / 100 
                    local heightAccordingToPercent = v.height * percent
                    local yStart = v.y + (v.height - heightAccordingToPercent)
                    drawRectangle(canvas, v.x, yStart, v.width, heightAccordingToPercent, v.radius, v.radius, v.color)
                    end
                end
            end
        end
    end
end
end



function canvas:onMouseUp()
    canvas.onSignal("mouseup")
        for k,v in pairs(elements) do
            if v.type ~= "BetterElement_Label" then
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
            local mousex, mousey = ui.mousepos()
            if v.visible then
                if v.type ~= "BetterElement_Border" and v.type ~= "BetterElement_Shadow" then
            if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                v.onMouseUp()
            end
            end
        end
        end
        end
    end
   
    function canvas:onHover()
        canvas.onSignal("hover")
        local cursorSet = false
        local mousex, mousey = ui.mousepos()
        for k,v in pairs(elements) do
            if v.type == "BetterElement_Image" then
                if v.visible then
                    if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                        v.isMouseHovering = true;
                        if v.cursorSet then
                            canvas.cursor = "hand"
                        end
                        v.onHover()
                    else
                        if v.isMouseHovering then
                        v.onLeave()
                        v.isMouseHovering = false;
                        end
                    end
                end
            end
            if v.type == "BetterElement_Label" then
                if v.visible then
                    local measure = self:measure(v.text)
                    local w,h = measure.width,measure.height
                    v.width,v.height = w,h
                    if isMouseOnHitBox(mousex, mousey, mainWindow, v) then
                        v.isMouseHovering = true;
                        if v.cursorSet then
                            canvas.cursor = "hand"
                        end
                        v.onHover()
                    else
                        if v.isMouseHovering then
                        v.onLeave()
                        v.isMouseHovering = false;
                        end
                    end
                end
            end
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
