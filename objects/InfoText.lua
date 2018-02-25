--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 21.02.18
-- Time: 19:13
-- To change this template use File | Settings | File Templates.
--

InfoText = GameObject:extend()

function InfoText:new(area, x, y, opts)
    InfoText.super.new(self, area, x, y, opts)

    self.font = opts.font or fonts.C64_Pro_STYLE
    self.size = opts.size or 24
    self.color = opts.color or colors.default_color
    self.depth = 80
    self.characters = {}
    self.background_colors = {}
    self.foreground_colors = {}

    for i = 1, #self.text do table.insert(self.characters, self.text:utf8sub(i, i)) end

    self.visible = true
    self.timer:after(0.70, function()
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)
    end)

    self.timer:after(1.10, function() self.dead = true end)
    self.visible = true
    self.timer:after(0.70, function()
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)

        self.timer:every(0.035, function()
            local random_characters = '0123456789!@#$%¨&*()-=+[]^~/;?><.,|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYXZ'
            for i, character in ipairs(self.characters) do
                if love.math.random(1, 20) <= 1 then
                    local r = love.math.random(1, #random_characters)
                    self.characters[i] = random_characters:utf8sub(r, r)
                else
                    self.characters[i] = character
                end
                if love.math.random(1, 10) <= 1 then
                    self.background_colors[i] = utils.table.random(self.all_colors)
                else
                    self.background_colors[i] = nil
                end

                if love.math.random(1, 10) <= 2 then
                    self.foreground_colors[i] = utils.table.random(self.all_colors)
                else
                    self.background_colors[i] = nil
                end
            end
        end)
    end)

    self.timer:after(1.10, function() self.dead = true end)

    local default_colors = {colors.default_color, colors.hp_color, colors.ammo_color, colors.boost_color, colors.skill_point_color}
    local negative_colors = {
        {255-colors.default_color[1], 255-colors.default_color[2], 255-colors.default_color[3]},
        {255-colors.hp_color[1], 255-colors.hp_color[2], 255-colors.hp_color[3]},
        {255-colors.ammo_color[1], 255-colors.ammo_color[2], 255-colors.ammo_color[3]},
        {255-colors.boost_color[1], 255-colors.boost_color[2], 255-colors.boost_color[3]},
        {255-colors.skill_point_color[1], 255-colors.skill_point_color[2], 255-colors.skill_point_color[3]}
    }
    self.all_colors = fn.append(default_colors, negative_colors)
end

function InfoText:destroy()
    InfoText.super.destroy(self)
end

function InfoText:update(dt)
    InfoText.super.update(self, dt)
end

function InfoText:draw()
    if not self.visible then return end

    love.graphics.setFont(self.font, self.size)

    for i = 1, #self.characters do
        local width = 0
        if i > 1 then
            for j = 1, i-1 do
                width = width + self.font:getWidth(self.characters[j])
            end
        end

        if self.background_colors[i] then
            love.graphics.setColor(self.background_colors[i])
            love.graphics.rectangle('fill', self.x + width, self.y - self.font:getHeight()/2,
                self.font:getWidth(self.characters[i]), self.font:getHeight())
        end

        love.graphics.setColor(self.foreground_colors[i] or self.color or colors.default_color)
        love.graphics.print(self.characters[i], self.x + width, self.y,
            0, 1, 1, 0, self.font:getHeight()/2)
    end

    love.graphics.setColor(colors.default_color)
end


