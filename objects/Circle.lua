--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 18.02.18
-- Time: 13:04
-- To change this template use File | Settings | File Templates.
--

Circle = GameObject:extend()

Circle.segments = 100

function Circle:update(dt)
    self.super.update(self, dt)

    self.timer:after(love.math.random(2,4), function()
        self.dead = true
    end)
end

function Circle:draw()
    self.super.draw()
    love.graphics.circle("fill", self.x, self.y, self.radius, Circle.segments)
end

function Circle:__tostring()
    return "Circle( " .. self.id .. " r=" .. self.radius .. " @ " .. self.x .. ", " .. self.y .. " )"
end

return Circle

