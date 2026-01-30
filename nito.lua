-- NITO | Clean Tabbed UI (Stable, Keybind Fix, Persistent Elements)
-- UI ONLY

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- ================= CONFIG =================
local UI = {
    Open = true,
    Pos = Vector2.new(450,250),
    Size = Vector2.new(560,360),
    Accent = Color3.fromRGB(155,115,255),
    Dragging = false,
    CurrentTab = "Main",
    Binding = false,
    Sliding = false
}

local Tabs = {"Main","Movement","Visuals","Misc"}

local State = {
    Aimbot = false,
    Orbit = false,
    Triggerbot = false,
    OrbitSpeed = 5,
    OrbitDistance = 10,
    OrbitMode = "Random",
    ToggleKey = Enum.KeyCode.F
}

-- ================= DRAW HELPERS =================
local Drawings = {}
local function New(t,props)
    local o = Drawing.new(t)
    for k,v in pairs(props) do o[k] = v end
    table.insert(Drawings,o)
    return o
end

-- ================= FRAME =================
local Frame = New("Square",{Filled=true,Color=Color3.fromRGB(18,18,22),Size=UI.Size,Position=UI.Pos})
local Sidebar = New("Square",{Filled=true,Color=Color3.fromRGB(22,22,28),Size=Vector2.new(130,UI.Size.Y),Position=UI.Pos})
local Title = New("Text",{Text="N I T O",Size=24,Center=true,Outline=true,Color=UI.Accent})

-- ================= TABS =================
local TabButtons = {}
for i,name in ipairs(Tabs) do
    TabButtons[name] = New("Text",{Text=name,Size=16,Outline=true,Color=Color3.fromRGB(180,180,180)})
end

-- ================= MAIN CONTROLS =================
local function CreateLabel(text,size)
    return New("Text",{Text=text,Size=size,Outline=true,Color=Color3.fromRGB(220,220,220)})
end

-- Persistent drawings for Main tab
local MainControls = {
    Aimbot = CreateLabel("Aimbot: OFF",16),
    Orbit = CreateLabel("Orbit: OFF",16),
    OrbitSpeedLabel = CreateLabel("Orbit Speed: 5",14),
    OrbitDistanceLabel = CreateLabel("Orbit Distance: 10",14),
    OrbitSpeedBar = New("Square",{Filled=true,Color=Color3.fromRGB(50,50,50),Size=Vector2.new(200,5)}),
    OrbitSpeedHandle = New("Square",{Filled=true,Color=UI.Accent,Size=Vector2.new(10,10)}),
    OrbitDistanceBar = New("Square",{Filled=true,Color=Color3.fromRGB(50,50,50),Size=Vector2.new(200,5)}),
    OrbitDistanceHandle = New("Square",{Filled=true,Color=UI.Accent,Size=Vector2.new(10,10)}),
    OrbitMode = CreateLabel("Orbit Mode: Random",14),
    Divider = New("Line",{Thickness=2,Color=Color3.fromRGB(80,80,80)}),
    Triggerbot = CreateLabel("Triggerbot: OFF",16),
    Keybind = CreateLabel("Toggle Key: F",14)
}

-- ================= INPUT =================
local function inBounds(mouse,pos,size)
    return mouse.X>pos.X and mouse.X<pos.X+size.X and mouse.Y>pos.Y and mouse.Y<pos.Y+size.Y
end

UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    local m = UIS:GetMouseLocation()

    -- Key binding
    if UI.Binding then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            State.ToggleKey = input.KeyCode
        end
        UI.Binding = false
        return
    end

    if input.KeyCode == Enum.KeyCode.Insert then
        UI.Open = not UI.Open
        for _,v in pairs(Drawings) do v.Visible = UI.Open end
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if inBounds(m,Frame.Position,Vector2.new(Frame.Size.X,30)) then
            UI.Dragging = true
        end

        -- Tab Buttons
        for name,btn in pairs(TabButtons) do
            if inBounds(m,btn.Position,Vector2.new(90,20)) then
                UI.CurrentTab = name
            end
        end

        -- Main tab interactions
        local function toggle(lbl,key)
            if inBounds(m,lbl.Position,Vector2.new(220,18)) then
                State[key] = not State[key]
            end
        end
        toggle(MainControls.Aimbot,"Aimbot")
        toggle(MainControls.Orbit,"Orbit")
        toggle(MainControls.Triggerbot,"Triggerbot")

        -- Dropdown
        if inBounds(m,MainControls.OrbitMode.Position,Vector2.new(200,18)) then
            State.OrbitMode = (State.OrbitMode=="Random") and "Velocity" or "Random"
        end

        -- Keybind
        if inBounds(m,MainControls.Keybind.Position,Vector2.new(200,18)) then
            UI.Binding = true
        end

        -- Sliders
        if inBounds(m,MainControls.OrbitSpeedBar.Position,MainControls.OrbitSpeedBar.Size) then
            UI.Sliding = "OrbitSpeed"
        elseif inBounds(m,MainControls.OrbitDistanceBar.Position,MainControls.OrbitDistanceBar.Size) then
            UI.Sliding = "OrbitDistance"
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        UI.Dragging = false
        UI.Sliding = false
    end
end)

-- ================= RENDER =================
RS.RenderStepped:Connect(function()
    if not UI.Open then return end
    local mouse = UIS:GetMouseLocation()

    -- Dragging
    if UI.Dragging then
        UI.Pos = mouse - Vector2.new(UI.Size.X/2,15)
    end

    -- Frame / Sidebar / Title
    Frame.Position = UI.Pos
    Sidebar.Position = UI.Pos
    Title.Position = UI.Pos + Vector2.new(65,18)

    -- Tabs
    for i,name in ipairs(Tabs) do
        local btn = TabButtons[name]
        btn.Position = UI.Pos + Vector2.new(20,60+(i-1)*35)
        btn.Color = (UI.CurrentTab==name) and UI.Accent or Color3.fromRGB(180,180,180)
    end

    -- Base coordinates for tab content
    local x,y = UI.Pos.X+160, UI.Pos.Y+70

    -- Main tab always visible, only update content if active
    local isMain = UI.CurrentTab=="Main"

    -- Update toggles
    MainControls.Aimbot.Position = Vector2.new(x,y)
    MainControls.Aimbot.Text = "Aimbot: "..(State.Aimbot and "ON" or "OFF"); y+=30

    MainControls.Orbit.Position = Vector2.new(x,y)
    MainControls.Orbit.Text = "Orbit: "..(State.Orbit and "ON" or "OFF"); y+=30

    -- Orbit Speed Slider
    MainControls.OrbitSpeedLabel.Position = Vector2.new(x,y)
    MainControls.OrbitSpeedLabel.Text = "Orbit Speed: "..State.OrbitSpeed
    MainControls.OrbitSpeedBar.Position = Vector2.new(x,y+20)
    local speedBarLen = MainControls.OrbitSpeedBar.Size.X
    local handleX = x + (State.OrbitSpeed-1)/(20-1)*speedBarLen
    MainControls.OrbitSpeedHandle.Position = Vector2.new(handleX-5,y+17)
    if UI.Sliding=="OrbitSpeed" and isMain then
        local val = math.clamp((mouse.X - x)/speedBarLen,0,1)*(20-1)+1
        State.OrbitSpeed = math.floor(val*100)/100
    end
    y+=40

    -- Orbit Distance Slider
    MainControls.OrbitDistanceLabel.Position = Vector2.new(x,y)
    MainControls.OrbitDistanceLabel.Text = "Orbit Distance: "..State.OrbitDistance
    MainControls.OrbitDistanceBar.Position = Vector2.new(x,y+20)
    local distBarLen = MainControls.OrbitDistanceBar.Size.X
    local distHandleX = x + (State.OrbitDistance-1)/(50-1)*distBarLen
    MainControls.OrbitDistanceHandle.Position = Vector2.new(distHandleX-5,y+17)
    if UI.Sliding=="OrbitDistance" and isMain then
        local val = math.clamp((mouse.X - x)/distBarLen,0,1)*(50-1)+1
        State.OrbitDistance = math.floor(val*100)/100
    end
    y+=40

    -- Orbit Mode Dropdown
    MainControls.OrbitMode.Position = Vector2.new(x,y)
    MainControls.OrbitMode.Text = "Orbit Mode: "..State.OrbitMode; y+=30

    -- Divider
    MainControls.Divider.From = Vector2.new(x,y)
    MainControls.Divider.To = Vector2.new(x+240,y); y+=20

    -- Triggerbot Section
    MainControls.Triggerbot.Position = Vector2.new(x,y)
    MainControls.Triggerbot.Text = "Triggerbot: "..(State.Triggerbot and "ON" or "OFF"); y+=30

    -- Keybind
    MainControls.Keybind.Position = Vector2.new(x,y)
    MainControls.Keybind.Text = "Toggle Key: "..State.ToggleKey.Name

    -- Hide/show other tabs placeholder
    for k,v in pairs(MainControls) do
        if not isMain then
            -- Keep visible but disable interaction
            v.Visible = true
        end
    end
end)
