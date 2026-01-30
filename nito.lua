-- NITO | Clean Tabbed UI (Xeno Optimized)
-- UI ONLY — Toggles, Sliders, Dropdowns, Dynamic Tabs

local UIS = game:GetService("UserInputService")
local RS  = game:GetService("RunService")

-- ================= CONFIG =================
local UI = {
    Open = true,
    Pos = Vector2.new(450, 250),
    Size = Vector2.new(560, 360),
    Accent = Color3.fromRGB(155,115,255),
    Dragging = false,
    CurrentTab = "Main",
    Binding = false,
    Sliding = false
}

local Tabs = { "Main", "Movement", "Visuals", "Misc" }

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
local function New(t,p)
    local o = Drawing.new(t)
    for k,v in pairs(p) do o[k]=v end
    table.insert(Drawings,o)
    return o
end

-- ================= FRAME =================
local Frame = New("Square",{Filled=true,Color=Color3.fromRGB(18,18,22),Size=UI.Size,Position=UI.Pos})
local Sidebar = New("Square",{Filled=true,Color=Color3.fromRGB(22,22,28),Size=Vector2.new(130,UI.Size.Y),Position=UI.Pos})
local Title = New("Text",{Text="N I T O",Size=24,Center=true,Outline=true,Color=UI.Accent})

-- ================= TABS =================
local TabButtons = {}
for i,n in ipairs(Tabs) do
    TabButtons[n] = New("Text",{Text=n,Size=16,Outline=true,Color=Color3.fromRGB(180,180,180)})
end

-- ================= MAIN CONTROLS =================
local function CreateLabel(text,size)
    return New("Text",{Text=text,Size=size,Outline=true,Color=Color3.fromRGB(220,220,220)})
end

local MainControls = {
    Aimbot = CreateLabel("Aimbot: OFF",16),
    Orbit = CreateLabel("Orbit: OFF",16),
    OrbitSpeed = CreateLabel("Orbit Speed: 5",14),
    OrbitDistance = CreateLabel("Orbit Distance: 10",14),
    OrbitMode = CreateLabel("Orbit Mode: Random",14),
    Triggerbot = CreateLabel("Triggerbot: OFF",16),
    Keybind = CreateLabel("Toggle Key: F",14),
}

-- Helper to check bounds
local function inBounds(mouse,pos,size)
    return mouse.X>pos.X and mouse.X<pos.X+size.X and mouse.Y>pos.Y and mouse.Y<pos.Y+size.Y
end

-- ================= INPUT =================
UIS.InputBegan:Connect(function(input,gp)
    if gp then return end
    local m = UIS:GetMouseLocation()

    -- Binding key
    if UI.Binding then
        State.ToggleKey = input.KeyCode
        UI.Binding = false
        return
    end

    -- Open/close UI
    if input.KeyCode == Enum.KeyCode.Insert then
        UI.Open = not UI.Open
        for _,v in pairs(Drawings) do v.Visible = UI.Open end
    end

    -- Mouse input
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Drag
        if inBounds(m,Frame.Position,Vector2.new(Frame.Size.X,30)) then
            UI.Dragging = true
        end

        -- Tabs
        for name,btn in pairs(TabButtons) do
            if inBounds(m,btn.Position,Vector2.new(90,20)) then
                UI.CurrentTab = name
                break
            end
        end

        -- Main tab toggles
        if UI.CurrentTab=="Main" then
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
            if inBounds(m,MainControls.OrbitSpeed.Position,Vector2.new(200,18)) then
                UI.Sliding = "OrbitSpeed"
            elseif inBounds(m,MainControls.OrbitDistance.Position,Vector2.new(200,18)) then
                UI.Sliding = "OrbitDistance"
            end
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
    local mousePos = UIS:GetMouseLocation()

    -- Drag
    if UI.Dragging then
        UI.Pos = mousePos - Vector2.new(UI.Size.X/2,15)
    end

    Frame.Position = UI.Pos
    Sidebar.Position = UI.Pos
    Title.Position = UI.Pos + Vector2.new(65,18)

    -- Tabs
    for i,name in ipairs(Tabs) do
        local btn = TabButtons[name]
        btn.Position = UI.Pos + Vector2.new(20,60+(i-1)*35)
        btn.Color = (UI.CurrentTab==name) and UI.Accent or Color3.fromRGB(180,180,180)
    end

    -- Clear and render tab content
    local x,y = UI.Pos.X+160, UI.Pos.Y+70

    if UI.CurrentTab=="Main" then
        -- Toggles
        MainControls.Aimbot.Text = "Aimbot: "..(State.Aimbot and "ON" or "OFF")
        MainControls.Aimbot.Position = Vector2.new(x,y); y+=30
        MainControls.Orbit.Text = "Orbit: "..(State.Orbit and "ON" or "OFF")
        MainControls.Orbit.Position = Vector2.new(x,y); y+=30
        MainControls.Triggerbot.Text = "Triggerbot: "..(State.Triggerbot and "ON" or "OFF")
        MainControls.Triggerbot.Position = Vector2.new(x,y); y+=30

        -- Sliders
        local function slider(lbl,key,min,max)
            lbl.Position = Vector2.new(x,y)
            lbl.Text = lbl.Text:match("^(.-):")..": "..State[key]
            if UI.Sliding==key then
                local val = math.clamp((mousePos.X - x)/200,0,1)*(max-min)+min
                State[key] = math.floor(val*100)/100
            end
            y+=25
        end
        slider(MainControls.OrbitSpeed,"OrbitSpeed",1,20)
        slider(MainControls.OrbitDistance,"OrbitDistance",1,50)

        -- Dropdown
        MainControls.OrbitMode.Text = "Orbit Mode: "..State.OrbitMode
        MainControls.OrbitMode.Position = Vector2.new(x,y); y+=25

        -- Keybind
        MainControls.Keybind.Text = "Toggle Key: "..State.ToggleKey.Name
        MainControls.Keybind.Position = Vector2.new(x,y); y+=30
    else
        -- For other tabs, just show a placeholder
        local label = New("Text",{Text=UI.CurrentTab.." Tab Content",Size=16,Outline=true,Color=Color3.fromRGB(220,220,220)})
        label.Position = Vector2.new(x,y)
    end
end)
