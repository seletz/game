--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 20.02.18
-- Time: 22:11
-- To change this template use File | Settings | File Templates.
--

Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.timer = Timer()

    self.timer:every(0.3, function()
        local x = love.math.random(0,800)
        local y = love.math.random(0,600)
        local r = love.math.random(0,50)
        local c = self.area:addGameObject('Circle', x, y, {radius = r})
        self.area:dump()
    end, 10)

end

function Stage:update(dt)
    self.timer:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    self.area:draw()
end

