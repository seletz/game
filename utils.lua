--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 20.02.18
-- Time: 21:43
-- To change this template use File | Settings | File Templates.
--

local utils = {}

function utils.recursiveEnumerate(folder, file_list)
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

function utils.requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        print("require " .. file)
        require(file)
    end
end

function utils.UUID()
    local fn = function(x)
        local r = math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function utils.random(min, max)
    local min, max = min or 0, max or 1
    return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end

return utils


