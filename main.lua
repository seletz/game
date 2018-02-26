------------------------------------------------------------------------------
-- LIBRARIES
dbg = require 'libraries/mobdebug/mobdebug'
Input = require 'libraries/input/Input'
Object = require 'libraries/classic/classic'
Timer = require 'libraries/hump/timer'
Camera = require 'libraries/hump/camera'
Vector = require 'libraries/hump/vector'
Physics = require 'libraries/windfield'
lurker = require 'libraries/lurker/lurker'
Draft = require 'libraries/draft/draft'
fn = require 'libraries/moses/moses'

require 'libraries/utf8/utf8'

------------------------------------------------------------------------------
-- GAME LIBRARIES
require 'objects/GameObject'
utils = require 'utils'
colors = require 'colors'

------------------------------------------------------------------------------
-- GLOBALS
camera = Camera()
draft = Draft()
timer = Timer()

------------------------------------------------------------------------------
-- GLOBAL INITS

-- no buffering for stdouti please
io.stdout:setvbuf("no")
camera.smoother = Camera.smooth.damped(5)
lurker.interval = 0.25

game_state = {
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

------------------------------------------------------------------------------
-- FUNCTIONS

function resize(s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
end

function love.load()
    local object_files = {}
    utils.recursiveEnumerate('objects', object_files)
    utils.requireFiles(object_files)

    fonts = utils.loadFonts()

    -- this only works if initialized here . :??
    input = Input()

    input:bind("left", "left")
    input:bind("right", "right")
    input:bind("up", "up")
    input:bind("down", "down")

    input:bind("f1", function()
        print("------------------------------------------------------------")
        print("Before collection: " .. collectgarbage("count")/1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count")/1024)
        print("Object count: ")
        local counts = utils.type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("------------------------------------------------------------")
    end)

    love.graphics.setDefaultFilter("nearest")
    resize(2)
    gotoRoom("Stage")
end

function love.update(dt)
    local slow_amount = game_state.slow_amount
    local dt = dt * slow_amount

    lurker.update()

    timer:update(dt)
    camera:update(dt)

    if game_state.current_room then
        game_state.current_room:update(dt)
    end
end

function love.draw()
    love.graphics.setFont(fonts.ARCADECLASSIC)
    local flash_frames = game_state.flash_frames
    local current_room = game_state.current_room

    if current_room then
        current_room:draw()
    end

    if flash_frames then
        flash_frames = flash_frames - 1
        if flash_frames == -1 then flash_frames = nil end
    end
    if flash_frames then
        love.graphics.setColor(colors.background_color)
        love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
        love.graphics.setColor(255, 255, 255)
    end

    game_state.flash_frames = flash_frames
end

function flash(frames)
    game_state.flash_frames = frames
end

function slow(amount, duration)
    game_state.slow_amount = amount
    timer:tween(duration, game_state, {slow_amount = 1}, 'in-out-cubic')
end

function gotoRoom(room_type, ...)
    local current_room = game_state.current_room
    if current_room and current_room.destroy then current_room:destroy() end

    game_state.current_room = _G[room_type](...)
end
