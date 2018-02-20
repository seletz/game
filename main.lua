dbg = require 'libraries/mobdebug/mobdebug'
Input = require 'libraries/input/Input'
Object = require 'libraries/classic/classic'
Timer = require 'libraries/hump/timer'
Camera = require 'libraries/hump/camera'

require 'objects/GameObject'

utils = require 'utils'
lurker = require 'libraries/lurker/lurker'

------------------------------------------------------------------------------
-- GLOBAL INITS
io.stdout:setvbuf("no")
lurker.interval = 0.25

------------------------------------------------------------------------------
-- GLOBALS
camera = Camera()
game_state = {
    current_room = nil,
}

function resize(s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
end

function love.load()
    local object_files = {}
    utils.recursiveEnumerate('objects', object_files)
    utils.requireFiles(object_files)

    -- this only works if initialized here . :??
    input = Input()

    input:bind('x', function()
        print("BOOOOOM!")
        camera:shake(4, 60, 1)
    end)

    input:bind("left", "left")
    input:bind("right", "right")
    input:bind("up", "up")
    input:bind("down", "down")

    love.graphics.setDefaultFilter("nearest")
    resize(2)
    gotoRoom("Stage")
end

function love.update(dt)
    -- lurker.update()
    camera:update(dt)

    if game_state.current_room then
        game_state.current_room:update(dt)
    end
end

function love.draw()
    if game_state.current_room then
        game_state.current_room:draw()
    end
end

function gotoRoom(room_type, ...)
    game_state.current_room = _G[room_type](...)
end
