--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

HP = GameObject:extend()

function HP:new(area, x, y, opts)
    HP.super.new(self, area, x, y, opts)

    local direction = utils.table.random({-1, 1})
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = utils.random(48, gh - 48)

    self.color = opts.color or colors.hp_color

    self.s = 14
    self.si = self.s - 6
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(true)
    self.v = -direction*utils.random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    -- self.collider:applyAngularImpulse(utils.random(-24, 24))
end

function HP:destroy()
    HP.super.destroy(self)
end

function HP:die()
    self.dead = true
    self.area:addGameObject('HPEffect', self.x, self.y,
        {color = colors.default_color, s = self.s})

    for i = 1, love.math.random(4, 8) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = colors.hp_color})
    end

    self.area:addGameObject('InfoText',
        self.x + utils.random(-self.s, self.s),
        self.y + utils.random(-self.s, self.s),
        {text = '+HP', color = colors.hp_color})
end

function HP:update(dt)
    HP.super.update(self, dt)
end

function HP:draw()
    love.graphics.setColor(self.color)
    utils.pushRotate(self.x, self.y, self.collider:getAngle())

    -- the cross
    local w = 3
    love.graphics.setColor(colors.hp_color)
    love.graphics.rectangle("fill", self.x - w, self.y - self.si, 2*w, 2*self.si)
    love.graphics.rectangle("fill", self.x - self.si, self.y - w, 2*self.si, 2*w)

    -- the circle
    love.graphics.setColor(colors.default_color)
    love.graphics.circle('line', self.x, self.y, self.s)

    love.graphics.pop()

    love.graphics.setColor(colors.default_color)
end


