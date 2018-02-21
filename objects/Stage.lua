--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 20.02.18
-- Time: 22:11
-- To change this template use File | Settings | File Templates.
--

Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas(gw, gh)

    self.timer = Timer()

--[[    self.timer:every(0.3, function()
        local x = love.math.random(0,gw)
        local y = love.math.random(0,gh)
        local r = love.math.random(0,gw / 10)
        self.area:addGameObject('Circle', x, y, {radius = r})
    end, 10)]]

    camera.smoother = Camera.smooth.damped(5)

    self.area:addGameObject('Player', gw/2, gh/2)
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

