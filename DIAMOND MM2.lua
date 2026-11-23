
--========================================================
-- 💎 DIAMOND MM2 V1 [BETA]
-- FULL EDITION
--========================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

--========================================================
-- CONFIGURATION
--========================================================

local OWNER_ID = 7162643277
local DEV_ID = 4918761384

local SCRIPT_URL = "YOUR_RAW_GITHUB_URL"

local Running = true
local Language = "RU"
local Device = "Auto"
local ThemeName = "Blue"

local RoleESP = false
local MurderAlert = false
local SheriffAlert = false
local AutoDodge = false
local AutoRefresh = true
local AutoKillNPC = false
local NPCKillRadius = 12
local LastNPCAttack = 0
local AutoFarmCoins = false
local LastCoinMove = 0
local CoinTarget = nil

local SpeedEnabled = false
local JumpEnabled = false
local FlyEnabled = false
local FlySpeed = 55
local FlyVelocity = nil
local FlyGyro = nil

local PreviousRoles = {}
local RoleCache = {}
local RoleCacheTime = 0
local ESPObjects = {}
local PlayerTags = {}
local KnifeObjects = {}

local OriginalSpeed = 16
local OriginalJump = 50

--========================================================
-- TRANSLATIONS
--========================================================

local Texts = {
    RU = {
        Home = "Главная",
        Roles = "Роли",
        Visuals = "Визуалы",
        Themes = "Темы",
        Settings = "Настройки",
        Combat = "Бой (NPC)",
        Welcome = "ДОБРО ПОЖАЛОВАТЬ",
        Version = "Версия V1 [BETA]",
        RoleESP = "ESP ролей",
        MurderAlert = "Уведомление об убийце",
        SheriffAlert = "Уведомление о шерифе",
        AutoRefresh = "Автообновление ESP",
        AutoDodge = "Автоуклонение от ножей",
        Speed = "Ускорение",
        Jump = "Высокий прыжок",
        Fly = "Полёт",
        Refresh = "Обновить ESP",
        Detection = "Определение ролей",
        Unknown = "НЕИЗВЕСТНО",
        Murderer = "УБИЙЦА",
        Sheriff = "ШЕРИФ",
        Innocent = "НЕВИНОВЕН",
        Language = "ВЫБОР ЯЗЫКА",
        Device = "ВЫБОР УСТРОЙСТВА",
        Reload = "ПЕРЕЗАГРУЗИТЬ СКРИПТ",
        Destroy = "УДАЛИТЬ СКРИПТ",
        Enabled = "Включено",
        Disabled = "Выключено"
    },

    EN = {
        Home = "Home",
        Roles = "Roles",
        Visuals = "Visuals",
        Themes = "Themes",
        Settings = "Settings",
        Combat = "Combat (NPC)",
        Welcome = "WELCOME",
        Version = "Version V1 [BETA]",
        RoleESP = "Role ESP",
        MurderAlert = "Murderer Alert",
        SheriffAlert = "Sheriff Alert",
        AutoRefresh = "Auto Refresh ESP",
        AutoDodge = "Auto Dodge Knives",
        Speed = "Speed Boost",
        Jump = "High Jump",
        Fly = "Fly",
        Refresh = "Refresh ESP",
        Detection = "Role Detection",
        Unknown = "UNKNOWN",
        Murderer = "MURDERER",
        Sheriff = "SHERIFF",
        Innocent = "INNOCENT",
        Language = "LANGUAGE",
        Device = "DEVICE",
        Reload = "RELOAD SCRIPT",
        Destroy = "DESTROY SCRIPT",
        Enabled = "Enabled",
        Disabled = "Disabled"
    }
}

local function T(key)
    return Texts[Language][key] or key
end

--========================================================
-- THEMES
--========================================================

local Themes = {
    Blue = {
        Main = Color3.fromRGB(15, 20, 34),
        Panel = Color3.fromRGB(28, 39, 60),
        Accent = Color3.fromRGB(65, 155, 255),
        Text = Color3.fromRGB(245, 248, 255)
    },

    Purple = {
        Main = Color3.fromRGB(24, 16, 38),
        Panel = Color3.fromRGB(50, 32, 75),
        Accent = Color3.fromRGB(175, 100, 255),
        Text = Color3.fromRGB(250, 240, 255)
    },

    Red = {
        Main = Color3.fromRGB(35, 17, 22),
        Panel = Color3.fromRGB(70, 32, 40),
        Accent = Color3.fromRGB(255, 65, 80),
        Text = Color3.fromRGB(255, 240, 240)
    },

    Green = {
        Main = Color3.fromRGB(14, 30, 24),
        Panel = Color3.fromRGB(30, 60, 45),
        Accent = Color3.fromRGB(65, 220, 145),
        Text = Color3.fromRGB(235, 255, 240)
    },

    Dark = {
        Main = Color3.fromRGB(13, 13, 17),
        Panel = Color3.fromRGB(35, 35, 42),
        Accent = Color3.fromRGB(190, 190, 200),
        Text = Color3.fromRGB(245, 245, 245)
    }
}

local Theme = Themes[ThemeName]

--========================================================
-- GUI INITIALIZATION
--========================================================

local Parent = CoreGui

pcall(function()
    if gethui then
        Parent = gethui()
    end
end)

pcall(function()
    local old = Parent:FindFirstChild("DiamondMM2")
    if old then old:Destroy() end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "DiamondMM2"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999
Gui.Parent = Parent

local Scale = 1

if UIS.TouchEnabled then
    Scale = 0.78
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(560 * Scale, 440 * Scale)
Main.Position = UDim2.new(0.5, -280 * Scale, 0.5, -220 * Scale)
Main.BackgroundColor3 = Theme.Main
Main.BackgroundTransparency = 0.12
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui

local function Corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
    return c
end

local function Tween(object, properties, duration)
    local animation = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.25,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        properties
    )

    animation:Play()
    return animation
end

Corner(Main, 15)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Accent
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

--========================================================
-- ANIMATED BACKGROUND
--========================================================

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Main),
    ColorSequenceKeypoint.new(0.5, Theme.Panel),
    ColorSequenceKeypoint.new(1, Theme.Main)
})
Gradient.Parent = Main

task.spawn(function()
    while Running and Gui.Parent do
        Tween(Gradient, {
            Rotation = Gradient.Rotation + 360
        }, 8)

        task.wait(8)
    end
end)

--========================================================
-- NOTIFICATIONS
--========================================================

local function Toast(message)
    if not Gui.Parent then return end

    local toast = Instance.new("Frame")
    toast.Size = UDim2.fromOffset(280, 65)
    toast.Position = UDim2.new(0.5, -140, 0, -90)
    toast.BackgroundColor3 = Color3.fromRGB(27, 30, 39)
    toast.BackgroundTransparency = 0.08
    toast.ZIndex = 50
    toast.Parent = Gui
    Corner(toast, 14)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Accent
    stroke.Transparency = 0.35
    stroke.Parent = toast

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 22)
    title.Position = UDim2.fromOffset(12, 7)
    title.BackgroundTransparency = 1
    title.Text = "💎 DIAMOND MM2"
    title.TextColor3 = Theme.Accent
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 51
    title.Parent = toast

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -20, 0, 25)
    body.Position = UDim2.fromOffset(12, 31)
    body.BackgroundTransparency = 1
    body.Text = message
    body.TextColor3 = Color3.new(1, 1, 1)
    body.TextSize = 12
    body.Font = Enum.Font.Gotham
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.ZIndex = 51
    body.Parent = toast

    Tween(toast, {
        Position = UDim2.new(0.5, -140, 0, 25)
    }, 0.35)

    task.delay(3, function()
        if toast.Parent then
            Tween(toast, {
                Position = UDim2.new(0.5, -140, 0, -90)
            }, 0.3)

            task.wait(0.35)
            toast:Destroy()
        end
    end)
end

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 58 * Scale)
Header.BackgroundColor3 = Theme.Panel
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -78, 0, 27)
Title.Position = UDim2.fromOffset(14, 5)
Title.BackgroundTransparency = 1
Title.Text = "💎 DIAMOND MM2"
Title.TextColor3 = Theme.Accent
Title.TextSize = 18 * Scale
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.fromOffset(30, 30)
CloseButton.Position = UDim2.new(1, -38, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(205, 55, 65)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 22
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header
Corner(CloseButton, 8)

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "DiamondOpenButton"
OpenButton.Size = UDim2.fromOffset(48, 48)
OpenButton.Position = UDim2.new(0, 22, 0.5, -24)
OpenButton.BackgroundColor3 = Theme.Accent
OpenButton.Text = "💎"
OpenButton.TextColor3 = Color3.new(1, 1, 1)
OpenButton.TextSize = 22
OpenButton.Font = Enum.Font.GothamBlack
OpenButton.Visible = false
OpenButton.Parent = Gui
Corner(OpenButton, 30)

CloseButton.Activated:Connect(function()
    Main.Visible = false
    OpenButton.Visible = true
end)

OpenButton.Activated:Connect(function()
    Main.Visible = true
    OpenButton.Visible = false
end)

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(1, -20, 0, 18)
Version.Position = UDim2.fromOffset(15, 33)
Version.BackgroundTransparency = 1
Version.Text = "V1 [BETA] • PREMIUM EDITION"
Version.TextColor3 = Theme.Text
Version.TextTransparency = 0.3
Version.TextSize = 9 * Scale
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = Header

--========================================================
-- BROWSER TABS
--========================================================

local TabBar = Instance.new("ScrollingFrame")
TabBar.Position = UDim2.fromOffset(8, 64 * Scale)
TabBar.Size = UDim2.new(1, -16, 0, 43 * Scale)
TabBar.BackgroundTransparency = 1
TabBar.BorderSizePixel = 0
TabBar.ScrollBarThickness = 0
TabBar.ScrollingDirection = Enum.ScrollingDirection.X
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBar.CanvasSize = UDim2.new()
TabBar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 6)
TabLayout.Parent = TabBar

local PageNames = {
    "Home",
    "Roles",
    "Visuals",
    "Themes",
    "Combat",
    "Coins",
    "Settings"
}

local PageFrames = {}
local TabButtons = {}
local CurrentPage

local Pages = Instance.new("Frame")
Pages.Position = UDim2.fromOffset(10, 113 * Scale)
Pages.Size = UDim2.new(1, -20, 1, -123 * Scale)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

for _, name in ipairs(PageNames) do
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Theme.Accent
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new()
    page.Visible = false
    page.Parent = Pages

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8 * Scale)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    PageFrames[name] = page
end

--========================================================
-- AVATAR THUMBNAILS
--========================================================

local AvatarIds = {
    Home = OWNER_ID,
    Roles = DEV_ID,
    Visuals = LP.UserId,
    Themes = OWNER_ID,
    Combat = LP.UserId,
    Coins = LP.UserId,
    Settings = DEV_ID
}

local function GetAvatar(userId)
    local success, image = pcall(function()
        return Players:GetUserThumbnailAsync(
            userId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)

    return success and image or ""
end

local function SwitchTab(name)
    CurrentPage = name

    for pageName, page in pairs(PageFrames) do
        page.Visible = pageName == name
    end

    for tabName, button in pairs(TabButtons) do
        Tween(button, {
            BackgroundColor3 = tabName == name
                and Theme.Accent
                or Theme.Panel
        }, 0.2)
    end
end

for _, name in ipairs(PageNames) do
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Size = UDim2.fromOffset(105 * Scale, 38 * Scale)
    tab.BackgroundColor3 = Theme.Panel
    tab.Text = ""
    tab.Parent = TabBar
    Corner(tab, 8)

    TabButtons[name] = tab

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(25 * Scale, 25 * Scale)
    avatar.Position = UDim2.fromOffset(5 * Scale, 6 * Scale)
    avatar.BackgroundTransparency = 1
    avatar.Image = GetAvatar(AvatarIds[name])
    avatar.Parent = tab
    Corner(avatar, 20)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -35 * Scale, 1, 0)
    label.Position = UDim2.fromOffset(34 * Scale, 0)
    label.BackgroundTransparency = 1
    label.Text = T(name)
    label.TextColor3 = Theme.Text
    label.TextSize = 10 * Scale
    label.Font = Enum.Font.GothamBold
    label.Parent = tab

    tab.Activated:Connect(function()
        SwitchTab(name)
    end)
end

--========================================================
-- UI HELPERS
--========================================================

local function Label(page, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 28 * Scale)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Accent
    label.TextSize = 13 * Scale
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = page
    return label
end

local function Button(page, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -8, 0, 38 * Scale)
    button.BackgroundColor3 = Theme.Panel
    button.BackgroundTransparency = 0.15
    button.TextColor3 = Theme.Text
    button.Text = text
    button.TextSize = 11 * Scale
    button.Font = Enum.Font.GothamBold
    button.Parent = page
    Corner(button, 8)

    button.Activated:Connect(callback)
    return button
end

local function Toggle(page, text, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 43 * Scale)
    row.BackgroundColor3 = Theme.Panel
    row.BackgroundTransparency = 0.15
    row.Parent = page
    Corner(row, 9)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75 * Scale, 1, 0)
    label.Position = UDim2.fromOffset(10 * Scale, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 11 * Scale
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.fromOffset(46 * Scale, 25 * Scale)
    switch.Position = UDim2.new(1, -56 * Scale, 0.5, -12.5 * Scale)
    switch.BackgroundColor3 = default and Theme.Accent
        or Color3.fromRGB(75, 80, 90)
    switch.Text = ""
    switch.Parent = row
    Corner(switch, 30)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.fromOffset(19 * Scale, 19 * Scale)
    circle.Position = default
        and UDim2.new(1, -22 * Scale, 0, 3 * Scale)
        or UDim2.fromOffset(3 * Scale, 3 * Scale)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.Parent = switch
    Corner(circle, 20)

    local state = default

    local function Set(value)
        state = value

        Tween(switch, {
            BackgroundColor3 = value and Theme.Accent
                or Color3.fromRGB(75, 80, 90)
        }, 0.2)

        Tween(circle, {
            Position = value
                and UDim2.new(1, -22 * Scale, 0, 3 * Scale)
                or UDim2.fromOffset(3 * Scale, 3 * Scale)
        }, 0.2)

        if callback then callback(value) end
    end

    switch.Activated:Connect(function()
        Set(not state)
    end)

    return {
        Set = Set,
        Get = function()
            return state
        end
    }
end

--========================================================
-- OWNER AND SCRIPT DEV TAGS
--========================================================

local Staff = {
    [OWNER_ID] = {
        Text = "OWNER",
        Color = Color3.fromRGB(255, 55, 65)
    },

    [DEV_ID] = {
        Text = "SCRIPT DEV",
        Color = Color3.fromRGB(255, 195, 35)
    }
}

local function RemoveTag(player)
    if PlayerTags[player] then
        PlayerTags[player]:Destroy()
        PlayerTags[player] = nil
    end
end

local function AddTag(player)
    local info = Staff[player.UserId]
    if not info then return end

    RemoveTag(player)

    local char = player.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DiamondStaffTag"
    billboard.Adornee = head
    billboard.Size = UDim2.fromOffset(145, 30)
    billboard.StudsOffset = Vector3.new(0, 3.4, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = Gui

    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.Text = info.Text
    text.TextColor3 = info.Color
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.new(0, 0, 0)
    text.TextSize = 15
    text.Font = Enum.Font.GothamBlack
    text.Parent = billboard

    PlayerTags[player] = billboard
end

local function ConnectPlayer(player)
    if not Staff[player.UserId] then return end

    if player.Character then
        AddTag(player)
    end

    player.CharacterAdded:Connect(function()
        task.wait(1)
        if Running then AddTag(player) end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    ConnectPlayer(player)
end

Players.PlayerAdded:Connect(ConnectPlayer)

Players.PlayerRemoving:Connect(function(player)
    RemoveTag(player)
    PreviousRoles[player] = nil
end)

--========================================================
-- ROLE DETECTION
--========================================================

local RoleColors = {
    Murderer = Color3.fromRGB(255, 55, 65),
    Sheriff = Color3.fromRGB(65, 150, 255),
    Innocent = Color3.fromRGB(65, 220, 125),
    Unknown = Color3.fromRGB(180, 185, 195)
}

local function ParseRole(value)
    if type(value) ~= "string" then return nil end

    local role = value:lower()

    if role:find("murder", 1, true) then
        return "Murderer"
    elseif role:find("sheriff", 1, true) then
        return "Sheriff"
    elseif role:find("innocent", 1, true) then
        return "Innocent"
    end

    return nil
end

local function RefreshRoleCache(force)
    if not force and os.clock() - RoleCacheTime < 0.8 then
        return
    end

    RoleCacheTime = os.clock()
    local remote = ReplicatedStorage:FindFirstChild("GetPlayerData", true)
    if not remote or not remote:IsA("RemoteFunction") then
        return
    end

    local ok, data = pcall(function()
        return remote:InvokeServer()
    end)

    if not ok or type(data) ~= "table" then
        return
    end

    local nextCache = {}
    for playerName, info in pairs(data) do
        if type(playerName) == "string" and type(info) == "table" then
            local parsed = ParseRole(info.Role or info.role or info.PlayerRole)
            if parsed then
                nextCache[playerName] = parsed
            end
        elseif type(info) == "table" and info.Name then
            local parsed = ParseRole(info.Role or info.role or info.PlayerRole)
            if parsed then
                nextCache[info.Name] = parsed
            end
        end
    end

    if next(nextCache) then
        RoleCache = nextCache
    end
end

local function DetectRole(player)
    RefreshRoleCache(false)

    -- MM2 role data is available here before players equip their weapons.
    local cachedRole = RoleCache[player.Name]
    if cachedRole then
        return cachedRole
    end

    local char = player.Character
    if not char then return "Unknown" end

    local role = ParseRole(player:GetAttribute("Role"))
        or ParseRole(char:GetAttribute("Role"))

    if role then return role end

    for _, object in ipairs(char:GetDescendants()) do
        role = ParseRole(object:GetAttribute("Role"))
        if role then return role end

        if object:IsA("StringValue")
            and (object.Name:lower() == "role" or object.Name:lower() == "playerrole") then
            role = ParseRole(object.Value)
            if role then return role end
        end
    end

    -- Equipped weapon detection is only a fallback.
    for _, object in ipairs(char:GetChildren()) do
        if object:IsA("Tool") then
            local name = object.Name:lower()
            if name:find("knife", 1, true) then
                return "Murderer"
            elseif name:find("gun", 1, true) then
                return "Sheriff"
            end
        end
    end

    return "Unknown"
end

--========================================================
-- ROLE ESP
--========================================================

local function RemoveESP(player)
    local data = ESPObjects[player]

    if data then
        for _, object in ipairs(data) do
            if object and object.Parent then
                object:Destroy()
            end
        end

        ESPObjects[player] = nil
    end
end

local function UpdateESP(player)
    if player == LP then return end

    local char = player.Character
    local head = char and char:FindFirstChild("Head")

    if not char or not head then
        RemoveESP(player)
        return
    end

    local role = DetectRole(player)
    local color = RoleColors[role]

    local data = ESPObjects[player]

    if data and data[1].Adornee ~= char then
        RemoveESP(player)
        data = nil
    end

    if not data then
        local highlight = Instance.new("Highlight")
        highlight.Name = "DiamondRoleHighlight"
        highlight.Adornee = char
        highlight.FillTransparency = 0.75
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = Gui

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "DiamondRoleLabel"
        billboard.Adornee = head
        billboard.Size = UDim2.fromOffset(170, 35)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = Gui

        local label = Instance.new("TextLabel")
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 13
        label.TextStrokeTransparency = 0
        label.Parent = billboard

        data = {highlight, billboard, label}
        ESPObjects[player] = data
    end

    data[1].FillColor = color
    data[1].OutlineColor = color
    data[2].Adornee = head

    data[3].TextColor3 = color
    data[3].Text = player.DisplayName .. " | " .. T(role)
end

local function RefreshESP()
    if not RoleESP then
        for player in pairs(ESPObjects) do
            RemoveESP(player)
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        UpdateESP(player)
    end

    for player in pairs(ESPObjects) do
        if not player.Parent then
            RemoveESP(player)
        end
    end
end

--========================================================
-- ROLE ALERTS
--========================================================

local function CheckRoles()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local role = DetectRole(player)

            if role ~= "Unknown"
                and PreviousRoles[player] ~= role then

                PreviousRoles[player] = role

                if role == "Murderer" and MurderAlert then
                    Toast("🔪 " .. player.DisplayName .. " - " .. T(role))
                elseif role == "Sheriff" and SheriffAlert then
                    Toast("🔫 " .. player.DisplayName .. " - " .. T(role))
                end
            end
        end
    end
end

--========================================================
-- AUTO DODGE
-- Detect visible moving knife projectiles.
--========================================================

local function IsKnife(object)
    if not object:IsA("BasePart") then
        return false
    end

    local name = object.Name:lower()

    return name:find("knife", 1, true)
        or name:find("projectile", 1, true)
        or name:find("throw", 1, true)
end

local function RegisterKnife(object)
    if IsKnife(object) then
        KnifeObjects[object] = true
    end
end

for _, object in ipairs(Workspace:GetDescendants()) do
    RegisterKnife(object)
end

Workspace.DescendantAdded:Connect(RegisterKnife)

Workspace.DescendantRemoving:Connect(function(object)
    KnifeObjects[object] = nil
end)

local DODGE_DISTANCE = 10
local lastDodge = 0
local DODGE_COOLDOWN = 0.45

local function FindDanger(root)
    local bestDistance = DODGE_DISTANCE
    local bestVelocity
    local bestPoint

    for knife in pairs(KnifeObjects) do
        if knife.Parent then
            local velocity = knife.AssemblyLinearVelocity
            local speed = velocity.Magnitude

            if speed > 8 then
                local offset = root.Position - knife.Position
                local time = math.clamp(
                    offset:Dot(velocity) / velocity:Dot(velocity),
                    0,
                    0.8
                )

                local predicted = knife.Position + velocity * time
                local distance = (predicted - root.Position).Magnitude

                local approaching = offset:Dot(velocity) > 0

                if approaching and distance < bestDistance then
                    bestDistance = distance
                    bestVelocity = velocity
                    bestPoint = predicted
                end
            end
        end
    end

    return bestVelocity, bestDistance, bestPoint
end

local function Dodge()
    if not AutoDodge then return end
    if os.clock() - lastDodge < DODGE_COOLDOWN then return end

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not hum or not root or hum.Health <= 0 then return end

    local velocity, distance, point = FindDanger(root)

    if velocity and point and distance < DODGE_DISTANCE then
        local away = root.Position - point
        local horizontal = Vector3.new(away.X, 0, away.Z)

        if horizontal.Magnitude < 0.1 then
            horizontal = Vector3.new(-velocity.Z, 0, velocity.X)
        end

        if horizontal.Magnitude > 0 then
            lastDodge = os.clock()
            hum:Move(horizontal.Unit, false)
        end
    end
end

--========================================================
-- PLAYER MOVEMENT
--========================================================

local function GetCharacter()
    local char = LP.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    return char, hum
end

local function SetSpeed(value)
    SpeedEnabled = value

    local _, hum = GetCharacter()
    if not hum then return end

    if value then
        OriginalSpeed = hum.WalkSpeed
        hum.WalkSpeed = 24
    else
        hum.WalkSpeed = OriginalSpeed
    end
end

local function SetJump(value)
    JumpEnabled = value

    local _, hum = GetCharacter()
    if not hum then return end

    if hum.UseJumpPower then
        if value then
            OriginalJump = hum.JumpPower
            hum.JumpPower = 70
        else
            hum.JumpPower = OriginalJump
        end
    else
        if value then
            OriginalJump = hum.JumpHeight
            hum.JumpHeight = 14
        else
            hum.JumpHeight = OriginalJump
        end
    end
end

--========================================================
-- FLY
--========================================================

local function StopFly()
    FlyEnabled = false
    if FlyVelocity then FlyVelocity:Destroy(); FlyVelocity = nil end
    if FlyGyro then FlyGyro:Destroy(); FlyGyro = nil end
end

local function StartFly()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then
        Toast("Character not ready")
        return false
    end

    if FlyVelocity then FlyVelocity:Destroy() end
    if FlyGyro then FlyGyro:Destroy() end

    FlyVelocity = Instance.new("BodyVelocity")
    FlyVelocity.Name = "DiamondFlyVelocity"
    FlyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    FlyVelocity.P = 1e4
    FlyVelocity.Velocity = Vector3.zero
    FlyVelocity.Parent = root

    FlyGyro = Instance.new("BodyGyro")
    FlyGyro.Name = "DiamondFlyGyro"
    FlyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    FlyGyro.P = 1e4
    FlyGyro.CFrame = root.CFrame
    FlyGyro.Parent = root

    FlyEnabled = true
    return true
end

local function SetFly(value)
    if value then
        if StartFly() then
            Toast("Fly ON • WASD + Space/Ctrl")
        end
    else
        StopFly()
        Toast("Fly OFF")
    end
end

local function UpdateFly()
    if not FlyEnabled then return end

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then
        StopFly()
        return
    end

    if not FlyVelocity or FlyVelocity.Parent ~= root then
        if not StartFly() then return end
    end

    local camera = Workspace.CurrentCamera
    if not camera then return end

    local move = Vector3.zero
    local look = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector

    if UIS:IsKeyDown(Enum.KeyCode.W) then move += look end
    if UIS:IsKeyDown(Enum.KeyCode.S) then move -= look end
    if UIS:IsKeyDown(Enum.KeyCode.D) then move += right end
    if UIS:IsKeyDown(Enum.KeyCode.A) then move -= right end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.C) then
        move -= Vector3.yAxis
    end

    -- Touch/gamepad movement follows the Humanoid's move direction.
    if UIS.TouchEnabled and move.Magnitude < 0.05 then
        move = hum.MoveDirection
    end

    if move.Magnitude > 0 then
        FlyVelocity.Velocity = move.Unit * FlySpeed
    else
        FlyVelocity.Velocity = Vector3.zero
    end

    FlyGyro.CFrame = camera.CFrame
end

--========================================================
-- COMBAT PAGE: NPC-ONLY TRAINING (OWNER-CREATED PLACE ONLY)
--========================================================

local function IsOwnUserCreatedPlace()
    return game.CreatorType == Enum.CreatorType.User
        and game.CreatorId == LP.UserId
end

local function FindNearestNPC()
    local char = LP.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local bestModel, bestHumanoid, bestRoot
    local bestDistance = NPCKillRadius

    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("Model") and object ~= char then
            local humanoid = object:FindFirstChildOfClass("Humanoid")
            local root = object:FindFirstChild("HumanoidRootPart")
                or object:FindFirstChild("Torso")
                or object:FindFirstChild("UpperTorso")

            if humanoid and root and humanoid.Health > 0
                and not Players:GetPlayerFromCharacter(object) then
                local distance = (root.Position - myRoot.Position).Magnitude
                if distance < bestDistance then
                    bestModel = object
                    bestHumanoid = humanoid
                    bestRoot = root
                    bestDistance = distance
                end
            end
        end
    end

    return bestModel, bestHumanoid, bestRoot, bestDistance
end

local function UpdateAutoKillNPC()
    if not AutoKillNPC or not Running then return end

    -- Deliberately restricted to a user-owned experience.
    if not IsOwnUserCreatedPlace() then
        AutoKillNPC = false
        Toast("Auto Kill NPC доступен только в вашей собственной игре")
        return
    end

    if os.clock() - LastNPCAttack < 0.35 then return end

    local model, humanoid, root = FindNearestNPC()
    if not model or not humanoid or not root then return end

    -- Avoid activating a weapon when another player is nearby.
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local otherRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot and (otherRoot.Position - root.Position).Magnitude < 30 then
                return
            end
        end
    end

    local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
    if tool and (tool:FindFirstChild("Handle") or tool.RequiresHandle == false) then
        LastNPCAttack = os.clock()
        pcall(function()
            tool:Activate()
        end)
    end
end

local Combat = PageFrames.Combat
Label(Combat, "⚔️ NPC TRAINING")
Label(Combat, "Работает только в вашей собственной игре и только по NPC.")
Toggle(Combat, "Auto Kill NPC", false, function(value)
    if value and not IsOwnUserCreatedPlace() then
        AutoKillNPC = false
        Toast("Недоступно: запустите свою собственную игру")
        return
    end
    AutoKillNPC = value
    Toast(value and "Auto Kill NPC ON" or "Auto Kill NPC OFF")
end)
Button(Combat, "🔎 Найти ближайшего NPC", function()
    local model, humanoid, root, distance = FindNearestNPC()
    if model then
        Toast(model.Name .. " • " .. math.floor(distance) .. " studs")
    else
        Toast("NPC в радиусе не найден")
    end
end)
Button(Combat, "📏 Радиус: 12 studs", function()
    NPCKillRadius = NPCKillRadius == 12 and 20 or (NPCKillRadius == 20 and 30 or 12)
    Toast("Радиус NPC: " .. NPCKillRadius .. " studs")
end)

--========================================================
-- AUTO FARM COINS
-- Walks to visible coin parts; does not teleport or invoke remotes.
--========================================================

local function FindNearestCoin()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return nil end

    local nearest, nearestDistance = nil, 1800
    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("BasePart") and object:IsDescendantOf(Workspace) then
            local name = string.lower(object.Name)
            local looksLikeCoin = string.find(name, "coin", 1, true) ~= nil
            if looksLikeCoin and object.Transparency < 1 and object.CanTouch then
                local distance = (object.Position - root.Position).Magnitude
                if distance < nearestDistance then
                    nearest = object
                    nearestDistance = distance
                end
            end
        end
    end
    return nearest, nearestDistance
end

local function UpdateAutoFarmCoins()
    if not AutoFarmCoins or not Running then return end
    if os.clock() - LastCoinMove < 0.65 then return end
    LastCoinMove = os.clock()

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    if not CoinTarget or not CoinTarget.Parent
        or (CoinTarget.Position - root.Position).Magnitude < 5 then
        CoinTarget = FindNearestCoin()
    end

    if CoinTarget and CoinTarget.Parent then
        hum:MoveTo(CoinTarget.Position)
    else
        CoinTarget = nil
    end
end

local CoinsPage = PageFrames.Coins
Label(CoinsPage, "🪙 AUTO FARM COINS")
Label(CoinsPage, "Автоматически идёт к ближайшим видимым монетам.")
Toggle(CoinsPage, "Auto Farm Coins", false, function(value)
    AutoFarmCoins = value
    CoinTarget = nil
    if not value then
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and root then hum:MoveTo(root.Position) end
    end
    Toast(value and "Auto Farm Coins ON" or "Auto Farm Coins OFF")
end)
Button(CoinsPage, "🔎 Найти ближайшую монету", function()
    local coin, distance = FindNearestCoin()
    if coin then
        CoinTarget = coin
        Toast("Монета найдена • " .. math.floor(distance) .. " studs")
    else
        Toast("Монеты не найдены")
    end
end)

--========================================================
-- HOME PAGE
--========================================================

local Home = PageFrames.Home

Label(Home, "💎 " .. T("Welcome"))
Label(Home, "DIAMOND MM2")
Label(Home, T("Version"))

local function StaffCard(page, userId, role, color)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, 65 * Scale)
    card.BackgroundColor3 = Theme.Panel
    card.Parent = page
    Corner(card, 10)

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(48 * Scale, 48 * Scale)
    avatar.Position = UDim2.fromOffset(8, 8)
    avatar.BackgroundTransparency = 1
    avatar.Image = GetAvatar(userId)
    avatar.Parent = card
    Corner(avatar, 30)

    local name = Instance.new("TextLabel")
    name.Position = UDim2.fromOffset(65 * Scale, 8)
    name.Size = UDim2.new(1, -75, 0, 25)
    name.BackgroundTransparency = 1
    name.Text = role
    name.TextColor3 = color
    name.TextSize = 14 * Scale
    name.Font = Enum.Font.GothamBlack
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = card

    local id = Instance.new("TextLabel")
    id.Position = UDim2.fromOffset(65 * Scale, 32)
    id.Size = UDim2.new(1, -75, 0, 20)
    id.BackgroundTransparency = 1
    id.Text = "ID: " .. userId
    id.TextColor3 = Theme.Text
    id.TextSize = 10 * Scale
    id.Font = Enum.Font.Gotham
    id.TextXAlignment = Enum.TextXAlignment.Left
    id.Parent = card
end

Label(Home, "PROJECT TEAM")

StaffCard(
    Home,
    OWNER_ID,
    "OWNER",
    Color3.fromRGB(255, 55, 65)
)

StaffCard(
    Home,
    DEV_ID,
    "SCRIPT DEV",
    Color3.fromRGB(255, 195, 35)
)

--========================================================
-- ROLES PAGE
--========================================================

local Roles = PageFrames.Roles

Label(Roles, "💎 " .. T("Detection"))

Toggle(Roles, T("RoleESP"), false, function(value)
    RoleESP = value
    RefreshESP()
end)

Toggle(Roles, T("MurderAlert"), false, function(value)
    MurderAlert = value
end)

Toggle(Roles, T("SheriffAlert"), false, function(value)
    SheriffAlert = value
end)

Button(Roles, T("Refresh"), function()
    RefreshESP()
    Toast("ESP refreshed")
end)

Button(Roles, "PRINT DETECTED ROLES", function()
    for _, player in ipairs(Players:GetPlayers()) do
        print(player.Name, DetectRole(player))
    end
end)

--========================================================
-- VISUALS PAGE
--========================================================

local Visuals = PageFrames.Visuals

Label(Visuals, "VISUAL SETTINGS")

Toggle(Visuals, T("AutoRefresh"), true, function(value)
    AutoRefresh = value
end)

Toggle(Visuals, T("AutoDodge"), false, function(value)
    AutoDodge = value
    Toast(value and "Auto Dodge ON" or "Auto Dodge OFF")
end)

Toggle(Visuals, T("Speed"), false, SetSpeed)
Toggle(Visuals, T("Jump"), false, SetJump)
Toggle(Visuals, T("Fly"), false, SetFly)

--========================================================
-- THEMES PAGE
--========================================================

local ThemesPage = PageFrames.Themes

Label(ThemesPage, "SELECT THEME")

local function ApplyTheme(name)
    ThemeName = name
    Theme = Themes[name]

    Main.BackgroundColor3 = Theme.Main
    Header.BackgroundColor3 = Theme.Panel
    MainStroke.Color = Theme.Accent
    Title.TextColor3 = Theme.Accent

    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Main),
        ColorSequenceKeypoint.new(0.5, Theme.Panel),
        ColorSequenceKeypoint.new(1, Theme.Main)
    })

    for _, button in pairs(TabButtons) do
        button.BackgroundColor3 = Theme.Panel
    end

    if CurrentPage then
        TabButtons[CurrentPage].BackgroundColor3 = Theme.Accent
    end

    for _, page in pairs(PageFrames) do
        page.ScrollBarImageColor3 = Theme.Accent

        for _, object in ipairs(page:GetChildren()) do
            if object:IsA("TextButton") then
                object.BackgroundColor3 = Theme.Panel
            elseif object:IsA("Frame") then
                if object:FindFirstChildOfClass("TextButton") then
                    object.BackgroundColor3 = Theme.Panel
                end
            end
        end
    end

    Toast("Theme: " .. name)
end

for name in pairs(Themes) do
    Button(ThemesPage, name, function()
        ApplyTheme(name)
    end)
end

--========================================================
-- SETTINGS PAGE
--========================================================

local Settings = PageFrames.Settings

Label(Settings, T("Language"))

Button(Settings, "🇷🇺 Русский", function()
    Language = "RU"
    Toast("Язык: Русский")
    RefreshESP()
end)

Button(Settings, "🇬🇧 English", function()
    Language = "EN"
    Toast("Language: English")
    RefreshESP()
end)

Label(Settings, T("Device"))

Button(Settings, "📱 PHONE", function()
    Device = "Phone"
    Scale = 0.78

    Tween(Main, {
        Size = UDim2.fromOffset(560 * Scale, 440 * Scale)
    }, 0.3)

    Toast("Phone mode")
end)

Button(Settings, "🖥 PC", function()
    Device = "PC"
    Scale = 1

    Tween(Main, {
        Size = UDim2.fromOffset(560, 440)
    }, 0.3)

    Toast("PC mode")
end)

Button(Settings, "⚡ AUTO", function()
    Device = "Auto"
    Scale = UIS.TouchEnabled and 0.78 or 1

    Tween(Main, {
        Size = UDim2.fromOffset(560 * Scale, 440 * Scale)
    }, 0.3)

    Toast("Automatic device mode")
end)

Button(Settings, "🔄 " .. T("Reload"), function()
    if SCRIPT_URL == "YOUR_RAW_GITHUB_URL" then
        Toast("Set SCRIPT_URL first!")
        return
    end

    local success, err = pcall(function()
        local source = game:HttpGet(SCRIPT_URL)
        local func = assert(loadstring(source))
        func()
    end)

    if not success then
        warn("[DIAMOND RELOAD ERROR]", err)
        Toast("Reload failed. Check console.")
    end
end)

Button(Settings, "🗑 " .. T("Destroy"), function()
    Running = false

    RoleESP = false
    AutoDodge = false
    AutoKillNPC = false
    AutoFarmCoins = false
    CoinTarget = nil
    StopFly()
    OpenButton.Visible = false

    for player in pairs(ESPObjects) do
        RemoveESP(player)
    end

    for player in pairs(PlayerTags) do
        RemoveTag(player)
    end

    Gui:Destroy()
end)

--========================================================
-- DRAG MENU: PC + TOUCH
--========================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
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
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--========================================================
-- RESIZE HANDLE ON THE WINDOW
--========================================================

local Resize = Instance.new("TextButton")
Resize.Name = "ResizeHandle"
Resize.Size = UDim2.fromOffset(24, 24)
Resize.AnchorPoint = Vector2.new(1, 1)
Resize.Position = UDim2.new(1, -5, 1, -5)
Resize.BackgroundColor3 = Theme.Accent
Resize.Text = "↘"
Resize.TextSize = 17
Resize.TextColor3 = Color3.new(1, 1, 1)
Resize.Font = Enum.Font.GothamBold
Resize.Parent = Main
Resize.ZIndex = 30
Corner(Resize, 7)

local resizeDragging = false
local resizeStart
local originalSize

Resize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        resizeDragging = true
        resizeStart = input.Position
        originalSize = Main.AbsoluteSize
    end
end)

UIS.InputChanged:Connect(function(input)
    if resizeDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - resizeStart
        local width = math.clamp(originalSize.X + delta.X, 340, 760)
        local height = math.clamp(originalSize.Y + delta.Y, 300, 760)
        Main.Size = UDim2.fromOffset(width, height)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        resizeDragging = false
    end
end)

--========================================================
-- CHARACTER RESPAWN
--========================================================

LP.CharacterAdded:Connect(function()
    task.wait(1)

    if not Running then return end

    local _, hum = GetCharacter()

    if hum then
        if FlyEnabled then
            StartFly()
        end
        if SpeedEnabled then hum.WalkSpeed = 24 end

        if JumpEnabled then
            if hum.UseJumpPower then
                hum.JumpPower = 70
            else
                hum.JumpHeight = 14
            end
        end
    end
end)

--========================================================
-- ROUND ESP REFRESH
-- Refresh immediately when the round/map or player characters change.
-- The periodic refresh below remains as a fallback for role changes.
--========================================================

local refreshQueued = false
local function QueueRoundESPRefresh()
    if not AutoRefresh or not RoleESP or refreshQueued or not Running then return end
    refreshQueued = true
    task.delay(0.35, function()
        refreshQueued = false
        if Running and AutoRefresh and RoleESP then
            RefreshESP()
            CheckRoles()
        end
    end)
end

local lastMap = Workspace:FindFirstChild("Map")
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Map" then
        lastMap = child
        QueueRoundESPRefresh()
    end
end)

Workspace.ChildRemoved:Connect(function(child)
    if child == lastMap or child.Name == "Map" then
        lastMap = nil
        QueueRoundESPRefresh()
    end
end)

Players.PlayerAdded:Connect(QueueRoundESPRefresh)
Players.PlayerRemoving:Connect(QueueRoundESPRefresh)

local function WatchCharacter(player)
    player.CharacterAdded:Connect(function()
        QueueRoundESPRefresh()
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    WatchCharacter(player)
end
Players.PlayerAdded:Connect(WatchCharacter)

--========================================================
-- MAIN UPDATE LOOP
--========================================================

task.spawn(function()
    while Running and Gui.Parent do
        RefreshRoleCache(true)
        if RoleESP and AutoRefresh then
            RefreshESP()
        end

        CheckRoles()

        task.wait(1)
    end
end)

task.spawn(function()
    while Running and Gui.Parent do
        if AutoDodge then
            Dodge()
        end
        if AutoKillNPC then
            UpdateAutoKillNPC()
        end
        if AutoFarmCoins then
            UpdateAutoFarmCoins()
        end
        if FlyEnabled then
            UpdateFly()
        end

        RunService.Heartbeat:Wait()
    end
end)

--========================================================
-- START
--========================================================

SwitchTab("Home")

Toast("DIAMOND MM2 V1 [BETA] loaded!")

print("================================")
print("DIAMOND MM2 V1 [BETA]")
print("UI: LOADED")
print("OWNER ID:", OWNER_ID)
print("DEV ID:", DEV_ID)
print("================================")
