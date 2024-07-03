# Better Elements for LuaRT
- This module is made for making better elements for [LuaRT](https://github.com/samyeyo/LuaRT/tree/v1.8.0).
- It uses `canvas` module for creating new and better elements.

# Features
- All Elements listed above:
+ `Buttons`
+ `CheckBox`
+ `Label`
+ `IconButton`
+ `LoadBar`
+ `Frame`
+ `Border`

> 💡 Tip: CheckBoxes can be used like RadioButtons.

> ⚠️ Warning: `Border` is not actual Element.It attaches to Elements.

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
local newBorder = betterElements:setBorder(checkBox,{
    color = 0x000000FF;
    thickness = 2;
})

```

> ⚠️ Warning: IconButton icons need to be `32x32` for better results.

# Installation
- Just download [betterElements.lua](https://github.com/zeykatecool/betterElements/blob/main/betterElements.lua) and require it from your lua file.

# How to use
- Check [examples](https://github.com/zeykatecool/betterElements/tree/main/examples) folder for examples.
> 📝 Information: Check [screenshots](https://github.com/zeykatecool/betterElements/tree/main/screenshots) folder to see difference between BetterElements and standart Elements.


> ⚠️ Warning: Try to not create more than one `Canvas` at the same time.You can use `BetterElements:addToPaint(func)` function to add function to paint process.If you need other elements for canvas just create it from there or just edit the original `betterElements.lua` file.

> ⚠️ Warning: If you are creating standart Elements,don't forget to add `(element):tofront()` for making them visible.

# Contact
- You can contact me from [LuaRT Discord Community Server](https://discord.gg/aAZ7jAVMC5).
