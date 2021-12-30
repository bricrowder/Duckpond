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
end

function game:update(dt)
    self.pond:update(dt)

    for i, v in ipairs(self.ducks) do
        v:update(dt, self.foodspawners)




        
        -- if v.mode == "chase" then

        -- else

        -- end



        -- for j, w in ipairs(self.ducks) do
        --     -- for duck collision check
        -- end

        -- Pick a random food and 
        -- local closest = nil
        -- local closestfull = nil
        -- local a = 0
        -- local closesta = 0
        -- for j, w in ipairs(self.foodspawners) do
        --     if w.food and #w.food > 0 then
        --         for k, f in ipairs(w.food) do
        --             -- calculate distance between duck and food
        --             local dx = math.abs(v.x - f.x)
        --             local dy = math.abs(v.y - f.y)
        --             local d = math.sqrt(dx*dx + dy*dy)
        --             -- if the duck is close enough to eat... stop and set to eat, remove some food life, we are eating so stop checking
        --             if d < v.texture:getWidth()/2 then
        --                 v.mode = "eat"
        --                 f.beingeaten = true
        --                 f.lifetime = f.lifetime - dt
        --                 break
        --             end
        --             -- if this is the first time checking or if the distance is less then what you already have
        --             if closest == nil or d < closest then
        --                 -- mark it as closest, calculate angle toward food and set mode to chase
        --                 closest = d
        --                 a = math.atan2(f.y-v.y, f.x-v.x)
        --                 v.mode = "chase"
        --                 -- mark if it is the closest food that hasn't been eaten yet
        --                 if not(f.beingeaten) and (closestfull == nil or d < closestfull) then
        --                     closestfull = d
        --                     closesta = a
        --                 end
        --             end
        --         end
        --     end
        -- end
        
        -- -- set the angle to chase if you arent eating, set mode to move if nothing found / no food in any foodspawner array
        -- if not(v.mode == "eat") then
        --     -- if there is a closest full
        --     if closestfull then
        --         v.angle = closesta
        --     elseif closest then
        --         v.angle = a
        --     else
        --         v.mode = "move"
        --     end
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

        love.graphics.print(self.ducks[1].mode, 10, 10)
        love.graphics.print(self.ducks[1].angle, 10, 25)
    else
        -- show pause menu
        love.graphics.setLineWidth(4)
        love.graphics.rectangle("line", 150, 50, 500, 500)
        love.graphics.print("PAUSED", 380,300)
        love.graphics.setLineWidth(1)
    end
end

return game