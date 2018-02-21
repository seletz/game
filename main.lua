------------------------------------------------------------------------------
-- LIBRARIES
dbg = require 'libraries/mobdebug/mobdebug'
Input = require 'libraries/input/Input'
Object = require 'libraries/classic/classic'
Timer = require 'libraries/hump/timer'
Camera = require 'libraries/hump/camera'
Physics = require 'libraries/windfield'
lurker = require 'libraries/lurker/lurker'
Draft = require 'libraries/draft/draft'

------------------------------------------------------------------------------
-- GAME LIBRARIES
require 'objects/GameObject'
utils = require 'utils'
colors = require 'colors'

------------------------------------------------------------------------------
-- GLOBALS
camera = Camera()
draft = Draft()

------------------------------------------------------------------------------
-- GLOBAL INITS

-- no buffering for stdouti please
io.stdout:setvbuf("no")
camera.smoother = Camera.smooth.damped(5)
lurker.interval = 0.25

game_state = {
    current_room = nil,
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

    input:bind("f2", function()
        gotoRoom("Stage")
    end)

    input:bind("f3", function()
        if current_room and current_room.destroy then
            print("kill current room ...")
            current_room:destroy()
        end
    end)

    love.graphics.setDefaultFilter("nearest")
    resize(2)
    gotoRoom("Stage")
end

function love.update(dt)
    lurker.update()
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
    if current_room and current_room.destroy then current_room:destroy() end
    game_state.current_room = _G[room_type](...)
end
