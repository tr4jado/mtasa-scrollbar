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

local reMap = function(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local clamp = function(value, min, max)
    return math.max(min, math.min(value, max))
end

-- Scroll class

Scroll = {}
Scroll.__index = Scroll
Scroll.instances = {}

function Scroll.new(min, total)
    local self = setmetatable({}, Scroll)

    self.visible = min
    self.total = total

    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0

    self.value = 0
    self.dragging = false
    self.mouse = false
    self.poses = 0

    self.parent = false

    table.insert(Scroll.instances, self)

    return self
end

function Scroll:draw(x, y, width, height, trackColor, gripColor)
    self.x, self.y, self.width, self.height = x, y, width, height

    if self.total < self.visible then
        return
    end

    cursor.update()

    local gripHeight = (height / self.total) * self.visible

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
end

function Scroll:getValue()
    return self.value
end

function Scroll:setValue(value)
    self = clamp(value, 0, self.total - self.visible)
    return true
end

function Scroll:setParent(x, y, width, height)
    self.parent = {x, y, width, height}
    return true
end

function Scroll:destroy()
    for i, instance in ipairs(Scroll.instances) do
        if instance == self then
            table.remove(Scroll.instances, i)
            self = nil

            collectgarbage()
            return true
        end
    end

    return false
end

-- Events

addEventHandler('onClientKey', root, function(button, state)
    if not state then
        return
    end

    if button == 'mouse_wheel_up' or 'mouse_wheel_down' then
        local up = button == 'mouse_wheel_up'

        for _, self in ipairs(Scroll.instances) do
            local parent = self.parent or {self.x, self.y, self.width, self.height}

            if cursor.onBox(unpack(parent)) or cursor.onBox(self.x, self.y, self.width, self.height) then
                self.value = clamp(self.value + (up and -1 or 1), 0, self.total - self.visible)
            end
        end
    end
end)
