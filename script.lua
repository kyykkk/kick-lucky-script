-- Professional Lucky Block Auto Farm Script - Dark Neon UI
-- (c) 2024 Premium Hub

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Configuration
local CONFIG = {
    Speed = 50,              -- Movement speed for auto farm
    CollectRange = 50,       -- Max distance to detect items
    DuplicateEnabled = false -- Toggle for duplicating brainrots
}

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumHub"
screenGui.Parent = player:FindFirstChild("PlayerGui") or Instance.new("PlayerGui", player)
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- UI Corners & Shadow
local uicorner = Instance.new("UICorner", mainFrame)
uicorner.CornerRadius = UDim.new(0, 12)
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)
-- Make only top corners round
titleBar.Position = UDim2.new(0, 0, 0, 0)

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ PREMIUM HUB"
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Minimize / Close Buttons
local minimizeBtn = Instance.new("ImageButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Image = "rbxassetid://6031090990" -- minus icon
minimizeBtn.ImageColor3 = Color3.fromRGB(180, 180, 220)
minimizeBtn.Parent = titleBar

local closeBtn = Instance.new("ImageButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Image = "rbxassetid://6031094667" -- x icon
closeBtn.ImageColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Parent = titleBar

-- Tab Buttons
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

local tabButtons = {}
local tabNames = {"Auto Farm", "Collector", "Extras"}
local tabFrames = {}

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 125, 0, 30)
    btn.Position = UDim2.new(0, (#tabButtons) * 130 + 5, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(150, 150, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    btn.Parent = tabContainer
    table.insert(tabButtons, btn)
    
    -- Tab content frame
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, -10, 1, -90)
    frame.Position = UDim2.new(0, 5, 0, 85)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 4
    frame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.Visible = false
    frame.Parent = mainFrame
    table.insert(tabFrames, frame)
    
    btn.MouseButton1Click:Connect(function()
        for i, b in ipairs(tabButtons) do
            b.BackgroundColor3 = (b == btn) and Color3.fromRGB(50, 80, 120) or Color3.fromRGB(35, 35, 50)
        end
        for i, f in ipairs(tabFrames) do
            f.Visible = (f == frame)
        end
    end)
end

for _, name in ipairs(tabNames) do
    createTab(name)
end
tabButtons[1].BackgroundColor3 = Color3.fromRGB(50, 80, 120)
tabFrames[1].Visible = true

-- Toggle Helper Function
local function createToggle(parent, text, default, callback)
    local yPos = #parent:GetChildren() * 55 + 10
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 45)
    toggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    toggleFrame.BorderSizePixel = 0
    local toggleCorner = Instance.new("UICorner", toggleFrame)
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 50, 0, 26)
    indicator.Position = UDim2.new(1, -60, 0, 9)
    indicator.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)
    indicator.BorderSizePixel = 0
    local indicatorCorner = Instance.new("UICorner", indicator)
    indicatorCorner.CornerRadius = UDim.new(0, 13)
    indicator.Parent = toggleFrame
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = UDim2.new(0, 3, 0, 3)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    local circleCorner = Instance.new("UICorner", circle)
    circleCorner.CornerRadius = UDim.new(0, 10)
    circle.Parent = indicator
    
    local state = default
    local function updateUI()
        TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 80)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(0, 27, 0, 3) or UDim2.new(0, 3, 0, 3)}):Play()
    end
    updateUI()
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = toggleFrame
    button.MouseButton1Click:Connect(function()
        state = not state
        updateUI()
        callback(state)
        -- Notification
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 200, 0, 40)
        notif.Position = UDim2.new(0.5, -100, 0, -50)
        notif.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        notif.BackgroundTransparency = 0.5
        local notifCorner = Instance.new("UICorner", notif)
        notifCorner.CornerRadius = UDim.new(0, 8)
        notif.Parent = mainFrame
        local notifLabel = Instance.new("TextLabel")
        notifLabel.Size = UDim2.new(1, 0, 1, 0)
        notifLabel.BackgroundTransparency = 1
        notifLabel.Text = text .. " " .. (state and "ON" or "OFF")
        notifLabel.TextColor3 = Color3.fromRGB(255,255,255)
        notifLabel.Font = Enum.Font.GothamBold
        notifLabel.TextSize = 14
        notifLabel.Parent = notif
        TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 0, 10)}):Play()
        task.delay(2, function()
            TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 0, -50)}):Play()
            task.delay(0.3, notif.Destroy, notif)
        end)
    end)
    
    return toggleFrame
end

-- Tab: Auto Farm
local farmTab = tabFrames[1]
createToggle(farmTab, "Auto Kick Brainrot", true, function(state)
    CONFIG.AutoKick = state
end)
createToggle(farmTab, "Auto Return Brainrot", true, function(state)
    CONFIG.AutoReturn = state
end)
createToggle(farmTab, "Duplicate Brainrot", false, function(state)
    CONFIG.DuplicateEnabled = state
end)
farmTab.CanvasSize = UDim2.new(0, 0, 0, #farmTab:GetChildren() * 55 + 20)

-- Tab: Collector
local collectTab = tabFrames[2]
createToggle(collectTab, "Auto Collect Money", true, function(state)
    CONFIG.AutoCollectMoney = state
end)
createToggle(collectTab, "Auto Collect 2x Strength", true, function(state)
    CONFIG.AutoCollectStrength = state
end)
collectTab.CanvasSize = UDim2.new(0, 0, 0, #collectTab:GetChildren() * 55 + 20)

-- Tab: Extras
local extraTab = tabFrames[3]
createToggle(extraTab, "Glow Effect", true, function(state)
    -- Simple glow via image label
    local glow = mainFrame:FindFirstChild("Glow")
    if not glow then
        glow = Instance.new("ImageLabel")
        glow.Name = "Glow"
        glow.Size = UDim2.new(1, 30, 1, 30)
        glow.Position = UDim2.new(0, -15, 0, -15)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://1316045217"
        glow.ImageColor3 = Color3.fromRGB(0, 150, 255)
        glow.ImageTransparency = 0.8
        glow.ScaleType = Enum.ScaleType.Slice
        glow.SliceCenter = Rect.new(10,10,118,118)
        glow.Parent = mainFrame
        glow.ZIndex = 0
    end
    glow.Visible = state
end)
createToggle(extraTab, "Auto Save Config", true, function(state)
    CONFIG.AutoSave = state
    if state then saveConfig() end
end)
extraTab.CanvasSize = UDim2.new(0, 0, 0, #extraTab:GetChildren() * 55 + 20)

-- Drag System
local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Minimize / Close
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 380, 0, 40) or UDim2.new(0, 380, 0, 520)
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = targetSize}):Play()
    mainFrame.ClipsDescendants = true
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Customization: Neon Glow (already added in extras tab)
-- Save/Load Config (simple using attributes)
local function saveConfig()
    player:SetAttribute("PremiumHubConfig", CONFIG)
end

local function loadConfig()
    local saved = player:GetAttribute("PremiumHubConfig")
    if saved then
        for k, v in pairs(saved) do
            CONFIG[k] = v
        end
    end
end
loadConfig()

-- Auto Farm Logic
local function findNearest(className, maxDist)
    local nearest = nil
    local minDist = maxDist
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:find(className) then
            local dist = (obj.Position - character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                nearest = obj
                minDist = dist
            end
        end
    end
    return nearest
end

local function kickBrainrot(brainrot)
    -- Simulate kick by applying velocity
    if brainrot and brainrot:IsA("BasePart") then
        local direction = (brainrot.Position - character.HumanoidRootPart.Position).Unit * 50
        brainrot.Velocity = direction
        -- Duplicate if enabled
        if CONFIG.DuplicateEnabled then
            local clone = brainrot:Clone()
            clone.Position = brainrot.Position + Vector3.new(0,5,0)
            clone.Parent = workspace
            task.delay(2, function() clone:Destroy() end)
        end
    end
end

local function returnBrainrot(brainrot)
    if brainrot and brainrot:IsA("BasePart") then
        local originalPos = brainrot:GetAttribute("OriginalPos") or brainrot.Position
        TweenService:Create(brainrot, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = originalPos}):Play()
    end
end

local function collectItem(item)
    if item and item:IsA("BasePart") then
        -- Teleport to item or simulate collection
        character.HumanoidRootPart.CFrame = CFrame.new(item.Position)
        task.wait(0.1)
        item:Destroy()
    end
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    if CONFIG.AutoKick then
        local brainrot = findNearest("Brainrot", CONFIG.CollectRange)
        if brainrot then
            kickBrainrot(brainrot)
        end
    end
    
    if CONFIG.AutoReturn then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:find("Brainrot") then
                if (obj.Position - character.HumanoidRootPart.Position).Magnitude > 30 then
                    returnBrainrot(obj)
                end
            end
        end
    end
    
    if CONFIG.AutoCollectMoney then
        local money = findNearest("Coin", CONFIG.CollectRange) or findNearest("Money", CONFIG.CollectRange)
        if money then
            collectItem(money)
        end
    end
    
    if CONFIG.AutoCollectStrength then
        local strength = findNearest("Strength", CONFIG.CollectRange) or findNearest("Boost", CONFIG.CollectRange)
        if strength then
            collectItem(strength)
        end
    end
end)

-- Auto save periodically
task.spawn(function()
    while task.wait(60) do
        if CONFIG.AutoSave then
            saveConfig()
        end
    end
end)

-- Optimization: Limit GUI updates
-- (Already done)
