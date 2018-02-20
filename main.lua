dbg = require 'libraries/mobdebug/mobdebug'
Input = require 'libraries/input/Input'
Object = require 'libraries/classic/classic'
io.stdout:setvbuf("no")

lurker = require 'libraries/lurker/lurker'
lurker.interval = 0.25

function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        if love.filesystem.isFile(file) then
            table.insert(file_list, file)
        elseif love.filesystem.isDirectory(file) then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        print("require " .. file)
        require(file)
    end
end

function love.load()
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    c = Circle(400, 300, 50)
    hc = HyperCircle(400, 300, 50, 10, 120)
    print(c)
    print(hc)

    --
    input = Input()
    input:bind("left", "left")
    input:bind("right", "right")
    input:bind("up", "up")
    input:bind("down", "down")
end

function love.update(dt)
    lurker.update()

    -- c:update(dt)
    hc:update(dt)

end

function love.draw()
    c:draw()
    hc:draw()
end
