--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

TargetParticle = GameObject:extend()

function TargetParticle:new(area, x, y, opts)
    TargetParticle.super.new(self, area, x, y, opts)

    self.color = opts.color or colors.hp_color
    self.r = opts.r or utils.random(2, 3)
    self.timer:tween(opts.d or utils.random(0.1, 0.3), self,
        {r = 0, x = self.target_x, y = self.target_y}, 'out-cubic', function() self.dead = true end)
end

function TargetParticle:destroy()
    TargetParticle.super.destroy(self)
end

function TargetParticle:update(dt)
    TargetParticle.super.update(self, dt)
end

function TargetParticle:draw()
    love.graphics.setColor(self.color)
    draft:rhombus(self.x, self.y, 2*self.r, 2*self.r, 'fill')
    love.graphics.setColor(colors.default_color)
end

