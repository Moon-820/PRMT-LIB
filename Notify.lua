-- TryxLib | Notify.lua
-- Système de notifications toast

local TweenService = game:GetService("TweenService")

local NOTIFY_W   = 280
local NOTIFY_H   = 64
local NOTIFY_PAD = 10
local ANIM       = 0.2

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or ANIM, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 7)
    c.Parent = p
    return c
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col
    s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local queue    = {}
local active   = 0
local MAX_NOTIF = 4

local typeColors = {
    success = Color3.fromRGB(60, 180, 100),
    error   = Color3.fromRGB(200, 60, 60),
    warn    = Color3.fromRGB(220, 160, 40),
    info    = Color3.fromRGB(80, 140, 220),
}

local typeIcons = {
    success = "✓",
    error   = "✕",
    warn    = "!",
    info    = "i",
}

local function notify(gui, cfg, theme)
    cfg = cfg or {}
    local title    = cfg.Title    or ""
    local desc     = cfg.Desc     or cfg.Content or ""
    local ntype    = cfg.Type     or cfg.Icon    or "info"
    local duration = cfg.Duration or 4

    local accentCol = typeColors[ntype] or theme.Accent
    local iconChar  = typeIcons[ntype]  or "i"

    -- Container des notifs (créé une fois)
    local container = gui:FindFirstChild("NotifyContainer")
    if not container then
        container = Instance.new("Frame")
        container.Name               = "NotifyContainer"
        container.Size               = UDim2.new(0, NOTIFY_W, 1, 0)
        container.Position           = UDim2.new(1, -(NOTIFY_W + 12), 0, 0)
        container.BackgroundTransparency = 1
        container.BorderSizePixel    = 0
        container.ZIndex             = 100

        local layout = Instance.new("UIListLayout")
        layout.VerticalAlignment    = Enum.VerticalAlignment.Bottom
        layout.HorizontalAlignment  = Enum.HorizontalAlignment.Right
        layout.Padding              = UDim.new(0, 6)
        layout.SortOrder            = Enum.SortOrder.LayoutOrder
        layout.Parent               = container

        local pad = Instance.new("UIPadding")
        pad.PaddingBottom = UDim.new(0, 12)
        pad.Parent        = container

        container.Parent = gui
    end

    if active >= MAX_NOTIF then return end
    active += 1

    -- Notif frame
    local notif = Instance.new("Frame")
    notif.Name             = "Notif"
    notif.Size             = UDim2.new(1, 0, 0, NOTIFY_H)
    notif.BackgroundColor3 = theme.Notify or Color3.fromRGB(18, 18, 18)
    notif.BorderSizePixel  = 0
    notif.ClipsDescendants = true
    notif.ZIndex           = 101
    corner(notif, UDim.new(0, 8))
    stroke(notif, theme.NotifyStroke or Color3.fromRGB(40, 40, 40), 1)

    -- Accent bar gauche
    local bar = Instance.new("Frame")
    bar.Size             = UDim2.new(0, 3, 1, 0)
    bar.BackgroundColor3 = accentCol
    bar.BorderSizePixel  = 0
    corner(bar, UDim.new(0, 2))
    bar.Parent = notif

    -- Icon circle
    local iconCircle = Instance.new("Frame")
    iconCircle.Size             = UDim2.new(0, 28, 0, 28)
    iconCircle.Position         = UDim2.new(0, 14, 0.5, -14)
    iconCircle.BackgroundColor3 = accentCol
    iconCircle.BorderSizePixel  = 0
    corner(iconCircle, UDim.new(1, 0))
    iconCircle.Parent = notif

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size             = UDim2.fromScale(1, 1)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text             = iconChar
    iconLbl.TextColor3       = Color3.fromRGB(255, 255, 255)
    iconLbl.TextSize         = 13
    iconLbl.Font             = Enum.Font.GothamBold
    iconLbl.TextXAlignment   = Enum.TextXAlignment.Center
    iconLbl.ZIndex           = 102
    iconLbl.Parent           = iconCircle

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size            = UDim2.new(1, -54, 0, 18)
    titleLbl.Position        = UDim2.new(0, 50, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text            = title
    titleLbl.TextColor3      = Color3.fromRGB(240, 240, 240)
    titleLbl.TextSize        = 13
    titleLbl.Font            = Enum.Font.GothamBold
    titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
    titleLbl.TextTruncate    = Enum.TextTruncate.AtEnd
    titleLbl.ZIndex          = 102
    titleLbl.Parent          = notif

    -- Desc
    local descLbl = Instance.new("TextLabel")
    descLbl.Size             = UDim2.new(1, -54, 0, 18)
    descLbl.Position         = UDim2.new(0, 50, 0, 30)
    descLbl.BackgroundTransparency = 1
    descLbl.Text             = desc
    descLbl.TextColor3       = Color3.fromRGB(140, 140, 140)
    descLbl.TextSize         = 11
    descLbl.Font             = Enum.Font.Gotham
    descLbl.TextXAlignment   = Enum.TextXAlignment.Left
    descLbl.TextTruncate     = Enum.TextTruncate.AtEnd
    descLbl.ZIndex           = 102
    descLbl.Parent           = notif

    -- Progress bar
    local progress = Instance.new("Frame")
    progress.Size             = UDim2.new(1, 0, 0, 2)
    progress.Position         = UDim2.new(0, 0, 1, -2)
    progress.BackgroundColor3 = accentCol
    progress.BorderSizePixel  = 0
    progress.ZIndex           = 103
    progress.Parent           = notif

    -- Apparition
    notif.Size = UDim2.new(1, 0, 0, 0)
    notif.Parent = container
    tween(notif, { Size = UDim2.new(1, 0, 0, NOTIFY_H) }, ANIM)

    -- Progress
    tween(progress, { Size = UDim2.new(0, 0, 0, 2) }, duration)

    -- Disparition
    task.delay(duration, function()
        tween(notif, { Size = UDim2.new(1, 0, 0, 0) }, ANIM)
        task.wait(ANIM)
        notif:Destroy()
        active = math.max(0, active - 1)
    end)

    -- Click pour fermer
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size                 = UDim2.fromScale(1, 1)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text                 = ""
    closeBtn.ZIndex               = 104
    closeBtn.Parent               = notif
    closeBtn.MouseButton1Click:Connect(function()
        tween(notif, { Size = UDim2.new(1, 0, 0, 0) }, ANIM)
        task.wait(ANIM)
        notif:Destroy()
        active = math.max(0, active - 1)
    end)
end

return notify
