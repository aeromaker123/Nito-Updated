-- Update Main tab visibility based on CurrentTab
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

    -- Check which tab is active
    local isMain = UI.CurrentTab=="Main"

    -- Show/hide Main tab drawings
    for _,v in pairs(MainControls) do
        if v ~= MainControls.Placeholder then
            v.Visible = isMain
        end
    end

    if isMain then
        local x,y = UI.Pos.X+160, UI.Pos.Y+70

        -- Update Main tab content
        MainControls.Aimbot.Position = Vector2.new(x,y)
        MainControls.Aimbot.Text = "Aimbot: "..(State.Aimbot and "ON" or "OFF"); y+=30

        MainControls.Orbit.Position = Vector2.new(x,y)
        MainControls.Orbit.Text = "Orbit: "..(State.Orbit and "ON" or "OFF"); y+=30

        MainControls.OrbitSpeedLabel.Position = Vector2.new(x,y)
        MainControls.OrbitSpeedLabel.Text = "Orbit Speed: "..State.OrbitSpeed
        MainControls.OrbitSpeedBar.Position = Vector2.new(x,y+20)
        MainControls.OrbitSpeedHandle.Position = Vector2.new(x + (State.OrbitSpeed-1)/(20-1)*200-5,y+17)
        if UI.Sliding=="OrbitSpeed" then
            local val = math.clamp((mouse.X - x)/200,0,1)*(20-1)+1
            State.OrbitSpeed = math.floor(val*100)/100
        end
        y+=40

        MainControls.OrbitDistanceLabel.Position = Vector2.new(x,y)
        MainControls.OrbitDistanceLabel.Text = "Orbit Distance: "..State.OrbitDistance
        MainControls.OrbitDistanceBar.Position = Vector2.new(x,y+20)
        MainControls.OrbitDistanceHandle.Position = Vector2.new(x + (State.OrbitDistance-1)/(50-1)*200-5,y+17)
        if UI.Sliding=="OrbitDistance" then
            local val = math.clamp((mouse.X - x)/200,0,1)*(50-1)+1
            State.OrbitDistance = math.floor(val*100)/100
        end
        y+=40

        MainControls.OrbitMode.Position = Vector2.new(x,y)
        MainControls.OrbitMode.Text = "Orbit Mode: "..State.OrbitMode; y+=30

        MainControls.Divider.From = Vector2.new(x,y)
        MainControls.Divider.To = Vector2.new(x+240,y); y+=20

        MainControls.Triggerbot.Position = Vector2.new(x,y)
        MainControls.Triggerbot.Text = "Triggerbot: "..(State.Triggerbot and "ON" or "OFF"); y+=30

        MainControls.Keybind.Position = Vector2.new(x,y)
        MainControls.Keybind.Text = "Toggle Key: "..State.ToggleKey.Name
    else
        -- Other tabs placeholder
        if not MainControls.Placeholder then
            MainControls.Placeholder = New("Text",{Text=UI.CurrentTab.." Tab Content",Size=16,Outline=true,Color=Color3.fromRGB(220,220,220)})
        end
        MainControls.Placeholder.Position = Vector2.new(UI.Pos.X+160, UI.Pos.Y+70)
        MainControls.Placeholder.Visible = true
    end
end)
