-- NITO GUI | FIXED SCROLL + UNLOAD | Xeno Safe

local UIS = game:GetService("UserInputService")

-- ================= CONFIG =================
local Tabs = {"Main","Movement","Visuals","Misc"}

local DaHoodGuns = {
    "Glock","Revolver","AR","AK-47","Shotgun","P90",
    "Drum Gun","Rifle","AUG","SMG","Double Barrel"
}

local State = {
    Aimbot = false,
    Orbit = false,
    Triggerbot = false,
    ShootShooter = false,
    TP = false,
    OrbitSpeed = 5,
    OrbitDistance = 10,
    OrbitMode = "Random",
    SelectedGun = "Glock",
    ToggleKey = Enum.KeyCode.F
}

-- ================= GUI ROOT =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NITO_GUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- ================= MAIN FRAME =================
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,560,0,380)
Frame.Position = UDim2.new(0.5,-280,0.5,-190)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- ================= TITLE =================
local Title = Instance.new("TextLabel")
Title.Text = "N I T O"
Title.Size = UDim2.new(1,0,0,40)
Title.Position = UDim2.new(0,0,0,5)
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(155,115,255)
Title.BackgroundTransparency = 1
Title.Parent = Frame

-- ================= SIDEBAR =================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,130,1,-50)
Sidebar.Position = UDim2.new(0,0,0,50)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Frame

local TabButtons = {}
for i,name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(1,-20,0,32)
    btn.Position = UDim2.new(0,10,0,10+(i-1)*40)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    TabButtons[name] = btn
end

-- ================= TAB CREATOR =================
local TabsFrames = {}

local function CreateTab(name)
    local tab = Instance.new("ScrollingFrame")
    tab.Size = UDim2.new(1,-150,1,-60)
    tab.Position = UDim2.new(0,140,0,55)
    tab.CanvasSize = UDim2.new(0,0,0,0)
    tab.ScrollBarThickness = 6
    tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.BackgroundTransparency = 1
    tab.Visible = (name == "Main")
    tab.Parent = Frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,12)
    layout.Parent = tab

    return tab
end

for _,name in ipairs(Tabs) do
    TabsFrames[name] = CreateTab(name)
end

local MainTab = TabsFrames.Main
local MiscTab = TabsFrames.Misc

-- ================= HELPERS =================
local function Toggle(parent,text,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,240,0,28)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    btn.BorderSizePixel = 0
    btn.Text = text..": OFF"
    btn.Parent = parent

    btn.MouseButton1Click:Connect(function()
        local new = callback()
        btn.Text = text..": "..(new and "ON" or "OFF")
    end)

    return btn
end

local function Divider(parent)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1,-20,0,2)
    d.BackgroundColor3 = Color3.fromRGB(155,115,255)
    d.BorderSizePixel = 0
    d.Parent = parent
end

-- ================= MAIN TAB =================
Toggle(MainTab,"Aimbot",function()
    State.Aimbot = not State.Aimbot
    return State.Aimbot
end)

Toggle(MainTab,"Orbit",function()
    State.Orbit = not State.Orbit
    return State.Orbit
end)

Toggle(MainTab,"Triggerbot",function()
    State.Triggerbot = not State.Triggerbot
    return State.Triggerbot
end)

Divider(MainTab)

Toggle(MainTab,"Shoot the Shooter",function()
    State.ShootShooter = not State.ShootShooter
    return State.ShootShooter
end)

Toggle(MainTab,"TP Toggle",function()
    State.TP = not State.TP
    return State.TP
end)

-- ================= GUN DROPDOWN =================
local GunBtn = Instance.new("TextButton")
GunBtn.Size = UDim2.new(0,240,0,28)
GunBtn.Text = "Gun: "..State.SelectedGun
GunBtn.BackgroundColor3 = Color3.fromRGB(35,35,40)
GunBtn.TextColor3 = Color3.fromRGB(230,230,230)
GunBtn.BorderSizePixel = 0
GunBtn.Parent = MainTab

local GunList = Instance.new("Frame")
GunList.Size = UDim2.new(0,240,0,160)
GunList.BackgroundColor3 = Color3.fromRGB(30,30,35)
GunList.Visible = false
GunList.Parent = GunBtn

local Search = Instance.new("TextBox")
Search.PlaceholderText = "Search..."
Search.Size = UDim2.new(1,-10,0,26)
Search.Position = UDim2.new(0,5,0,5)
Search.BackgroundColor3 = Color3.fromRGB(45,45,50)
Search.TextColor3 = Color3.fromRGB(230,230,230)
Search.BorderSizePixel = 0
Search.Parent = GunList

local function RefreshGuns()
    for _,c in pairs(GunList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    local y = 36
    for _,gun in ipairs(DaHoodGuns) do
        if gun:lower():find(Search.Text:lower()) then
            local b = Instance.new("TextButton")
            b.Text = gun
            b.Size = UDim2.new(1,0,0,24)
            b.Position = UDim2.new(0,0,0,y)
            b.BackgroundColor3 = Color3.fromRGB(40,40,45)
            b.TextColor3 = Color3.fromRGB(230,230,230)
            b.BorderSizePixel = 0
            b.Parent = GunList

            b.MouseButton1Click:Connect(function()
                State.SelectedGun = gun
                GunBtn.Text = "Gun: "..gun
                GunList.Visible = false
            end)

            y += 24
        end
    end
end

Search:GetPropertyChangedSignal("Text"):Connect(RefreshGuns)
GunBtn.MouseButton1Click:Connect(function()
    GunList.Visible = not GunList.Visible
    RefreshGuns()
end)

-- ================= MISC TAB =================
local Unload = Instance.new("TextButton")
Unload.Size = UDim2.new(0,240,0,32)
Unload.Text = "UNLOAD SCRIPT"
Unload.BackgroundColor3 = Color3.fromRGB(80,30,30)
Unload.TextColor3 = Color3.fromRGB(255,255,255)
Unload.BorderSizePixel = 0
Unload.Parent = MiscTab

Unload.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ================= TAB SWITCH =================
for name,btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _,tab in pairs(TabsFrames) do
            tab.Visible = false
        end
        TabsFrames[name].Visible = true
    end)
end
