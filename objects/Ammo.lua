--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

Ammo = GameObject:extend()

function Ammo:new(area, x, y, opts)
    Ammo.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 8, 8

    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setCollisionClass("Collectable")
    self.collider:setObject(self)
    self.collider:setFixedRotation(false)
    self.r = utils.random(0, math.pi)
    self.v = utils.random(10, 20)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    self.collider:applyAngularImpulse(utils.random(-24, 24))
end

function Ammo:destroy()
    Ammo.super.destroy(self)
end

function Ammo:update(dt)
    Ammo.super.update(self, dt)

    local target = game_state.current_room.player
    if target then
        local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
        local angle = math.atan2(target.y - self.y, target.x - self.x)
        local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
        local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
        self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
    else
        self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    end
end

function Ammo:draw()
    love.graphics.setColor(colors.ammo_color)
    utils.pushRotate(self.x, self.y, self.collider:getAngle())
    draft:rhombus(self.x, self.y, self.w, self.h, 'line')
    love.graphics.pop()
    love.graphics.setColor(colors.default_color)
end


