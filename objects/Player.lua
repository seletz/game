--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
end

function Player:update(dt)
    Player.super.update(self, dt)
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, 25)
end


