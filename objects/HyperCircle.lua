--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 18.02.18
-- Time: 13:23
-- To change this template use File | Settings | File Templates.
--

HyperCircle = Circle:extend()


function HyperCircle:new(x, y, radius, line_width, outer_radius)
    HyperCircle.super.new(self, x, y, radius)

    self.line_width = line_width
    self.outer_radius = outer_radius
end

function HyperCircle:update(dt)
    if input:down("left") then
        self.x = self.x - 1
    end
    if input:down("right") then
        self.x = self.x + 1
    end

    if input:sequence("right", 0.5, "left", 0.5, "right") then
        self.line_width = self.line_width * 2
        print("lw combo: " .. self.line_width)
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

