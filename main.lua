-- game objects --
local playerclass
local duckclass
local foodspawnerclass
pondclass = require "pond"
local menuclass = require "menu"
local hiscoreclass = require "hiscore"

-- global game variables --
local mode              -- menu, game, hiscore
local player            -- player object
local ducks             -- list of npc ducks
local foodspawners      -- list of food spawners
local food              -- list of food
local backgroundcolour  -- window colour
local background        -- play area background

function love.load()
    -- set the mode to start in the menu
    mode = "menu"
    backgroundcolour = {0.3, 0.3, 1.0, 1.0}
    menu = menuclass.new()
    hiscore = hiscoreclass.new()
end

function love.keypressed(key)
    if mode == "menu" then
        menu:keypressed(key)
    elseif mode == "game" then
    elseif mode == "hiscore" then
    end    
end

function love.mousepressed(x, y, button)
    if mode == "menu" then
        menu:mousepressed(x, y, button)
    elseif mode == "game" then
    elseif mode == "hiscore" then
    end    
end

function love.update(dt)
    if mode == "menu" then
        menu:update(dt)
    elseif mode == "game" then
    elseif mode == "hiscore" then
    end
end

function love.draw()
    love.graphics.clear(backgroundcolour)
    if mode == "menu" then
        menu:draw()
        hiscore:drawmenu()
    elseif mode == "game" then
    elseif mode == "hiscore" then
    end
end