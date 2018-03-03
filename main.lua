------------------------------------------------------------------------------
-- LIBRARIES
--dbg         = require 'libraries/mobdebug/mobdebug'
Input       = require 'libraries/input/Input'
Object      = require 'libraries/classic/classic'
Timer       = require 'libraries/hump/timer'
Camera      = require 'libraries/hump/camera'
Vector      = require 'libraries/hump/vector'
Physics     = require 'libraries/windfield'
Draft       = require 'libraries/draft/draft'
fn          = require 'libraries/moses/moses'
lume        = require 'libraries/lume/lume'
require 'libraries/utf8/utf8'
require 'libraries/lovedebug/lovedebug'

------------------------------------------------------------------------------
-- GAME LIBRARIES
CooldownTimer   = require 'libraries/game/CooldownTimer'
GameObject      = require 'libraries/game/GameObject'
Stats           = require 'libraries/game/Stats'
gameui          = require 'libraries/game/UI'
utils           = require 'libraries/game/utils'
colors          = require 'libraries/game/colors'

------------------------------------------------------------------------------
-- GLOBALS
require 'libraries/game/globals'

------------------------------------------------------------------------------
-- FUNCTIONS

function love.load()

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
    love.graphics.setLineStyle("rough")
    resize(2)
    gotoRoom("Stage")
end

function love.update(dt)
    -- require("libraries/lovebird/lovebird").update()

    withCurrentTime(dt, function(t)
        --lurker.update()
        timer:update(t)
        camera:update(t)
    end)

    withCurrentRoom(function(room)
        room:update(dt)
    end)
end

function love.draw()
    withCurrentRoom(function(room)
        room:draw(dt)
    end)

    if current_room then
        current_room:draw()
    end

    untilCounterZero("flash_frames", function()
        love.graphics.setColor(colors.background_color)
        love.graphics.rectangle('fill', 0, 0, sx*gw, sy*gh)
        love.graphics.setColor(255, 255, 255)
    end)
end



