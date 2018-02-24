--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

ShootEffect = GameObject:extend()

function ShootEffect:new(area, x, y, opts)
    ShootEffect.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w = 8
    self.timer:tween(0.1, self, {w = 0}, 'in-out-cubic', function() self.dead = true end)
end

function ShootEffect:destroy()
    ShootEffect.super.destroy(self)
end

function ShootEffect:update(dt)
    ShootEffect.super.update(self, dt)
    if self.player then
        self.x = self.player.x + self.d*math.cos(self.player.r)
        self.y = self.player.y + self.d*math.sin(self.player.r)
    end
end

function ShootEffect:draw()
    utils.pushRotate(self.x, self.y, self.player.r + math.pi/4)
    love.graphics.setColor(colors.default_color)
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
    love.graphics.pop()
end


