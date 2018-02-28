--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 26.02.18
-- Time: 21:24
-- To change this template use File | Settings | File Templates.
--

local Stats = Object:extend()

function Stats:new(name, base, max, multiplier, value)
    self.name = name
    self.base = base or 100
    self.max = max or self.base
    self.multiplier = multiplier or 1
    self.bonus = 0

    self:reset(value)
end

function Stats:add(amount, f)
    self.value = math.max(0, math.min(self.value + amount, self.max))

    if self.value <= 0 and f then
        f(self)
    end

    return self.value
end

function Stats:sub(amount, f)
    self.value = math.max(0, math.min(self.value - amount, self.max))

    if self.value <= 0 and f then
        f(self)
    end

    return self.value
end

function Stats:multiply(m)
    self.multiplier = m or 1
    return self:reset()
end

function Stats:reset(value, f)
    self.value = self.multiplier*(self.bonus + (value or self.base))

    if self.value <= 0 and f then
        f(self)
    end
    return self.value
end

return Stats

