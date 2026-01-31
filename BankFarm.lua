-- NITO GUI | PLAYERGUI SAFE | GUARANTEED RENDER

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- ===== WAIT FOR PLAYERGUI =====
local PlayerGui = LP:WaitForChild("PlayerGui")

-- ===== CLEAN OLD =====
pcall(function()
    PlayerGui:FindFirstChild("NITO_GUI"):Destroy()
end)

-- ===== SCREEN GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NITO_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ===== MAIN FRAME =====
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 640, 0, 440)
Main.Position = UDim2.new(0.5, -320, 0.5, -220)
Main.BackgroundColor3 = Color3.fromRGB(18,18,22)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- ===== TITLE BAR =====
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,40)
TitleBar.BackgroundColor3 = Color3.fromRGB(22,22,28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,1,0)
Title.BackgroundTransparency = 1
Title.Text = "N I T O"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Color3.fromRGB(155,115,255)
Title.Parent = TitleBar

-- ===== SIDEBAR =====
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,140,1,-40)
Sidebar.Position = UDim2.new(0,0,0,40)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0,10)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Pad = Instance.new("UIPadding", Sidebar)
Pad.PaddingTop = UDim.new(0,12)

-- ===== CONTENT =====
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-150,1,-50)
Content.Position = UDim2.new(0,150,0,50)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- ===== TABS =====
local Tabs = {"Main","Movement","Visuals","Misc"}
local TabFrames = {}
local CurrentTab

local function NewTab(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Size = UDim2.new(1,0,1,0)
    sf.CanvasSize = UDim2.new()
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.ScrollBarImageTransparency = 0.4
    sf.Visible = false
    sf.BackgroundTransparency = 1
    sf.Parent = Content

    local layout = Instance.new("UIListLayout", sf)
    layout.Padding = UDim.new(0,12)

    TabFrames[name] = sf
end

for _,t in ipairs(Tabs) do
    NewTab(t)
end

-- ===== TAB BUTTONS =====
for _,name in ipairs(Tabs) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,120,0,32)
    b.Text = name
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(230,230,230)
    b.BackgroundColor3 = Color3.fromRGB(35,35,40)
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

-- ===== ELEMENT HELPERS =====
local function Button(parent,text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,260,0,34)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.fromRGB(235,235,235)
    b.BackgroundColor3 = Color3.fromRGB(35,35,40)
    b.BorderSizePixel = 0
    b.Parent = parent
end

local function Divider(parent)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(0,260,0,2)
    d.BackgroundColor3 = Color3.fromRGB(155,115,255)
    d.BorderSizePixel = 0
    d.Parent = parent
end

-- ===== MAIN TAB CONTENT =====
local MainTab = TabFrames.Main
Button(MainTab,"Aimbot")
Button(MainTab,"Orbit")
Button(MainTab,"Orbit Speed")
Button(MainTab,"Orbit Distance")
Button(MainTab,"Orbit Mode")

Divider(MainTab)

Button(MainTab,"Triggerbot")

Divider(MainTab)

Button(MainTab,"Shoot the Shooter")
Button(MainTab,"TP Toggle")
Button(MainTab,"Select Gun")

-- ===== OTHER TABS =====
Button(TabFrames.Movement,"Movement Feature")
Button(TabFrames.Visuals,"Visual Feature")
Button(TabFrames.Misc,"Misc Feature")

-- ===== DEFAULT TAB =====
CurrentTab = "Main"
TabFrames.Main.Visible = true
