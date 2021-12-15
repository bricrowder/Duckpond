-- other game code
local playerclass = require "player"
local duckclass = require "duck"
local foodspawnerclass = require "foodspawner"
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
        
    }
    
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

    for i, v in ipairs(self.ducks) do
        v:update(dt)
    end

    -- duck on duck collision, in pixels
    local checkdistance = 100
    for i, v in ipairs(self.ducks) do
        for j, w in ipairs(self.ducks) do
            -- only if this isn't already the duck being checked
            -- if i not j then
            --     -- set adjust flag accordingly
            --     -- check my other game!
            -- end
        end
    end
end

function game:draw()
    if not self.paused then
        self.pond:draw()

        for i, v in ipairs(self.ducks) do
            v:draw()
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