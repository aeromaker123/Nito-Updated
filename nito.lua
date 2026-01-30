-- Set up a simple table to manage tab contents
local TabContents = {
    Main = MainControls,
    Movement = {},
    Visuals = {},
    Misc = {}
}

-- When rendering, toggle visibility of each tab's drawings
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
        btn.Visible = true
    end

    -- Update tab visibility
    for tabName, elements in pairs(TabContents) do
        local visible = (UI.CurrentTab == tabName)
        for _, v in pairs(elements) do
            v.Visible = visible
        end
    end

    -- Only update content for active tab
    if UI.CurrentTab == "Main" then
        local x,y = UI.Pos.X+160, UI.Pos.Y+70

        -- Aimbot / Orbit Toggle
        MainControls.Aimbot.Position = Vector2.new(x,y)
        MainControls.Aimbot.Text = "Aimbot: "..(State.Aimbot and "ON" or "OFF"); y+=30

        MainControls.Orbit.Position = Vector2.new(x,y)
        MainControls.Orbit.Text = "Orbit: "..(State.Orbit and "ON" or "OFF"); y+=30

        -- Orbit Speed Slider
        MainControls.OrbitSpeedLabel.Position = Vector2.new(x,y)
        MainControls.OrbitSpeedLabel.Text = "Orbit Speed: "..State.OrbitSpeed
        MainControls.OrbitSpeedBar.Position = Vector2.new(x,y+20)
        MainControls.OrbitSpeedHandle.Position = Vector2.new(x + (State.OrbitSpeed-1)/(20-1)*200-5,y+17)
        if UI.Sliding=="OrbitSpeed" then
            local val = math.clamp((mouse.X - x)/200,0,1)*(20-1)+1
            State.OrbitSpeed = math.floor(val*100)/100
        end
        y+=40

        -- Orbit Distance Slider
        MainControls.OrbitDistanceLabel.Position = Vector2.new(x,y)
        MainControls.OrbitDistanceLabel.Text = "Orbit Distance: "..State.OrbitDistance
        MainControls.OrbitDistanceBar.Position = Vector2.new(x,y+20)
        MainControls.OrbitDistanceHandle.Position = Vector2.new(x + (State.OrbitDistance-1)/(50-1)*200-5,y+17)
        if UI.Sliding=="OrbitDistance" then
            local val = math.clamp((mouse.X - x)/200,0,1)*(50-1)+1
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
    end
end)
