--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 18.02.18
-- Time: 13:23
-- To change this template use File | Settings | File Templates.
--

HyperCircle = Circle:extend()

local Timer = require 'libraries/hump/timer'


function HyperCircle:new(x, y, radius, line_width, outer_radius)
    HyperCircle.super.new(self, x, y, radius)

    self.line_width = line_width
    self.outer_radius = outer_radius

    local period = 0.25

    self.timer:script(function(wait)
        while true do
            self.timer:tween(period, self, {line_width = line_width * 1.1}, "in-out-quad")
            wait(period)
            self.timer:tween(period, self, {line_width = line_width *0.9}, "in-out-quad")
            wait(period)
        end
    end)
end

function HyperCircle:update(dt)
    self.super.update(self, dt)

    if input:down("left") then
        self.x = self.x - 1
    end
    if input:down("right") then
        self.x = self.x + 1
    end
end

function HyperCircle:draw()
    self.super.draw(self)
    love.graphics.setLineWidth( self.line_width )
    love.graphics.circle("line", self.x, self.y, self.outer_radius, Circle.segments)
end

function HyperCircle:__tostring()
    return "HyperCircle( " .. self.creation_time .. " r=" .. self.radius .. " @ " .. self.x .. ", " .. self.y .. " )"
end

return HyperCircle

