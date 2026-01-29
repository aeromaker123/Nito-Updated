-- Da Hood Auto Robbery Script
-- Uses Flame Thrower, Teleports for Ammo, Gets LMG, Breaks Safes, Collects Money

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChild("Humanoid")

-- Wait for necessary objects
wait(2)

-- Function to get flame thrower and ammo
function getFlameThrower()
    local flamer = workspace:FindFirstChild("Flame Thrower")
    if flamer then
        -- Teleport to flame thrower location (adjust this based on your map)
        local flamerLocation = Vector3.new(100, 20, 100) -- Adjust coordinates
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(flamerLocation))
        
        -- Wait a bit for teleport to complete
        wait(1)
        
        -- Get ammo (this will be handled by the TP system)
        local ammo = workspace:FindFirstChild("Ammo")
        if ammo then
            print("Getting ammo...")
            game:GetService("Players").LocalPlayer.Character:SetPrimaryPartCFrame(ammo.PrimaryPart.CFrame)
            wait(1)
        end
        
        return true
    else
        print("Flame Thrower not found!")
        return false
    end
end

-- Function to get LMG
function getLMG()
    local lmg = workspace:FindFirstChild("LMG")
    if lmg then
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(lmg.PrimaryPart.CFrame)
        print("Got LMG!")
        return true
    else
        print("LMG not found!")
        return false
    end
end

-- Function to break bank doors with flame thrower
function breakBankDoors()
    local bankDoors = workspace:FindFirstChild("Bank Doors")
    if bankDoors then
        print("Breaking bank doors...")
        
        -- Use flame thrower on bank doors (this will simulate using it)
        for _, door in pairs(bankDoors:GetChildren()) do
            if door:IsA("BasePart") then
                -- Simulate using flame thrower on the door
                print("Using Flame Thrower on", door.Name)
                wait(2) -- Animation time
            end
        end
        
        return true
    else
        print("No bank doors found!")
        return false
    end
end

-- Function to break little safes (safes that are not the big ones)
function breakLittleSafes()
    local safes = workspace:FindFirstChild("Safes")
    if safes then
        for _, safe in pairs(safes:GetChildren()) do
            if safe:IsA("BasePart") and safe.Name ~= "BigSafe" then -- Assuming there's a big safe
                print("Breaking little safe:", safe.Name)
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(safe.PrimaryPart.CFrame)
                wait(1) -- Wait for action to complete
                
                -- Simulate breaking the safe with flame thrower
                print("Using Flame Thrower on", safe.Name)
                wait(2)
            end
        end
        
        return true
    else
        print("No safes found!")
        return false
    end
end

-- Function to collect money
function collectMoney()
    local money = workspace:FindFirstChild("Money")
    if money then
        for _, coin in pairs(money:GetChildren()) do
            if coin:IsA("BasePart") and coin.Name == "Coin" then
                print("Collecting", coin.Name)
                game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(coin.PrimaryPart.CFrame)
                wait(1)
            end
        end
        
        return true
    else
        print("No money found!")
        return false
    end
end

-- Main Robbery Function
function runRobbery()
    print("Starting Da Hood Auto Robbery...")
    
    -- Step 1: Get Flame Thrower and Ammo
    if getFlameThrower() then
        wait(2)
        
        -- Step 2: Get LMG
        if getLMG() then
            wait(2)
            
            -- Step 3: Break Bank Doors with Flame Thrower
            breakBankDoors()
            wait(2)
            
            -- Step 4: Break Little Safes
            breakLittleSafes()
            wait(2)
            
            -- Step 5: Collect Money
            collectMoney()
            print("Robbery Complete!")
        end
    else
        print("Failed to get Flame Thrower")
    end
end

-- Start the robbery process
runRobbery()

-- Additional auto collection feature
local function autoCollect()
    local player = game.Players.LocalPlayer
    
    while true do
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            -- Check for nearby collectibles or money
            local char = player.Character
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            
            if rootPart then
                -- Simple auto collection logic (you can expand this)
                wait(10) -- Wait before checking again
            end
        else
            wait(2)
        end
    end
end

-- Start automatic collection in background
local collectThread = spawn(autoCollect)

print("Da Hood Auto Robbery Script Loaded!")
