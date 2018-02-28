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
        local file = utils.removeext(file)
        print("require " .. file)
        require(file)
    end
end

function utils.splitpath(p)
    return string.match(p, "(.-)([^\\/]-%.?([^%.\\/]*))$")
end

function utils.removeext(p)
    return p:sub(1, -5)
end

function utils.loadFonts()
    local files = {}
    local fonts = {}

    utils.recursiveEnumerate("resources/fonts", files)

    for _, file in ipairs(files) do
        local _, fname, ext = utils.splitpath(file)
        if ext and string.match(ext, "ttf") then
            print("font: " .. fname)
            fonts[utils.removeext(fname)] = love.graphics.newFont(file, FONT_SIZE)
        end
    end

    return fonts
end

function utils.createIrregularPolyPoints(s, n)
    local size = s or 14
    local n_points = n or 8
    local dr = 2*math.pi / n_points
    local points = {}

    for i = 0,n_points-1 do
        local r = i*dr
        local d = size + utils.random(-size/4, size/4)

        table.insert(points, d*math.cos(r))
        table.insert(points, d*math.sin(r))
    end
    return points
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

function utils.pushRotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x, -y)
end

function utils.pushRotateScale(x, y, r, sx, sy)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1, sy or sx or 1)
    love.graphics.translate(-x, -y)
end

utils.table = {}
function utils.table.random(t)
    return t[love.math.random(1, #t)]
end

function utils.count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
        f(t)
        seen[t] = true
        for _,v in pairs(t) do
            if type(v) == "table" then
                count_table(v)
            elseif type(v) == "userdata" then
                f(v)
            end
        end
    end
    count_table(_G)
end

function utils.type_count()
    local counts = {}
    local enumerate = function (o)
        local t = utils.type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    utils.count_all(enumerate)
    return counts
end


utils._type_table = nil
function utils.type_name(o)
    if utils._type_table == nil then
        utils._type_table = {}
        for k,v in pairs(_G) do
            utils._type_table[v] = k
        end
        utils._type_table[0] = "table"
    end
    return utils._type_table[getmetatable(o) or 0] or "Unknown"
end

return utils


