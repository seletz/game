--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

Rock = GameObject:extend()

function Rock:new(area, x, y, opts)
    Rock.super.new(self, area, x, y, opts)

    local direction = utils.table.random({-1, 1})
    self.s = 16
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = utils.random(self.s, gh - self.s)

    self.color = opts.color or colors.hp_color
    self.points = utils.createIrregularPolyPoints(self.s/2, 8)

    self.collider = self.area.world:newPolygonCollider(self.points)
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.v = -direction*utils.random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(utils.random(-100, 100))

    -- effects

    self.hit_flash = false

    -- stats

    self.hp = opts.hp or 100
end

function Rock:destroy()
    Rock.super.destroy(self)
end

function Rock:die()
    self.dead = true
    for i = 1, love.math.random(4, 8) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = self.color})
    end
end

function Rock:hit(damage)
    local damage = damage or 100

    self.hp = self.hp - damage

    if self.hp <= 0 then
        self:die()
    else
        self.hit_flash = true
        self.timer:after(0.2, function() self.hit_flash = false end)
    end
end

function Rock:update(dt)
    Rock.super.update(self, dt)
end

function Rock:draw()
    if self.hit_flash then
        love.graphics.setColor(colors.default_color)
    else
        love.graphics.setColor(self.color)
    end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(colors.default_color)
end


