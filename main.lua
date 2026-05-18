local TryxLib = {}
TryxLib.__index = TryxLib

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

local Themes = {}

Themes.Default = {
    Name           = "Default",
    Background     = Color3.fromRGB(10, 10, 12),
    BackgroundAlt  = Color3.fromRGB(14, 14, 17),
    Sidebar        = Color3.fromRGB(13, 13, 16),
    TopBar         = Color3.fromRGB(11, 11, 14),
    Element        = Color3.fromRGB(19, 19, 23),
    ElementHover   = Color3.fromRGB(26, 26, 31),
    ElementActive  = Color3.fromRGB(30, 30, 36),
    ElementStroke  = Color3.fromRGB(38, 38, 46),
    ElementStroke2 = Color3.fromRGB(28, 28, 34),
    Accent         = Color3.fromRGB(218, 175, 55),
    AccentDark     = Color3.fromRGB(160, 128, 35),
    AccentLight    = Color3.fromRGB(240, 200, 90),
    TextPrimary    = Color3.fromRGB(238, 238, 238),
    TextSecondary  = Color3.fromRGB(148, 148, 158),
    TextDisabled   = Color3.fromRGB(68, 68, 78),
    TextAccent     = Color3.fromRGB(218, 175, 55),
    TabActive      = Color3.fromRGB(21, 21, 26),
    TabInactive    = Color3.fromRGB(13, 13, 16),
    TabHover       = Color3.fromRGB(18, 18, 22),
    TabStroke      = Color3.fromRGB(218, 175, 55),
    Notify         = Color3.fromRGB(17, 17, 21),
    NotifyStroke   = Color3.fromRGB(42, 42, 52),
    ScrollBar      = Color3.fromRGB(50, 50, 62),
    Danger         = Color3.fromRGB(210, 58, 58),
    DangerDark     = Color3.fromRGB(160, 40, 40),
    Success        = Color3.fromRGB(58, 188, 98),
    SuccessDark    = Color3.fromRGB(40, 140, 70),
    Warning        = Color3.fromRGB(218, 158, 38),
    WarningDark    = Color3.fromRGB(160, 115, 25),
    Info           = Color3.fromRGB(72, 148, 228),
    InfoDark       = Color3.fromRGB(48, 108, 178),
    InputBg        = Color3.fromRGB(12, 12, 15),
    CardBg         = Color3.fromRGB(16, 16, 20),
    CardStroke     = Color3.fromRGB(32, 32, 40),
    ProfileBg      = Color3.fromRGB(14, 14, 18),
    ShadowColor    = Color3.fromRGB(0, 0, 0),
}

Themes.Dark = {
    Name           = "Dark",
    Background     = Color3.fromRGB(8, 8, 8),
    BackgroundAlt  = Color3.fromRGB(12, 12, 12),
    Sidebar        = Color3.fromRGB(10, 10, 10),
    TopBar         = Color3.fromRGB(9, 9, 9),
    Element        = Color3.fromRGB(16, 16, 16),
    ElementHover   = Color3.fromRGB(22, 22, 22),
    ElementActive  = Color3.fromRGB(26, 26, 26),
    ElementStroke  = Color3.fromRGB(32, 32, 32),
    ElementStroke2 = Color3.fromRGB(24, 24, 24),
    Accent         = Color3.fromRGB(218, 175, 55),
    AccentDark     = Color3.fromRGB(160, 128, 35),
    AccentLight    = Color3.fromRGB(240, 200, 90),
    TextPrimary    = Color3.fromRGB(232, 232, 232),
    TextSecondary  = Color3.fromRGB(140, 140, 140),
    TextDisabled   = Color3.fromRGB(60, 60, 60),
    TextAccent     = Color3.fromRGB(218, 175, 55),
    TabActive      = Color3.fromRGB(18, 18, 18),
    TabInactive    = Color3.fromRGB(10, 10, 10),
    TabHover       = Color3.fromRGB(15, 15, 15),
    TabStroke      = Color3.fromRGB(218, 175, 55),
    Notify         = Color3.fromRGB(14, 14, 14),
    NotifyStroke   = Color3.fromRGB(36, 36, 36),
    ScrollBar      = Color3.fromRGB(44, 44, 44),
    Danger         = Color3.fromRGB(210, 58, 58),
    DangerDark     = Color3.fromRGB(160, 40, 40),
    Success        = Color3.fromRGB(58, 188, 98),
    SuccessDark    = Color3.fromRGB(40, 140, 70),
    Warning        = Color3.fromRGB(218, 158, 38),
    WarningDark    = Color3.fromRGB(160, 115, 25),
    Info           = Color3.fromRGB(72, 148, 228),
    InfoDark       = Color3.fromRGB(48, 108, 178),
    InputBg        = Color3.fromRGB(10, 10, 10),
    CardBg         = Color3.fromRGB(13, 13, 13),
    CardStroke     = Color3.fromRGB(28, 28, 28),
    ProfileBg      = Color3.fromRGB(11, 11, 11),
    ShadowColor    = Color3.fromRGB(0, 0, 0),
}

Themes.Midnight = {
    Name           = "Midnight",
    Background     = Color3.fromRGB(6, 6, 14),
    BackgroundAlt  = Color3.fromRGB(9, 9, 20),
    Sidebar        = Color3.fromRGB(8, 8, 18),
    TopBar         = Color3.fromRGB(7, 7, 16),
    Element        = Color3.fromRGB(14, 14, 28),
    ElementHover   = Color3.fromRGB(20, 20, 38),
    ElementActive  = Color3.fromRGB(24, 24, 46),
    ElementStroke  = Color3.fromRGB(36, 36, 68),
    ElementStroke2 = Color3.fromRGB(26, 26, 50),
    Accent         = Color3.fromRGB(138, 108, 255),
    AccentDark     = Color3.fromRGB(98, 72, 210),
    AccentLight    = Color3.fromRGB(168, 142, 255),
    TextPrimary    = Color3.fromRGB(235, 235, 248),
    TextSecondary  = Color3.fromRGB(148, 148, 188),
    TextDisabled   = Color3.fromRGB(58, 58, 98),
    TextAccent     = Color3.fromRGB(138, 108, 255),
    TabActive      = Color3.fromRGB(16, 16, 34),
    TabInactive    = Color3.fromRGB(8, 8, 18),
    TabHover       = Color3.fromRGB(13, 13, 28),
    TabStroke      = Color3.fromRGB(138, 108, 255),
    Notify         = Color3.fromRGB(12, 12, 24),
    NotifyStroke   = Color3.fromRGB(38, 38, 72),
    ScrollBar      = Color3.fromRGB(48, 48, 88),
    Danger         = Color3.fromRGB(210, 58, 88),
    DangerDark     = Color3.fromRGB(160, 40, 60),
    Success        = Color3.fromRGB(58, 188, 128),
    SuccessDark    = Color3.fromRGB(40, 140, 90),
    Warning        = Color3.fromRGB(218, 158, 58),
    WarningDark    = Color3.fromRGB(160, 115, 38),
    Info           = Color3.fromRGB(88, 148, 255),
    InfoDark       = Color3.fromRGB(58, 108, 210),
    InputBg        = Color3.fromRGB(8, 8, 18),
    CardBg         = Color3.fromRGB(11, 11, 22),
    CardStroke     = Color3.fromRGB(30, 30, 58),
    ProfileBg      = Color3.fromRGB(10, 10, 20),
    ShadowColor    = Color3.fromRGB(0, 0, 8),
}

Themes.Slate = {
    Name           = "Slate",
    Background     = Color3.fromRGB(15, 17, 21),
    BackgroundAlt  = Color3.fromRGB(20, 23, 28),
    Sidebar        = Color3.fromRGB(18, 20, 25),
    TopBar         = Color3.fromRGB(16, 18, 23),
    Element        = Color3.fromRGB(24, 27, 34),
    ElementHover   = Color3.fromRGB(32, 36, 44),
    ElementActive  = Color3.fromRGB(38, 43, 52),
    ElementStroke  = Color3.fromRGB(48, 54, 66),
    ElementStroke2 = Color3.fromRGB(36, 40, 50),
    Accent         = Color3.fromRGB(99, 179, 237),
    AccentDark     = Color3.fromRGB(66, 138, 198),
    AccentLight    = Color3.fromRGB(144, 205, 255),
    TextPrimary    = Color3.fromRGB(226, 232, 240),
    TextSecondary  = Color3.fromRGB(148, 163, 184),
    TextDisabled   = Color3.fromRGB(71, 85, 105),
    TextAccent     = Color3.fromRGB(99, 179, 237),
    TabActive      = Color3.fromRGB(26, 30, 38),
    TabInactive    = Color3.fromRGB(18, 20, 25),
    TabHover       = Color3.fromRGB(22, 25, 32),
    TabStroke      = Color3.fromRGB(99, 179, 237),
    Notify         = Color3.fromRGB(22, 25, 32),
    NotifyStroke   = Color3.fromRGB(52, 58, 72),
    ScrollBar      = Color3.fromRGB(52, 60, 75),
    Danger         = Color3.fromRGB(248, 113, 113),
    DangerDark     = Color3.fromRGB(198, 70, 70),
    Success        = Color3.fromRGB(74, 222, 128),
    SuccessDark    = Color3.fromRGB(50, 168, 90),
    Warning        = Color3.fromRGB(251, 191, 36),
    WarningDark    = Color3.fromRGB(194, 144, 20),
    Info           = Color3.fromRGB(99, 179, 237),
    InfoDark       = Color3.fromRGB(66, 138, 198),
    InputBg        = Color3.fromRGB(13, 15, 19),
    CardBg         = Color3.fromRGB(20, 23, 29),
    CardStroke     = Color3.fromRGB(40, 46, 58),
    ProfileBg      = Color3.fromRGB(17, 20, 26),
    ShadowColor    = Color3.fromRGB(0, 0, 0),
}

local SIDEBAR_W    = 168
local TOPBAR_H     = 44
local MIN_W        = 500
local MIN_H        = 340
local DEFAULT_W    = 640
local DEFAULT_H    = 440
local ELEMENT_H    = 46
local ELEMENT_PAD  = 5
local CORNER_WIN   = UDim.new(0, 10)
local CORNER_EL    = UDim.new(0, 7)
local CORNER_SM    = UDim.new(0, 5)
local ANIM_FAST    = 0.10
local ANIM_MED     = 0.16
local ANIM_SLOW    = 0.26
local SHADOW_IMG   = "rbxassetid://6014261993"
local OVERLAY_Z    = 9999

local activeOverlays = {}

local function closeAllOverlays()
    for _, fn in ipairs(activeOverlays) do
        pcall(fn)
    end
    activeOverlays = {}
end

local function registerOverlay(closeFn)
    table.insert(activeOverlays, closeFn)
end

local function unregisterOverlay(closeFn)
    for i, fn in ipairs(activeOverlays) do
        if fn == closeFn then
            table.remove(activeOverlays, i)
            return
        end
    end
end

local function tw(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or ANIM_MED, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER_EL
    c.Parent = p
    return c
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color           = col or Color3.fromRGB(40, 40, 40)
    s.Thickness       = th or 1
    s.LineJoinMode    = Enum.LineJoinMode.Round
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent          = p
    return s
end

local function pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 6)
    u.PaddingBottom = UDim.new(0, b or 6)
    u.PaddingLeft   = UDim.new(0, l or 10)
    u.PaddingRight  = UDim.new(0, r or 10)
    u.Parent = p
    return u
end

local function frame(parent, bg, size, pos, zi)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or Color3.fromRGB(20, 20, 20)
    f.Size             = size or UDim2.fromScale(1, 1)
    f.Position         = pos or UDim2.new(0, 0, 0, 0)
    f.BorderSizePixel  = 0
    if zi then f.ZIndex = zi end
    f.Parent = parent
    return f
end

local function lbl(parent, text, col, sz, font, xa)
    local l = Instance.new("TextLabel")
    l.Text                   = text or ""
    l.TextColor3             = col or Color3.fromRGB(240, 240, 240)
    l.TextSize               = sz or 13
    l.Font                   = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment         = xa or Enum.TextXAlignment.Left
    l.TextYAlignment         = Enum.TextYAlignment.Center
    l.TextTruncate           = Enum.TextTruncate.AtEnd
    l.ClipsDescendants       = false
    l.Parent                 = parent
    return l
end

local function btn(parent, size, pos, zi)
    local b = Instance.new("TextButton")
    b.Size                   = size or UDim2.fromScale(1, 1)
    b.Position               = pos or UDim2.new(0, 0, 0, 0)
    b.BackgroundTransparency = 1
    b.Text                   = ""
    b.BorderSizePixel        = 0
    b.AutoButtonColor        = false
    b.ZIndex                 = zi or 2
    b.Parent                 = parent
    return b
end

local function shadow(parent)
    local s = Instance.new("ImageLabel")
    s.Name               = "Shadow"
    s.Size               = UDim2.new(1, 40, 1, 40)
    s.Position           = UDim2.new(0, -20, 0, -20)
    s.BackgroundTransparency = 1
    s.Image              = SHADOW_IMG
    s.ImageColor3        = Color3.fromRGB(0, 0, 0)
    s.ImageTransparency  = 0.46
    s.ScaleType          = Enum.ScaleType.Slice
    s.SliceCenter        = Rect.new(49, 49, 450, 450)
    s.ZIndex             = 0
    s.Parent             = parent
    return s
end

local function ripple(parent, theme)
    local r = frame(parent, theme.Accent, UDim2.new(0, 0, 0, 0))
    r.AnchorPoint            = Vector2.new(0.5, 0.5)
    r.Position               = UDim2.new(0.5, 0, 0.5, 0)
    r.BackgroundTransparency = 0.82
    r.ZIndex                 = 8
    r.ClipsDescendants       = false
    corner(r, UDim.new(1, 0))
    local sz = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.4
    tw(r, { Size = UDim2.new(0, sz, 0, sz), BackgroundTransparency = 1 }, 0.48, Enum.EasingStyle.Quart)
    task.delay(0.52, function() if r.Parent then r:Destroy() end end)
end

local function makeDraggable(handle, target)
    local dragging, ds, sp = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            ds = i.Position
            sp = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - ds
            local vp = Camera.ViewportSize
            target.Position = UDim2.new(0,
                math.clamp(sp.X.Offset + d.X, 0, vp.X - target.AbsoluteSize.X),
                0,
                math.clamp(sp.Y.Offset + d.Y, 0, vp.Y - target.AbsoluteSize.Y)
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function makeResizable(handle, target)
    local resizing, rs, ss = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            rs = i.Position
            ss = target.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - rs
            target.Size = UDim2.new(0, math.max(MIN_W, ss.X.Offset + d.X), 0, math.max(MIN_H, ss.Y.Offset + d.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
end

local keyNames = {
    [Enum.KeyCode.LeftControl]  = "L-CTRL",
    [Enum.KeyCode.RightControl] = "R-CTRL",
    [Enum.KeyCode.LeftShift]    = "L-SHIFT",
    [Enum.KeyCode.RightShift]   = "R-SHIFT",
    [Enum.KeyCode.LeftAlt]      = "L-ALT",
    [Enum.KeyCode.RightAlt]     = "R-ALT",
    [Enum.KeyCode.Return]       = "ENTER",
    [Enum.KeyCode.Space]        = "SPACE",
    [Enum.KeyCode.Tab]          = "TAB",
    [Enum.KeyCode.Delete]       = "DEL",
    [Enum.KeyCode.BackSpace]    = "BACK",
    [Enum.KeyCode.Escape]       = "ESC",
    [Enum.KeyCode.Insert]       = "INS",
    [Enum.KeyCode.Home]         = "HOME",
    [Enum.KeyCode.End]          = "END",
    [Enum.KeyCode.PageUp]       = "PGUP",
    [Enum.KeyCode.PageDown]     = "PGDN",
    [Enum.KeyCode.Up]           = "UP",
    [Enum.KeyCode.Down]         = "DOWN",
    [Enum.KeyCode.Left]         = "LEFT",
    [Enum.KeyCode.Right]        = "RIGHT",
    [Enum.KeyCode.CapsLock]     = "CAPS",
    [Enum.KeyCode.NumLock]      = "NUMLK",
    [Enum.KeyCode.F1]  = "F1",  [Enum.KeyCode.F2]  = "F2",  [Enum.KeyCode.F3]  = "F3",
    [Enum.KeyCode.F4]  = "F4",  [Enum.KeyCode.F5]  = "F5",  [Enum.KeyCode.F6]  = "F6",
    [Enum.KeyCode.F7]  = "F7",  [Enum.KeyCode.F8]  = "F8",  [Enum.KeyCode.F9]  = "F9",
    [Enum.KeyCode.F10] = "F10", [Enum.KeyCode.F11] = "F11", [Enum.KeyCode.F12] = "F12",
    [Enum.KeyCode.Zero]  = "0", [Enum.KeyCode.One]   = "1", [Enum.KeyCode.Two]   = "2",
    [Enum.KeyCode.Three] = "3", [Enum.KeyCode.Four]  = "4", [Enum.KeyCode.Five]  = "5",
    [Enum.KeyCode.Six]   = "6", [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine]  = "9",
}

local function keyName(kc)
    return keyNames[kc] or kc.Name:upper()
end

local notifyCount = 0
local MAX_NOTIFY  = 5
local notifyGui   = nil

local ntypes = {
    success = { col = Color3.fromRGB(58, 188, 98),  icon = "✓" },
    error   = { col = Color3.fromRGB(210, 58, 58),  icon = "✕" },
    warn    = { col = Color3.fromRGB(218, 158, 38), icon = "!" },
    info    = { col = Color3.fromRGB(72, 148, 228), icon = "i" },
}

local function getNotifContainer()
    if notifyGui and notifyGui.Parent then
        return notifyGui:FindFirstChild("Container")
    end
    local g = Instance.new("ScreenGui")
    g.Name           = "TryxLib_Notify"
    g.ResetOnSpawn   = false
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.DisplayOrder   = 1000
    g.IgnoreGuiInset = true
    g.Parent         = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")
    notifyGui        = g

    local cont = frame(g, Color3.fromRGB(0, 0, 0), UDim2.new(0, 298, 1, -20), UDim2.new(1, -312, 0, 10))
    cont.Name                    = "Container"
    cont.BackgroundTransparency  = 1
    local lay = Instance.new("UIListLayout")
    lay.VerticalAlignment   = Enum.VerticalAlignment.Bottom
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    lay.Padding             = UDim.new(0, 6)
    lay.SortOrder           = Enum.SortOrder.LayoutOrder
    lay.Parent              = cont
    pad(cont, 0, 14, 0, 0)
    return cont
end

local function doNotify(cfg, theme)
    theme = theme or Themes.Default
    if notifyCount >= MAX_NOTIFY then return end
    notifyCount += 1

    local cont     = getNotifContainer()
    local title    = cfg.Title    or ""
    local desc     = cfg.Desc     or cfg.Content or ""
    local ntype    = cfg.Type     or "info"
    local duration = cfg.Duration or 4
    local td       = ntypes[ntype] or ntypes.info
    local accent   = cfg.Color    or td.col

    local wrapper = frame(cont, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 0))
    wrapper.BackgroundTransparency = 1
    wrapper.ClipsDescendants       = true

    local n = frame(wrapper, theme.Notify, UDim2.new(1, -2, 0, 70))
    n.Position         = UDim2.new(0, 2, 0, 0)
    n.ClipsDescendants = true
    n.ZIndex           = 10
    corner(n, UDim.new(0, 9))
    stroke(n, theme.NotifyStroke, 1)

    local accentBar = frame(n, accent, UDim2.new(0, 3, 1, 0))
    corner(accentBar, UDim.new(0, 2))

    local iconBg = frame(n, accent, UDim2.new(0, 28, 0, 28))
    iconBg.Position              = UDim2.new(0, 14, 0.5, -14)
    iconBg.ZIndex                = 11
    iconBg.BackgroundTransparency = 0.12
    corner(iconBg, UDim.new(1, 0))

    local iconL = lbl(iconBg, td.icon, Color3.fromRGB(255, 255, 255), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    iconL.Size   = UDim2.fromScale(1, 1)
    iconL.ZIndex = 12

    local tl = lbl(n, title, Color3.fromRGB(238, 238, 238), 13, Enum.Font.GothamBold)
    tl.Size     = UDim2.new(1, -58, 0, 17)
    tl.Position = UDim2.new(0, 50, 0, 10)
    tl.ZIndex   = 11

    local dl = lbl(n, desc, Color3.fromRGB(148, 148, 158), 11, Enum.Font.Gotham)
    dl.Size        = UDim2.new(1, -58, 0, 28)
    dl.Position    = UDim2.new(0, 50, 0, 28)
    dl.ZIndex      = 11
    dl.TextWrapped = true
    dl.TextTruncate = Enum.TextTruncate.None

    local prog = frame(n, accent, UDim2.new(1, 0, 0, 2))
    prog.Position              = UDim2.new(0, 0, 1, -2)
    prog.ZIndex                = 12
    prog.BackgroundTransparency = 0.25

    tw(wrapper, { Size = UDim2.new(1, 0, 0, 76) }, ANIM_MED)
    tw(prog, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        tw(wrapper, { Size = UDim2.new(1, 0, 0, 0) }, ANIM_FAST)
        task.wait(ANIM_FAST + 0.05)
        if wrapper.Parent then wrapper:Destroy() end
        notifyCount = math.max(0, notifyCount - 1)
    end

    task.delay(duration, dismiss)
    local cb = btn(n, UDim2.fromScale(1, 1), nil, 13)
    cb.MouseButton1Click:Connect(dismiss)
end

local function baseEl(theme, cfg, h)
    local height = h or ELEMENT_H
    if cfg.Desc and cfg.Desc ~= "" then height = height + 16 end

    local f = Instance.new("Frame")
    f.Size               = UDim2.new(1, 0, 0, height)
    f.BackgroundColor3   = cfg.Color or theme.Element
    f.BorderSizePixel    = 0
    f.ClipsDescendants   = true
    if cfg.Transparency then f.BackgroundTransparency = cfg.Transparency end
    corner(f, CORNER_EL)
    stroke(f, theme.ElementStroke, 1)
    pad(f, 0, 0, 14, 14)
    return f, height
end

local function titleDesc(parent, theme, cfg, offsetR, y)
    y       = y or 0
    offsetR = offsetR or 0
    local hasDesc = cfg.Desc and cfg.Desc ~= ""
    local ty      = hasDesc and (y + 8) or (y + math.floor((ELEMENT_H - 16) / 2))

    local iconOff = 0
    if cfg.Icon and cfg.Icon ~= "" then
        local ic = lbl(parent, cfg.Icon, theme.Accent, 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        ic.Size     = UDim2.new(0, 18, 0, 18)
        ic.Position = UDim2.new(0, 0, 0, ty)
        iconOff     = 22
    end

    local tl = lbl(parent, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
    tl.Size         = UDim2.new(1, -(offsetR + iconOff), 0, 16)
    tl.Position     = UDim2.new(0, iconOff, 0, ty)
    tl.TextTruncate = Enum.TextTruncate.AtEnd

    if hasDesc then
        local dl = lbl(parent, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        dl.Size         = UDim2.new(1, -(offsetR + iconOff), 0, 14)
        dl.Position     = UDim2.new(0, iconOff, 0, ty + 18)
        dl.TextTruncate = Enum.TextTruncate.AtEnd
    end
    return tl
end

local function makeScrollbar(scrollFrame, theme)
    local bar = frame(scrollFrame, theme.ScrollBar, UDim2.new(0, 3, 0, 0))
    bar.AnchorPoint     = Vector2.new(1, 0)
    bar.Position        = UDim2.new(1, -2, 0, 0)
    bar.BorderSizePixel = 0
    corner(bar, UDim.new(1, 0))
    bar.ZIndex = 5

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not scrollFrame.Parent then conn:Disconnect() return end
        local ch  = scrollFrame.AbsoluteWindowSize.Y
        local ca  = scrollFrame.CanvasSize.Y.Offset
        if ca <= ch then bar.Visible = false return end
        bar.Visible = true
        local ratio = ch / ca
        local pos   = scrollFrame.CanvasPosition.Y / (ca - ch)
        bar.Size     = UDim2.new(0, 3, 0, math.max(30, ch * ratio))
        bar.Position = UDim2.new(1, -2, 0, pos * (ch - bar.AbsoluteSize.Y))
    end)

    return bar
end

local function getScreenGui(instance)
    local p = instance
    while p do
        if p:IsA("ScreenGui") then return p end
        p = p.Parent
    end
    return nil
end

local function positionPopup(popup, anchor, offsetX, offsetY, preferUp)
    offsetX = offsetX or 0
    offsetY = offsetY or 6

    local vp   = Camera.ViewportSize
    local abs  = anchor.AbsolutePosition
    local asiz = anchor.AbsoluteSize
    local psiz = popup.AbsoluteSize

    local x = abs.X + offsetX
    local y = abs.Y + asiz.Y + offsetY

    if y + psiz.Y > vp.Y - 10 or preferUp then
        y = abs.Y - psiz.Y - offsetY
    end
    if x + psiz.X > vp.X - 10 then
        x = vp.X - psiz.X - 10
    end
    if x < 6 then x = 6 end
    if y < 6 then y = 6 end

    popup.Position = UDim2.new(0, x, 0, y)
end

local function injectElements(Tab, theme, page, gui)

    function Tab:Button(cfg)
        cfg = cfg or {}
        local disabled = cfg.Disabled or false
        local f, _     = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 34)

        local arr = lbl(f, "›", theme.Accent, 22, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        arr.Size         = UDim2.new(0, 22, 1, 0)
        arr.Position     = UDim2.new(1, -26, 0, 0)
        arr.TextTruncate = Enum.TextTruncate.None

        local b = btn(f)
        b.MouseEnter:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = theme.ElementHover })
            tw(arr, { TextColor3 = theme.AccentLight })
        end)
        b.MouseLeave:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = cfg.Color or theme.Element })
            tw(arr, { TextColor3 = theme.Accent })
        end)
        b.MouseButton1Down:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = theme.ElementActive })
            ripple(f, theme)
        end)
        b.MouseButton1Up:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = theme.ElementHover })
        end)
        b.MouseButton1Click:Connect(function()
            if disabled then return end
            task.spawn(function() pcall(cfg.Callback or function() end) end)
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:SetDisabled(v)
            disabled = v
            tw(f, { BackgroundTransparency = v and 0.4 or 0 })
        end
        function obj:Trigger()
            task.spawn(function() pcall(cfg.Callback or function() end) end)
        end
        function obj:SetTitle(t) end
        return obj
    end

    function Tab:Toggle(cfg)
        cfg = cfg or {}
        local toggleType = cfg.Type     or "Default"
        local value      = cfg.Value ~= nil and cfg.Value or false
        local disabled   = cfg.Disabled or false
        local f          = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 58)

        local updateFn

        if toggleType == "Checkbox" then
            local box = frame(f, value and theme.Accent or theme.InputBg, UDim2.new(0, 20, 0, 20))
            box.Position = UDim2.new(1, -24, 0.5, -10)
            corner(box, UDim.new(0, 5))
            local bs = stroke(box, value and theme.Accent or theme.ElementStroke, 1.5)

            local chk = lbl(box, "✓", Color3.fromRGB(255, 255, 255), 12, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            chk.Size             = UDim2.fromScale(1, 1)
            chk.TextTransparency = value and 0 or 1
            chk.TextTruncate     = Enum.TextTruncate.None

            updateFn = function(v)
                tw(box, { BackgroundColor3 = v and theme.Accent or theme.InputBg })
                tw(chk, { TextTransparency = v and 0 or 1 })
                bs.Color = v and theme.Accent or theme.ElementStroke
            end
        else
            local track = frame(f, value and theme.Accent or theme.ElementStroke, UDim2.new(0, 38, 0, 20))
            track.Position = UDim2.new(1, -44, 0.5, -10)
            corner(track, UDim.new(1, 0))

            local thumb = frame(track, Color3.fromRGB(255, 255, 255), UDim2.new(0, 14, 0, 14))
            thumb.AnchorPoint = Vector2.new(0, 0.5)
            thumb.Position    = value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            corner(thumb, UDim.new(1, 0))

            updateFn = function(v)
                tw(track, { BackgroundColor3 = v and theme.Accent or theme.ElementStroke })
                tw(thumb, { Position = v and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
            end
        end

        local b = btn(f)
        b.MouseEnter:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = theme.ElementHover })
        end)
        b.MouseLeave:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = cfg.Color or theme.Element })
        end)
        b.MouseButton1Click:Connect(function()
            if disabled then return end
            value = not value
            updateFn(value)
            task.spawn(function() pcall(cfg.Callback or function() end, value) end)
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Set(v)
            value = v
            updateFn(v)
            task.spawn(function() pcall(cfg.Callback or function() end, v) end)
        end
        function obj:Get() return value end
        function obj:SetDisabled(v) disabled = v; tw(f, { BackgroundTransparency = v and 0.4 or 0 }) end
        return obj
    end

    function Tab:Input(cfg)
        cfg = cfg or {}
        local multiline = cfg.MultiLine or false
        local disabled  = cfg.Disabled  or false
        local boxH      = multiline and 52 or 28
        local height    = 40 + boxH + (cfg.Desc and cfg.Desc ~= "" and 16 or 0)

        local f = baseEl(theme, { Color = cfg.Color, Transparency = cfg.Transparency, Desc = "", Title = "" })
        f.Size             = UDim2.new(1, 0, 0, height)
        f.ClipsDescendants = true

        local tl = lbl(f, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        tl.Size         = UDim2.new(1, 0, 0, 16)
        tl.Position     = UDim2.new(0, 0, 0, 10)
        tl.TextTruncate = Enum.TextTruncate.AtEnd

        if cfg.Desc and cfg.Desc ~= "" then
            local dl = lbl(f, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
            dl.Size     = UDim2.new(1, 0, 0, 14)
            dl.Position = UDim2.new(0, 0, 0, 28)
        end

        local yOff = (cfg.Desc and cfg.Desc ~= "") and 46 or 30

        local box = frame(f, theme.InputBg, UDim2.new(1, 0, 0, boxH))
        box.Position = UDim2.new(0, 0, 0, yOff)
        corner(box, CORNER_SM)
        local boxS = stroke(box, theme.ElementStroke, 1)

        local input = Instance.new("TextBox")
        input.Size               = UDim2.new(1, -12, 1, multiline and -8 or 0)
        input.Position           = UDim2.new(0, 6, 0, multiline and 4 or 0)
        input.BackgroundTransparency = 1
        input.Text               = cfg.Default or ""
        input.PlaceholderText    = cfg.Placeholder or ""
        input.TextColor3         = theme.TextPrimary
        input.PlaceholderColor3  = theme.TextDisabled
        input.TextSize           = 12
        input.Font               = Enum.Font.Gotham
        input.TextXAlignment     = Enum.TextXAlignment.Left
        input.ClearTextOnFocus   = false
        input.MultiLine          = multiline
        input.TextWrapped        = multiline
        input.TextYAlignment     = multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
        input.Parent             = box

        if disabled then input.TextEditable = false end

        input.Focused:Connect(function()
            tw(box, { BackgroundColor3 = theme.ElementHover })
            tw(boxS, { Color = theme.Accent })
        end)
        input.FocusLost:Connect(function(enter)
            tw(box, { BackgroundColor3 = theme.InputBg })
            tw(boxS, { Color = theme.ElementStroke })
            if enter then task.spawn(function() pcall(cfg.Callback or function() end, input.Text) end) end
        end)
        if cfg.LiveCallback then
            input:GetPropertyChangedSignal("Text"):Connect(function()
                task.spawn(function() pcall(cfg.LiveCallback, input.Text) end)
            end)
        end

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = {}
        function obj:Get() return input.Text end
        function obj:Set(v) input.Text = v end
        function obj:Clear() input.Text = "" end
        function obj:SetDisabled(v)
            disabled = v
            input.TextEditable = not v
            tw(f, { BackgroundTransparency = v and 0.4 or 0 })
        end
        return obj
    end

    function Tab:Slider(cfg)
        cfg = cfg or {}
        local min      = cfg.Min      or 0
        local max      = cfg.Max      or 100
        local value    = math.clamp(cfg.Value or min, min, max)
        local step     = cfg.Step     or 1
        local suffix   = cfg.Suffix   or ""
        local disabled = cfg.Disabled or false
        local useInput = cfg.Input    == true

        local frameH = 60 + (cfg.Desc and cfg.Desc ~= "" and 16 or 0)
        local f      = baseEl(theme, { Color = cfg.Color, Transparency = cfg.Transparency, Desc = "", Title = "" })
        f.Size             = UDim2.new(1, 0, 0, frameH)
        f.ClipsDescendants = true

        local tl = lbl(f, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        tl.Size     = UDim2.new(1, useInput and -62 or -56, 0, 16)
        tl.Position = UDim2.new(0, 0, 0, 10)

        local valDisplay
        if useInput then
            local inputFrame = frame(f, theme.InputBg, UDim2.new(0, 50, 0, 22))
            inputFrame.Position = UDim2.new(1, -52, 0, 6)
            corner(inputFrame, UDim.new(0, 4))
            stroke(inputFrame, theme.ElementStroke, 1)

            local ib = Instance.new("TextBox")
            ib.Size               = UDim2.new(1, -8, 1, 0)
            ib.Position           = UDim2.new(0, 4, 0, 0)
            ib.BackgroundTransparency = 1
            ib.Text               = tostring(value)
            ib.TextColor3         = theme.Accent
            ib.TextSize           = 12
            ib.Font               = Enum.Font.GothamBold
            ib.TextXAlignment     = Enum.TextXAlignment.Center
            ib.ClearTextOnFocus   = false
            ib.ZIndex             = 4
            ib.Parent             = inputFrame
            valDisplay            = ib
        else
            local vl = lbl(f, tostring(value) .. suffix, theme.Accent, 12, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            vl.Size         = UDim2.new(0, 50, 0, 16)
            vl.Position     = UDim2.new(1, -52, 0, 10)
            vl.TextTruncate = Enum.TextTruncate.None
            valDisplay      = vl
        end

        local trackY = (cfg.Desc and cfg.Desc ~= "") and 52 or 38

        local track = frame(f, theme.ElementStroke2, UDim2.new(1, 0, 0, 6))
        track.Position = UDim2.new(0, 0, 0, trackY)
        corner(track, UDim.new(1, 0))

        local fill = frame(track, cfg.AccentColor or theme.Accent, UDim2.new((value - min) / (max - min), 0, 1, 0))
        corner(fill, UDim.new(1, 0))

        local thumb = frame(track, Color3.fromRGB(255, 255, 255), UDim2.new(0, 14, 0, 14))
        thumb.AnchorPoint = Vector2.new(0.5, 0.5)
        thumb.Position    = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
        corner(thumb, UDim.new(1, 0))
        stroke(thumb, cfg.AccentColor or theme.Accent, 1.5)
        thumb.ZIndex = 3

        local dragging = false

        local function snapValue(v)
            if step <= 0 then return v end
            return math.floor(v / step + 0.5) * step
        end

        local function applyValue(v)
            value = math.clamp(snapValue(v), min, max)
            local pct = (max - min == 0) and 0 or (value - min) / (max - min)
            fill.Size     = UDim2.new(pct, 0, 1, 0)
            thumb.Position = UDim2.new(pct, 0, 0.5, 0)
            if useInput then
                valDisplay.Text = tostring(value)
            else
                valDisplay.Text = tostring(value) .. suffix
            end
            task.spawn(function() pcall(cfg.Callback or function() end, value) end)
        end

        local function inputXToValue(inputX)
            local abs  = track.AbsolutePosition.X
            local w    = track.AbsoluteSize.X
            if w == 0 then return value end
            local rel  = math.clamp((inputX - abs) / w, 0, 1)
            return min + rel * (max - min)
        end

        local function onInputBegan(i)
            if disabled then return end
            local isTouch = i.UserInputType == Enum.UserInputType.Touch
            local isMouse = i.UserInputType == Enum.UserInputType.MouseButton1
            if not (isTouch or isMouse) then return end
            dragging = true
            applyValue(inputXToValue(i.Position.X))
        end

        local function onInputChanged(i)
            if not dragging then return end
            local isTouch = i.UserInputType == Enum.UserInputType.Touch
            local isMouse = i.UserInputType == Enum.UserInputType.MouseMovement
            if not (isTouch or isMouse) then return end
            applyValue(inputXToValue(i.Position.X))
        end

        local function onInputEnded(i)
            local isTouch = i.UserInputType == Enum.UserInputType.Touch
            local isMouse = i.UserInputType == Enum.UserInputType.MouseButton1
            if isTouch or isMouse then dragging = false end
        end

        track.InputBegan:Connect(onInputBegan)
        UserInputService.InputChanged:Connect(onInputChanged)
        UserInputService.InputEnded:Connect(onInputEnded)

        if useInput then
            valDisplay.FocusLost:Connect(function()
                local parsed = tonumber(valDisplay.Text)
                if parsed then
                    applyValue(parsed)
                else
                    valDisplay.Text = tostring(value)
                end
            end)
        end

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = {}
        function obj:Get() return value end
        function obj:Set(v) applyValue(v) end
        function obj:SetDisabled(v)
            disabled = v
            tw(f, { BackgroundTransparency = v and 0.4 or 0 })
        end
        return obj
    end

    function Tab:Dropdown(cfg)
        cfg = cfg or {}
        local values   = cfg.Values   or {}
        local value    = cfg.Value    or (values[1] or "")
        local multi    = cfg.Multi    == true
        local disabled = cfg.Disabled or false
        local open     = false
        local selected = multi and {} or value

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 114)

        local selBox = frame(f, theme.InputBg, UDim2.new(0, 102, 0, 26))
        selBox.Position = UDim2.new(1, -104, 0.5, -13)
        corner(selBox, CORNER_SM)
        stroke(selBox, theme.ElementStroke, 1)

        local selLbl = lbl(selBox, multi and "Select..." or tostring(value), theme.TextPrimary, 11, Enum.Font.Gotham)
        selLbl.Size         = UDim2.new(1, -22, 1, 0)
        selLbl.Position     = UDim2.new(0, 7, 0, 0)
        selLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local chevron = lbl(selBox, "▾", theme.TextSecondary, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        chevron.Size     = UDim2.new(0, 16, 1, 0)
        chevron.Position = UDim2.new(1, -18, 0, 0)
        chevron.TextTruncate = Enum.TextTruncate.None

        local list       = nil
        local listConn   = nil
        local scrollConn = nil

        local function getDisplayText()
            if multi then
                local count = 0
                for _ in pairs(selected) do count += 1 end
                return count == 0 and "Select..." or count .. " selected"
            end
            return tostring(selected)
        end

        local function closeList()
            if not list then return end
            open = false
            tw(chevron, { Rotation = 0 }, ANIM_FAST)
            local captured = list
            tw(captured, { BackgroundTransparency = 1 }, ANIM_FAST)
            task.delay(ANIM_FAST + 0.02, function()
                if captured and captured.Parent then captured:Destroy() end
            end)
            list = nil
            if listConn then listConn:Disconnect(); listConn = nil end
            if scrollConn then scrollConn:Disconnect(); scrollConn = nil end
            unregisterOverlay(closeList)
        end

        local function buildList()
            closeList()
            if disabled then return end

            local sg = gui
            if not sg then return end

            list = frame(sg, theme.Element, UDim2.new(0, 110, 0, 0))
            list.ZIndex           = OVERLAY_Z
            list.ClipsDescendants = true
            list.BackgroundTransparency = 0
            corner(list, CORNER_SM)
            stroke(list, theme.ElementStroke, 1)
            shadow(list)

            local itemH   = 28
            local maxShow = math.min(#values, 7)
            local listH   = maxShow * itemH + 8

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size                    = UDim2.fromScale(1, 1)
            scroll.BackgroundTransparency  = 1
            scroll.BorderSizePixel         = 0
            scroll.CanvasSize              = UDim2.new(0, 0, 0, #values * itemH + 8)
            scroll.ScrollBarThickness      = 3
            scroll.ScrollBarImageColor3    = theme.ScrollBar
            scroll.ScrollingDirection      = Enum.ScrollingDirection.Y
            scroll.AutomaticCanvasSize     = Enum.AutomaticSize.None
            scroll.ElasticBehavior         = Enum.ElasticBehavior.Never
            scroll.Parent                  = list

            local lay = Instance.new("UIListLayout")
            lay.Padding   = UDim.new(0, 0)
            lay.SortOrder = Enum.SortOrder.LayoutOrder
            lay.Parent    = scroll
            pad(scroll, 4, 4, 4, 4)

            for idx, v in ipairs(values) do
                local isSelected = multi and selected[v] or (selected == v)
                local item = frame(scroll, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, itemH))
                item.BackgroundTransparency = 1

                local itemBg = frame(item, isSelected and theme.ElementActive or Color3.fromRGB(0, 0, 0), UDim2.fromScale(1, 1))
                itemBg.BackgroundTransparency = isSelected and 0 or 1
                corner(itemBg, UDim.new(0, 4))

                local il = lbl(item, tostring(v), isSelected and theme.Accent or theme.TextPrimary, 12, Enum.Font.Gotham)
                il.Size         = UDim2.new(1, -8, 1, 0)
                il.Position     = UDim2.new(0, 8, 0, 0)
                il.TextTruncate = Enum.TextTruncate.AtEnd
                il.ZIndex       = OVERLAY_Z + 1

                if isSelected and multi then
                    local check = lbl(item, "✓", theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                    check.Size     = UDim2.new(0, 20, 1, 0)
                    check.Position = UDim2.new(1, -22, 0, 0)
                    check.ZIndex   = OVERLAY_Z + 1
                    check.TextTruncate = Enum.TextTruncate.None
                end

                local ib = btn(item, UDim2.fromScale(1, 1), nil, OVERLAY_Z + 2)
                ib.MouseEnter:Connect(function()
                    tw(itemBg, { BackgroundColor3 = theme.ElementHover, BackgroundTransparency = 0 })
                    tw(il, { TextColor3 = theme.TextPrimary })
                end)
                ib.MouseLeave:Connect(function()
                    if multi and selected[v] or (not multi and selected == v) then
                        tw(itemBg, { BackgroundColor3 = theme.ElementActive, BackgroundTransparency = 0 })
                        tw(il, { TextColor3 = theme.Accent })
                    else
                        tw(itemBg, { BackgroundTransparency = 1 })
                        tw(il, { TextColor3 = theme.TextPrimary })
                    end
                end)
                ib.MouseButton1Click:Connect(function()
                    if multi then
                        selected[v] = not selected[v] and true or nil
                    else
                        selected = v
                    end
                    selLbl.Text = getDisplayText()
                    task.spawn(function() pcall(cfg.Callback or function() end, selected) end)
                    if not multi then closeList() end
                end)
            end

            list.Size = UDim2.new(0, 110, 0, 0)

            positionPopup(list, selBox, 0, 4)

            tw(list, { Size = UDim2.new(0, 110, 0, listH) }, ANIM_FAST)
            tw(chevron, { Rotation = 180 }, ANIM_FAST)

            listConn = UserInputService.InputBegan:Connect(function(i, gp)
                if gp then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mx, my = i.Position.X, i.Position.Y
                    if list then
                        local lpos = list.AbsolutePosition
                        local lsiz = list.AbsoluteSize
                        if not (mx >= lpos.X and mx <= lpos.X + lsiz.X and my >= lpos.Y and my <= lpos.Y + lsiz.Y) then
                            local fpos = f.AbsolutePosition
                            local fsiz = f.AbsoluteSize
                            if not (mx >= fpos.X and mx <= fpos.X + fsiz.X and my >= fpos.Y and my <= fpos.Y + fsiz.Y) then
                                closeList()
                            end
                        end
                    end
                end
            end)

            registerOverlay(closeList)
        end

        local b = btn(f)
        b.MouseEnter:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = theme.ElementHover })
        end)
        b.MouseLeave:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = cfg.Color or theme.Element })
        end)
        b.MouseButton1Click:Connect(function()
            if disabled then return end
            open = not open
            if open then
                closeAllOverlays()
                open = true
                buildList()
            else
                closeList()
            end
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = {}
        function obj:Get() return selected end
        function obj:Set(v)
            selected = v
            selLbl.Text = getDisplayText()
        end
        function obj:SetValues(v)
            values = v
            if not multi then selected = v[1] or "" end
            selLbl.Text = getDisplayText()
            if open then closeList(); open = true; buildList() end
        end
        function obj:Close() closeList() end
        function obj:SetDisabled(v) disabled = v; tw(f, { BackgroundTransparency = v and 0.4 or 0 }) end
        return obj
    end

    function Tab:ColorPicker(cfg)
        cfg = cfg or {}
        local value    = cfg.Value    or Color3.fromRGB(255, 255, 255)
        local disabled = cfg.Disabled or false
        local open     = false
        local panel    = nil
        local panelConn = nil

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 50)

        local preview = frame(f, value, UDim2.new(0, 30, 0, 22))
        preview.Position = UDim2.new(1, -32, 0.5, -11)
        corner(preview, CORNER_SM)
        stroke(preview, theme.ElementStroke, 1)

        local rgb = { math.floor(value.R * 255), math.floor(value.G * 255), math.floor(value.B * 255) }

        local function updateColor()
            value = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
            tw(preview, { BackgroundColor3 = value })
            task.spawn(function() pcall(cfg.Callback or function() end, value) end)
        end

        local function closePanel()
            if not panel then return end
            open = false
            local captured = panel
            tw(captured, { BackgroundTransparency = 1 }, ANIM_FAST)
            task.delay(ANIM_FAST + 0.02, function()
                if captured and captured.Parent then captured:Destroy() end
            end)
            panel = nil
            if panelConn then panelConn:Disconnect(); panelConn = nil end
            unregisterOverlay(closePanel)
        end

        local function buildPanel()
            closePanel()
            local sg = gui
            if not sg then return end

            panel = frame(sg, theme.Element, UDim2.new(0, 214, 0, 0))
            panel.ZIndex    = OVERLAY_Z
            panel.BackgroundTransparency = 0
            corner(panel, CORNER_EL)
            stroke(panel, theme.ElementStroke, 1)
            shadow(panel)

            pad(panel, 10, 10, 12, 12)

            local lay = Instance.new("UIListLayout")
            lay.Padding   = UDim.new(0, 8)
            lay.SortOrder = Enum.SortOrder.LayoutOrder
            lay.Parent    = panel

            local hexRow = frame(panel, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 26))
            hexRow.BackgroundTransparency = 1
            hexRow.ZIndex                 = OVERLAY_Z + 1
            hexRow.LayoutOrder            = 0

            local hexLabel = lbl(hexRow, "HEX", theme.TextSecondary, 9, Enum.Font.GothamBold)
            hexLabel.Size  = UDim2.new(0, 28, 1, 0)
            hexLabel.ZIndex = OVERLAY_Z + 1

            local hexInputFrame = frame(hexRow, theme.InputBg, UDim2.new(1, -32, 1, 0))
            hexInputFrame.Position = UDim2.new(0, 32, 0, 0)
            corner(hexInputFrame, UDim.new(0, 4))
            stroke(hexInputFrame, theme.ElementStroke, 1)
            hexInputFrame.ZIndex = OVERLAY_Z + 1

            local function toHex(r, g, b)
                return string.format("%02X%02X%02X", r, g, b)
            end

            local hexBox = Instance.new("TextBox")
            hexBox.Size               = UDim2.new(1, -8, 1, 0)
            hexBox.Position           = UDim2.new(0, 4, 0, 0)
            hexBox.BackgroundTransparency = 1
            hexBox.Text               = toHex(rgb[1], rgb[2], rgb[3])
            hexBox.TextColor3         = theme.TextPrimary
            hexBox.TextSize           = 11
            hexBox.Font               = Enum.Font.GothamMono or Enum.Font.Gotham
            hexBox.TextXAlignment     = Enum.TextXAlignment.Left
            hexBox.ClearTextOnFocus   = false
            hexBox.ZIndex             = OVERLAY_Z + 2
            hexBox.Parent             = hexInputFrame

            hexBox.FocusLost:Connect(function()
                local hex = hexBox.Text:gsub("[^%x]", ""):sub(1, 6)
                if #hex == 6 then
                    local r2 = tonumber(hex:sub(1, 2), 16) or 0
                    local g2 = tonumber(hex:sub(3, 4), 16) or 0
                    local b2 = tonumber(hex:sub(5, 6), 16) or 0
                    rgb[1], rgb[2], rgb[3] = r2, g2, b2
                    updateColor()
                end
                hexBox.Text = toHex(rgb[1], rgb[2], rgb[3])
            end)

            local channels = {
                { name = "R", idx = 1, col = Color3.fromRGB(220, 60, 60) },
                { name = "G", idx = 2, col = Color3.fromRGB(60, 200, 80) },
                { name = "B", idx = 3, col = Color3.fromRGB(60, 120, 220) },
            }

            local totalH = 26 + 8 + #channels * (26 + 8) + 20

            for ordIdx, ch in ipairs(channels) do
                local row = frame(panel, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 26))
                row.BackgroundTransparency = 1
                row.ZIndex                 = OVERLAY_Z + 1
                row.LayoutOrder            = ordIdx

                local cl = lbl(row, ch.name, theme.TextSecondary, 9, Enum.Font.GothamBold)
                cl.Size  = UDim2.new(0, 14, 1, 0)
                cl.ZIndex = OVERLAY_Z + 1
                cl.TextTruncate = Enum.TextTruncate.None

                local tr = frame(row, theme.ElementStroke2, UDim2.new(1, -56, 0, 6))
                tr.Position = UDim2.new(0, 18, 0.5, -3)
                tr.ZIndex   = OVERLAY_Z + 1
                corner(tr, UDim.new(1, 0))

                local fi = frame(tr, ch.col, UDim2.new(rgb[ch.idx] / 255, 0, 1, 0))
                fi.BackgroundTransparency = 0.2
                fi.ZIndex                 = OVERLAY_Z + 2
                corner(fi, UDim.new(1, 0))

                local th2 = frame(tr, Color3.fromRGB(255, 255, 255), UDim2.new(0, 12, 0, 12))
                th2.AnchorPoint = Vector2.new(0.5, 0.5)
                th2.Position    = UDim2.new(rgb[ch.idx] / 255, 0, 0.5, 0)
                th2.ZIndex      = OVERLAY_Z + 3
                corner(th2, UDim.new(1, 0))
                stroke(th2, ch.col, 1.5)

                local vi = Instance.new("TextBox")
                vi.Size               = UDim2.new(0, 30, 0, 18)
                vi.Position           = UDim2.new(1, -30, 0.5, -9)
                vi.BackgroundColor3   = theme.InputBg
                vi.Text               = tostring(rgb[ch.idx])
                vi.TextColor3         = theme.TextPrimary
                vi.TextSize           = 10
                vi.Font               = Enum.Font.GothamBold
                vi.TextXAlignment     = Enum.TextXAlignment.Center
                vi.ClearTextOnFocus   = false
                vi.BorderSizePixel    = 0
                vi.ZIndex             = OVERLAY_Z + 4
                corner(vi, UDim.new(0, 3))
                vi.Parent = row

                local drag2 = false

                local function applySlider(inputX)
                    local abs  = tr.AbsolutePosition.X
                    local w    = tr.AbsoluteSize.X
                    if w == 0 then return end
                    local r2   = math.clamp((inputX - abs) / w, 0, 1)
                    rgb[ch.idx] = math.floor(r2 * 255)
                    vi.Text = tostring(rgb[ch.idx])
                    fi.Size     = UDim2.new(r2, 0, 1, 0)
                    th2.Position = UDim2.new(r2, 0, 0.5, 0)
                    updateColor()
                    hexBox.Text = toHex(rgb[1], rgb[2], rgb[3])
                end

                tr.InputBegan:Connect(function(i)
                    local isMouse = i.UserInputType == Enum.UserInputType.MouseButton1
                    local isTouch = i.UserInputType == Enum.UserInputType.Touch
                    if isMouse or isTouch then
                        drag2 = true
                        applySlider(i.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if not drag2 then return end
                    local isMouse = i.UserInputType == Enum.UserInputType.MouseMovement
                    local isTouch = i.UserInputType == Enum.UserInputType.Touch
                    if isMouse or isTouch then applySlider(i.Position.X) end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    local isMouse = i.UserInputType == Enum.UserInputType.MouseButton1
                    local isTouch = i.UserInputType == Enum.UserInputType.Touch
                    if isMouse or isTouch then drag2 = false end
                end)

                vi.FocusLost:Connect(function()
                    local v2 = math.clamp(tonumber(vi.Text) or rgb[ch.idx], 0, 255)
                    rgb[ch.idx] = math.floor(v2)
                    vi.Text = tostring(rgb[ch.idx])
                    local r2 = rgb[ch.idx] / 255
                    fi.Size      = UDim2.new(r2, 0, 1, 0)
                    th2.Position = UDim2.new(r2, 0, 0.5, 0)
                    updateColor()
                    hexBox.Text = toHex(rgb[1], rgb[2], rgb[3])
                end)
            end

            panel.Size = UDim2.new(0, 214, 0, 0)
            positionPopup(panel, preview, -182, 6)

            local targetH = 26 + 8 + 3 * (26 + 8) + 20
            tw(panel, { Size = UDim2.new(0, 214, 0, targetH) }, ANIM_FAST)

            panelConn = UserInputService.InputBegan:Connect(function(i, gp)
                if gp then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mx, my = i.Position.X, i.Position.Y
                    if panel then
                        local pp = panel.AbsolutePosition
                        local ps = panel.AbsoluteSize
                        if not (mx >= pp.X and mx <= pp.X + ps.X and my >= pp.Y and my <= pp.Y + ps.Y) then
                            local fp = f.AbsolutePosition
                            local fs = f.AbsoluteSize
                            if not (mx >= fp.X and mx <= fp.X + fs.X and my >= fp.Y and my <= fp.Y + fs.Y) then
                                closePanel()
                            end
                        end
                    end
                end
            end)

            registerOverlay(closePanel)
        end

        local b = btn(f)
        b.MouseEnter:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = theme.ElementHover })
        end)
        b.MouseLeave:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = cfg.Color or theme.Element })
        end)
        b.MouseButton1Click:Connect(function()
            if disabled then return end
            open = not open
            if open then
                closeAllOverlays()
                open = true
                buildPanel()
            else
                closePanel()
            end
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get() return value end
        function obj:Set(col)
            value = col
            rgb[1] = math.floor(col.R * 255)
            rgb[2] = math.floor(col.G * 255)
            rgb[3] = math.floor(col.B * 255)
            preview.BackgroundColor3 = col
            if open then closeAllOverlays(); open = true; buildPanel() end
        end
        function obj:SetDisabled(v) disabled = v; tw(f, { BackgroundTransparency = v and 0.4 or 0 }) end
        return obj
    end

    function Tab:Keybind(cfg)
        cfg = cfg or {}
        local value     = cfg.Key      or Enum.KeyCode.F
        local disabled  = cfg.Disabled or false
        local listening = false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 92)

        local keyBox = frame(f, theme.InputBg, UDim2.new(0, 80, 0, 26))
        keyBox.Position = UDim2.new(1, -82, 0.5, -13)
        corner(keyBox, CORNER_SM)
        stroke(keyBox, theme.ElementStroke2, 1)

        local keyL = lbl(keyBox, "[" .. keyName(value) .. "]", theme.Accent, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        keyL.Size        = UDim2.fromScale(1, 1)
        keyL.TextTruncate = Enum.TextTruncate.None

        local b = btn(f)
        b.MouseEnter:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = theme.ElementHover })
        end)
        b.MouseLeave:Connect(function()
            if disabled then return end
            tw(f, { BackgroundColor3 = cfg.Color or theme.Element })
        end)
        b.MouseButton1Click:Connect(function()
            if disabled or listening then return end
            listening       = true
            keyL.Text       = "[ ... ]"
            keyL.TextColor3 = theme.Warning
            tw(keyBox, { BackgroundColor3 = theme.ElementActive })
            local conn
            conn = UserInputService.InputBegan:Connect(function(i, gp)
                if gp then return end
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    value           = i.KeyCode
                    listening       = false
                    keyL.Text       = "[" .. keyName(value) .. "]"
                    keyL.TextColor3 = theme.Accent
                    tw(keyBox, { BackgroundColor3 = theme.InputBg })
                    conn:Disconnect()
                    task.spawn(function() pcall(cfg.Callback or function() end, value) end)
                end
            end)
        end)

        if cfg.OnPress then
            UserInputService.InputBegan:Connect(function(i, gp)
                if gp or listening or disabled then return end
                if i.KeyCode == value then
                    task.spawn(function() pcall(cfg.OnPress, value) end)
                end
            end)
        end

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get() return value end
        function obj:Set(kc) value = kc; keyL.Text = "[" .. keyName(kc) .. "]" end
        function obj:SetDisabled(v) disabled = v; tw(f, { BackgroundTransparency = v and 0.4 or 0 }) end
        return obj
    end

    function Tab:KeybindButton(cfg)
        cfg = cfg or {}
        local value     = cfg.Key       or Enum.KeyCode.F
        local disabled  = cfg.Disabled  or false
        local listening = false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 130)

        local keyBox = frame(f, theme.InputBg, UDim2.new(0, 48, 0, 22))
        keyBox.Position = UDim2.new(1, -120, 0.5, -11)
        corner(keyBox, CORNER_SM)
        stroke(keyBox, theme.ElementStroke2, 1)

        local keyL = lbl(keyBox, keyName(value), theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        keyL.Size        = UDim2.fromScale(1, 1)
        keyL.TextTruncate = Enum.TextTruncate.None

        local execBox = frame(f, theme.Accent, UDim2.new(0, 60, 0, 26))
        execBox.Position = UDim2.new(1, -62, 0.5, -13)
        corner(execBox, CORNER_SM)

        local execL = lbl(execBox, cfg.ButtonText or "Run", Color3.fromRGB(10, 10, 10), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        execL.Size        = UDim2.fromScale(1, 1)
        execL.TextTruncate = Enum.TextTruncate.None

        local eb = btn(execBox, UDim2.fromScale(1, 1), nil, 3)
        eb.MouseButton1Click:Connect(function()
            if disabled then return end
            ripple(execBox, theme)
            task.spawn(function() pcall(cfg.Callback or function() end) end)
        end)
        eb.MouseEnter:Connect(function() tw(execBox, { BackgroundColor3 = theme.AccentLight }) end)
        eb.MouseLeave:Connect(function() tw(execBox, { BackgroundColor3 = theme.Accent }) end)

        local kb = btn(keyBox, UDim2.fromScale(1, 1), nil, 3)
        kb.MouseButton1Click:Connect(function()
            if disabled or listening then return end
            listening = true
            keyL.Text       = "..."
            keyL.TextColor3 = theme.Warning
            local conn
            conn = UserInputService.InputBegan:Connect(function(i, gp)
                if gp then return end
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    value           = i.KeyCode
                    listening       = false
                    keyL.Text       = keyName(value)
                    keyL.TextColor3 = theme.Accent
                    conn:Disconnect()
                end
            end)
        end)

        UserInputService.InputBegan:Connect(function(i, gp)
            if gp or listening or disabled then return end
            if i.KeyCode == value then
                task.spawn(function() pcall(cfg.Callback or function() end) end)
            end
        end)

        local hb = btn(f, UDim2.new(1, -194, 1, 0))
        hb.MouseEnter:Connect(function() if not disabled then tw(f, { BackgroundColor3 = theme.ElementHover }) end end)
        hb.MouseLeave:Connect(function() if not disabled then tw(f, { BackgroundColor3 = cfg.Color or theme.Element }) end end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:GetKey() return value end
        function obj:SetKey(kc) value = kc; keyL.Text = keyName(kc) end
        function obj:SetDisabled(v) disabled = v; tw(f, { BackgroundTransparency = v and 0.4 or 0 }) end
        return obj
    end

    function Tab:Label(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 0))
        f.BackgroundTransparency = 1
        f.AutomaticSize = Enum.AutomaticSize.Y

        local tl = lbl(f, cfg.Title or "", cfg.Color or theme.TextPrimary, cfg.TextSize or 13, cfg.Font or Enum.Font.GothamMedium)
        tl.Size        = UDim2.new(1, 0, 0, 0)
        tl.AutomaticSize = Enum.AutomaticSize.Y
        tl.TextWrapped = true
        tl.TextTruncate = Enum.TextTruncate.None
        tl.TextYAlignment = Enum.TextYAlignment.Top
        tl.TextXAlignment = cfg.Align or Enum.TextXAlignment.Left

        f.Parent = page

        local obj = {}
        function obj:Set(t) tl.Text = t end
        function obj:SetColor(c) tl.TextColor3 = c end
        return obj
    end

    function Tab:Divider(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 20))
        f.BackgroundTransparency = 1

        local line = frame(f, cfg.Color or theme.ElementStroke, UDim2.new(1, 0, 0, 1))
        line.AnchorPoint = Vector2.new(0, 0.5)
        line.Position    = UDim2.new(0, 0, 0.5, 0)

        if cfg.Label and cfg.Label ~= "" then
            local bg = frame(f, theme.Background, UDim2.new(0, 0, 1, 0))
            bg.AutomaticSize  = Enum.AutomaticSize.X
            bg.AnchorPoint    = Vector2.new(0.5, 0)
            bg.Position       = UDim2.new(0.5, 0, 0, 0)
            bg.BorderSizePixel = 0
            local ll = lbl(bg, "  " .. cfg.Label .. "  ", theme.TextDisabled, 11, Enum.Font.Gotham, Enum.TextXAlignment.Center)
            ll.Size        = UDim2.new(1, 0, 1, 0)
            ll.TextTruncate = Enum.TextTruncate.None
        end

        f.Parent = page
        return f
    end

    function Tab:Space(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, cfg.Height or 8))
        f.BackgroundTransparency = 1
        f.Parent = page
        return f
    end

    function Tab:Paragraph(cfg)
        cfg = cfg or {}
        local outer = frame(page, cfg.Color or theme.CardBg, UDim2.new(1, 0, 0, 0))
        outer.AutomaticSize = Enum.AutomaticSize.Y
        corner(outer, CORNER_EL)
        stroke(outer, theme.CardStroke, 1)

        local inner = frame(outer, Color3.fromRGB(0, 0, 0), UDim2.fromScale(1, 1))
        inner.BackgroundTransparency = 1
        inner.AutomaticSize          = Enum.AutomaticSize.Y
        pad(inner, 10, 10, 14, 14)

        local lay = Instance.new("UIListLayout")
        lay.Padding           = UDim.new(0, 5)
        lay.FillDirection     = Enum.FillDirection.Vertical
        lay.HorizontalAlignment = Enum.HorizontalAlignment.Left
        lay.SortOrder         = Enum.SortOrder.LayoutOrder
        lay.Parent            = inner

        if cfg.Title and cfg.Title ~= "" then
            local tl = lbl(inner, cfg.Title, theme.TextPrimary, 13, Enum.Font.GothamBold)
            tl.Size             = UDim2.new(1, 0, 0, 0)
            tl.AutomaticSize    = Enum.AutomaticSize.Y
            tl.TextWrapped      = true
            tl.TextTruncate     = Enum.TextTruncate.None
            tl.TextXAlignment   = Enum.TextXAlignment.Left
            tl.TextYAlignment   = Enum.TextYAlignment.Top
        end

        if cfg.Desc and cfg.Desc ~= "" then
            local dl = lbl(inner, cfg.Desc, theme.TextSecondary, 12, Enum.Font.Gotham)
            dl.Size           = UDim2.new(1, 0, 0, 0)
            dl.AutomaticSize  = Enum.AutomaticSize.Y
            dl.TextWrapped    = true
            dl.TextTruncate   = Enum.TextTruncate.None
            dl.TextXAlignment = Enum.TextXAlignment.Left
            dl.TextYAlignment = Enum.TextYAlignment.Top
        end

        outer.Parent = page
        return outer
    end

    function Tab:Card(cfg)
        cfg = cfg or {}
        local h = cfg.Height or 78

        local f = frame(page, cfg.Color or theme.CardBg, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.CardStroke, 1)
        pad(f, 10, 10, 14, 14)

        if cfg.AccentColor then
            local abar = frame(f, cfg.AccentColor, UDim2.new(0, 3, 0.65, 0))
            abar.Position = UDim2.new(0, -14, 0.175, 0)
            corner(abar, UDim.new(0, 2))
        end

        if cfg.Icon then
            local ic = lbl(f, cfg.Icon, theme.Accent, 20, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            ic.Size     = UDim2.new(0, 26, 0, 26)
            ic.Position = UDim2.new(1, -30, 0, 0)
            ic.TextTruncate = Enum.TextTruncate.None
        end

        if cfg.Title and cfg.Title ~= "" then
            local tl = lbl(f, cfg.Title, theme.TextPrimary, 13, Enum.Font.GothamBold)
            tl.Size     = UDim2.new(1, -36, 0, 17)
            tl.Position = UDim2.new(0, 0, 0, 2)
        end

        local valLbl = nil
        if cfg.Value ~= nil then
            valLbl = lbl(f, tostring(cfg.Value), cfg.ValueColor or theme.Accent, 22, Enum.Font.GothamBold)
            valLbl.Size     = UDim2.new(1, 0, 0, 28)
            valLbl.Position = UDim2.new(0, 0, 0, 22)
            valLbl.TextTruncate = Enum.TextTruncate.None
        end

        if cfg.Desc and cfg.Desc ~= "" then
            local dl = lbl(f, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
            dl.Size     = UDim2.new(1, 0, 0, 14)
            dl.Position = UDim2.new(0, 0, 1, -18)
        end

        if cfg.Callback then
            local b = btn(f)
            b.MouseButton1Click:Connect(function()
                task.spawn(function() pcall(cfg.Callback) end)
            end)
            b.MouseEnter:Connect(function() tw(f, { BackgroundColor3 = theme.ElementHover }) end)
            b.MouseLeave:Connect(function() tw(f, { BackgroundColor3 = cfg.Color or theme.CardBg }) end)
        end

        f.Parent = page

        local obj = { _frame = f }
        function obj:SetValue(v)
            if valLbl then valLbl.Text = tostring(v) end
        end
        return obj
    end

    function Tab:CardRow(cards)
        cards = cards or {}
        local rowH = 0
        for _, c in ipairs(cards) do rowH = math.max(rowH, c.Height or 76) end

        local rowF = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, rowH))
        rowF.BackgroundTransparency = 1

        local rlay = Instance.new("UIListLayout")
        rlay.FillDirection       = Enum.FillDirection.Horizontal
        rlay.VerticalAlignment   = Enum.VerticalAlignment.Center
        rlay.HorizontalAlignment = Enum.HorizontalAlignment.Left
        rlay.Padding             = UDim.new(0, 6)
        rlay.Parent              = rowF

        local n    = #cards
        local objs = {}

        for i, cc in ipairs(cards) do
            local cw = math.floor((1 / n) * 100)
            local cf = frame(rowF, cc.Color or theme.CardBg, UDim2.new(cw / 100, i < n and -4 or 0, 1, 0))
            cf.BorderSizePixel = 0
            corner(cf, CORNER_EL)
            stroke(cf, theme.CardStroke, 1)
            pad(cf, 10, 10, 12, 12)

            if cc.Title then
                local tl = lbl(cf, cc.Title, theme.TextSecondary, 11, Enum.Font.Gotham)
                tl.Size = UDim2.new(1, 0, 0, 14)
                tl.Position = UDim2.new(0, 0, 0, 0)
            end

            local vl = nil
            if cc.Value ~= nil then
                vl = lbl(cf, tostring(cc.Value), cc.ValueColor or theme.Accent, 18, Enum.Font.GothamBold)
                vl.Size     = UDim2.new(1, 0, 0, 22)
                vl.Position = UDim2.new(0, 0, 0, 16)
                vl.TextTruncate = Enum.TextTruncate.None
            end

            if cc.Sub then
                local sl = lbl(cf, cc.Sub, theme.TextDisabled, 10, Enum.Font.Gotham)
                sl.Size     = UDim2.new(1, 0, 0, 12)
                sl.Position = UDim2.new(0, 0, 1, -14)
            end

            local o = { _frame = cf }
            function o:SetValue(v) if vl then vl.Text = tostring(v) end end
            table.insert(objs, o)
        end

        rowF.Parent = page
        return objs
    end

    function Tab:ProfileFrame(cfg)
        cfg = cfg or {}
        local userId   = cfg.UserId   or LocalPlayer.UserId
        local username = cfg.Username or LocalPlayer.Name
        local desc     = cfg.Desc     or LocalPlayer.Name
        local badges   = cfg.Badges   or {}

        local h = 82 + (#badges > 0 and 10 or 0)
        local f = frame(page, cfg.Color or theme.ProfileBg, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.CardStroke, 1)

        local strip = frame(f, theme.Accent, UDim2.new(1, 0, 0, 3))
        strip.BackgroundTransparency = 0.75
        corner(strip, UDim.new(0, 2))

        local avBg = frame(f, theme.ElementStroke, UDim2.new(0, 52, 0, 52))
        avBg.Position = UDim2.new(0, 14, 0.5, -26)
        corner(avBg, UDim.new(1, 0))
        stroke(avBg, theme.Accent, 2)

        local av = Instance.new("ImageLabel")
        av.Size              = UDim2.new(1, -4, 1, -4)
        av.Position          = UDim2.new(0, 2, 0, 2)
        av.BackgroundColor3  = theme.Element
        av.Image             = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
        av.ScaleType         = Enum.ScaleType.Crop
        av.ZIndex            = 2
        corner(av, UDim.new(1, 0))
        av.Parent = avBg

        local dot = frame(avBg, theme.Success, UDim2.new(0, 11, 0, 11))
        dot.Position = UDim2.new(1, -11, 1, -11)
        dot.ZIndex   = 3
        corner(dot, UDim.new(1, 0))
        stroke(dot, theme.ProfileBg, 2)

        local nameLbl = lbl(f, username, theme.TextPrimary, 13, Enum.Font.GothamBold)
        nameLbl.Size     = UDim2.new(1, -120, 0, 17)
        nameLbl.Position = UDim2.new(0, 74, 0, 14)

        local descLbl = lbl(f, desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        descLbl.Size     = UDim2.new(1, -120, 0, 14)
        descLbl.Position = UDim2.new(0, 74, 0, 32)

        if #badges > 0 then
            local badgeRow = frame(f, Color3.fromRGB(0, 0, 0), UDim2.new(1, -120, 0, 17))
            badgeRow.Position              = UDim2.new(0, 74, 0, 48)
            badgeRow.BackgroundTransparency = 1

            local blay = Instance.new("UIListLayout")
            blay.FillDirection     = Enum.FillDirection.Horizontal
            blay.VerticalAlignment = Enum.VerticalAlignment.Center
            blay.Padding           = UDim.new(0, 4)
            blay.Parent            = badgeRow

            for _, badge in ipairs(badges) do
                local bf = frame(badgeRow, badge.Color or theme.Accent, UDim2.new(0, 0, 0, 15))
                bf.AutomaticSize              = Enum.AutomaticSize.X
                bf.BackgroundTransparency     = 0.76
                corner(bf, UDim.new(0, 4))
                pad(bf, 0, 0, 5, 5)
                local bl = lbl(bf, badge.Text or "•", badge.Color or theme.Accent, 9, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
                bl.Size          = UDim2.new(0, 0, 1, 0)
                bl.AutomaticSize = Enum.AutomaticSize.X
                bl.TextTruncate  = Enum.TextTruncate.None
            end
        end

        if cfg.Role then
            local rl = lbl(f, cfg.Role, theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            rl.Size     = UDim2.new(0, 90, 0, 16)
            rl.Position = UDim2.new(1, -98, 0, 14)
        end

        f.Parent = page
        return { _frame = f }
    end

    function Tab:Badge(cfg)
        cfg = cfg or {}
        local wrapper = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 34))
        wrapper.BackgroundTransparency = 1

        local lay = Instance.new("UIListLayout")
        lay.FillDirection     = Enum.FillDirection.Horizontal
        lay.VerticalAlignment = Enum.VerticalAlignment.Center
        lay.Padding           = UDim.new(0, 6)
        lay.Parent            = wrapper

        local badges = type(cfg[1]) == "table" and cfg or { cfg }
        for _, badge in ipairs(badges) do
            local bf = frame(wrapper, badge.Color or theme.Accent, UDim2.new(0, 0, 0, 22))
            bf.AutomaticSize              = Enum.AutomaticSize.X
            bf.BackgroundTransparency     = 0.78
            corner(bf, UDim.new(1, 0))
            pad(bf, 0, 0, 8, 8)
            local bl = lbl(bf, badge.Text or "Badge", badge.Color or theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            bl.Size          = UDim2.new(0, 0, 1, 0)
            bl.AutomaticSize = Enum.AutomaticSize.X
            bl.TextTruncate  = Enum.TextTruncate.None
        end

        wrapper.Parent = page
        return { _frame = wrapper }
    end

    function Tab:ProgressBar(cfg)
        cfg = cfg or {}
        local value   = math.clamp(cfg.Value or 0, 0, 1)
        local showPct = cfg.ShowPercent ~= false

        local frameH = 52 + (cfg.Desc and cfg.Desc ~= "" and 16 or 0)
        local f      = baseEl(theme, { Color = cfg.Color, Transparency = cfg.Transparency, Desc = "", Title = "" })
        f.Size             = UDim2.new(1, 0, 0, frameH)
        f.ClipsDescendants = true

        local tl = lbl(f, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        tl.Size     = UDim2.new(1, showPct and -42 or 0, 0, 16)
        tl.Position = UDim2.new(0, 0, 0, 10)

        local pctLbl = nil
        if showPct then
            pctLbl = lbl(f, math.floor(value * 100) .. "%", theme.Accent, 12, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            pctLbl.Size     = UDim2.new(0, 38, 0, 16)
            pctLbl.Position = UDim2.new(1, -40, 0, 10)
            pctLbl.TextTruncate = Enum.TextTruncate.None
        end

        local trackY = (cfg.Desc and cfg.Desc ~= "") and 50 or 34

        local track = frame(f, theme.ElementStroke2, UDim2.new(1, 0, 0, 8))
        track.Position = UDim2.new(0, 0, 0, trackY)
        corner(track, UDim.new(1, 0))

        local fill = frame(track, cfg.BarColor or theme.Accent, UDim2.new(value, 0, 1, 0))
        corner(fill, UDim.new(1, 0))

        f.Parent = page

        local obj = {}
        function obj:Set(v)
            value = math.clamp(v, 0, 1)
            tw(fill, { Size = UDim2.new(value, 0, 1, 0) }, ANIM_MED)
            if pctLbl then pctLbl.Text = math.floor(value * 100) .. "%" end
        end
        function obj:Get() return value end
        return obj
    end

    function Tab:Separator(cfg)
        cfg = cfg or {}
        return Tab:Divider(cfg)
    end

    function Tab:Section(cfg)
        cfg = cfg or {}
        local wrapper = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 24))
        wrapper.BackgroundTransparency = 1

        local tl = lbl(wrapper, (cfg.Title or ""):upper(), theme.TextDisabled, 10, Enum.Font.GothamBold)
        tl.Size         = UDim2.new(1, 0, 1, 0)
        tl.TextTruncate = Enum.TextTruncate.None

        wrapper.Parent = page
        return wrapper
    end

    function Tab:NumberInput(cfg)
        cfg = cfg or {}
        local min      = cfg.Min   or 0
        local max      = cfg.Max   or math.huge
        local step     = cfg.Step  or 1
        local value    = math.clamp(cfg.Value or min, min, max)
        local disabled = cfg.Disabled or false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 90)

        local controlBox = frame(f, theme.InputBg, UDim2.new(0, 78, 0, 26))
        controlBox.Position = UDim2.new(1, -80, 0.5, -13)
        corner(controlBox, CORNER_SM)
        stroke(controlBox, theme.ElementStroke, 1)

        local minusBtn = frame(controlBox, theme.ElementHover, UDim2.new(0, 26, 1, 0))
        corner(minusBtn, UDim.new(0, 4))
        local minusL = lbl(minusBtn, "–", theme.TextPrimary, 14, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        minusL.Size        = UDim2.fromScale(1, 1)
        minusL.TextTruncate = Enum.TextTruncate.None

        local numBox = Instance.new("TextBox")
        numBox.Size               = UDim2.new(1, -52, 1, 0)
        numBox.Position           = UDim2.new(0, 26, 0, 0)
        numBox.BackgroundTransparency = 1
        numBox.Text               = tostring(value)
        numBox.TextColor3         = theme.Accent
        numBox.TextSize           = 12
        numBox.Font               = Enum.Font.GothamBold
        numBox.TextXAlignment     = Enum.TextXAlignment.Center
        numBox.ClearTextOnFocus   = false
        numBox.ZIndex             = 3
        numBox.Parent             = controlBox

        local plusBtn = frame(controlBox, theme.ElementHover, UDim2.new(0, 26, 1, 0))
        plusBtn.Position = UDim2.new(1, -26, 0, 0)
        corner(plusBtn, UDim.new(0, 4))
        local plusL = lbl(plusBtn, "+", theme.TextPrimary, 14, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        plusL.Size        = UDim2.fromScale(1, 1)
        plusL.TextTruncate = Enum.TextTruncate.None

        local function applyValue(v)
            value = math.clamp(v, min, max)
            numBox.Text = tostring(value)
            task.spawn(function() pcall(cfg.Callback or function() end, value) end)
        end

        local mb = btn(minusBtn, UDim2.fromScale(1, 1), nil, 4)
        mb.MouseButton1Click:Connect(function()
            if disabled then return end
            applyValue(value - step)
        end)
        mb.MouseEnter:Connect(function() tw(minusBtn, { BackgroundColor3 = theme.ElementActive }) end)
        mb.MouseLeave:Connect(function() tw(minusBtn, { BackgroundColor3 = theme.ElementHover }) end)

        local pb = btn(plusBtn, UDim2.fromScale(1, 1), nil, 4)
        pb.MouseButton1Click:Connect(function()
            if disabled then return end
            applyValue(value + step)
        end)
        pb.MouseEnter:Connect(function() tw(plusBtn, { BackgroundColor3 = theme.ElementActive }) end)
        pb.MouseLeave:Connect(function() tw(plusBtn, { BackgroundColor3 = theme.ElementHover }) end)

        numBox.FocusLost:Connect(function()
            local parsed = tonumber(numBox.Text)
            if parsed then applyValue(parsed) else numBox.Text = tostring(value) end
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = {}
        function obj:Get() return value end
        function obj:Set(v) applyValue(v) end
        return obj
    end

    function Tab:Table(cfg)
        cfg = cfg or {}
        local headers = cfg.Headers or {}
        local rows    = cfg.Rows    or {}
        local rowH    = 28
        local headH   = 30
        local totalH  = headH + #rows * rowH + 2

        local f = frame(page, theme.CardBg, UDim2.new(1, 0, 0, totalH))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.CardStroke, 1)
        f.ClipsDescendants = true

        local headRow = frame(f, theme.ElementStroke2, UDim2.new(1, 0, 0, headH))
        local colCount = #headers
        for i, h in ipairs(headers) do
            local cw = 1 / colCount
            local hl = lbl(headRow, tostring(h), theme.TextSecondary, 11, Enum.Font.GothamBold)
            hl.Size         = UDim2.new(cw, -8, 1, 0)
            hl.Position     = UDim2.new(cw * (i - 1), 8, 0, 0)
            hl.TextTruncate = Enum.TextTruncate.AtEnd
        end

        for ri, row in ipairs(rows) do
            local rowF = frame(f, ri % 2 == 0 and theme.Element or Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, rowH))
            rowF.Position              = UDim2.new(0, 0, 0, headH + (ri - 1) * rowH)
            rowF.BackgroundTransparency = ri % 2 == 0 and 0 or 1

            for ci, cell in ipairs(row) do
                local cw = 1 / colCount
                local cl = lbl(rowF, tostring(cell), theme.TextPrimary, 11, Enum.Font.Gotham)
                cl.Size         = UDim2.new(cw, -8, 1, 0)
                cl.Position     = UDim2.new(cw * (ci - 1), 8, 0, 0)
                cl.TextTruncate = Enum.TextTruncate.AtEnd
            end
        end

        f.Parent = page
        return { _frame = f }
    end
end

local function CreateLibrary(cfg)
    cfg = cfg or {}
    local title   = cfg.Title   or "TryxLib"
    local theme   = cfg.Theme   or Themes.Default
    local toggleKey = cfg.Key   or Enum.KeyCode.RightShift
    local startOpen = cfg.Open \~= false

    local gui = Instance.new("ScreenGui")
    gui.Name            = "TryxLib_" .. title
    gui.ResetOnSpawn    = false
    gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder    = 100
    gui.IgnoreGuiInset  = true
    gui.Parent          = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

    local vp  = Camera.ViewportSize
    local win = frame(gui, theme.Background, UDim2.new(0, DEFAULT_W, 0, DEFAULT_H))
    win.AnchorPoint    = Vector2.new(0.5, 0.5)
    win.Position       = UDim2.new(0.5, 0, 0.5, 0)
    win.BorderSizePixel = 0
    win.ClipsDescendants = false
    win.Visible        = startOpen
    corner(win, CORNER_WIN)
    stroke(win, theme.ElementStroke, 1)
    shadow(win)

    local topBar = frame(win, theme.TopBar, UDim2.new(1, 0, 0, TOPBAR_H))
    corner(topBar, CORNER_WIN)

    local topBarBottom = frame(topBar, theme.TopBar, UDim2.new(1, 0, 0.5, 0))
    topBarBottom.Position = UDim2.new(0, 0, 0.5, 0)

    local titleLbl = lbl(topBar, title, theme.TextPrimary, 13, Enum.Font.GothamBold)
    titleLbl.Size     = UDim2.new(1, -80, 1, 0)
    titleLbl.Position = UDim2.new(0, 16, 0, 0)
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local closeBtn = frame(topBar, theme.Danger, UDim2.new(0, 12, 0, 12))
    closeBtn.Position  = UDim2.new(1, -20, 0.5, -6)
    closeBtn.ZIndex    = 3
    corner(closeBtn, UDim.new(1, 0))
    local closeBtnB = btn(topBar, UDim2.new(0, 22, 0, 22), UDim2.new(1, -24, 0.5, -11), 4)
    closeBtnB.MouseButton1Click:Connect(function()
        tw(win, { Size = UDim2.new(0, DEFAULT_W, 0, 0) }, ANIM_FAST)
        task.wait(ANIM_FAST + 0.02)
        win.Visible = false
        win.Size    = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H)
    end)
    closeBtnB.MouseEnter:Connect(function() tw(closeBtn, { BackgroundColor3 = theme.DangerDark }) end)
    closeBtnB.MouseLeave:Connect(function() tw(closeBtn, { BackgroundColor3 = theme.Danger }) end)

    local minBtn = frame(topBar, theme.Warning, UDim2.new(0, 12, 0, 12))
    minBtn.Position = UDim2.new(1, -38, 0.5, -6)
    minBtn.ZIndex   = 3
    corner(minBtn, UDim.new(1, 0))
    local minBtnB = btn(topBar, UDim2.new(0, 22, 0, 22), UDim2.new(1, -42, 0.5, -11), 4)
    local minimized = false
    minBtnB.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tw(win, { Size = UDim2.new(0, DEFAULT_W, 0, TOPBAR_H) }, ANIM_MED)
        else
            tw(win, { Size = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H) }, ANIM_MED)
        end
    end)
    minBtnB.MouseEnter:Connect(function() tw(minBtn, { BackgroundColor3 = theme.WarningDark }) end)
    minBtnB.MouseLeave:Connect(function() tw(minBtn, { BackgroundColor3 = theme.Warning }) end)

    makeDraggable(topBar, win)

    local sideBar = frame(win, theme.Sidebar, UDim2.new(0, SIDEBAR_W, 1, -TOPBAR_H))
    sideBar.Position = UDim2.new(0, 0, 0, TOPBAR_H)

    local tabList = Instance.new("ScrollingFrame")
    tabList.Size                   = UDim2.fromScale(1, 1)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel        = 0
    tabList.CanvasSize             = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    tabList.ScrollBarThickness     = 3
    tabList.ScrollBarImageColor3   = theme.ScrollBar
    tabList.ScrollingDirection     = Enum.ScrollingDirection.Y
    tabList.ElasticBehavior        = Enum.ElasticBehavior.Never
    tabList.Parent                 = sideBar
    pad(tabList, 8, 8, 6, 6)

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding         = UDim.new(0, ELEMENT_PAD)
    tabLayout.SortOrder       = Enum.SortOrder.LayoutOrder
    tabLayout.FillDirection   = Enum.FillDirection.Vertical
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent          = tabList

    local contentArea = frame(win, theme.BackgroundAlt, UDim2.new(1, -SIDEBAR_W, 1, -TOPBAR_H))
    contentArea.Position = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)

    local resizeHandle = frame(win, Color3.fromRGB(0, 0, 0), UDim2.new(0, 12, 0, 12))
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.AnchorPoint           = Vector2.new(1, 1)
    resizeHandle.Position              = UDim2.new(1, 0, 1, 0)
    resizeHandle.ZIndex                = 10
    makeResizable(resizeHandle, win)

    local tabs       = {}
    local activeTab  = nil
    local tabObjects = {}

    local function activateTab(tabObj)
        if activeTab == tabObj then return end
        closeAllOverlays()
        if activeTab then
            activeTab._page.Visible = false
            tw(activeTab._btn, { BackgroundColor3 = theme.TabInactive })
            local s = activeTab._btn:FindFirstChildWhichIsA("UIStroke")
            if s then s.Thickness = 0 end
        end
        activeTab = tabObj
        tabObj._page.Visible = true
        tw(tabObj._btn, { BackgroundColor3 = theme.TabActive })
        local s = tabObj._btn:FindFirstChildWhichIsA("UIStroke")
        if s then s.Thickness = 1.5 end
    end

    local Library = {}
    Library._gui   = gui
    Library._win   = win
    Library._theme = theme

    function Library:Tab(cfg)
        cfg = cfg or {}
        local tabTitle = cfg.Title or "Tab"
        local tabIcon  = cfg.Icon  or ""
        local tabOrder = #tabs + 1

        local tabBtn = frame(tabList, theme.TabInactive, UDim2.new(1, 0, 0, 36))
        tabBtn.LayoutOrder = tabOrder
        corner(tabBtn, CORNER_SM)
        local tabS = stroke(tabBtn, theme.TabStroke, 0)
        tabS.Thickness = 0

        local tabContentFrame = frame(tabBtn, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 1, 0))
        tabContentFrame.BackgroundTransparency = 1

        if tabIcon \~= "" then
            local ic = lbl(tabContentFrame, tabIcon, theme.TextSecondary, 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            ic.Size     = UDim2.new(0, 20, 1, 0)
            ic.Position = UDim2.new(0, 6, 0, 0)
            ic.TextTruncate = Enum.TextTruncate.None
        end

        local tl = lbl(tabContentFrame, tabTitle, theme.TextSecondary, 12, Enum.Font.GothamMedium)
        tl.Size     = UDim2.new(1, tabIcon \~= "" and -28 or -12, 1, 0)
        tl.Position = UDim2.new(0, tabIcon \~= "" and 28 or 6, 0, 0)
        tl.TextTruncate = Enum.TextTruncate.AtEnd

        local tabPage = Instance.new("ScrollingFrame")
        tabPage.Size                   = UDim2.fromScale(1, 1)
        tabPage.BackgroundTransparency = 1
        tabPage.BorderSizePixel        = 0
        tabPage.CanvasSize             = UDim2.new(0, 0, 0, 0)
        tabPage.AutomaticCanvasSize    = Enum.AutomaticSize.Y
        tabPage.ScrollBarThickness     = 3
        tabPage.ScrollBarImageColor3   = theme.ScrollBar
        tabPage.ScrollingDirection     = Enum.ScrollingDirection.Y
        tabPage.ElasticBehavior        = Enum.ElasticBehavior.Never
        tabPage.Visible                = false
        tabPage.Parent                 = contentArea
        pad(tabPage, 8, 8, 8, 8)

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding           = UDim.new(0, ELEMENT_PAD)
        pageLayout.SortOrder         = Enum.SortOrder.LayoutOrder
        pageLayout.FillDirection     = Enum.FillDirection.Vertical
        pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLayout.Parent            = tabPage

        local Tab = {}
        Tab._btn   = tabBtn
        Tab._page  = tabPage
        Tab._theme = theme
        Tab._gui   = gui
        function Tab:_addElement(el) el.Parent = tabPage end

        injectElements(Tab, theme, tabPage, gui)

        local tb = btn(tabBtn, UDim2.fromScale(1, 1), nil, 3)
        tb.MouseEnter:Connect(function()
            if activeTab == Tab then return end
            tw(tabBtn, { BackgroundColor3 = theme.TabHover })
            tw(tl, { TextColor3 = theme.TextPrimary })
        end)
        tb.MouseLeave:Connect(function()
            if activeTab == Tab then return end
            tw(tabBtn, { BackgroundColor3 = theme.TabInactive })
            tw(tl, { TextColor3 = theme.TextSecondary })
        end)
        tb.MouseButton1Click:Connect(function() activateTab(Tab) end)

        table.insert(tabs, Tab)
        table.insert(tabObjects, Tab)

        if #tabs == 1 then activateTab(Tab) end

        return Tab
    end

    function Library:Notify(cfg)
        doNotify(cfg, theme)
    end

    function Library:SetTheme(newTheme)
        theme = newTheme
    end

    function Library:Toggle()
        if win.Visible then
            tw(win, { Size = UDim2.new(0, DEFAULT_W, 0, 0) }, ANIM_FAST)
            task.wait(ANIM_FAST + 0.02)
            win.Visible = false
            win.Size    = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H)
        else
            win.Visible = true
            tw(win, { Size = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H) }, ANIM_MED)
        end
    end

    function Library:Destroy()
        gui:Destroy()
    end

    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == toggleKey then
            Library:Toggle()
        end
    end)

    return Library
end

local TryxLib = {}

function TryxLib.new(cfg)
    return CreateLibrary(cfg)
end

return TryxLib
