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

    self.area:addGameObject('Circle', 400, 300, {radius = 50})
    self.area:dump()
end

function Stage:update(dt)
    self.area:update(dt)
end

function Stage:draw()
    self.area:draw()
end

