-- NITO | Xeno-Optimized Drawing UI Framework
-- UI ONLY – logic hooks intentionally empty

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Mouse = UserInputService:GetMouseLocation()

-- ================= CONFIG =================
local UI = {
    Open = true,
    Dragging = false,
    Position = Vector2.new(500, 300),
    Size = Vector2.new(420, 260),
    Accent = Color3.fromRGB(140, 90, 255)
}

local Toggles = {
    Defense = false,
    AutoAction = false,
    ESP = false
}

-- ================= DRAWINGS =================
local Frame = Drawing.new("Square")
Frame.Filled = true
Frame.Color = Color3.fromRGB(20,20,25)
Frame.Size = UI.Size
Frame.Position = UI.Position
Frame.Transparency = 1
Frame.Visible = true

local Title = Drawing.new("Text")
Title.Text = "N I T O"
Title.Size = 20
Title.Center = true
Title.Outline = true
Title.Color = UI.Accent
Title.Position = UI.Position + Vector2.new(UI.Size.X/2, 10)
Title.Visible = true

local Info = Drawing.new("Text")
Info.Text = "Xeno Optimized • Drawing UI"
Info.Size = 13
Info.Center = true
Info.Outline = true
Info.Color = Color3.fromRGB(180,180,180)
Info.Position = UI.Position + Vector2.new(UI.Size.X/2, 35)
Info.Visible = true

-- Toggle Texts
local ToggleTexts = {}

local function createToggle(name, offsetY)
    local t = Drawing.new("Text")
    t.Text = name .. ": OFF"
    t.Size = 14
    t.Outline = true
    t.Color = Color3.fromRGB(220,220,220)
    t.Position = UI.Position + Vector2.new(20, offsetY)
    t.Visible = true
    ToggleTexts[name] = t
end

createToggle("Defense", 80)
createToggle("AutoAction", 110)
createToggle("ESP", 140)

-- ================= INPUT =================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.Insert then
        UI.Open = not UI.Open
        Frame.Visible = UI.Open
        Title.Visible = UI.Open
        Info.Visible = UI.Open
        for _,v in pairs(ToggleTexts) do
            v.Visible = UI.Open
        end
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local m = UserInputService:GetMouseLocation()
        if m.X > Frame.Position.X and m.X < Frame.Position.X + Frame.Size.X
        and m.Y > Frame.Position.Y and m.Y < Frame.Position.Y + 40 then
            UI.Dragging = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        UI.Dragging = false
    end
end)

-- ================= RENDER LOOP =================
RunService.RenderStepped:Connect(function()
    if not UI.Open then return end

    if UI.Dragging then
        local m = UserInputService:GetMouseLocation()
        UI.Position = m - Vector2.new(UI.Size.X/2, 20)
    end

    Frame.Position = UI.Position
    Title.Position = UI.Position + Vector2.new(UI.Size.X/2, 10)
    Info.Position = UI.Position + Vector2.new(UI.Size.X/2, 35)

    local y = 80
    for name, text in pairs(ToggleTexts) do
        text.Position = UI.Position + Vector2.new(20, y)
        text.Text = name .. ": " .. (Toggles[name] and "ON" or "OFF")
        text.Color = Toggles[name] and UI.Accent or Color3.fromRGB(200,200,200)
        y += 30
    end
end)
