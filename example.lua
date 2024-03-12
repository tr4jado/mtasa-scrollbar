local total = 50
local visible = 5

local scroll = Scroll.new(visible, total)
scroll:setParent(30, 10, 50, 100)

local test = {}
for i = 1, total do
    table.insert(test, 'Test ' .. i)
end

addEventHandler('onClientRender', root, function()
    scroll:draw(10, 10, 10, 100, tocolor(255, 255, 255), tocolor(0, 0, 0))

    for i = 1, visible do
        local index = i + scroll:getValue()
        dxDrawText(test[index], 30, 10 + ((i - 1) * 20), 0, 0, tocolor(255, 255, 255))
    end
end)
