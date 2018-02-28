--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)

    self.s = opts.s or 2.5
    self.v = opts.v or 200

    self.attack = opts.attack or 'Neutral'
    self.color = colors.default_color

    withAttack(self.attack, function(attack)
        self.color = attack.color
    end)

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setCollisionClass('Projectile')
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    -- stats
    self.damage = opts.damage or 100
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end

function Projectile:die()
    self.dead = true
    self.area:addGameObject('ProjectileDeathEffect', self.x, self.y,
        {color = colors.hp_color, w = 3*self.s})
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()

        object:hit(self.damage)
        self:die()
    end
    if self.collider:enter('EnemyProjectile') then
        local collision_data = self.collider:getEnterCollisionData('EnemyProjectile')
        local object = collision_data.collider:getObject()

        object:die()
        self:die()
    end
end

function Projectile:draw()
    love.graphics.setColor(colors.default_color)

    utils.pushRotate(self.x, self.y, self.r)
    love.graphics.setLineWidth(self.s - self.s/4)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - 2*self.s, self.y, self.x, self.y)
    love.graphics.setColor(colors.hp_color) -- change half the projectile line to another color
    love.graphics.line(self.x, self.y, self.x + 2*self.s, self.y)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end


