--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

Shooter = GameObject:extend()

function Shooter:new(area, x, y, opts)
    Shooter.super.new(self, area, x, y, opts)

    local direction = utils.table.random({-1, 1})
    self.w, self.h = 12, 6
    self.x = gw/2 + direction*(gw/2 + 48)
    self.y = utils.random(self.h, gh - self.h)

    self.color = opts.color or colors.hp_color
    self.collider = self.area.world:newPolygonCollider(
        {self.w, 0, -self.w/2, self.h, -self.w, 0, -self.w/2, -self.h})
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.collider:setAngle(direction == 1 and math.pi or 0)
    self.collider:setFixedRotation(true)
    self.v = -direction*utils.random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)

    -- effects

    self.hit_flash = false
    self.timer:every(utils.random(3, 5), function()
        self.area:addGameObject('PreAttackEffect',
            self.x + 1.4*self.w*math.cos(self.collider:getAngle()),
            self.y + 1.4*self.w*math.sin(self.collider:getAngle()),
            {shooter = self, color = colors.hp_color, duration = 1})
        self.timer:after(1, function()
            local current_room = game_state.current_room

            self.area:addGameObject('EnemyProjectile',
                self.x + 1.4*self.w*math.cos(self.collider:getAngle()),
                self.y + 1.4*self.w*math.sin(self.collider:getAngle()),
                {
                    r = math.atan2(current_room.player.y - self.y, current_room.player.x - self.x),
                    v = utils.random(80, 100), s = 3.5
                })
        end)
    end)

    -- stats

    self.hp = opts.hp or 100
    self.value = 150
end

function Shooter:destroy()
    Shooter.super.destroy(self)
end

function Shooter:die()
    self.dead = true
    for i = 1, love.math.random(4, 8) do
        self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 3, color = self.color})
    end
end

function Shooter:hit(damage)
    local damage = damage or 100

    self.hp = self.hp - damage

    if self.hp <= 0 then
        self:die()
        self.area.room:addScore(self.value)
    else
        self.hit_flash = true
        self.timer:after(0.2, function() self.hit_flash = false end)
    end
end

function Shooter:update(dt)
    Shooter.super.update(self, dt)
end

function Shooter:draw()
    if self.hit_flash then
        love.graphics.setColor(colors.default_color)
    else
        love.graphics.setColor(self.color)
    end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(colors.default_color)
end


