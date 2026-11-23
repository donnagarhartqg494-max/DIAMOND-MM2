
--================================================
-- DIAMOND MM2 V1 [BETA]
-- Murder Mystery 2
--================================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local Gui = Instance.new("ScreenGui")
Gui.Name = "DiamondMM2_BETA"
Gui.ResetOnSpawn = false
Gui.Parent = (gethui and gethui()) or CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(340, 405)
Main.Position = UDim2.new(0.5, -170, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(15, 18, 29)
Main.BorderSizePixel = 0
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 13)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(65, 145, 255)
Stroke.Thickness = 1.5

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 65)
Header.BackgroundColor3 = Color3.fromRGB(25, 33, 51)
Header.Text = "💎 DIAMOND MM2\nV1 [BETA]"
Header.TextColor3 = Color3.fromRGB(100, 180, 255)
Header.TextSize = 19
Header.Font = Enum.Font.GothamBold
Header.Parent = Main

Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Content = Instance.new("Frame")
Content.Position = UDim2.fromOffset(12, 78)
Content.Size = UDim2.new(1, -24, 1, -90)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 9)
Layout.Parent = Content

local function Button(name, callback)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, 0, 0, 40)
    B.BackgroundColor3 = Color3.fromRGB(34, 45, 67)
    B.TextColor3 = Color3.new(1,1,1)
    B.TextSize = 13
    B.Font = Enum.Font.GothamBold
    B.Text = name
    B.Parent = Content

    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.MouseButton1Click:Connect(callback)
    return B
end

local function Label(text)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, 0, 0, 25)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(155, 180, 220)
    L.TextSize = 12
    L.Font = Enum.Font.Gotham
    L.Parent = Content
end

-- ROLE ESP
local RoleESP = false
local MurdererAlert = false
local SheriffAlert = false
local Objects = {}
local LastAlerts = {}

local RoleColors = {
    Murderer = Color3.fromRGB(255, 65, 65),
    Sheriff = Color3.fromRGB(65, 145, 255),
    Innocent = Color3.fromRGB(70, 220, 120)
}

local function GetRole(player)
    -- Only use role data exposed by the game.
    local char = player.Character
    if char then
        for _, obj in ipairs(char:GetChildren()) do
            local role = obj:GetAttribute("Role")
            if type(role) == "string" then
                local lower = role:lower()
                if lower:find("murderer", 1, true) then
                    return "Murderer"
                elseif lower:find("sheriff", 1, true) then
                    return "Sheriff"
                elseif lower:find("innocent", 1, true) then
                    return "Innocent"
                end
            end
        end
    end

    return nil
end

local function ClearESP()
    for _, objects in pairs(Objects) do
        for _, obj in ipairs(objects) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
    end
    table.clear(Objects)
end

local function AddESP(player)
    if player == LP then return end

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local role = GetRole(player)
    local color = role and RoleColors[role] or Color3.fromRGB(180, 190, 210)

    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.65
    highlight.Parent = Gui

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = root
    billboard.Size = UDim2.fromOffset(170, 42)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = Gui

    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.TextColor3 = color
    text.TextStrokeTransparency = 0
    text.Font = Enum.Font.GothamBold
    text.TextSize = 13
    text.Text = player.DisplayName .. " | " .. (role or "Unknown")
    text.Parent = billboard

    Objects[player] = {highlight, billboard}
end

local function RefreshESP()
    ClearESP()
    if not RoleESP then return end

    for _, player in ipairs(Players:GetPlayers()) do
        AddESP(player)
    end
end

local function Alert(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "💎 DIAMOND MM2",
            Text = text,
            Duration = 4
        })
    end)
end

local function CheckRoles()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local role = GetRole(player)

            if role and not LastAlerts[player] then
                LastAlerts[player] = role

                if role == "Murderer" and MurdererAlert then
                    Alert(player.DisplayName .. " is MURDERER!")
                elseif role == "Sheriff" and SheriffAlert then
                    Alert(player.DisplayName .. " is SHERIFF!")
                end
            elseif role then
                LastAlerts[player] = role
            end
        end
    end

    if RoleESP then
        RefreshESP()
    end
end

-- BUTTONS
Label("👁️ PLAYER INFORMATION")

Button("Role ESP: OFF", function()
    RoleESP = not RoleESP
    RefreshESP()
end)

Button("🔄 Refresh Role ESP", RefreshESP)

Label("🔔 ALERTS")

Button("Murderer Alert: OFF", function()
    MurdererAlert = not MurdererAlert
    Alert("Murderer Alert: " .. (MurdererAlert and "ON" or "OFF"))
end)

Button("Sheriff Alert: OFF", function()
    SheriffAlert = not SheriffAlert
    Alert("Sheriff Alert: " .. (SheriffAlert and "ON" or "OFF"))
end)

Label("⚙️ INFORMATION")
Button("Show available roles", function()
    for _, player in ipairs(Players:GetPlayers()) do
        local role = GetRole(player)
        print(player.Name, role or "Unknown")
    end
    Alert("Role information printed to console")
end)

Button("Close DIAMOND MM2", function()
    RoleESP = false
    ClearESP()
    Gui:Destroy()
end)

-- DRAG
local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

Players.PlayerRemoving:Connect(function(player)
    LastAlerts[player] = nil
end)

task.spawn(function()
    while Gui.Parent do
        CheckRoles()
        task.wait(1)
    end
end)

print("[DIAMOND MM2 V1 BETA] Loaded!")
