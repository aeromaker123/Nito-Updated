-- NITO GUI | Scroll-Safe, No Cutoff, Proper Layout

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
Frame.Size = UDim2.fromOffset(620,420)
Frame.Position = UDim2.fromScale(0.5,0.5) - UDim2.fromOffset(310,210)
Frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- ================= TITLE =================
local Title = Instance.new("TextLabel")
Title.Text = "N I T O"
Title.Size = UDim2.fromOffset(220,32)
Title.Position = UDim2.fromScale(0.5,0) - UDim2.fromOffset(110,-12)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(155,115,255)
Title.TextScaled = true
Title.Parent = Frame

-- ================= SIDEBAR =================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(130,420)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Frame

local Tabs = {"Main","Movement","Visuals","Misc"}
local TabButtons = {}

local SideLayout = Instance.new("UIListLayout",Sidebar)
SideLayout.Padding = UDim.new(0,10)
SideLayout.HorizontalAlignment = Center
SideLayout.VerticalAlignment = Center

for _,name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.fromOffset(105,32)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,40)
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar
    TabButtons[name] = btn
end

-- ================= CONTENT HOLDER =================
local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(140,50)
Content.Size = UDim2.fromOffset(460,340)
Content.BackgroundTransparency = 1
Content.Parent = Frame

local TabsFrames = {}

local function CreateTab(name)
    local tab = Instance.new("ScrollingFrame")
    tab.Size = UDim2.fromScale(1,1)
    tab.CanvasSize = UDim2.new()
    tab.ScrollBarImageTransparency = 0.4
    tab.AutomaticCanvasSize = Enum.AutomaticSize.None
    tab.BackgroundTransparency = 1
    tab.Visible = name=="Main"
    tab.Parent = Content
    TabsFrames[name] = tab
    return tab
end

for _,n in ipairs(Tabs) do CreateTab(n) end
local MainTab = TabsFrames.Main

-- ================= HORIZONTAL CONTAINER =================
local Row = Instance.new("Frame",MainTab)
Row.Size = UDim2.fromScale(1,1)
Row.BackgroundTransparency = 1

local RowLayout = Instance.new("UIListLayout",Row)
RowLayout.FillDirection = Horizontal
RowLayout.Padding = UDim.new(0,16)

-- ================= COLUMNS =================
local function Column()
    local f = Instance.new("Frame")
    f.Size = UDim2.fromScale(0.5,1)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundTransparency = 1

    local p = Instance.new("UIPadding",f)
    p.PaddingTop = UDim.new(0,5)

    local l = Instance.new("UIListLayout",f)
    l.Padding = UDim.new(0,10)

    return f
end

local Left = Column()
Left.Parent = Row

local Divider = Instance.new("Frame",Row)
Divider.Size = UDim2.fromOffset(2,300)
Divider.BackgroundColor3 = Color3.fromRGB(155,115,255)
Divider.BorderSizePixel = 0

local Right = Column()
Right.Parent = Row

-- ================= AUTO CANVAS RESIZE =================
local function AutoResize()
    task.wait()
    MainTab.CanvasSize = UDim2.fromOffset(0, RowLayout.AbsoluteContentSize.Y + 20)
end
RowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(AutoResize)

-- ================= HELPERS =================
local function Toggle(text,parent,cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(200,30)
    b.BackgroundColor3 = Color3.fromRGB(35,35,40)
    b.TextColor3 = Color3.fromRGB(230,230,230)
    b.BorderSizePixel = 0
    b.Text = text
    b.Parent = parent
    b.MouseButton1Click:Connect(cb)
end

local function Slider(name,min,max,parent,cb)
    local f = Instance.new("Frame",parent)
    f.Size = UDim2.fromOffset(200,46)
    f.BackgroundTransparency = 1

    local t = Instance.new("TextLabel",f)
    t.Size = UDim2.fromScale(1,0.45)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.fromRGB(230,230,230)
    t.Text = name..": "..min

    local bar = Instance.new("Frame",f)
    bar.Position = UDim2.fromScale(0,0.6)
    bar.Size = UDim2.fromScale(1,0.18)
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
                    t.Text = name..": "..v
                    cb(v)
                end
            end)
            UIS.InputEnded:Once(function() move:Disconnect() end)
        end
    end)
end

-- ================= LEFT CONTENT =================
Toggle("Aimbot",Left,function() State.Aimbot=not State.Aimbot end)
Toggle("Orbit",Left,function() State.Orbit=not State.Orbit end)
Slider("Orbit Speed",1,20,Left,function(v) State.OrbitSpeed=v end)
Slider("Orbit Distance",1,50,Left,function(v) State.OrbitDistance=v end)
Toggle("Orbit Mode",Left,function()
    State.OrbitMode = State.OrbitMode=="Random" and "Velocity" or "Random"
end)
Toggle("Triggerbot",Left,function() State.Triggerbot=not State.Triggerbot end)

-- ================= RIGHT CONTENT =================
Toggle("Shoot the Shooter",Right,function() State.ShootShooter=not State.ShootShooter end)
Toggle("TP Toggle",Right,function() State.TP=not State.TP end)

local Drop = Instance.new("Frame",Right)
Drop.Size = UDim2.fromOffset(200,160)
Drop.BackgroundColor3 = Color3.fromRGB(30,30,35)
Drop.BorderSizePixel = 0

local Search = Instance.new("TextBox",Drop)
Search.Size = UDim2.fromOffset(190,26)
Search.Position = UDim2.fromOffset(5,5)
Search.PlaceholderText = "Search gun..."
Search.TextColor3 = Color3.fromRGB(230,230,230)
Search.BackgroundColor3 = Color3.fromRGB(40,40,45)
Search.BorderSizePixel = 0

local List = Instance.new("ScrollingFrame",Drop)
List.Position = UDim2.fromOffset(0,38)
List.Size = UDim2.fromScale(1,1)
List.CanvasSize = UDim2.new()
Instance.new("UIListLayout",List)

local function Refresh(filter)
    for _,c in pairs(List:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _,g in ipairs(Guns) do
        if not filter or g:lower():find(filter) then
            local b = Instance.new("TextButton",List)
            b.Size = UDim2.fromOffset(190,26)
            b.Text = g
            b.BackgroundColor3 = Color3.fromRGB(40,40,45)
            b.TextColor3 = Color3.fromRGB(230,230,230)
            b.BorderSizePixel = 0
            b.MouseButton1Click:Connect(function()
                State.SelectedGun=g
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
