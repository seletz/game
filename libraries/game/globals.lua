--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 27.02.18
-- Time: 21:01
-- To change this template use File | Settings | File Templates.
--

camera = Camera()
draft = Draft()
timer = Timer()

-- no buffering for stdout please
io.stdout:setvbuf("no")
camera.smoother = Camera.smooth.damped(5)

FONT_SIZE = 18

do
    local object_files = {}
    utils.recursiveEnumerate('objects', object_files)
    utils.requireFiles(object_files)
    fonts = utils.loadFonts()
end


GAME_FONT = fonts.SYDNIE_STANDARD

------------------------------------------------------------------------------
-- Game State
state = require "libraries/game/state"


------------------------------------------------------------------------------
-- FUNCTIONS

function resize(s)
    love.window.setMode(s*gw, s*gh)
    sx, sy = s, s
end

function flash(frames)
    state.flash_frames = frames
end

function slow(amount, duration)
    state.slow_amount = amount
    timer:tween(duration, state, {slow_amount = 1}, 'in-out-cubic')
end

function getCurrentRoom()
    return state.current_room
end

function gotoRoom(room_type, ...)
    local current_room = state.current_room
    if current_room and current_room.destroy then current_room:destroy() end

    state.current_room = _G[room_type](...)
end

function withCurrentTime(dt, f, ...)
    local t = state.slow_amount * dt
    return f(t, ...)
end

function withCurrentRoom(f, ...)
    if state.current_room then
        return f(state.current_room, ...)
    end
end

function withState(key, f, ...)
    local s = state[key]
    if s then
        return f(s, ...)
    end
end

function withAttacks(f, ...)
    return f(state.attacks, ...)
end

function withAttack(a, f, ...)
    local attack = state.attacks[a]
    if attack then
        return f(attack, ...)
    end
end

function withPlayer(f, ...)
    return withCurrentRoom(function(room, ...)
        if room.player then
            return f(room.player, ...)
        end
    end)
end

function untilCounterZero(name, f, ...)
    local counter = state[name]
    local flag = true
    if counter then
        counter = counter - 1
        if counter <= 0 then
            flag = false
            counter = nil
        end
        state[name] = counter
        if flag then
            return f(counter, ...)
        end
    end
end

