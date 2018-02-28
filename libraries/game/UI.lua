local ui = {}

function ui.bar(x, y, w, h, color, current, max, font, font_scale)
    local r, g, b = unpack(color or colors.default_color)
    local current, max = math.floor(current or 0), max or 100
    local w = w or 48
    local h = h or 4
    local sf = font_scale or 1
    love.graphics.setColor(r, g, b)
    love.graphics.rectangle('fill', x, y, w*(current / max), h)
    love.graphics.setColor(r - 32, g - 32, b - 32)
    love.graphics.rectangle('line', x, y, w, h)

    love.graphics.setFont(font, 12)
    love.graphics.setColor(r, g, b)
    love.graphics.print(current .. '/' .. max, x + 24, y - 10, 0, sf, sf,
        math.floor(font:getWidth(current .. '/' .. max)/2),
        math.floor(font:getHeight()/2))
end

return ui
