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
    for i = 1, 5 do
        table.insert(g.ducks, duckclass.new())
    end

    g.foodspawners = {
        foodspawnerclass.new(100, 75),
        foodspawnerclass.new(400, 50),
        foodspawnerclass.new(700, 65)
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
end

function game:update(dt)
    self.pond:update(dt)

    local checkdistance = 100       -- duck collision check distance
    for i, v in ipairs(self.ducks) do
        v:update(dt)

        -- for j, w in ipairs(self.ducks) do
        --     -- for duck collision check
        -- end

        -- head toward closest food
        -- for j, w in ipairs() do
            
        -- end
                

    end

    -- update food spawners / food
    for i, v in ipairs(self.foodspawners) do
        v:update(dt)
    end

end

function game:draw()
    if not self.paused then
        self.pond:draw()

        for i, v in ipairs(self.foodspawners) do
            v:draw()
        end

        for i, v in ipairs(self.ducks) do
            v:draw()
            love.graphics.print(i, v.x, v.y)
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