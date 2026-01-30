-- NITO | Clean Tabbed UI (Xeno Optimized)
-- UI ONLY — no feature logic

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- ================= SETTINGS =================
local UI = {
    Open = true,
    Pos = Vector2.new(450, 250),
    Size = Vector2.new(520, 320),
    Accent = Color3.fromRGB(155, 115, 255),
    Dragging = false,
    CurrentTab = "Aimbot"
}

local Tabs = { "Aimbot", "Movement", "Visuals", "Misc" }

-- ================= DRAW HELPERS =================
local Drawings = {}

local function New(type, props)
    local obj = Drawing.new(type)
    for i,v in pairs(props) do
        obj[i] = v
    end
    table.insert(Drawings, obj)
    return obj
end

-- ================= MAIN FRAME =================
local Frame = New("Square", {
    Filled = true,
    Color = Color3.fromRGB(18,18,22),
    Size = UI.Size,
    Position = UI.Pos,
    Visible = true
})

local Sidebar = New("Square", {
    Filled = true,
    Color = Color3.fromRGB(22,22,28),
    Size = Vector2.new(120, UI.Size.Y),
    Position = UI.Pos,
    Visible = true
})

local Title = New("Text", {
    Text = "N I T O",
    Size = 22,
    Center = true,
    Outline = true,
    Color = UI.Accent,
    Position = UI.Pos + Vector2.new(60, 18),
    Visible = true
})

-- ================= TAB BUTTONS =================
local TabButtons = {}

for i, name in ipairs(Tabs) do
    local btn = New("Text", {
        Text = name,
        Size = 14,
        Outline = true,
        Center = false,
        Color = Color3.fromRGB(190,190,190),
        Position = UI.Pos + Vector2.new(20, 60 + (i-1)*35),
        Visible = true
    })
    TabButtons[name] = btn
end

-- ================= CONTENT TITLE =================
local SectionTitle = New("Text", {
    Text = UI.CurrentTab,
    Size = 18,
    Outline = true,
    Color = Color3.fromRGB(235,235,235),
    Position = UI.Pos + Vector2.new(150, 20),
    Visible = true
})

-- ================= INPUT =================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == Enum.KeyCode.Insert then
        UI.Open = not UI.Open
        for _,v in pairs(Drawings) do
            v.Visible = UI.Open
        end
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local m = UIS:GetMouseLocation()

        -- Drag top bar
        if m.X > Frame.Position.X and m.X < Frame.Position.X + Frame.Size.X
        and m.Y > Frame.Position.Y and m.Y < Frame.Position.Y + 35 then
            UI.Dragging = true
        end

        -- Tab clicks
        for name, btn in pairs(TabButtons) do
            local pos = btn.Position
            if m.X > pos.X and m.X < pos.X + 90
            and m.Y > pos.Y and m.Y < pos.Y + 18 then
                UI.CurrentTab = name
            end
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        UI.Dragging = false
    end
end)

-- ================= RENDER LOOP =================
RS.RenderStepped:Connect(function()
    if not UI.Open then return end

    if UI.Dragging then
        local m = UIS:GetMouseLocation()
        UI.Pos = m - Vector2.new(UI.Size.X/2, 15)
    end

    -- Frame positions
    Frame.Position = UI.Pos
    Sidebar.Position = UI.Pos
    Title.Position = UI.Pos + Vector2.new(60, 18)
    SectionTitle.Position = UI.Pos + Vector2.new(150, 20)
    SectionTitle.Text = UI.CurrentTab

    -- Tabs
    for i, name in ipairs(Tabs) do
        local btn = TabButtons[name]
        btn.Position = UI.Pos + Vector2.new(20, 60 + (i-1)*35)

        if UI.CurrentTab == name then
            btn.Color = UI.Accent
        else
            btn.Color = Color3.fromRGB(180,180,180)
        end
    end
end)
