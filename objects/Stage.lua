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

    self.font = GAME_FONT

    self.score = 0
    self.skill_points = 0

    -- Projectile will ignore Projectile
    -- XXX: Collectable will ignore Collectable
    -- Collectable will ignore Projectile
    -- Player will generate collision events with Collectable
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile', 'Player'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Enemy', 'Projectile'}})

    -- Apparently there's no way to alter the collision ignores using the windfield api. sigh.
    do 
        local collectable = self.area.world.collision_classes["Collectable"]
        local enemyprojectile = self.area.world.collision_classes["EnemyProjectile"]

        table.insert(collectable.ignores, "EnemyProjectile")
        table.insert(enemyprojectile.ignores, "Collectable")

        self.area.world:collisionClassesSet()
    end


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
    withState("attacks", function(state)
        local attacks = lume.keys(state)
        local attack = lume.randomchoice(attacks)

        print("+"..attack)

        self.area:addGameObject("Attack", utils.random(0, gw), utils.random(0, gh), {
            attack=attack
        })

    end)
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
    love.graphics.print(self.score, gw - 80, 0) --, 0, 1, 1,
        --math.floor(self.font:getWidth(self.score)/2), self.font:getHeight()/2)

    -- Skill Points
    love.graphics.setColor(colors.skill_point_color)
    love.graphics.print(self.skill_points, 80, 0) --, 0, 1, 1,
        --math.floor(self.font:getWidth(self.skill_points)/2), self.font:getHeight()/2)

    -- Hp
    gameui.bar(gw/2 - 52, gh - 16, 48, 4, colors.hp_color,
        self.player.hp_stat.value,
        self.player.hp_stat.max,
        self.font)

    -- Ammo
    gameui.bar(gw/2 - 52, 16, 48, 4, colors.ammo_color,
        self.player.ammo_stat.value,
        self.player.ammo_stat.max,
        self.font)

    -- boost
    gameui.bar(gw/2 + 4, 16, 48, 4, colors.boost_color,
        self.player.boost_stat.value,
        self.player.boost_stat.max,
        self.font)

    -- cycle
    gameui.bar(gw/2 + 4, gh - 16, 48, 4, colors.default_color,
        self.director.cycle_time*10, self.director.cycle_duration*10,
        self.font)


    love.graphics.setColor(255, 255, 255)
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

