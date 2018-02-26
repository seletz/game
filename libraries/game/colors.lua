--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 20.02.18
-- Time: 21:43
-- To change this template use File | Settings | File Templates.
--

local colors = {}

colors.white = {255, 255, 255, 255}
colors.red = {255, 0, 0, 255}
colors.green = {0, 255, 0, 255}
colors.blue = {0, 0, 255, 255 }
colors.cyan = {0, 255, 255, 255 }
colors.magenta = {255, 0, 255, 255 }
colors.yellow = {255, 255, 0, 255 }
colors.black = {0, 0, 0, 255 }

colors.default_color = {222, 222, 222}
colors.background_color = {16, 16, 16}
colors.ammo_color = {123, 200, 164}
colors.boost_color = {76, 195, 217}
colors.hp_color = {241, 103, 69}
colors.skill_point_color = {255, 198, 93 }
colors.trail_color = colors.yellow

colors.default_colors = {colors.default_color, colors.hp_color, colors.ammo_color, colors.boost_color, colors.skill_point_color}
colors.negative_colors = {
    {255-colors.default_color[1], 255-colors.default_color[2], 255-colors.default_color[3]},
    {255-colors.hp_color[1], 255-colors.hp_color[2], 255-colors.hp_color[3]},
    {255-colors.ammo_color[1], 255-colors.ammo_color[2], 255-colors.ammo_color[3]},
    {255-colors.boost_color[1], 255-colors.boost_color[2], 255-colors.boost_color[3]},
    {255-colors.skill_point_color[1], 255-colors.skill_point_color[2], 255-colors.skill_point_color[3]}
}
colors.all_colors = fn.append(colors.default_colors, colors.negative_colors)

return colors


