--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 20.02.18
-- Time: 22:11
-- To change this template use File | Settings | File Templates.
--

Stage = Object:extend()

function Stage:new()
    self.main_canvas = love.graphics.newCanvas(gw, gh)

    self.timer = Timer()

    self.area = Area(self)
    self.area:addPhysicsWorld()


    -- Projectile will ignore Projectile
    -- XXX: Collectable will ignore Collectable
    -- Collectable will ignore Projectile
    -- Player will generate collision events with Collectable
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Projectile'}})
    -- self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})

    self.player = self.area:addGameObject('Player', gw/2, gh/2)

    input:bind('p', function()
        self.area:addGameObject('Ammo', utils.random(0, gw), utils.random(0, gh))
    end)

    input:bind('f4', function()
        self.player:die()
    end)

end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
end

function Stage:update(dt)
    self.timer:update(dt)

    camera:lockPosition(dt, gw/2, gh/2)

    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.area:draw()
    camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

