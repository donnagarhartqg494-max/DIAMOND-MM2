
--====================================================
-- DIAMOND MM2 V1 [BETA]
-- PREMIUM UI UPDATE
--====================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer

-- CLEANUP
pcall(function()
    local parent = gethui and gethui() or CoreGui
    local old = parent:FindFirstChild("DiamondMM2")
    if old then old:Destroy() end
end)

-- DEVICE
local Device = UIS.TouchEnabled and "Phone" or "PC"
local DeviceScale = Device == "Phone" and 0.78 or 1

-- THEMES
local Themes = {
    Blue = {
        Main = Color3.fromRGB(15, 22, 38),
        Panel = Color3.fromRGB(30, 48, 75),
        Accent = Color3.fromRGB(65, 155, 255),
        Text = Color3.fromRGB(240, 245, 255)
    },

    Purple = {
        Main = Color3.fromRGB(25, 16, 38),
        Panel = Color3.fromRGB(52, 34, 75),
        Accent = Color3.fromRGB(170, 100, 255),
        Text = Color3.fromRGB(250, 240, 255)
    },

    Red = {
        Main = Color3.fromRGB(35, 17, 22),
        Panel = Color3.fromRGB(70, 32, 40),
        Accent = Color3.fromRGB(255, 75, 95),
        Text = Color3.fromRGB(255, 240, 240)
    },

    Green = {
        Main = Color3.fromRGB(14, 30, 24),
        Panel = Color3.fromRGB(30, 60, 45),
        Accent = Color3.fromRGB(65, 220, 145),
        Text = Color3.fromRGB(235, 255, 240)
    },

    Dark = {
        Main = Color3.fromRGB(15, 15, 18),
        Panel = Color3.fromRGB(38, 38, 43),
        Accent = Color3.fromRGB(190, 190, 200),
        Text = Color3.fromRGB(245, 245, 245)
    }
}

local ThemeName = "Blue"
local Theme = Themes[ThemeName]

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "DiamondMM2"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

local Parent = CoreGui
pcall(function()
    if gethui then Parent = gethui() end
end)

Gui.Parent = Parent

-- HELPERS
local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
    return c
end

local function Tween(obj, props, time)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.25, Enum.EasingStyle.Quint),
        props
    ):Play()
end

local function Text(parent, value, size, color)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = value
    t.TextSize = size or 13
    t.TextColor3 = color or Theme.Text
    t.Font = Enum.Font.GothamMedium
    t.Parent = parent
    return t
end

-- MAIN
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(
    390 * DeviceScale,
    450 * DeviceScale
)
Main.Position = UDim2.new(0.5, -195 * DeviceScale, 0.5, -225 * DeviceScale)
Main.BackgroundColor3 = Theme.Main
Main.BackgroundTransparency = 0.12
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui

Corner(Main, 16)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2
MainStroke.Parent = Main

-- ANIMATED BACKGROUND
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Main),
    ColorSequenceKeypoint.new(0.5, Theme.Panel),
    ColorSequenceKeypoint.new(1, Theme.Main)
})
Gradient.Rotation = 0
Gradient.Parent = Main

task.spawn(function()
    while Gui.Parent do
        Tween(Gradient, {Rotation = 360}, 8)
        task.wait(8)
    end
end)

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 62 * DeviceScale)
Header.BackgroundColor3 = Theme.Panel
Header.BackgroundTransparency = 0.25
Header.BorderSizePixel = 0
Header.Parent = Main

local Title = Text(Header, "💎 DIAMOND MM2", 18 * DeviceScale)
Title.Position = UDim2.fromOffset(15, 7)
Title.Size = UDim2.new(1, -75, 0, 28)

local Version = Text(Header, "V1 [BETA] • PREMIUM UI", 9 * DeviceScale, Theme.Accent)
Version.Position = UDim2.fromOffset(17, 34)
Version.Size = UDim2.new(1, -80, 0, 17)

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(35, 35)
Close.Position = UDim2.new(1, -44, 0, 13)
Close.BackgroundColor3 = Theme.Main
Close.Text = "×"
Close.TextColor3 = Theme.Text
Close.TextSize = 24
Close.Parent = Header
Corner(Close, 9)

-- CONTENT
local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.fromOffset(12, 72 * DeviceScale)
Content.Size = UDim2.new(1, -24, 1, -84 * DeviceScale)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.ScrollBarImageColor3 = Theme.Accent
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.CanvasSize = UDim2.new()
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 9 * DeviceScale)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Content

-- SECTION
local function Section(name)
    local L = Text(Content, name, 13 * DeviceScale, Theme.Accent)
    L.Size = UDim2.new(1, -5, 0, 27 * DeviceScale)
    L.TextXAlignment = Enum.TextXAlignment.Left
end

-- TOAST LIKE IPHONE
local function Toast(message)
    local toast = Instance.new("Frame")
    toast.Size = UDim2.fromOffset(260, 62)
    toast.Position = UDim2.new(0.5, -130, 0, -80)
    toast.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    toast.BackgroundTransparency = 0.08
    toast.Parent = Gui
    toast.ZIndex = 20
    Corner(toast, 16)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Accent
    stroke.Transparency = 0.5
    stroke.Parent = toast

    local icon = Text(toast, "💎", 22)
    icon.Position = UDim2.fromOffset(12, 8)
    icon.Size = UDim2.fromOffset(35, 42)
    icon.ZIndex = 21

    local title = Text(toast, "DIAMOND MM2", 12)
    title.Position = UDim2.fromOffset(50, 8)
    title.Size = UDim2.fromOffset(195, 17)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 21

    local body = Text(toast, message, 11, Color3.fromRGB(210, 215, 225))
    body.Position = UDim2.fromOffset(50, 27)
    body.Size = UDim2.fromOffset(195, 23)
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.ZIndex = 21

    Tween(toast, {Position = UDim2.new(0.5, -130, 0, 25)}, 0.4)

    task.delay(2.7, function()
        if toast.Parent then
            Tween(toast, {
                Position = UDim2.new(0.5, -130, 0, -85)
            }, 0.35)
            task.wait(0.4)
            toast:Destroy()
        end
    end)
end

-- IPHONE STYLE TOGGLE
local function Toggle(name, default, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -5, 0, 48 * DeviceScale)
    Row.BackgroundColor3 = Theme.Panel
    Row.BackgroundTransparency = 0.25
    Row.Parent = Content
    Corner(Row, 11)

    local Label = Text(Row, name, 12 * DeviceScale)
    Label.Position = UDim2.fromOffset(12, 0)
    Label.Size = UDim2.new(1, -75, 1, 0)
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.fromOffset(48 * DeviceScale, 27 * DeviceScale)
    Switch.Position = UDim2.new(1, -59 * DeviceScale, 0.5, -13.5 * DeviceScale)
    Switch.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(75, 78, 87)
    Switch.Text = ""
    Switch.AutoButtonColor = false
    Switch.Parent = Row
    Corner(Switch, 30)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.fromOffset(21 * DeviceScale, 21 * DeviceScale)
    Circle.Position = default
        and UDim2.new(1, -24 * DeviceScale, 0.5, -10.5 * DeviceScale)
        or UDim2.fromOffset(3 * DeviceScale, 3 * DeviceScale)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Circle.Parent = Switch
    Corner(Circle, 30)

    local state = default

    local function Set(value)
        state = value
        Tween(Switch, {
            BackgroundColor3 = value and Theme.Accent
                or Color3.fromRGB(75, 78, 87)
        }, 0.2)

        Tween(Circle, {
            Position = value
                and UDim2.new(1, -24 * DeviceScale, 0.5, -10.5 * DeviceScale)
                or UDim2.fromOffset(3 * DeviceScale, 3 * DeviceScale)
        }, 0.2)

        if callback then callback(value) end
    end

    Switch.Activated:Connect(function()
        Set(not state)
    end)

    return {
        Set = Set,
        Get = function() return state end,
        Button = Switch
    }
end

-- ROLE DETECTION
local function FindRole(player)
    local function check(container)
        if not container then return nil end

        for _, item in ipairs(container:GetDescendants()) do
            if item:IsA("Tool") then
                local name = item.Name:lower()

                if name:find("knife", 1, true) then
                    return "Murderer"
                elseif name:find("gun", 1, true) then
                    return "Sheriff"
                end
            end

            local role = item:GetAttribute("Role")
            if type(role) == "string" then
                local r = role:lower()
                if r:find("murder", 1, true) then
                    return "Murderer"
                elseif r:find("sheriff", 1, true) then
                    return "Sheriff"
                elseif r:find("innocent", 1, true) then
                    return "Innocent"
                end
            end

            if item:IsA("StringValue") and item.Name:lower() == "role" then
                local r = item.Value:lower()
                if r:find("murder", 1, true) then
                    return "Murderer"
                elseif r:find("sheriff", 1, true) then
                    return "Sheriff"
                elseif r:find("innocent", 1, true) then
                    return "Innocent"
                end
            end
        end
    end

    local char = player.Character
    local role = check(char)
    if role then return role end

    -- Backpack is only reliably visible for the local player.
    if player == LP then
        role = check(player:FindFirstChildOfClass("Backpack"))
        if role then return role end
    end

    return "Unknown"
end

local RoleESP = false
local MurderAlert = false
local SheriffAlert = false
local ESPObjects = {}
local PreviousRoles = {}

local RoleColors = {
    Murderer = Color3.fromRGB(255, 65, 75),
    Sheriff = Color3.fromRGB(65, 150, 255),
    Innocent = Color3.fromRGB(70, 220, 130),
    Unknown = Color3.fromRGB(190, 190, 200)
}

local function RemovePlayerESP(player)
    local objects = ESPObjects[player]
    if objects then
        for _, obj in ipairs(objects) do
            if obj.Parent then obj:Destroy() end
        end
        ESPObjects[player] = nil
    end
end

local function AddPlayerESP(player)
    if player == LP then return end

    RemovePlayerESP(player)

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local role = FindRole(player)
    local color = RoleColors[role] or RoleColors.Unknown

    local highlight = Instance.new("Highlight")
    highlight.Adornee = char
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.65
    highlight.OutlineTransparency = 0
    highlight.Parent = Gui

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = root
    billboard.Size = UDim2.fromOffset(170, 35)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = Gui

    local label = Text(billboard, "", 12, color)
    label.Size = UDim2.fromScale(1, 1)
    label.TextStrokeTransparency = 0
    label.Text = player.DisplayName .. " | " .. role

    ESPObjects[player] = {highlight, billboard}
end

local function RefreshESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            AddPlayerESP(player)
        end
    end

    for player in pairs(ESPObjects) do
        if not player.Parent then
            RemovePlayerESP(player)
        end
    end
end

-- ROLE ALERTS
local function CheckRoles()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local role = FindRole(player)

            if role ~= "Unknown" and PreviousRoles[player] ~= role then
                PreviousRoles[player] = role

                if role == "Murderer" and MurderAlert then
                    Toast("🔪 Murderer: " .. player.DisplayName)
                elseif role == "Sheriff" and SheriffAlert then
                    Toast("🔫 Sheriff: " .. player.DisplayName)
                end

                if RoleESP then
                    AddPlayerESP(player)
                end
            end
        end
    end
end

-- GAME FEATURES
Section("👁 PLAYER INFORMATION")

Toggle("Role ESP", false, function(value)
    RoleESP = value
    if value then
        RefreshESP()
    else
        for player in pairs(ESPObjects) do
            RemovePlayerESP(player)
        end
    end
end)

Toggle("Murderer Alert", false, function(value)
    MurderAlert = value
end)

Toggle("Sheriff Alert", false, function(value)
    SheriffAlert = value
end)

Toggle("Auto Refresh ESP", true, function(value)
    _G.DiamondAutoRefresh = value
end)

Section("⚙️ PLAYER SETTINGS")

Toggle("Speed Boost", false, function(value)
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = value and 24 or 16
    end
end)

Toggle("Jump Boost", false, function(value)
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.UseJumpPower then
            hum.JumpPower = value and 70 or 50
        else
            hum.JumpHeight = value and 14 or 7.2
        end
    end
end)

Section("🎨 CUSTOMIZATION")

local function ThemeButton(name)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -5, 0, 35 * DeviceScale)
    B.BackgroundColor3 = Themes[name].Accent
    B.Text = name
    B.TextColor3 = Color3.new(1, 1, 1)
    B.TextSize = 12
    B.Font = Enum.Font.GothamBold
    B.Parent = Content
    Corner(B, 9)

    B.Activated:Connect(function()
        ThemeName = name
        Theme = Themes[name]

        Main.BackgroundColor3 = Theme.Main
        MainStroke.Color = Theme.Accent
        Header.BackgroundColor3 = Theme.Panel
        Title.TextColor3 = Theme.Text
        Version.TextColor3 = Theme.Accent
        Content.ScrollBarImageColor3 = Theme.Accent

        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Main),
            ColorSequenceKeypoint.new(0.5, Theme.Panel),
            ColorSequenceKeypoint.new(1, Theme.Main)
        })

        Toast("Theme changed: " .. name)
    end)
end

ThemeButton("Blue")
ThemeButton("Purple")
ThemeButton("Red")
ThemeButton("Green")
ThemeButton("Dark")

-- DEVICE SETTINGS
Section("📱 DEVICE")

local function DeviceButton(name)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -5, 0, 36 * DeviceScale)
    B.BackgroundColor3 = Theme.Panel
    B.TextColor3 = Theme.Text
    B.Text = name
    B.TextSize = 12
    B.Parent = Content
    Corner(B, 9)

    B.Activated:Connect(function()
        Device = name

        local scale = name == "Phone" and 0.78 or 1
        Tween(Main, {
            Size = UDim2.fromOffset(390 * scale, 450 * scale)
        }, 0.3)

        DeviceScale = scale
        Toast("Device: " .. name .. " (reopen to resize all controls)")
    end)
end

DeviceButton("Phone")
DeviceButton("PC")
DeviceButton("Auto")

-- MENU DRAG: MOUSE + TOUCH
local dragInput
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragInput and (
        input == dragInput or
        input.UserInputType == Enum.UserInputType.MouseMovement or
        input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == dragInput then
        dragInput = nil
    end
end)

-- FLOATING RESIZE BUTTON
local Resize = Instance.new("TextButton")
Resize.Size = UDim2.fromOffset(52, 52)
Resize.Position = UDim2.new(1, -75, 1, -110)
Resize.BackgroundColor3 = Theme.Accent
Resize.Text = "↕"
Resize.TextSize = 25
Resize.TextColor3 = Color3.new(1, 1, 1)
Resize.Font = Enum.Font.GothamBold
Resize.Parent = Gui
Resize.ZIndex = 10
Corner(Resize, 30)

local ResizeStroke = Instance.new("UIStroke")
ResizeStroke.Color = Color3.new(1, 1, 1)
ResizeStroke.Transparency = 0.6
ResizeStroke.Parent = Resize

local resizeDragging = false
local resizeStart
local originalSize

Resize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        resizeDragging = true
        resizeStart = input.Position
        originalSize = Main.Size
    end
end)

UIS.InputChanged:Connect(function(input)
    if resizeDragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then

        local delta = input.Position - resizeStart

        Resize.Position = UDim2.new(
            1, -75 + delta.X,
            1, -110 + delta.Y
        )

        local change = -delta.Y

        local width = math.clamp(
            originalSize.X.Offset + change,
            280, 650
        )

        local height = math.clamp(
            originalSize.Y.Offset + change,
            320, 750
        )

        Main.Size = UDim2.fromOffset(width, height)
    end
end)

UIS.InputEnded:Connect(function(input)
    if resizeDragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1
    ) then
        resizeDragging = false
    end
end)

-- CLOSE
Close.Activated:Connect(function()
    Gui:Destroy()
end)

-- PLAYER EVENTS
Players.PlayerRemoving:Connect(function(player)
    RemovePlayerESP(player)
    PreviousRoles[player] = nil
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if RoleESP then
            AddPlayerESP(player)
        end
    end)
end)

-- LOOP
task.spawn(function()
    while Gui.Parent do
        CheckRoles()

        if _G.DiamondAutoRefresh and RoleESP then
            RefreshESP()
        end

        task.wait(1)
    end
end)

-- DEVICE SELECTOR
local Selector = Instance.new("Frame")
Selector.Size = UDim2.fromOffset(270, 165)
Selector.Position = UDim2.new(0.5, -135, 0.5, -82)
Selector.BackgroundColor3 = Theme.Panel
Selector.Parent = Gui
Selector.ZIndex = 30
Corner(Selector, 14)

local SelectTitle = Text(Selector, "SELECT YOUR DEVICE", 15)
SelectTitle.Position = UDim2.fromOffset(10, 12)
SelectTitle.Size = UDim2.new(1, -20, 0, 28)
SelectTitle.ZIndex = 31

local function SelectDevice(name)
    Device = name
    local scale = name == "Phone" and 0.78 or 1

    Main.Size = UDim2.fromOffset(390 * scale, 450 * scale)
    Main.Position = UDim2.new(0.5, -195 * scale, 0.5, -225 * scale)

    Selector:Destroy()
    Toast("Welcome to DIAMOND MM2!")
end

local function SelectButton(name, y)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -24, 0, 34)
    B.Position = UDim2.fromOffset(12, y)
    B.BackgroundColor3 = Theme.Accent
    B.TextColor3 = Color3.new(1, 1, 1)
    B.Text = name
    B.TextSize = 12
    B.Font = Enum.Font.GothamBold
    B.Parent = Selector
    B.ZIndex = 31
    Corner(B, 8)

    B.Activated:Connect(function()
        SelectDevice(name)
    end)
end

SelectButton("📱 Phone", 48)
SelectButton("🖥 PC", 88)
SelectButton("⚡ Auto", 128)

print("[DIAMOND MM2 V1 BETA] Loaded!")
