local screen = Vector2(guiGetScreenSize())

local cursor = {}

cursor.update = function()
    cursor.state = isCursorShowing()

    if cursor.state then
        local x, y = getCursorPosition()
        cursor.x, cursor.y = x * screen.x, y * screen.y
    else
        cursor.x, cursor.y = -1, -1
    end
end

cursor.onBox = function(x, y, w, h)
    return cursor.x >= x and cursor.x <= x + w and cursor.y >= y and cursor.y <= y + h
end

local Key = {}
Key.instance = {}

Key.isDown = function(key)
    return Key.instance[key]
end

Key.reset = function(key)
    Key.instance[key] = false
end

local keyAvailable = {
    ['mouse_wheel_up'] = true,
    ['mouse_wheel_down'] = true
}

for button in pairs(keyAvailable) do
    bindKey(button, 'down', function(_, state)
        Key.instance[button] = state == 'down' and cursor.state
    end)
end

local reMap = function(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local clamp = function(value, min, max)
    return math.max(min, math.min(value, max))
end

-- Scroll class

Scroll = {}
Scroll.__index = Scroll

function Scroll.new(min, total)
    local self = setmetatable({}, Scroll)

    self.visible = min
    self.total = total

    self.value = 0
    self.dragging = false
    self.mouse = false
    self.poses = 0

    self.parent = false

    return self
end

function Scroll:draw(x, y, width, height, trackColor, gripColor)
    if self.total < self.visible then
        return
    end

    cursor.update()

    local gripHeight = (height / self.total) * self.visible
    local onParent = false

    if self.parent then
        if cursor.onBox(unpack(self.parent)) then
            onParent = true
        end
    else
        onParent = true
    end

    if onParent then
        if Key.isDown('mouse_wheel_up') then
            self.value = math.max(self.value - 1, 0)
        end

        if Key.isDown('mouse_wheel_down') then
            self.value = math.min(self.value + 1, self.total - self.visible)
        end
    end

    if self.dragging then
        self.poses = clamp(cursor.y - self.dragging, y, y + height - gripHeight)
        self.value = math.floor(
            reMap(self.poses, y, y + height - gripHeight, 0, 1) * (self.total - self.visible)
        )
    end

    local gripY = reMap(self.value, 0, self.total - self.visible, y, y + height - gripHeight)
    self.poses = gripY

    if getKeyState('mouse1') then
        if cursor.onBox(x, gripY, width, gripHeight) and not self.mouse then
            self.mouse = true
            self.dragging = cursor.y - self.poses
        end
    else
        self.mouse = false
        self.dragging = false
    end

    dxDrawRectangle(x, y, width, height, trackColor)
    dxDrawRectangle(x, gripY, width, gripHeight, gripColor)

    for button in pairs(keyAvailable) do
        Key.reset(button)
    end
end

function Scroll:getValue()
    return self.value
end

function Scroll:setValue(value)
    self = math.max(0, math.min(value, self.total - self.visible))
end

function Scroll:setParent(x, y, width, height)
    self.parent = {x, y, width, height}
end

function Scroll:destroy()
    self = nil
end