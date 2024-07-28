# Better Elements for LuaRT
- This module is made for making better elements for [LuaRT](https://github.com/samyeyo/LuaRT/tree/v1.8.0).
- It uses `canvas` module for creating new and better elements.

# Features
- All Elements listed above:
+ `Button`
+ `CheckBox`
+ `Label`
+ `IconButton`
+ `LoadBar`
+ `RotatedLoadBar`
+ `Frame`
+ `Image`
+ `Border`
+ `Shadow`

> 💡 Tip: CheckBoxes can be used like RadioButtons.

> ⚠️ Warning: `Border` and `Shadow` is not actual Elements.It attaches to Elements.

>Example:
```lua
 --Creating BetterElement_Canvas
local canvas = betterElements:newCanvas(WINDOW,{
    bgcolor = 0x242424;
})

--Creating new Frame
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

--Adding new border to Frame
local newBorder = betterElements:setBorder(frame,{
    color = 0x000000FF;
    thickness = 2;
})

--Adding new shadow to Frame
local shadowOfFrame = betterElements:setShadow(frame,{
    color = 0x000000FF;
    thickness = 1;
    visible = true;
    offsetX = 0;
    offsetY = 1;
})
--Check examples folder for better example.
```

> ⚠️ Warning: IconButton icons need to be `32x32` for better results.

## Information about Element Colors
* ~~Element colors is represented by a number, an RGBA value (one byte per primary color and one byte for alpha channel).~~
* You can use `transparency` property for this now.
> Example:
```lua
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
    bgcolor = 0xC9C9C9FF; --Alpha channel is FF (means it is opaque) but it will be not seen because transparency is 1.
    visible = true;
    transparency = 1;
    childs = {}
})
--Frame CANNOT be seen.
--Check examples folder for better example.
```
> ⚠️ Warning: Elements with a `transparency` value of `0` can still interact with the user.You can set `visible` value to `false` if you don't want this.

# Latest Updates
- Added `betterElements:isMouseOnElement(window,object)` function.
> Usage Example:
```lua
function betterElements_Canvas:onContext()
  if betterElement.isMouseOnElement(mainWindow,underPlusButton) then
    require("console").writeln("Hello")
  end
end
```
- Added `Image` element.


# Installation
- Just download [betterElements.lua](https://github.com/zeykatecool/betterElements/blob/main/betterElements.lua) and require it from your lua file.

# How to use
- Check [examples](https://github.com/zeykatecool/betterElements/tree/main/examples) folder for examples.
> 📝 Information: Check [screenshots](https://github.com/zeykatecool/betterElements/tree/main/screenshots) folder to see difference between BetterElements and standart Elements.


> ⚠️ Warning: Try to not create more than one `Canvas` at the same time.You can use `BetterElements:addToPaint(func)` function to add function to paint process.If you need other elements for canvas just create it from there or just edit the original `betterElements.lua` file.

> ⚠️ Warning: If you are creating standart Elements,don't forget to add `(element):tofront()` for making them visible.

# Contact
- You can contact me from [LuaRT Discord Community Server](https://discord.gg/aAZ7jAVMC5).
