-- NITO | FULL DRAWING UI | XENO SAFE | WITH UNLOAD

local UIS = game:GetService("UserInputService")
local RS  = game:GetService("RunService")

-- ================= CONFIG =================
local UI = {
    Open = true,
    Pos = Vector2.new(400, 220),
    Size = Vector2.new(620, 420),
    Accent = Color3.fromRGB(155,115,255),
    Dragging = false,
    Tab = "Main"
}

local State = {
    Aimbot = false,
    Orbit = false,
    OrbitSpeed = 10,
    OrbitDistance = 15,
    OrbitMode = "Random",
    Triggerbot = false,
    ShootShooter = false,
    TP = false,
    Gun = "Glock"
}

local Guns = {
    "Glock","Revolver","Shotgun","Double-Barrel","SMG","Silencer",
    "Drum Gun","AR","AK-47","AUG","Rifle","LMG","Tactical Shotgun"
}

-- ================= DRAWING + CONNECTION HELPERS =================
local Drawings = {}
local Connections = {}

local function D(type, props)
    local o = Drawing.new(type)
    for k,v in pairs(props) do o[k] = v end
    table.insert(Drawings, o)
    return o
end

local function Connect(sig, fn)
    local c = sig:Connect(fn)
    table.insert(Connections, c)
    return c
end

local function Unload()
    UI.Open = false

    for _,c in ipairs(Connections) do
        pcall(function() c:Disconnect() end)
    end
    for _,d in ipairs(Drawings) do
        pcall(function() d:Remove() end)
    end

    table.clear(Connections)
    table.clear(Drawings)
end

-- ================= FRAME =================
local Frame = D("Square",{
    Filled = true,
    Color = Color3.fromRGB(18,18,22),
    Size = UI.Size,
    Position = UI.Pos
})

local Sidebar = D("Square",{
    Filled = true,
    Color = Color3.fromRGB(22,22,28),
    Size = Vector2.new(140, UI.Size.Y),
    Position = UI.Pos
})

local Title = D("Text",{
    Text = "N I T O",
    Size = 24,
    Center = true,
    Outline = true,
    Color = UI.Accent
})

-- ================= TABS =================
local Tabs = {"Main","Movement","Visuals","Misc"}
local TabText = {}

for i,t in ipairs(Tabs) do
    TabText[t] = D("Text",{
        Text = t,
        Size = 15,
        Outline = true,
        Color = Color3.fromRGB(180,180,180)
    })
end

-- ================= LABELS =================
local Labels = {}
local function Label()
    return D("Text",{Size=15,Outline=true})
end

Labels.Aimbot = Label()
Labels.Orbit = Label()
Labels.Trigger = Label()
Labels.Shoot = Label()
Labels.TP = Label()

local SpeedLabel = D("Text",{Size=14,Outline=true})
local DistLabel  = D("Text",{Size=14,Outline=true})
local ModeLabel  = D("Text",{Size=14,Outline=true})
local GunLabel   = D("Text",{Size=14,Outline=true})

local Divider = D("Line",{Thickness=2,Color=UI.Accent})

-- Misc
local UnloadLabel = D("Text",{
    Text = "Unload Script",
    Size = 16,
    Outline = true,
    Color = Color3.fromRGB(255,80,80)
})

-- ================= INPUT =================
Connect(UIS.InputBegan,function(i,gp)
    if gp or not UI.Open then return end
    local m = UIS:GetMouseLocation()

    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Drag
        if m.X>Frame.Position.X and m.X<Frame.Position.X+Frame.Size.X
        and m.Y>Frame.Position.Y and m.Y<Frame.Position.Y+30 then
            UI.Dragging = true
        end

        -- Tabs
        for t,b in pairs(TabText) do
            local p=b.Position
            if m.X>p.X and m.X<p.X+90 and m.Y>p.Y and m.Y<p.Y+18 then
                UI.Tab = t
            end
        end

        local function click(txt,cb)
            local p=txt.Position
            if txt.Visible and m.X>p.X and m.X<p.X+260 and m.Y>p.Y and m.Y<p.Y+18 then
                cb()
            end
        end

        if UI.Tab=="Main" then
            click(Labels.Aimbot,function() State.Aimbot=not State.Aimbot end)
            click(Labels.Orbit,function() State.Orbit=not State.Orbit end)
            click(Labels.Trigger,function() State.Triggerbot=not State.Triggerbot end)
            click(Labels.Shoot,function() State.ShootShooter=not State.ShootShooter end)
            click(Labels.TP,function() State.TP=not State.TP end)
            click(ModeLabel,function()
                State.OrbitMode = State.OrbitMode=="Random" and "Velocity" or "Random"
            end)
        elseif UI.Tab=="Misc" then
            click(UnloadLabel,Unload)
        end
    end
end)

Connect(UIS.InputEnded,function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        UI.Dragging=false
    end
end)

-- ================= RENDER =================
Connect(RS.RenderStepped,function()
    if not UI.Open then return end

    if UI.Dragging then
        UI.Pos = UIS:GetMouseLocation() - Vector2.new(UI.Size.X/2,15)
    end

    Frame.Position = UI.Pos
    Sidebar.Position = UI.Pos
    Title.Position = UI.Pos + Vector2.new(UI.Size.X/2,18)

    for i,t in ipairs(Tabs) do
        local b = TabText[t]
        b.Position = UI.Pos + Vector2.new(20,60+(i-1)*34)
        b.Color = (UI.Tab==t) and UI.Accent or Color3.fromRGB(180,180,180)
        b.Visible = true
    end

    -- Hide all
    for _,v in pairs(Labels) do v.Visible=false end
    SpeedLabel.Visible=false
    DistLabel.Visible=false
    ModeLabel.Visible=false
    GunLabel.Visible=false
    Divider.Visible=false
    UnloadLabel.Visible=false

    if UI.Tab=="Main" then
        local x = UI.Pos.X + 160
        local y = UI.Pos.Y + 70

        local function row(lbl,text,on)
            lbl.Text = text
            lbl.Position = Vector2.new(x,y)
            lbl.Color = on and UI.Accent or Color3.fromRGB(220,220,220)
            lbl.Visible=true
            y+=28
        end

        row(Labels.Aimbot,"Aimbot: "..(State.Aimbot and "ON" or "OFF"),State.Aimbot)
        row(Labels.Orbit,"Orbit: "..(State.Orbit and "ON" or "OFF"),State.Orbit)

        SpeedLabel.Text="Orbit Speed: "..State.OrbitSpeed
        SpeedLabel.Position=Vector2.new(x,y)
        SpeedLabel.Visible=true
        y+=24

        DistLabel.Text="Orbit Distance: "..State.OrbitDistance
        DistLabel.Position=Vector2.new(x,y)
        DistLabel.Visible=true
        y+=24

        ModeLabel.Text="Orbit Mode: "..State.OrbitMode
        ModeLabel.Position=Vector2.new(x,y)
        ModeLabel.Visible=true
        y+=28

        Divider.From=Vector2.new(x,y)
        Divider.To=Vector2.new(x+260,y)
        Divider.Visible=true
        y+=18

        row(Labels.Trigger,"Triggerbot: "..(State.Triggerbot and "ON" or "OFF"),State.Triggerbot)

        -- Right side
        local rx = x + 300
        local ry = UI.Pos.Y + 70

        Labels.Shoot.Text="Shoot the Shooter: "..(State.ShootShooter and "ON" or "OFF")
        Labels.Shoot.Position=Vector2.new(rx,ry)
        Labels.Shoot.Visible=true
        ry+=28

        Labels.TP.Text="TP: "..(State.TP and "ON" or "OFF")
        Labels.TP.Position=Vector2.new(rx,ry)
        Labels.TP.Visible=true
        ry+=28

        GunLabel.Text="Gun: "..State.Gun
        GunLabel.Position=Vector2.new(rx,ry)
        GunLabel.Visible=true

    elseif UI.Tab=="Misc" then
        UnloadLabel.Position = Vector2.new(
            UI.Pos.X + 160,
            UI.Pos.Y + 80
        )
        UnloadLabel.Visible = true
    end
end)
