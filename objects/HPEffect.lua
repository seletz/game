--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

HPEffect = GameObject:extend()

function HPEffect:new(area, x, y, opts)
    HPEffect.super.new(self, area, x, y, opts)

    self.current_color = colors.default_color
    self.timer:after(0.2, function()
        self.current_color = self.color
        self.timer:after(0.35, function()
            self.dead = true
        end)
    end)

    self.visible = true
    self.timer:after(0.2, function()
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)
    end)

    self.m = 1
    self.timer:tween(0.25, self, {m = 2}, 'in-out-cubic')
end

function HPEffect:destroy()
    HPEffect.super.destroy(self)
end

function HPEffect:update(dt)
    HPEffect.super.update(self, dt)
end

function HPEffect:draw()
    if not self.visible then return end

    love.graphics.setColor(self.current_color)
    love.graphics.circle('line', self.x, self.y, self.s*self.m)
    love.graphics.setColor(colors.default_color)
end


