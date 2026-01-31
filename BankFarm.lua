-- NITO GUI | Proper Layout, No Overflow, Xeno Safe

local UIS = game:GetService("UserInputService")

-- ================= STATE =================
local State = {
    Aimbot = false,
    Orbit = false,
    Triggerbot = false,
    OrbitSpeed = 1,
    OrbitDistance = 1,
    OrbitMode = "Random",
    ShootShooter = true,
    TP = true,
    SelectedGun = "Glock",
    Binding = false,
    ToggleKey = Enum.KeyCode.F
}

local Guns = {
    "Glock","Revolver","Shotgun","SMG","P90",
    "Drum Gun","AR","AK-47","AUG","Rifle"
}

-- ================= GUI ROOT =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromOffset(520,360)
Frame.Position = UDim2.fromScale(0.5,0.5) - UDim2.fromOffset(260,180)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- ================= TITLE =================
local Title = Instance.new("TextLabel")
Title.Text = "N I T O"
Title.Size = UDim2.fromOffset(200,30)
Title.Position = UDim2.fromScale(0.5,0) - UDim2.fromOffset(100,-10)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(155,115,255)
Title.TextScaled = true
Title.Parent = Frame

-- ================= SIDEBAR =================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(120,360)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Frame

local Tabs = {"Main","Movement","Visuals","Misc"}
local TabButtons = {}

local TabLayout = Instance.new("UIListLayout",Sidebar)
TabLayout.Padding = UDim.new(0,10)
TabLayout.HorizontalAlignment = Center
TabLayout.VerticalAlignment = Center

for _,name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.fromOffset(100,30)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    TabButtons[name] = btn
end

-- ================= TAB HOLDER =================
local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(130,50)
Content.Size = UDim2.fromOffset(370,290)
Content.BackgroundTransparency = 1
Content.Parent = Frame

local TabsFrames = {}

local function CreateTab(name)
    local tab = Instance.new("Frame")
    tab.Size = UDim2.fromScale(1,1)
    tab.BackgroundTransparency = 1
    tab.Visible = name=="Main"
    tab.Parent = Content
    TabsFrames[name] = tab
    return tab
end

for _,n in ipairs(Tabs) do CreateTab(n) end
local MainTab = TabsFrames.Main

-- ================= MAIN TAB LAYOUT =================
local Left = Instance.new("Frame",MainTab)
Left.Size = UDim2.fromScale(0.48,1)
Left.BackgroundTransparency = 1

local Right = Instance.new("Frame",MainTab)
Right.Position = UDim2.fromScale(0.52,0)
Right.Size = UDim2.fromScale(0.48,1)
Right.BackgroundTransparency = 1

local Divider = Instance.new("Frame",MainTab)
Divider.Position = UDim2.fromScale(0.5,0)
Divider.Size = UDim2.fromOffset(2,290)
Divider.BackgroundColor3 = Color3.fromRGB(155,115,255)
Divider.BorderSizePixel = 0

local function Stack(parent)
    local p = Instance.new("UIPadding",parent)
    p.PaddingTop = UDim.new(0,5)
    local l = Instance.new("UIListLayout",parent)
    l.Padding = UDim.new(0,8)
end
Stack(Left)
Stack(Right)

-- ================= HELPERS =================
local function Toggle(text,parent,callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(170,26)
    b.BackgroundColor3 = Color3.fromRGB(35,35,40)
    b.TextColor3 = Color3.fromRGB(230,230,230)
    b.BorderSizePixel = 0
    b.Text = text
    b.Parent = parent
    b.MouseButton1Click:Connect(callback)
    return b
end

local function Slider(name,min,max,parent,cb)
    local wrap = Instance.new("Frame",parent)
    wrap.Size = UDim2.fromOffset(170,40)
    wrap.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel",wrap)
    lbl.Size = UDim2.fromScale(1,0.4)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(230,230,230)
    lbl.Text = name..": "..min

    local bar = Instance.new("Frame",wrap)
    bar.Position = UDim2.fromScale(0,0.6)
    bar.Size = UDim2.fromScale(1,0.15)
    bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
    bar.BorderSizePixel = 0

    local fill = Instance.new("Frame",bar)
    fill.Size = UDim2.fromScale(0,1)
    fill.BackgroundColor3 = Color3.fromRGB(155,115,255)
    fill.BorderSizePixel = 0

    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            local move; move = UIS.InputChanged:Connect(function(m)
                if m.UserInputType==Enum.UserInputType.MouseMovement then
                    local r = math.clamp((m.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
                    local v = math.floor(min+(max-min)*r)
                    fill.Size = UDim2.fromScale(r,1)
                    lbl.Text = name..": "..v
                    cb(v)
                end
            end)
            UIS.InputEnded:Once(function() move:Disconnect() end)
        end
    end)
end

-- ================= LEFT CONTENT =================
Toggle("Aimbot: OFF",Left,function()
    State.Aimbot = not State.Aimbot
end)

Toggle("Orbit: OFF",Left,function()
    State.Orbit = not State.Orbit
end)

Slider("Orbit Speed",1,20,Left,function(v) State.OrbitSpeed=v end)
Slider("Orbit Distance",1,50,Left,function(v) State.OrbitDistance=v end)

Toggle("Orbit Mode: Random",Left,function(btn)
    State.OrbitMode = State.OrbitMode=="Random" and "Velocity" or "Random"
end)

Toggle("Triggerbot: OFF",Left,function()
    State.Triggerbot = not State.Triggerbot
end)

Toggle("Toggle Key: F",Left,function(btn)
    State.Binding = true
    btn.Text = "Press a key..."
end)

-- ================= RIGHT CONTENT =================
Toggle("Shoot the Shooter: ON",Right,function()
    State.ShootShooter = not State.ShootShooter
end)

Toggle("TP Toggle: ON",Right,function()
    State.TP = not State.TP
end)

-- ================= GUN DROPDOWN =================
local Drop = Instance.new("Frame",Right)
Drop.Size = UDim2.fromOffset(170,140)
Drop.BackgroundColor3 = Color3.fromRGB(30,30,35)
Drop.BorderSizePixel = 0

local Search = Instance.new("TextBox",Drop)
Search.Size = UDim2.fromOffset(160,24)
Search.Position = UDim2.fromOffset(5,5)
Search.PlaceholderText = "Search gun..."
Search.TextColor3 = Color3.fromRGB(230,230,230)
Search.BackgroundColor3 = Color3.fromRGB(40,40,45)
Search.BorderSizePixel = 0

local List = Instance.new("ScrollingFrame",Drop)
List.Position = UDim2.fromOffset(0,35)
List.Size = UDim2.fromScale(1,1)
List.CanvasSize = UDim2.new()
List.ScrollBarImageTransparency = 0.5
Instance.new("UIListLayout",List)

local function Refresh(filter)
    for _,c in pairs(List:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _,g in ipairs(Guns) do
        if not filter or g:lower():find(filter) then
            local b = Instance.new("TextButton",List)
            b.Text = g
            b.Size = UDim2.fromOffset(160,26)
            b.BackgroundColor3 = Color3.fromRGB(40,40,45)
            b.TextColor3 = Color3.fromRGB(230,230,230)
            b.BorderSizePixel = 0
            b.MouseButton1Click:Connect(function()
                State.SelectedGun = g
            end)
        end
    end
end
Refresh()

Search:GetPropertyChangedSignal("Text"):Connect(function()
    Refresh(Search.Text:lower())
end)

-- ================= TAB SWITCH =================
for name,btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _,t in pairs(TabsFrames) do t.Visible=false end
        TabsFrames[name].Visible=true
    end)
end

UIS.InputBegan:Connect(function(i)
    if State.Binding and i.UserInputType==Enum.UserInputType.Keyboard then
        State.ToggleKey = i.KeyCode
        State.Binding = false
    end
end)
