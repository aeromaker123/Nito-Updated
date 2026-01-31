-- NITO GUI | CLEAN REMAKE | XENO SAFE | UI ONLY

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- ===== DESTROY OLD =====
pcall(function()
    game:GetService("CoreGui"):FindFirstChild("NITO_GUI"):Destroy()
end)

-- ===== SCREEN GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NITO_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game:GetService("CoreGui")

-- ===== MAIN FRAME =====
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(640, 440)
Main.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(320, 220)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- ===== TITLE =====
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "N I T O"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Color3.fromRGB(155,115,255)
Title.Parent = Main

-- ===== SIDEBAR =====
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(140, 400)
Sidebar.Position = UDim2.fromOffset(0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 10)
SideLayout.HorizontalAlignment = Center
SideLayout.VerticalAlignment = Top

Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)

-- ===== CONTENT HOLDER =====
local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(150, 50)
Content.Size = UDim2.new(1, -160, 1, -60)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- ===== TABS =====
local Tabs = {"Main","Movement","Visuals","Misc"}
local TabFrames = {}
local CurrentTab

local function CreateTab(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Size = UDim2.fromScale(1,1)
    sf.CanvasSize = UDim2.new()
    sf.ScrollBarImageTransparency = 0.4
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.Visible = false
    sf.BackgroundTransparency = 1
    sf.Parent = Content

    local layout = Instance.new("UIListLayout", sf)
    layout.Padding = UDim.new(0, 12)

    TabFrames[name] = sf
end

for _,t in ipairs(Tabs) do
    CreateTab(t)
end

-- ===== TAB BUTTONS =====
local function CreateTabButton(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(120, 32)
    b.BackgroundColor3 = Color3.fromRGB(35,35,40)
    b.Text = name
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(220,220,220)
    b.BorderSizePixel = 0
    b.Parent = Sidebar

    b.MouseButton1Click:Connect(function()
        if CurrentTab then
            TabFrames[CurrentTab].Visible = false
        end
        CurrentTab = name
        TabFrames[name].Visible = true
    end)
end

for _,t in ipairs(Tabs) do
    CreateTabButton(t)
end

-- ===== UI ELEMENT HELPERS =====
local function Toggle(parent, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(260, 34)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.BorderSizePixel = 0
    btn.Parent = parent
end

local function Divider(parent)
    local d = Instance.new("Frame")
    d.Size = UDim2.fromOffset(260, 2)
    d.BackgroundColor3 = Color3.fromRGB(155,115,255)
    d.BorderSizePixel = 0
    d.Parent = parent
end

-- ===== MAIN TAB CONTENT =====
local MainTab = TabFrames.Main

Toggle(MainTab, "Aimbot")
Toggle(MainTab, "Orbit")
Toggle(MainTab, "Orbit Speed")
Toggle(MainTab, "Orbit Distance")
Toggle(MainTab, "Orbit Mode")

Divider(MainTab)

Toggle(MainTab, "Triggerbot")

Divider(MainTab)

Toggle(MainTab, "Shoot the Shooter")
Toggle(MainTab, "TP Toggle")
Toggle(MainTab, "Select Gun")

-- ===== OTHER TABS (PLACEHOLDERS) =====
Toggle(TabFrames.Movement, "Movement Feature 1")
Toggle(TabFrames.Visuals, "Visual Feature 1")
Toggle(TabFrames.Misc, "Misc Feature 1")

-- ===== DEFAULT TAB =====
CurrentTab = "Main"
TabFrames.Main.Visible = true
