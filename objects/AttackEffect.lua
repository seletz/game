--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

AttackEffect = GameObject:extend()

function AttackEffect:new(area, x, y, opts)
    AttackEffect.super.new(self, area, x, y, opts)

    self.color = opts.color or colors.default_color

    self.visible = true
    self.timer:after(0.2, function()
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)
    end)

    self.s = 1
    self.timer:tween(0.35, self, {s = 3}, 'in-out-cubic')
    self.timer:after(0.45, function()
        self.dead = true
    end)
end

function AttackEffect:destroy()
    AttackEffect.super.destroy(self)
end

function AttackEffect:update(dt)
    AttackEffect.super.update(self, dt)
end

function AttackEffect:draw()
    if not self.visible then return end

    local w = self.w * self.s
    local wi = (self.w - 5)* self.s

    love.graphics.setColor(self.color)
    draft:rhombus(self.x, self.y, wi, wi, 'line')
    love.graphics.setColor(colors.default_color)
    draft:rhombus(self.x, self.y, w, w, 'line')
    love.graphics.setColor(colors.default_color)
end


