--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

TrailParticle = GameObject:extend()

function TrailParticle:new(area, x, y, opts)
    TrailParticle.super.new(self, area, x, y, opts)

    self.color = opts.color or colors.trail_color
    self.r = opts.r or random(4, 6)
    self.timer:tween(opts.d or random(0.3, 0.5), self, {r = 0}, 'linear',
        function() self.dead = true end)
end

function TrailParticle:destroy()
    TrailParticle.super.destroy(self)
end

function TrailParticle:update(dt)
    TrailParticle.super.update(self, dt)
end

function TrailParticle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.r);
    love.graphics.setColor(255, 255, 255)
end

