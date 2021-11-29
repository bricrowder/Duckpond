local hiscore = {}
hiscore.__index = hiscore

function hiscore.new()
    local h = {}
    setmetatable (h, hiscore)

    h.list = {}
    h.text = love.graphics.newText(love.graphics.newFont(24),"")
    h.title = love.graphics.newText(love.graphics.newFont(24),"TOP 10 LEGENDS!")
    h.titleposition = {x = 500, y = 160}
    h.rectposition = {x = 500, y = 200, w = 220, h = 380}
    h.tableposition = {x = 520, y = 220}

    local counter = 0
    local basecolour = {0.8, 0.8, 1.0, 1.0}
    local colourinc = 0.4
    local colourdir = -1

    for l in love.filesystem.lines("data/hiscore.csv") do
        -- split string
        local s = string.find(l,",")
        local name = l:sub(1,s-1)
        local score = l:sub(s+1)
        table.insert(h.list, {name=name, score=score})
        -- create colour based on current gradient
        local colour = {
            basecolour[1] + colourinc,
            basecolour[2] + colourinc,
            basecolour[3],
            1.0,
        }
        -- update colour gradient, switch directions if necessary
        colourinc = colourinc + (0.1 * colourdir)
        if colourinc >= 0.4 or colourinc <= 0 then
            colourdir = colourdir * -1
        end
        -- write to text object
        h.text:add({colour,name}, 0, counter * 35)
        h.text:add({colour,score}, 100, counter * 35)
        -- update line counter
        counter = counter + 1
    end

    return h
end

function hiscore:drawmenu()
    -- draw hiscore box
    -- to be formatted better!
    love.graphics.setLineWidth(4)
    love.graphics.draw(self.title, self.titleposition.x, self.titleposition.y)
    love.graphics.rectangle("line", self.rectposition.x, self.rectposition.y, self.rectposition.w, self.rectposition.h)
    love.graphics.draw(self.text, self.tableposition.x, self.tableposition.y)
    love.graphics.setLineWidth(1)
end

return hiscore