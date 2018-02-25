--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Player')

    self.ship = 'Fighter'
    self.polygons = {}

    if self.ship == 'Fighter' then
        self.polygons[1] = {
            self.w, 0, -- 1
            self.w/2, -self.w/2, -- 2
            -self.w/2, -self.w/2, -- 3
            -self.w, 0, -- 4
            -self.w/2, self.w/2, -- 5
            self.w/2, self.w/2, -- 6
        }

        self.polygons[2] = {
            self.w/2, -self.w/2, -- 7
            0, -self.w, -- 8
            -self.w - self.w/2, -self.w, -- 9
            -3*self.w/4, -self.w/4, -- 10
            -self.w/2, -self.w/2, -- 11
        }

        self.polygons[3] = {
            self.w/2, self.w/2, -- 12
            -self.w/2, self.w/2, -- 13
            -3*self.w/4, self.w/4, -- 14
            -self.w - self.w/2, self.w, -- 15
            0, self.w, -- 16
        }
    end

    self.r = -math.pi/2
    self.rv = 1.66*math.pi
    self.v = 0
    self.base_max_v = 100
    self.max_v = self.base_max_v
    self.a = 100

    self.trail_color = colors.trail_color
    self.timer:every(0.01, function()
        if self.ship == 'Fighter' then
            self.area:addGameObject('TrailParticle',
                self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2),
                self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2),
                {parent = self, r = utils.random(2, 4), d = utils.random(0.15, 0.25), color = self.trail_color})
            self.area:addGameObject('TrailParticle',
                self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2),
                self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2),
                {parent = self, r = utils.random(2, 4), d = utils.random(0.15, 0.25), color = self.trail_color})
        else
            self.area:addGameObject('TrailParticle',
                self.x - self.w*math.cos(self.r), self.y - self.h*math.sin(self.r),
                {parent = self, r = utils.random(2, 4), d = utils.random(0.15, 0.25), color = self.trail_color})
        end
    end)

    self.timer:every(0.24, function()
        self:shoot()
    end)

    self.timer:every(5, function()
        self:tick()
    end)

    -- Stats

    self.max_boost = 100
    self.boost = self.max_boost
    self.can_boost = true
    self.boost_timer = 0
    self.boost_cooldown = 2

    self.max_hp = 100
    self.hp = self.max_hp

    self.max_ammo = 100
    self.ammo = self.max_ammo
end

function Player:destroy()
    Player.super.destroy(self)
end

function Player:shoot()
    local d = 1.2*self.w

    if self.ammo > 0 then
        self.ammo = self.ammo - 1

    self.area:addGameObject('ShootEffect',
        self.x + d*math.cos(self.r),
        self.y + d*math.sin(self.r),
        {player = self, d = d})

    self.area:addGameObject('Projectile',
        self.x + 1.5*d*math.cos(self.r),
        self.y + 1.5*d*math.sin(self.r),
        {r = self.r})
    end
end

function Player:tick()
    self.area:addGameObject('TickEffect', self.x, self.y, {parent = self})
end

function Player:die()
    self.dead = true
    flash(4)
    camera:shake(6, 60, 0.4)
    slow(0.15, 1)

    for i = 1, love.math.random(8, 12) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y)
    end
end

function Player:update(dt)
    Player.super.update(self, dt)

    if input:down('left') then self.r = self.r - self.rv*dt end
    if input:down('right') then self.r = self.r + self.rv*dt end

    self.boost = math.min(self.boost + 10*dt, self.max_boost)
    self.boost_timer = self.boost_timer + dt
    if self.boost_timer > self.boost_cooldown then self.can_boost = true end
    self.max_v = self.base_max_v
    self.boosting = false

    if input:down('up') and self.boost > 1 and self.can_boost then
        self.boosting = true
        self.max_v = 1.5*self.base_max_v
        self.boost = self.boost - 50*dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
    end
    if input:down('down') and self.boost > 1 and self.can_boost then
        self.boosting = true
        self.max_v = 0.5*self.base_max_v
        self.boost = self.boost - 50*dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
    end
    self.trail_color = colors.skill_point_color
    if self.boosting then self.trail_color = colors.boost_color end

    --
    self.v = math.min(self.v + self.a*dt, self.max_v)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    if self.collider:enter('Collectable') then
        local collision_data = self.collider:getEnterCollisionData('Collectable')
        local object = collision_data.collider:getObject()
        if object:is(Ammo) then
            object:die()
            self:addAmmo(5)
        end
    end
end

function Player:addAmmo(amount)
    self.ammo = math.min(self.ammo + amount, self.max_ammo)
end

function Player:draw()
    --love.graphics.circle('line', self.x, self.y, self.w)
    --love.graphics.line(self.x, self.y, self.x + self.w*math.cos(self.r), self.y + self.w*math.sin(self.r))

    utils.pushRotate(self.x, self.y, self.r)
    love.graphics.setColor(colors.default_color)

    for _, polygon in ipairs(self.polygons) do
        local points = fn.map(polygon, function(k, v)
            if k % 2 == 1 then
                return self.x + v + utils.random(-1, 1)
            else
                return self.y + v + utils.random(-1, 1)
            end
        end)
        love.graphics.polygon('line', points)
    end

    love.graphics.pop()

    love.graphics.print(
        string.format("HP %2d AM %2d BST %2d V %2d ", self.hp, self.ammo, self.boost, self.v),
        10, 10)
end


