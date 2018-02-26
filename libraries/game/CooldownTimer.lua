---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by seletz.
--- DateTime: 18.02.18 12:23
---

local function CooldownTimer(duration)
    local t = 0
    local d = duration

    return function(dt, f)
        t = t + dt
        if t > d then
            t = 0
            f()
        end
        return t
    end
end

return CooldownTimer