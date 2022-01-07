-- other game code
local playerclass = require "player"
local duckclass = require "duck"
local foodspawnerclass = require "foodspawner"
local foodclass = require "food"
local pondclass = require "pond"

local game = {}
game.__index = game

function game.new()
    local g = {}
    setmetatable(g, game)

    g.player = playerclass.new()

    g.pond = pondclass.new("pond1")

    g.ducks = {}
    for i = 1, 3 do
        table.insert(g.ducks, duckclass.new())
    end

    g.foodspawners = {
        foodspawnerclass.new(100, 75, math.pi/2, math.pi/4, 1),
        foodspawnerclass.new(400, 50, math.pi/4*3, math.pi/4, 2),
        foodspawnerclass.new(700, 65, math.pi/4*3, math.pi/2, 3)
    }
    
    g.food = {}

    g.paused = false

    return g
end

function game:keypressed(key)
    if key == "escape" then
        -- pause menu / quit
        self.paused = not self.paused
    end
    if key == "f" then
        for i, v in ipairs(self.foodspawners) do
            v.active = not(v.active)
        end
    end
end

function game:update(dt)
    self.pond:update(dt)

    for i, v in ipairs(self.ducks) do
        v:update(dt, self.foodspawners)
    end

    -- update food spawners / food
    for i, v in ipairs(self.foodspawners) do
        v:update(dt)
    end

end

function game:draw()
    if not self.paused then
        if #self.ducks > 0 then
            self.pond:draw(self.ducks)
        end

        for i, v in ipairs(self.foodspawners) do
            v:draw()
        end

        for i, v in ipairs(self.ducks) do
            v:draw()
            love.graphics.print(i, v.x, v.y)
            love.graphics.print(#v.ripples, v.x, v.y+15)
            love.graphics.print(v.angle, v.x, v.y+30)
        end
    else
        -- show pause menu
        love.graphics.setLineWidth(4)
        love.graphics.rectangle("line", 150, 50, 500, 500)
        love.graphics.print("PAUSED", 380,300)
        love.graphics.setLineWidth(1)
    end
end

return game