local Tweens = {}

local Easings = {}

function Easings.Linear(t)
    return t
end

function Easings.InQuad(t)
    return t * t
end

function Easings.OutQuad(t)
    return t * (2 - t)
end

function Easings.InOutQuad(t)
    if t < 0.5 then
        return 2 * t * t
    else
        return -1 + (4 - 2 * t) * t
    end
end

function Easings.OutBounce(t)
    if t < 1 / 2.75 then
        return 7.5625 * t * t
    elseif t < 2 / 2.75 then
        t = t - 1.5 / 2.75
        return 7.5625 * t * t + 0.75
    elseif t < 2.5 / 2.75 then
        t = t - 2.25 / 2.75
        return 7.5625 * t * t + 0.9375
    else
        t = t - 2.625 / 2.75
        return 7.5625 * t * t + 0.984375
    end
end

local Tween = {
    Easings = Easings
}

function Tween.new(Object, HowLong, Properties, Callback, Easing)
    local newTween = setmetatable({
        Object = Object,
        HowLong = HowLong,
        Properties = Properties,
        ElapsedTime = 0,
        Callback = Callback,
        Playing = false,
        Easing = Easing,
    }, {
        __index = Tween
    })

    return newTween
end

function Tween:Play()
    self.ElapsedTime = 0
    self.Playing = true
    Tweens[self] = self
end

function Tween:Stop()
    self.ElapsedTime = 0
    self.Playing = false
    Tweens[self] = nil
end

function Tween:clearAll()
    for _, tween in pairs(Tweens) do
        if tween.Playing then
            tween.Playing = false
            if tween.Callback then
                tween.Callback(tween.Object)
            end
        end
    end
    Tweens = {}
end

local function updateTweens()
    for _, tween in pairs(Tweens) do
        if tween.Playing then
            tween.ElapsedTime = tween.ElapsedTime + 1
            local progress = math.min(tween.ElapsedTime / tween.HowLong, 1)
            local easedProgress = tween.Easing(progress)
            for property, endValue in pairs(tween.Properties) do
                local startValue = tween.Object[property]
                local newValue = startValue + (endValue - startValue) * easedProgress
                tween.Object[property] = newValue
                if progress >= 1 then
                    tween.Playing = false
                    if tween.Callback then
                        tween.Callback(tween.Object)
                    end
                    Tweens[tween] = nil
                end
            end
        end
    end
end

function Tween.UpdateAll()
    updateTweens()
end

return Tween
