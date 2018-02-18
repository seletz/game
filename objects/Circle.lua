--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 18.02.18
-- Time: 13:04
-- To change this template use File | Settings | File Templates.
--

Circle = Object:extend()

Circle.segments = 100

function Circle:new(x, y, radius)
    self.x = x
    self.y = y
    self.radius = radius
    self.creation_time = love.timer.getDelta()
end

function Circle:update(dt)
end

function Circle:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius, Circle.segments)
end

function Circle:__tostring()
    return "Circle( " .. self.creation_time .. " r=" .. self.radius .. " @ " .. self.x .. ", " .. self.y .. " )"
end

return Circle

