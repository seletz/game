--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 20.02.18
-- Time: 21:58
-- To change this template use File | Settings | File Templates.
--

GameObject = Object:extend()

function GameObject:new(area, x, y, opts)
    local opts = opts or {}
    if opts then
        for k, v in pairs(opts) do
            self[k] = v
        end
    end

    self.area = area
    self.x, self.y = x, y
    self.id = utils.UUID()
    self.dead = false
    self.timer = Timer()
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
end

function GameObject:draw()

end

function GameObject:__tostring()
    return "GameObject( " .. self.id .. " @ " .. self.x .. ", " .. self.y .. " )"
end

