-- Initial GUI Setup
local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ESP_GUI"

    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.Size = UDim2.new(0, 200, 0, 150)
    Frame.Position = UDim2.new(0.5, -100, 0, 10)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BackgroundTransparency = 0.5
    Frame.Draggable = true
    Frame.Active = true

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = Frame
    ToggleButton.Size = UDim2.new(1, 0, 0.3, 0)
    ToggleButton.Position = UDim2.new(0, 0, 0, 0)
    ToggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
    ToggleButton.Text = "Please choose a color"
    ToggleButton.TextScaled = true

    local ColorButton = Instance.new("TextButton")
    ColorButton.Parent = Frame
    ColorButton.Size = UDim2.new(1, 0, 0.3, 0)
    ColorButton.Position = UDim2.new(0, 0, 0.4, 0)
    ColorButton.BackgroundColor3 = Color3.new(1, 1, 1)
    ColorButton.Text = "Select Color"
    ColorButton.TextScaled = true

    local ColorFrame = Instance.new("Frame")
    ColorFrame.Parent = ScreenGui
    ColorFrame.Size = UDim2.new(0, 200, 0, 150)
    ColorFrame.Position = UDim2.new(0.5, -100, 0, 160)
    ColorFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    ColorFrame.BackgroundTransparency = 0.5
    ColorFrame.Visible = false
    ColorFrame.Draggable = true
    ColorFrame.Active = true

    local RedButton = Instance.new("TextButton")
    RedButton.Parent = ColorFrame
    RedButton.Size = UDim2.new(1, 0, 0.3, 0)
    RedButton.Position = UDim2.new(0, 0, 0, 0)
    RedButton.BackgroundColor3 = Color3.new(1, 0, 0)
    RedButton.Text = "Red"
    RedButton.TextScaled = true

    local WhiteButton = Instance.new("TextButton")
    WhiteButton.Parent = ColorFrame
    WhiteButton.Size = UDim2.new(1, 0, 0.3, 0)
    WhiteButton.Position = UDim2.new(0, 0, 0.4, 0)
    WhiteButton.BackgroundColor3 = Color3.new(1, 1, 1)
    WhiteButton.Text = "White"
    WhiteButton.TextScaled = true

    local RainbowButton = Instance.new("TextButton")
    RainbowButton.Parent = ColorFrame
    RainbowButton.Size = UDim2.new(1, 0, 0.3, 0)
    RainbowButton.Position = UDim2.new(0, 0, 0.8, 0)
    RainbowButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Orange for visual distinction
    RainbowButton.Text = "Rainbow"
    RainbowButton.TextScaled = true

    return ScreenGui, ToggleButton, ColorButton, ColorFrame, RedButton, WhiteButton, RainbowButton
end

-- Initialize variables
local espEnabled = false
local espColor = nil -- No color selected initially

-- Function to create ESP for a player
local function createESP(player)
    local esp = Instance.new("BillboardGui")
    esp.Name = "ESP"
    esp.AlwaysOnTop = true
    esp.Size = UDim2.new(1, 0, 1, 0)
    esp.Adornee = player.Character:FindFirstChild("HumanoidRootPart")

    local frame = Instance.new("Frame", esp)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = espColor

    esp.Parent = player.Character:FindFirstChild("HumanoidRootPart")
end

-- Function to remove ESP from a player
local function removeESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("ESP") then
        player.Character:FindFirstChild("HumanoidRootPart").ESP:Destroy()
    end
end

-- Function to update ESP for all players
local function updateESP()
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= game.Players.LocalPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if espEnabled then
                removeESP(otherPlayer)
                createESP(otherPlayer)
            else
                removeESP(otherPlayer)
            end
        end
    end
end

-- Function to handle ESP toggle
local function toggleESP(ToggleButton)
    if espColor then
        espEnabled = not espEnabled
        ToggleButton.Text = espEnabled and "ESP On" or "ESP Off"
        ToggleButton.BackgroundColor3 = espEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        updateESP()
    else
        ToggleButton.Text = "Please choose a color"
    end
end

-- Setup GUI and connect events
local function setupGUI()
    local ScreenGui, ToggleButton, ColorButton, ColorFrame, RedButton, WhiteButton, RainbowButton = createGUI()
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    ToggleButton.MouseButton1Click:Connect(function()
        toggleESP(ToggleButton)
    end)

    ColorButton.MouseButton1Click:Connect(function()
        ColorFrame.Visible = not ColorFrame.Visible
    end)

    RedButton.MouseButton1Click:Connect(function()
        espColor = Color3.new(1, 0, 0)
        ColorButton.Text = "Red"
        ColorFrame.Visible = false
        if espEnabled then
            updateESP()
        end
    end)

    WhiteButton.MouseButton1Click:Connect(function()
        espColor = Color3.new(1, 1, 1)
        ColorButton.Text = "White"
        ColorFrame.Visible = false
        if espEnabled then
            updateESP()
        end
    end)

    RainbowButton.MouseButton1Click:Connect(function()
        espColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        ColorButton.Text = "Rainbow"
        ColorFrame.Visible = false
        if espEnabled then
            updateESP()
        end
    end)
end

-- Handle character respawn
local function onCharacterAdded(character)
    wait(0.5) -- Delay to ensure character is fully loaded
    setupGUI()
    updateESP()
end

-- Keep GUI and ESP across respawns
game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Initialize GUI and ESP
setupGUI()
updateESP()
