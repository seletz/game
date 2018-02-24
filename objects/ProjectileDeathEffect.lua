--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

ProjectileDeathEffect = GameObject:extend()

function ProjectileDeathEffect:new(area, x, y, opts)
    ProjectileDeathEffect.super.new(self, area, x, y, opts)

    self.first = true
    self.timer:after(0.1, function()
        self.first = false
        self.second = true
        self.timer:after(0.15, function()
            self.second = false
            self.dead = true
        end)
    end)
end

function ProjectileDeathEffect:destroy()
    ProjectileDeathEffect.super.destroy(self)
end

function ProjectileDeathEffect:update(dt)
    ProjectileDeathEffect.super.update(self, dt)
    if self.player then
        self.x = self.player.x + self.d*math.cos(self.player.r)
        self.y = self.player.y + self.d*math.sin(self.player.r)
    end
end

function ProjectileDeathEffect:draw()
    if self.first then
        love.graphics.setColor(colors.default_color)
    elseif self.second then
        love.graphics.setColor(self.color)
    end
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
end


