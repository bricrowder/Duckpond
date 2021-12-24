-- game classes --
local gameclass = require "game"
local menuclass = require "menu"
local hiscoreclass = require "hiscore"

-- global game variables --
local mode               -- menu, game, hiscore
local backgroundcolour   -- window colour
game = nil               -- the game object
menu = nil               -- the menu object
hiscore = nil            -- the hiscore object

-- load menu and hiscore
function love.load()
    
    -- setup randomizer
    local seed = os.time()
    math.randomseed(seed)
    -- macos used to need a few pops or it will not actually be random... not sure why


    
    print("starting!")
    print(seed)

    -- set the mode to start in the menu
    mode = "menu"
    backgroundcolour = {0.3, 0.3, 1.0, 1.0}
    menu = menuclass.new()
    hiscore = hiscoreclass.new()
    -- createGame() is called from the menu object

end

function love.keypressed(key)
    if mode == "menu" then
        menu:keypressed(key)
    elseif mode == "game" then
        game:keypressed(key)
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
        game:update(dt)
    elseif mode == "hiscore" then
    end
end

function love.draw()
    love.graphics.clear(backgroundcolour)
    if mode == "menu" then
        menu:draw()
        hiscore:drawmenu()
    elseif mode == "game" then
        game:draw()
    elseif mode == "hiscore" then
    end
end

function createGame()
    mode = "game"
    game = gameclass.new()
end