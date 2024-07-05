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

```

> ⚠️ Warning: IconButton icons need to be `32x32` for better results.

## Information about Element Colors
* Element colors is represented by a number, an RGBA value (one byte per primary color and one byte for alpha channel).
* A RGBA color can be represented as an hexadecimal number : 0xRRGGBBAA , RR meaning a 8bit hexadecimal red value, and so on.
* Alpha channel specifies the opacity level of a color and can range from 00 to FF.

> Example : Get HEX Code of red color and write it like that `0xff0000`.After that put Alpha Channel.For example `0xff0000FF`.
* If you still didn't understand how to do it you can use `BetterElements:HEXtoColor(HEX)` function.
> Example :
```lua
local BetterElements = require("betterElements")
print(BetterElements:HEXtoColor("#C9C9C9"),0xC9C9C9FF)
--[[ Output : 
3385444863
3385444863
]]
-- Result is same so they are same colors.
```

# Latest Updates
- Added `Shadow` Element.You can add shadow to all elements now.
- Added `zindex` property.You can change zindex of all elements.
- `Borders` are now renders together with the element they are attached to.
- Added `function checkIfElementUnderOtherElements(element)...`.You can't interact with other elements which is under of the element.

# Installation
- Just download [betterElements.lua](https://github.com/zeykatecool/betterElements/blob/main/betterElements.lua) and require it from your lua file.

# How to use
- Check [examples](https://github.com/zeykatecool/betterElements/tree/main/examples) folder for examples.
> 📝 Information: Check [screenshots](https://github.com/zeykatecool/betterElements/tree/main/screenshots) folder to see difference between BetterElements and standart Elements.


> ⚠️ Warning: Try to not create more than one `Canvas` at the same time.You can use `BetterElements:addToPaint(func)` function to add function to paint process.If you need other elements for canvas just create it from there or just edit the original `betterElements.lua` file.

> ⚠️ Warning: If you are creating standart Elements,don't forget to add `(element):tofront()` for making them visible.

# Contact
- You can contact me from [LuaRT Discord Community Server](https://discord.gg/aAZ7jAVMC5).
