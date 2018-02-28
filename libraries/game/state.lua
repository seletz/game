--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 28.02.18
-- Time: 20:54
-- To change this template use File | Settings | File Templates.
--

local game_state = {
    current_room = nil,
    flash_frames = nil,
    slow_amount = 1,
    attacks = {
        ['Neutral']     = {cooldown = 0.24, ammo = 0, abbreviation = 'N', color = colors.default_color},
        ['Double']      = {cooldown = 0.32, ammo = 2, abbreviation = '2', color = colors.ammo_color},
        ['Triple']      = {cooldown = 0.32, ammo = 3, abbreviation = '3', color = colors.boost_color},
        ['Rapid']       = {cooldown = 0.12, ammo = 1, abbreviation = 'R', color = colors.default_color },
        ['Spread']      = {cooldown = 0.16, ammo = 1, abbreviation = 'RS', color = colors.default_color},
        ['Back']        = {cooldown = 0.32, ammo = 2, abbreviation = 'Ba', color = colors.skill_point_color },
        ['Side']        = {cooldown = 0.32, ammo = 2, abbreviation = 'Si', color = colors.boost_color}
    },
}
return game_state
