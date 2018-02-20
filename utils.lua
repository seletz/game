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

return utils


