
--==================================================
-- DIAMOND MM2 V1 [BETA]
-- BROWSER UI + OWNER SYSTEM
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local OWNER_ID = 7162643277
local DEV_ID = 4918761384

-- PUT YOUR RAW GITHUB SCRIPT URL HERE
local SCRIPT_URL = "YOUR_RAW_GITHUB_URL"

local Parent = CoreGui
pcall(function()
    if gethui then Parent = gethui() end
end)

pcall(function()
    local old = Parent:FindFirstChild("DiamondMM2")
    if old then old:Destroy() end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "DiamondMM2"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = Parent

local Theme = {
    Main = Color3.fromRGB(15, 20, 34),
    Panel = Color3.fromRGB(28, 39, 60),
    Accent = Color3.fromRGB(65, 155, 255),
    Text = Color3.fromRGB(245, 248, 255)
}

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(560, 430)
Main.Position = UDim2.new(.5, -280, .5, -215)
Main.BackgroundColor3 = Theme.Main
Main.BackgroundTransparency = .12
Main.BorderSizePixel = 0
Main.Parent = Gui

local function Corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

Corner(Main, 14)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Theme.Accent
Stroke.Thickness = 1.5
Stroke.Parent = Main

-- ANIMATED BACKGROUND
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Main),
    ColorSequenceKeypoint.new(.5, Theme.Panel),
    ColorSequenceKeypoint.new(1, Theme.Main)
})
Gradient.Parent = Main

task.spawn(function()
    while Gui.Parent do
        TweenService:Create(
            Gradient,
            TweenInfo.new(7, Enum.EasingStyle.Linear),
            {Rotation = Gradient.Rotation + 360}
        ):Play()
        task.wait(7)
    end
end)

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundColor3 = Theme.Panel
Header.BackgroundTransparency = .2
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.fromOffset(14, 0)
Title.BackgroundTransparency = 1
Title.Text = "DIAMOND MM2  |  V1 [BETA]"
Title.TextColor3 = Theme.Text
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- BROWSER TAB BAR
local TabBar = Instance.new("ScrollingFrame")
TabBar.Position = UDim2.fromOffset(8, 62)
TabBar.Size = UDim2.new(1, -16, 0, 45)
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

-- PAGES
local Pages = Instance.new("Frame")
Pages.Position = UDim2.fromOffset(10, 115)
Pages.Size = UDim2.new(1, -20, 1, -125)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

local PageNames = {
    "Home",
    "Roles",
    "Visuals",
    "Themes",
    "Settings"
}

local PageFrames = {}
local CurrentPage

-- AVATAR ICONS
local AvatarIds = {
    Home = OWNER_ID,
    Roles = DEV_ID,
    Visuals = LP.UserId,
    Themes = OWNER_ID,
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

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new()
    page.Visible = false
    page.Parent = Pages

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 9)
    layout.Parent = page

    PageFrames[name] = page
    return page
end

for _, name in ipairs(PageNames) do
    CreatePage(name)
end

local function SwitchTab(name)
    CurrentPage = name

    for pageName, page in pairs(PageFrames) do
        page.Visible = pageName == name
    end

    for _, button in ipairs(TabBar:GetChildren()) do
        if button:IsA("TextButton") then
            local active = button.Name == name
            TweenService:Create(button, TweenInfo.new(.2), {
                BackgroundColor3 = active
                    and Theme.Accent
                    or Theme.Panel
            }):Play()
        end
    end
end

for _, name in ipairs(PageNames) do
    local tab = Instance.new("TextButton")
    tab.Name = name
    tab.Size = UDim2.fromOffset(105, 39)
    tab.BackgroundColor3 = Theme.Panel
    tab.Text = ""
    tab.Parent = TabBar
    Corner(tab, 8)

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(25, 25)
    avatar.Position = UDim2.fromOffset(6, 7)
    avatar.BackgroundTransparency = 1
    avatar.Image = GetAvatar(AvatarIds[name])
    avatar.Parent = tab
    Corner(avatar, 20)

    local label = Instance.new("TextLabel")
    label.Position = UDim2.fromOffset(35, 0)
    label.Size = UDim2.new(1, -38, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.Parent = tab

    tab.Activated:Connect(function()
        SwitchTab(name)
    end)
end

-- UI HELPERS
local function Label(page, text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -8, 0, 30)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Theme.Accent
    l.TextSize = 14
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = page
    return l
end

local function Button(page, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -8, 0, 38)
    b.BackgroundColor3 = Theme.Panel
    b.TextColor3 = Theme.Text
    b.Text = text
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Parent = page
    Corner(b, 8)
    b.Activated:Connect(callback)
    return b
end

-- IPHONE STYLE SWITCH
local function Toggle(page, text, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -8, 0, 43)
    row.BackgroundColor3 = Theme.Panel
    row.BackgroundTransparency = .15
    row.Parent = page
    Corner(row, 9)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Position = UDim2.fromOffset(10, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.fromOffset(46, 25)
    switch.Position = UDim2.new(1, -56, .5, -12)
    switch.BackgroundColor3 = Color3.fromRGB(75, 80, 90)
    switch.Text = ""
    switch.Parent = row
    Corner(switch, 30)

    local circle = Instance.new("Frame")
    circle.Size = UDim2.fromOffset(19, 19)
    circle.Position = UDim2.fromOffset(3, 3)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    circle.Parent = switch
    Corner(circle, 20)

    local state = false

    switch.Activated:Connect(function()
        state = not state

        TweenService:Create(switch, TweenInfo.new(.2), {
            BackgroundColor3 = state and Theme.Accent
                or Color3.fromRGB(75, 80, 90)
        }):Play()

        TweenService:Create(circle, TweenInfo.new(.2), {
            Position = state
                and UDim2.new(1, -22, 0, 3)
                or UDim2.fromOffset(3, 3)
        }):Play()

        callback(state)
    end)

    return switch
end

-- OWNER / DEV TAGS
local TAGS = {
    [OWNER_ID] = {
        Text = "OWNER",
        Color = Color3.fromRGB(255, 55, 65)
    },

    [DEV_ID] = {
        Text = "SCRIPT DEV",
        Color = Color3.fromRGB(255, 195, 35)
    }
}

local PlayerTags = {}

local function RemoveTag(player)
    if PlayerTags[player] then
        PlayerTags[player]:Destroy()
        PlayerTags[player] = nil
    end
end

local function AddTag(player)
    local info = TAGS[player.UserId]
    if not info then return end

    RemoveTag(player)

    local character = player.Character
    local head = character and character:FindFirstChild("Head")
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

local function RefreshTags()
    for _, player in ipairs(Players:GetPlayers()) do
        if TAGS[player.UserId] then
            AddTag(player)
        end
    end
end

local function ConnectPlayer(player)
    if TAGS[player.UserId] then
        if player.Character then
            AddTag(player)
        end

        player.CharacterAdded:Connect(function()
            task.wait(1)
            AddTag(player)
        end)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    ConnectPlayer(player)
end

Players.PlayerAdded:Connect(ConnectPlayer)

Players.PlayerRemoving:Connect(function(player)
    RemoveTag(player)
end)

-- HOME
local Home = PageFrames.Home

Label(Home, "WELCOME TO DIAMOND MM2")
Label(Home, "Version V1 [BETA]")
Label(Home, "Premium Roblox interface")

local function StaffCard(page, userId, role, color)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, 65)
    card.BackgroundColor3 = Theme.Panel
    card.Parent = page
    Corner(card, 10)

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(48, 48)
    avatar.Position = UDim2.fromOffset(8, 8)
    avatar.BackgroundTransparency = 1
    avatar.Image = GetAvatar(userId)
    avatar.Parent = card
    Corner(avatar, 30)

    local name = Instance.new("TextLabel")
    name.Position = UDim2.fromOffset(65, 8)
    name.Size = UDim2.new(1, -75, 0, 25)
    name.BackgroundTransparency = 1
    name.Text = role
    name.TextColor3 = color
    name.TextSize = 14
    name.Font = Enum.Font.GothamBlack
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = card

    local id = Instance.new("TextLabel")
    id.Position = UDim2.fromOffset(65, 32)
    id.Size = UDim2.new(1, -75, 0, 20)
    id.BackgroundTransparency = 1
    id.Text = "ID: " .. userId
    id.TextColor3 = Theme.Text
    id.TextSize = 10
    id.Font = Enum.Font.Gotham
    id.TextXAlignment = Enum.TextXAlignment.Left
    id.Parent = card
end

StaffCard(Home, OWNER_ID, "OWNER", Color3.fromRGB(255, 55, 65))
StaffCard(Home, DEV_ID, "SCRIPT DEV", Color3.fromRGB(255, 195, 35))

-- ROLES
local Roles = PageFrames.Roles

Label(Roles, "ROLE INFORMATION")
Label(Roles, "Roles are shown only when exposed by the game.")
local RoleStatus = Label(Roles, "Role detection: waiting")

Button(Roles, "REFRESH PLAYER TAGS", function()
    RefreshTags()
    RoleStatus.Text = "Staff tags refreshed"
end)

-- VISUALS
local Visuals = PageFrames.Visuals

Label(Visuals, "VISUAL SETTINGS")

local ESPEnabled = false

Toggle(Visuals, "Player ESP", function(value)
    ESPEnabled = value
    RoleStatus.Text = value and "ESP enabled" or "ESP disabled"
end)

Button(Visuals, "Refresh visuals", function()
    RefreshTags()
end)

-- THEMES
local ThemesPage = PageFrames.Themes

Label(ThemesPage, "SELECT INTERFACE THEME")

local Themes = {
    Blue = {
        Main = Color3.fromRGB(15, 20, 34),
        Panel = Color3.fromRGB(28, 39, 60),
        Accent = Color3.fromRGB(65, 155, 255)
    },

    Purple = {
        Main = Color3.fromRGB(24, 16, 38),
        Panel = Color3.fromRGB(50, 32, 75),
        Accent = Color3.fromRGB(175, 100, 255)
    },

    Red = {
        Main = Color3.fromRGB(35, 17, 22),
        Panel = Color3.fromRGB(70, 32, 40),
        Accent = Color3.fromRGB(255, 65, 80)
    },

    Green = {
        Main = Color3.fromRGB(14, 30, 24),
        Panel = Color3.fromRGB(30, 60, 45),
        Accent = Color3.fromRGB(65, 220, 145)
    }
}

local function ApplyTheme(name)
    Theme = Themes[name]
    Main.BackgroundColor3 = Theme.Main
    Header.BackgroundColor3 = Theme.Panel
    Stroke.Color = Theme.Accent
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Main),
        ColorSequenceKeypoint.new(.5, Theme.Panel),
        ColorSequenceKeypoint.new(1, Theme.Main)
    })

    for _, page in pairs(PageFrames) do
        for _, child in ipairs(page:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Theme.Panel
            end
        end
    end
end

for name in pairs(Themes) do
    Button(ThemesPage, name, function()
        ApplyTheme(name)
    end)
end

-- SETTINGS
local Settings = PageFrames.Settings

Label(Settings, "SCRIPT CONTROLS")

Button(Settings, "RELOAD SCRIPT", function()
    if not SCRIPT_URL:find("^https://") or SCRIPT_URL == "YOUR_RAW_GITHUB_URL" then
        warn("[DIAMOND] Set SCRIPT_URL first!")
        return
    end

    local success, err = pcall(function()
        local source = game:HttpGet(SCRIPT_URL)
        local fn = assert(loadstring(source))
        fn()
    end)

    if not success then
        warn("[DIAMOND RELOAD ERROR] " .. tostring(err))
    end
end)

Button(Settings, "DESTROY SCRIPT", function()
    Gui:Destroy()
end)

-- DRAG ON PC AND MOBILE
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

-- DEVICE SIZE
if UIS.TouchEnabled then
    Main.Size = UDim2.fromOffset(430, 380)
    Main.Position = UDim2.new(.5, -215, .5, -190)
end

SwitchTab("Home")

print("[DIAMOND MM2 V1 BETA] UI loaded")
