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
    self.director = Director(self)
    self.area:addPhysicsWorld()

    self.font = fonts.C64_Pro_STYLE

    self.score = 0
    self.skill_points = 0

    -- Projectile will ignore Projectile
    -- XXX: Collectable will ignore Collectable
    -- Collectable will ignore Projectile
    -- Player will generate collision events with Collectable
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Player', 'Projectile'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})

    self.player = self.area:addGameObject('Player', gw/2, gh/2)

    input:bind('1', function()
        self.player:setAttack("Neutral")
    end)

    input:bind('2', function()
        self.player:setAttack("Double")
    end)

    input:bind('3', function()
        self.player:setAttack("Triple")
    end)

    input:bind('4', function()
        self.player:setAttack("Rapid")
    end)

    input:bind('5', function()
        self.player:setAttack("Spread")
    end)

    input:bind('6', function()
        self.player:setAttack("Back")
    end)

    input:bind('7', function()
        self.player:setAttack("Side")
    end)

end

function Stage:addScore(pt)
    self.score = self.score + pt
end

function Stage:addSkillPoint(pt)
    self.skill_points = self.skill_points + pt
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
end

function Stage:finish()
    timer:after(1, function()
        gotoRoom('Stage')
    end)
end

function Stage:update(dt)
    camera:lockPosition(dt, gw/2, gh/2)

    self.timer:update(dt)
    self.director:update(dt)
    self.area:update(dt)
end

function Stage:addSPResource()
    print("+SP")
    self.area:addGameObject('SkillPoint', utils.random(0, gw), utils.random(0, gh))
end

function Stage:addHPResource()
    print("+HP")
    self.area:addGameObject('HP', utils.random(0, gw), utils.random(0, gh))
end

function Stage:addRandomAttackResource()
    local attacks = {}
    for k in pairs(game_state.attacks) do
        table.insert(attacks, k)
    end

    local attack = attacks[math.random(#attacks)]

    print("+"..attack)
    self.area:addGameObject("Attack", utils.random(0, gw), utils.random(0, gh), {
        attack=attack
    })
end

local function bar(x, y, w, h, color, current, max, font, font_scale)
    local r, g, b = unpack(color or colors.default_color)
    local current, max = math.floor(current or 0), max or 100
    local w = w or 48
    local h = h or 4
    local sf = font_scale or 0.75
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', x, y, w*(current / max), h)
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', x, y, w, h)

    love.graphics.setFont(font)
    love.graphics.setColor(r, g, b)
    love.graphics.print(current .. '/' .. max, x + 24, y - 10, 0, sf, sf,
        math.floor(font:getWidth(current .. '/' .. max)/2),
        math.floor(font:getHeight()/2))
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    self.area:draw()
    camera:detach()

    love.graphics.setFont(self.font)

    -- Score
    love.graphics.setColor(colors.default_color)
    love.graphics.print(self.score, gw - 20, 10, 0, 1, 1,
        math.floor(self.font:getWidth(self.score)/2), self.font:getHeight()/2)

    -- Skill Points
    love.graphics.setColor(colors.skill_point_color)
    love.graphics.print(self.skill_points, 20, 10, 0, 1, 1,
        math.floor(self.font:getWidth(self.skill_points)/2), self.font:getHeight()/2)

    -- Hp
    bar(gw/2 - 52, gh - 16, 48, 4, colors.hp_color, self.player.hp, self.player.max_hp, self.font)

    -- Ammo
    bar(gw/2 - 52, 16, 48, 4, colors.ammo_color, self.player.ammo, self.player.max_ammo, self.font)

    -- boost
    bar(gw/2 + 4, 16, 48, 4, colors.boost_color, self.player.boost, self.player.max_boost, self.font)

    -- cycle
    bar(gw/2 + 4, gh - 16, 48, 4, colors.default_color, self.director.cycle_time*10, self.director.cycle_duration*10, self.font)


    love.graphics.setColor(255, 255, 255)
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

