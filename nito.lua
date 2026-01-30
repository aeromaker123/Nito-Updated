-- NITO | Clean Tabbed UI (Xeno Optimized)
-- UI ONLY — no exploit logic

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
    Binding = false
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
local Title = New("Text",{Text="N I T O",Size=22,Center=true,Outline=true,Color=UI.Accent})

-- ================= TABS =================
local TabButtons = {}
for i,n in ipairs(Tabs) do
    TabButtons[n]=New("Text",{Text=n,Size=14,Outline=true,Color=Color3.fromRGB(180,180,180)})
end

-- ================= MAIN CONTROLS =================
local Labels = {
    Aimbot = New("Text",{Text="Aimbot: OFF",Size=15,Outline=true}),
    Orbit = New("Text",{Text="Orbit: OFF",Size=15,Outline=true}),
    Speed = New("Text",{Text="Orbit Speed",Size=14,Outline=true}),
    Distance = New("Text",{Text="Orbit Distance",Size=14,Outline=true}),
    Mode = New("Text",{Text="Orbit Mode: Random",Size=14,Outline=true}),
    Divider = New("Line",{Thickness=1,Color=Color3.fromRGB(60,60,60)}),
    Trigger = New("Text",{Text="Triggerbot: OFF",Size=15,Outline=true}),
    Keybind = New("Text",{Text="Toggle Key: F",Size=14,Outline=true})
}

-- ================= INPUT =================
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end

    if UI.Binding then
        State.ToggleKey = i.KeyCode
        UI.Binding = false
        return
    end

    if i.KeyCode == Enum.KeyCode.Insert then
        UI.Open = not UI.Open
        for _,v in pairs(Drawings) do v.Visible = UI.Open end
    end

    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local m = UIS:GetMouseLocation()

        -- Drag
        if m.X>Frame.Position.X and m.X<Frame.Position.X+Frame.Size.X
        and m.Y>Frame.Position.Y and m.Y<Frame.Position.Y+30 then
            UI.Dragging=true
        end

        -- Toggles
        local function click(txt,cb)
            local p=txt.Position
            if m.X>p.X and m.X<p.X+220 and m.Y>p.Y and m.Y<p.Y+18 then cb() end
        end

        if UI.CurrentTab=="Main" then
            click(Labels.Aimbot,function() State.Aimbot=not State.Aimbot end)
            click(Labels.Orbit,function() State.Orbit=not State.Orbit end)
            click(Labels.Trigger,function() State.Triggerbot=not State.Triggerbot end)
            click(Labels.Mode,function()
                State.OrbitMode = (State.OrbitMode=="Random") and "Velocity" or "Random"
            end)
            click(Labels.Keybind,function() UI.Binding=true end)
        end

        -- Tabs
        for n,b in pairs(TabButtons) do
            local p=b.Position
            if m.X>p.X and m.X<p.X+90 and m.Y>p.Y and m.Y<p.Y+18 then
                UI.CurrentTab=n
            end
        end
    end
end)

UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then UI.Dragging=false end
end)

-- ================= RENDER =================
RS.RenderStepped:Connect(function()
    if not UI.Open then return end
    if UI.Dragging then
        UI.Pos = UIS:GetMouseLocation()-Vector2.new(UI.Size.X/2,15)
    end

    Frame.Position=UI.Pos
    Sidebar.Position=UI.Pos
    Title.Position=UI.Pos+Vector2.new(65,18)

    for i,n in ipairs(Tabs) do
        local b=TabButtons[n]
        b.Position=UI.Pos+Vector2.new(20,60+(i-1)*35)
        b.Color=(UI.CurrentTab==n) and UI.Accent or Color3.fromRGB(180,180,180)
    end

    local x,y=UI.Pos.X+160,UI.Pos.Y+70
    local function upd(txt,val)
        txt.Position=Vector2.new(x,y)
        txt.Color=val and UI.Accent or Color3.fromRGB(200,200,200)
        y+=30
    end

    if UI.CurrentTab=="Main" then
        Labels.Aimbot.Text="Aimbot: "..(State.Aimbot and "ON" or "OFF")
        upd(Labels.Aimbot,State.Aimbot)

        Labels.Orbit.Text="Orbit: "..(State.Orbit and "ON" or "OFF")
        upd(Labels.Orbit,State.Orbit)

        Labels.Speed.Text="Orbit Speed: "..State.OrbitSpeed
        Labels.Speed.Position=Vector2.new(x,y) y+=25

        Labels.Distance.Text="Orbit Distance: "..State.OrbitDistance
        Labels.Distance.Position=Vector2.new(x,y) y+=30

        Labels.Mode.Text="Orbit Mode: "..State.OrbitMode
        Labels.Mode.Position=Vector2.new(x,y) y+=25

        Labels.Divider.From=Vector2.new(x,y)
        Labels.Divider.To=Vector2.new(x+240,y)
        y+=20

        Labels.Trigger.Text="Triggerbot: "..(State.Triggerbot and "ON" or "OFF")
        upd(Labels.Trigger,State.Triggerbot)

        Labels.Keybind.Text="Toggle Key: "..State.ToggleKey.Name
        Labels.Keybind.Position=Vector2.new(x,y)
    end
end)
