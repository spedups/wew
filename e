local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Reaper 2 UI", "DarkTheme")

-- Information Tab (Watermark and Version)
local InfoTab = Window:NewTab("Information")
local InfoSection = InfoTab:NewSection("Info")

-- Button for Watermark
InfoSection:NewButton("Watermark: DEMXNMANES", "Display the watermark", function()
    print("Watermark: DEMXNMANES")
end)

-- Button for Version
InfoSection:NewButton("Version: 1.1", "Display the version", function()
    print("Version: 1.1")
end)
-- Button to inject Infinity Yield
InfoSection:NewButton("Inject Infinity Yield", "Inject Infinity Yield for powerful admin commands", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- Skins Tab
local SkinsTab = Window:NewTab("Skins")
local SkinsSection = SkinsTab:NewSection("Manage Skins")

-- Placeholder for the dynamic skinName
local skinName = "Aizen" -- Default value
local skinIconID = "rbxassetid://17071030081"

-- Text Field for skinName
local inputField
SkinsSection:NewTextBox("Enter Skin Name", "Default is Aizen", function(input)
    skinName = input -- Update skinName dynamically
end)

-- Button to Add Skin
SkinsSection:NewButton("Add Skin", "Add the specified skin", function()
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local skinsList = playerGui.HUD.MainFrame.Skins.List

    -- Function to create a new skin
    local function createSkin(name)
        local hitbox = Instance.new("Frame")
        hitbox.Size = UDim2.new(0, 80, 0, 77)
        hitbox.BackgroundTransparency = 1
        hitbox.Name = name .. "Hitbox" .. tostring(math.random(1, 1000000)) -- Unique hitbox name

        local newSkin = Instance.new("Frame")
        newSkin.Size = UDim2.new(0, 73, 0, 71)
        newSkin.Position = UDim2.new(0.5, -37.5, 0.5, -33.5)
        newSkin.BackgroundColor3 = Color3.fromRGB(130, 130, 130)
        newSkin.BorderSizePixel = 0
        newSkin.Name = name
        newSkin.Parent = hitbox

        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 15)
        uiCorner.Parent = newSkin

        local skinIcon = Instance.new("ImageLabel")
        skinIcon.Size = UDim2.new(0.75, 0, 0.8, 0)
        skinIcon.Position = UDim2.new(0.1, 0, 0.09, 0)
        skinIcon.Image = skinIconID
        skinIcon.ImageColor3 = Color3.fromRGB(80, 80, 100)
        skinIcon.BackgroundTransparency = 1
        skinIcon.Parent = newSkin

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        nameLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name -- Use the dynamic name
        nameLabel.FontFace = Font.new("rbxasset://fonts/families/JosefinSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        nameLabel.TextScaled = true
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center
        nameLabel.Parent = newSkin

        return hitbox
    end

    -- Function to update skin positions
    local function updateSkinPositions()
        local rowSize = 4
        local spacing = 10
        local skinSize = 80

        local count = 0
        for _, child in ipairs(skinsList:GetChildren()) do
            if child:IsA("Frame") then
                local row = math.floor(count / rowSize)
                local col = count % rowSize
                child.Position = UDim2.new(0, col * (skinSize + spacing), 0, row * (skinSize + spacing))
                count += 1
            end
        end
    end

    -- Add the new skin
    if skinName and skinName ~= "" then -- Ensure a valid name
        local newSkin = createSkin(skinName)
        newSkin.Parent = skinsList
        updateSkinPositions()
    else
        print("Please enter a valid skin name!")
    end
end)

-- Button to Destroy All Skins (including ImageButtons)
SkinsSection:NewButton("Destroy All Skins", "Remove all skins and image buttons from the list", function()
    local player = game:GetService("Players").LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local skinsList = playerGui.HUD.MainFrame.Skins.List

    -- Destroy all child frames and ImageButtons
    for _, child in ipairs(skinsList:GetChildren()) do
        if child:IsA("Frame") or child:IsA("ImageButton") then
            child:Destroy()
        end
    end
end)

-- Username Modifier Tab
local UsernameModifierTab = Window:NewTab("Username Modifier")
local UsernameModifierSection = UsernameModifierTab:NewSection("Modify Username")

-- TextBox for Avatar Image ID
UsernameModifierSection:NewTextBox("Avatar Image ID", "Enter the Avatar Image ID", function(input)
    getgenv().avatarImageID = input -- Set Avatar Image ID dynamically
end)

-- TextBox for Dynamic ID (Adds 'p_' automatically)
UsernameModifierSection:NewTextBox("Dynamic ID (prefix)", "Enter dynamic ID", function(input)
    getgenv().dynamicID = "p_" .. input -- Automatically add 'p_' to the dynamic ID
end)

-- Button to Update Username
UsernameModifierSection:NewButton("Update Username", "Apply the changes to your username", function()
    getgenv().userID = tonumber(getgenv().avatarImageID)

    local UserService = game:GetService("UserService")

    local success, result = pcall(function()
        return UserService:GetUserInfosByUserIdsAsync({ getgenv().userID })
    end)
    
    if success then
        for _, userInfo in ipairs(result) do
            print("Id:", userInfo.Id)
            print("Username:", userInfo.Username)
            print("DisplayName:", userInfo.DisplayName)
            getgenv().newDisplayName = userInfo.DisplayName
            getgenv().newPlayerName = userInfo.Username
        end
    else
        warn("Error fetching user info")
    end
    
    local avatarImageObject = game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.PlayerDropDown.InnerFrame.PlayerHeader.AvatarImage
    local imageUrl = "rbxthumb://type=AvatarHeadShot&id=" .. getgenv().avatarImageID .. "&w=150&h=150"
    avatarImageObject.Image = imageUrl
    
    local displayNameObject = game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.PlayerDropDown.InnerFrame.PlayerHeader.Background.TextContainerFrame.DisplayName
    displayNameObject.Text = getgenv().newDisplayName
    
    local playerNameObject = game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.PlayerDropDown.InnerFrame.PlayerHeader.Background.TextContainerFrame.PlayerName
    playerNameObject.Text = "@" .. getgenv().newPlayerName
    
    local path = "game:GetService('CoreGui').RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame." .. getgenv().dynamicID .. ".ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName"
    local playerNameTextObject = loadstring("return " .. path)()
    if playerNameTextObject then
        playerNameTextObject.Text = getgenv().newDisplayName
    else
        warn("Could not find the object at path: " .. path)
    end
end)

-- Stats Tab
local StatsTab = Window:NewTab("Stats")
local StatsSection = StatsTab:NewSection("Manage Stats")

-- Function to sanitize the input (remove commas, handle dots)
local function sanitizeInput(input)
    input = input:gsub(",", "")
    local number = tonumber(input)
    if number then
        return number
    else
        return nil
    end
end

-- Function to format the Cash value with commas
local function formatCashWithCommas(value)
    local formattedValue = tostring(value)
    local left, right = formattedValue:match("^(%d+)(%.%d+)$")
    if not left then
        left = formattedValue
    end
    left = left:reverse():gsub("%d%d%d", "%1,"):reverse()
    return left .. (right or "")
end

-- Level Input
StatsSection:NewTextBox("Level", "Set your level", function(input)
    local levelValue = sanitizeInput(input)
    
    if levelValue then
        game:GetService("Players").LocalPlayer.PlayerGui.HUD.BarsBackground.Level.Text = tostring(levelValue)
    else
        print("Invalid level input!")
    end
end)

-- Prestige Input
StatsSection:NewTextBox("Prestige", "Set your Prestige", function(input)
    local prestigeValue = sanitizeInput(input)
    
    if prestigeValue then
        game:GetService("Players").LocalPlayer.PlayerGui.HUD.BarsBackground.Prestige.Text = tostring(prestigeValue)
    else
        print("Invalid Prestige input!")
    end
end)

-- Clan Input
StatsSection:NewTextBox("Clan", "Set your Clan", function(input)
    game:GetService("Players").LocalPlayer.PlayerGui.HUD.Clan.Text = "Clan: " .. input
end)

-- Pet Spins Input
StatsSection:NewTextBox("Pet Spins", "Set your Pet Spins", function(input)
    local petSpinsValue = sanitizeInput(input)
    
    if petSpinsValue then
        game:GetService("Players").LocalPlayer.PlayerGui.HUD.MainFrame.PetsMainFrame.SpinFrame.SpinFrame.Spin.Cash.Text = "Pet Spins: " .. tostring(petSpinsValue)
    else
        print("Invalid Pet Spins input!")
    end
end)

-- Legendary Spins Input
StatsSection:NewTextBox("Legendary Spins", "Set your Legendary Spins", function(input)
    local legendarySpinsValue = sanitizeInput(input)
    
    if legendarySpinsValue then
        game:GetService("Players").LocalPlayer.PlayerGui.HUD.MainFrame.SecondarySpinFrame.Stats.Legendary.TextLabel.Text = tostring(legendarySpinsValue)
    else
        print("Invalid Legendary Spins input!")
    end
end)

-- Normal Spins Input
StatsSection:NewTextBox("Normal Spins", "Set your Normal Spins", function(input)
    local normalSpinsValue = sanitizeInput(input)
    
    if normalSpinsValue then
        game:GetService("Players").LocalPlayer.PlayerGui.HUD.MainFrame.SecondarySpinFrame.Stats.Spins.TextLabel.Text = tostring(normalSpinsValue)
    else
        print("Invalid Normal Spins input!")
    end
end)

-- Hotbar Tab
local HotbarTab = Window:NewTab("Hotbar")
local HotbarSection = HotbarTab:NewSection("Manage Hotbar")

-- Hotbar inputs for each hotbar slot
for i = 1, 7 do
    HotbarSection:NewTextBox("Hotbar Slot " .. i, "Set value for slot " .. i, function(input)
        game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Frame[tostring(i)].SkillName.Text = input
    end)
end

-- Additional slots R, T, Y
HotbarSection:NewTextBox("Hotbar Slot R", "Set value for slot R", function(input)
    game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Frame["R"].SkillName.Text = input
end)

HotbarSection:NewTextBox("Hotbar Slot T", "Set value for slot T", function(input)
    game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Frame["T"].SkillName.Text = input
end)

HotbarSection:NewTextBox("Hotbar Slot Y", "Set value for slot Y", function(input)
    game:GetService("Players").LocalPlayer.PlayerGui.Hotbar.Frame["Y"].SkillName.Text = input
end)

-- Players Tab
local PlayersTab = Window:NewTab("Players")
local PlayersSection = PlayersTab:NewSection("Player Info")

-- Function to copy Roblox ID to clipboard
local function copyToClipboard(text)
    setclipboard(text)
end

-- Add a button for each player in the game
local function addPlayerButton(player)
    PlayersSection:NewButton(player.Name, "Get Roblox ID for " .. player.Name, function()
        local username = player.Name
        local userId = player.UserId
        copyToClipboard(userId)
        print(username .. "'s Roblox ID is: " .. userId .. " (copied to clipboard)")
    end)
end

-- Dynamically add buttons for players
for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
    addPlayerButton(player)
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    addPlayerButton(player)  -- Add button when a new player joins
end)

-- Stats Tab (with HP and Reiatsu)
local StatsTab = Window:NewTab("Stats")
local StatsSection = StatsTab:NewSection("Manage Stats")

-- Function to sanitize the input (remove commas, handle dots)
local function sanitizeInput(input)
    -- Remove any commas
    input = input:gsub(",", "")
    -- Check if the input is a valid number (allowing decimal points)
    local number = tonumber(input)
    if number then
        return number
    else
        return nil -- Return nil if not a valid number
    end
end

-- HP Input (Instant Update)
StatsSection:NewTextBox("HP", "Set your HP", function(input)
    local hpValue = sanitizeInput(input)
    
    if hpValue then
        -- Update HP in UI instantly
        local player = game:GetService("Players").LocalPlayer
        local healthFraction = player.PlayerGui.HUD.BarsBackground.Health.Fractione
        healthFraction.Text = tostring(hpValue) .. "/" .. tostring(hpValue)
    else
        print("Invalid HP input!")
    end
end)

-- Reiatsu Input (Instant Update)
StatsSection:NewTextBox("Reiatsu", "Set your Reiatsu", function(input)
    local reiatsuValue = sanitizeInput(input)
    
    if reiatsuValue then
        -- Update Reiatsu in UI instantly
        local player = game:GetService("Players").LocalPlayer
        local reiatsuFraction = player.PlayerGui.HUD.BarsBackground.Reiatsu.Fractione
        reiatsuFraction.Text = tostring(reiatsuValue) .. "/" .. tostring(reiatsuValue)
    else
        print("Invalid Reiatsu input!")
    end
end)

-- Button to Change HP and Reiatsu Name
StatsSection:NewButton("Change HP and Reiatsu Name", "Change the displayed names for HP and Reiatsu", function()
    -- Change HP fraction name to Fractione
    game:GetService("Players").LocalPlayer.PlayerGui.HUD.BarsBackground.Health.Fraction.Name = "Fractione"
    
    -- Change Reiatsu fraction name to Fractione
    game:GetService("Players").LocalPlayer.PlayerGui.HUD.BarsBackground.Reiatsu.Fraction.Name = "Fractione"
end)
