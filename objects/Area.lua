--
-- Created by IntelliJ IDEA.
-- User: seletz
-- Date: 20.02.18
-- Time: 21:57
-- To change this template use File | Settings | File Templates.
--

Area = Object:extend()

function Area:new(room)
    self.room = room
    self.game_objects = {}

    self.draw_world = false

    input:bind("w", function()
        self.draw_world = not self.draw_world
    end)
end

function Area:destroy()
    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:destroy()
    end

    self.game_objects = {}
    if self.world then
        self.world:destroy()
        self.world = nil
    end

end

function Area:update(dt)
    if self.world then self.world:update(dt) end

    for i = #self.game_objects, 1, -1 do
        local game_object = self.game_objects[i]
        game_object:update(dt)
        if game_object.dead then
            game_object:destroy()
            table.remove(self.game_objects, i)
        end
    end
end

function Area:draw()
    if self.world and self.draw_world then self.world:draw() end

    table.sort(self.game_objects, function(a, b)
        if a.depth == b.depth then return a.creation_time < b.creation_time
        else return a.depth < b.depth end
    end)

    for _, game_object in ipairs(self.game_objects) do game_object:draw() end
end

function Area:addGameObject(game_object_type, x, y, opts)
    -- print("A: new GO " .. game_object_type)
    local opts = opts or {}
    local game_object = _G[game_object_type](self, x or 0, y or 0, opts)
    table.insert(self.game_objects, game_object)
    return game_object
end

function Area:getAllGameObjectsThat(filter)
    local out = {}
    for _, game_object in pairs(self.game_objects) do
        if filter(game_object) then
            table.insert(out, game_object)
        end
    end
    return out
end

function Area:getAllGameObjectsOfType(types, f)
    return self:getAllGameObjectsThat(function(go)
        for _, tp in ipairs(types) do
            if go:is(_G[tp]) then
                if f then
                    return f(go)
                else
                    return true
                end
            end
        end
    end)
end

function Area:addPhysicsWorld()
    self.world = Physics.newWorld(0, 0, true)
end

function Area:dump()
    print("Area [")
    for nr, game_object in ipairs(self.game_objects) do
        print("   #" .. nr .. ":  " .. game_object:__tostring())
    end
    print("]")
end