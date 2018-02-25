--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

PreAttackEffect = GameObject:extend()

function PreAttackEffect:new(area, x, y, opts)
    PreAttackEffect.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w = 8
    self.timer:after(self.duration - self.duration/4, function() self.dead = true end)
    self.timer:every(0.02, function()
        self.area:addGameObject('TargetParticle',
            self.x + utils.random(-20, 20), self.y + utils.random(-20, 20),
            {target_x = self.x, target_y = self.y, color = self.color})
    end)
end

function PreAttackEffect:destroy()
    PreAttackEffect.super.destroy(self)
end

function PreAttackEffect:update(dt)
    PreAttackEffect.super.update(self, dt)
    if self.shooter and not self.shooter.dead then
        self.x = self.shooter.x + 1.4*self.shooter.w*math.cos(self.shooter.collider:getAngle())
        self.y = self.shooter.y + 1.4*self.shooter.w*math.sin(self.shooter.collider:getAngle())
    end
end

function PreAttackEffect:draw()
end


