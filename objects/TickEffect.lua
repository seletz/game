--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

TickEffect = GameObject:extend()

function TickEffect:new(area, x, y, opts)
    TickEffect.super.new(self, area, x, y, opts)

    self.w, self.h = 48, 32
    self.y_offset = 0
    self.timer:tween(0.13, self, {h = 0, y_offset = 32}, 'in-out-cubic',
        function() self.dead = true end)
end

function TickEffect:destroy()
    TickEffect.super.destroy(self)
end

function TickEffect:update(dt)
    TickEffect.super.update(self, dt)
    if self.parent then self.x, self.y = self.parent.x, self.parent.y - self.y_offset end
end

function TickEffect:draw()
    utils.pushRotate(self.x, self.y, self.parent.r)
    love.graphics.setColor(colors.default_color)
    love.graphics.rectangle('fill', self.x- self.w/2, self.y - self.h/2, self.w, self.h)
    love.graphics.pop()
end


