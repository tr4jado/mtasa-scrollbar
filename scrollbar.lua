-- Utils

local screenW, screenH = guiGetScreenSize()

local function reMap(value, low1, high1, low2, high2)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

function math.clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

function math.lerp(a, b, t)
    return a + (b - a) * t
end

local function lerp(id, target, duraction)
    if not cache_lerp then cache_lerp = {} end

    duraction = duraction or 500

    if not cache_lerp[id] then
        cache_lerp[id] = {
            target = target,
            current = target,
            start = getTickCount(),
            duraction = duraction
        }
    end

    local data = cache_lerp[id]

    if data.target ~= target then
        data.target = target
        data.start = getTickCount()
    end

    local progress = math.min((getTickCount() - data.start) / data.duraction, 1)
    data.current = math.lerp(data.current, data.target, progress)

    return data.current
end

local cursor = {
    state = false,
    x = 0,
    y = 0
}

function cursor:update()
    local state = isCursorShowing()

    if state then
        local x, y = getCursorPosition()
        self.x, self.y = x * screenW, y * screenH
    end

    self.state = state
end

function cursor:box(x, y, width, height)
    return self.x >= x and self.x <= x + width and self.y >= y and self.y <= y + height
end

-- Scroll

Scroll = {}
Scroll.__index = Scroll
Scroll.instances = {}

local list_properties = {
    value = "number",
    visible = "number",
    total = "number",
    box = "table",
    animation = "boolean"
}

function Scroll.new(properties)
    local self = {}
    setmetatable(self, {__index = Scroll})

    self.box = false

    self.value = 0
    self.visible = 0
    self.total = 0

    self.dragging = false
    self.mouse = false

    if properties then
        assert(type(properties) == "table", "Bad argument @ Scroll.new [Expected table at argument 1, got " .. type(properties) .. "]")

        for i, v in pairs(properties) do
            assert(list_properties[i], "Bad argument @ Scroll.new [Unexpected property '" .. i .. "']")
            assert(type(v) == list_properties[i], "Bad argument @ Scroll.new [Expected " .. list_properties[i] .. " at property '" .. i .. "', got " .. type(v) .. "]")
            self[i] = v
        end
    end

    table.insert(Scroll.instances, self)
    return self
end

function Scroll:draw(x, y, width, height, backgroundColor, foregroundColor)
    assert(type(x) == "number", "Bad argument @ Scroll:draw [Expected number at argument 1, got " .. type(x) .. "]")
    assert(type(y) == "number", "Bad argument @ Scroll:draw [Expected number at argument 2, got " .. type(y) .. "]")
    assert(type(width) == "number", "Bad argument @ Scroll:draw [Expected number at argument 3, got " .. type(width) .. "]")
    assert(type(height) == "number", "Bad argument @ Scroll:draw [Expected number at argument 4, got " .. type(height) .. "]")
    assert(type(backgroundColor) == "number", "Bad argument @ Scroll:draw [Expected number at argument 5, got " .. type(backgroundColor) .. "]")
    assert(type(foregroundColor) == "number", "Bad argument @ Scroll:draw [Expected number at argument 6, got " .. type(foregroundColor) .. "]")
    cursor:update()

    if self.total <= self.visible then return end

    local foregroundHeight = (height / self.total) * self.visible

    if self.dragging then
        self.value = math.floor(
            reMap(math.clamp(cursor.y - self.dragging, y, y + height - foregroundHeight), y, y + height - foregroundHeight, 0, 1) * (self.total - self.visible)
        )
    end

    local foregroundY = reMap(self.value, 0, self.total - self.visible, y, y + height - foregroundHeight)

    if getKeyState("mouse1") then
        if cursor:box(x, foregroundY, width, foregroundHeight) and not self.mouse then
            self.mouse = true
            self.dragging = cursor.y - foregroundY
        end
    else
        self.dragging = false
        self.mouse = false
    end

    dxDrawRectangle(x, y, width, height, backgroundColor)
    dxDrawRectangle(x, (self.animation and not self.dragging) and lerp(tostring(self), foregroundY) or foregroundY, width, foregroundHeight, foregroundColor)
end

addEventHandler("onClientKey", root, function(key, state)
    if key == "mouse_wheel_down" or key == "mouse_wheel_up" then
        local self = false

        for _, v in ipairs(Scroll.instances) do
            if v.box and cursor:box(v.box[1], v.box[2], v.box[3], v.box[4]) then
                self = v
                break
            end
        end

        if self then
            if key == "mouse_wheel_down" then
                self.value = math.min(self.value + 1, self.total - self.visible)
            else
                self.value = math.max(self.value - 1, 0)
            end
        end
    end
end)
