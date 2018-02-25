--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

Attack = GameObject:extend()

function Attack:new(area, x, y, opts)
    Attack.super.new(self, area, x, y, opts)

    local direction = utils.table.random({-1, 1})
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = utils.random(48, gh - 48)

    self.font = opts.font or fonts.C64_Pro_STYLE
    self.attack = opts.attack or "Double"
    self.color = game_state.attacks[self.attack].color
    self.abbr = game_state.attacks[self.attack].abbreviation

    self.w, self.h = 48, 48
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(true)
    self.v = -direction*utils.random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(utils.random(-24, 24))
end

function Attack:destroy()
    Attack.super.destroy(self)
end

function Attack:die()
    self.dead = true
    self.area:addGameObject('AttackEffect', self.x, self.y,
        {color = self.color, w = self.w, h = self.h, r = self.r})

    for i = 1, love.math.random(4, 8) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = self.color})
    end

    self.area:addGameObject('InfoText',
        self.x + utils.random(-self.w, self.w),
        self.y + utils.random(-self.h, self.h),
        {text = self.attack, color = self.color})
end

function Attack:update(dt)
    Attack.super.update(self, dt)
    self.collider:setLinearVelocity(self.v, 0)
end

function Attack:draw()
    love.graphics.setFont(self.font, self.size)

    local width = self.font:getWidth(self.abbr)

    love.graphics.setColor(self.color)
    utils.pushRotate(self.x, self.y, self.collider:getAngle())
    draft:rhombus(self.x, self.y, self.w - 5, self.h - 5, 'line')
    love.graphics.print(self.abbr, self.x - width/2, self.y,
        0, 1, 1, 0, self.font:getHeight()/2)
    love.graphics.setColor(colors.default_color)
    draft:rhombus(self.x, self.y, self.w, self.h, 'line')
    love.graphics.pop()
end


