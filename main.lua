
local TryxLib = {}
TryxLib.__index = TryxLib

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

local ANIM_FAST    = 0.14
local ANIM_MED     = 0.22
local ANIM_SLOW    = 0.35
local EASE_OUT     = Enum.EasingStyle.Quart
local EASE_DIR     = Enum.EasingDirection.Out

local CORNER_WIN   = UDim.new(0, 10)
local CORNER_EL    = UDim.new(0, 7)
local CORNER_SM    = UDim.new(0, 5)
local CORNER_XS    = UDim.new(0, 4)
local CORNER_PILL  = UDim.new(1, 0)

local DEFAULT_W    = 560
local DEFAULT_H    = 440
local MIN_W        = 380
local MIN_H        = 280
local TOPBAR_H     = 42
local SIDEBAR_W    = 112
local ELEMENT_H    = 48
local OVERLAY_Z    = 8000

local Themes = {}

Themes.Default = {
    Name           = "Default",
    Background     = Color3.fromRGB(10, 10, 12),
    BackgroundAlt  = Color3.fromRGB(13, 13, 16),
    Sidebar        = Color3.fromRGB(11, 11, 14),
    TopBar         = Color3.fromRGB(9,  9,  11),
    Element        = Color3.fromRGB(18, 18, 22),
    ElementHover   = Color3.fromRGB(24, 24, 30),
    ElementActive  = Color3.fromRGB(28, 28, 36),
    ElementStroke  = Color3.fromRGB(36, 36, 46),
    ElementStroke2 = Color3.fromRGB(26, 26, 34),
    Accent         = Color3.fromRGB(218, 175, 55),
    AccentDark     = Color3.fromRGB(155, 124, 35),
    AccentLight    = Color3.fromRGB(240, 200, 90),
    AccentFg       = Color3.fromRGB(20, 16, 6),
    TextPrimary    = Color3.fromRGB(238, 238, 238),
    TextSecondary  = Color3.fromRGB(145, 145, 158),
    TextDisabled   = Color3.fromRGB(65,  65,  78),
    TabActive      = Color3.fromRGB(20, 20, 26),
    TabInactive    = Color3.fromRGB(11, 11, 14),
    TabHover       = Color3.fromRGB(16, 16, 22),
    TabStroke      = Color3.fromRGB(218, 175, 55),
    Notify         = Color3.fromRGB(15, 15, 19),
    NotifyStroke   = Color3.fromRGB(40, 40, 52),
    ScrollBar      = Color3.fromRGB(48, 48, 62),
    Danger         = Color3.fromRGB(210, 58,  58),
    DangerDark     = Color3.fromRGB(155, 38,  38),
    Success        = Color3.fromRGB(58,  188, 98),
    SuccessDark    = Color3.fromRGB(38,  138, 68),
    Warning        = Color3.fromRGB(218, 158, 38),
    WarningDark    = Color3.fromRGB(155, 110, 22),
    Info           = Color3.fromRGB(72,  148, 228),
    InfoDark       = Color3.fromRGB(48,  105, 175),
    InputBg        = Color3.fromRGB(11, 11, 14),
    CardBg         = Color3.fromRGB(15, 15, 19),
    CardStroke     = Color3.fromRGB(30, 30, 40),
    ProfileBg      = Color3.fromRGB(13, 13, 17),
    ShadowColor    = Color3.fromRGB(0,   0,   0),
}

Themes.Dark = {
    Name           = "Dark",
    Background     = Color3.fromRGB(7, 7, 7),
    BackgroundAlt  = Color3.fromRGB(11, 11, 11),
    Sidebar        = Color3.fromRGB(9, 9, 9),
    TopBar         = Color3.fromRGB(8, 8, 8),
    Element        = Color3.fromRGB(15, 15, 15),
    ElementHover   = Color3.fromRGB(21, 21, 21),
    ElementActive  = Color3.fromRGB(26, 26, 26),
    ElementStroke  = Color3.fromRGB(30, 30, 30),
    ElementStroke2 = Color3.fromRGB(22, 22, 22),
    Accent         = Color3.fromRGB(218, 175, 55),
    AccentDark     = Color3.fromRGB(155, 124, 35),
    AccentLight    = Color3.fromRGB(240, 200, 90),
    AccentFg       = Color3.fromRGB(20, 16, 6),
    TextPrimary    = Color3.fromRGB(232, 232, 232),
    TextSecondary  = Color3.fromRGB(138, 138, 138),
    TextDisabled   = Color3.fromRGB(58,  58,  58),
    TabActive      = Color3.fromRGB(17, 17, 17),
    TabInactive    = Color3.fromRGB(9, 9, 9),
    TabHover       = Color3.fromRGB(14, 14, 14),
    TabStroke      = Color3.fromRGB(218, 175, 55),
    Notify         = Color3.fromRGB(12, 12, 12),
    NotifyStroke   = Color3.fromRGB(34, 34, 34),
    ScrollBar      = Color3.fromRGB(42, 42, 42),
    Danger         = Color3.fromRGB(210, 58,  58),
    DangerDark     = Color3.fromRGB(155, 38,  38),
    Success        = Color3.fromRGB(58,  188, 98),
    SuccessDark    = Color3.fromRGB(38,  138, 68),
    Warning        = Color3.fromRGB(218, 158, 38),
    WarningDark    = Color3.fromRGB(155, 110, 22),
    Info           = Color3.fromRGB(72,  148, 228),
    InfoDark       = Color3.fromRGB(48,  105, 175),
    InputBg        = Color3.fromRGB(8, 8, 8),
    CardBg         = Color3.fromRGB(12, 12, 12),
    CardStroke     = Color3.fromRGB(26, 26, 26),
    ProfileBg      = Color3.fromRGB(10, 10, 10),
    ShadowColor    = Color3.fromRGB(0,  0,  0),
}

Themes.Midnight = {
    Name           = "Midnight",
    Background     = Color3.fromRGB(6, 6, 15),
    BackgroundAlt  = Color3.fromRGB(9, 9, 21),
    Sidebar        = Color3.fromRGB(8, 8, 18),
    TopBar         = Color3.fromRGB(7, 7, 16),
    Element        = Color3.fromRGB(13, 13, 28),
    ElementHover   = Color3.fromRGB(19, 19, 38),
    ElementActive  = Color3.fromRGB(24, 24, 46),
    ElementStroke  = Color3.fromRGB(32, 32, 58),
    ElementStroke2 = Color3.fromRGB(22, 22, 42),
    Accent         = Color3.fromRGB(138, 108, 255),
    AccentDark     = Color3.fromRGB(90,  68,  195),
    AccentLight    = Color3.fromRGB(175, 150, 255),
    AccentFg       = Color3.fromRGB(10,  8,   22),
    TextPrimary    = Color3.fromRGB(232, 232, 248),
    TextSecondary  = Color3.fromRGB(138, 138, 175),
    TextDisabled   = Color3.fromRGB(55,  55,  88),
    TabActive      = Color3.fromRGB(15, 15, 32),
    TabInactive    = Color3.fromRGB(8, 8, 18),
    TabHover       = Color3.fromRGB(12, 12, 26),
    TabStroke      = Color3.fromRGB(138, 108, 255),
    Notify         = Color3.fromRGB(11, 11, 22),
    NotifyStroke   = Color3.fromRGB(36, 36, 65),
    ScrollBar      = Color3.fromRGB(48, 48, 88),
    Danger         = Color3.fromRGB(210, 58,  58),
    DangerDark     = Color3.fromRGB(155, 38,  38),
    Success        = Color3.fromRGB(58,  188, 98),
    SuccessDark    = Color3.fromRGB(38,  138, 68),
    Warning        = Color3.fromRGB(218, 158, 38),
    WarningDark    = Color3.fromRGB(155, 110, 22),
    Info           = Color3.fromRGB(72,  148, 228),
    InfoDark       = Color3.fromRGB(48,  105, 175),
    InputBg        = Color3.fromRGB(7, 7, 17),
    CardBg         = Color3.fromRGB(10, 10, 23),
    CardStroke     = Color3.fromRGB(28, 28, 55),
    ProfileBg      = Color3.fromRGB(9, 9, 20),
    ShadowColor    = Color3.fromRGB(0,  0,  0),
}

Themes.Slate = {
    Name           = "Slate",
    Background     = Color3.fromRGB(10, 13, 18),
    BackgroundAlt  = Color3.fromRGB(13, 17, 24),
    Sidebar        = Color3.fromRGB(11, 15, 21),
    TopBar         = Color3.fromRGB(10, 13, 19),
    Element        = Color3.fromRGB(16, 21, 30),
    ElementHover   = Color3.fromRGB(22, 28, 40),
    ElementActive  = Color3.fromRGB(27, 34, 48),
    ElementStroke  = Color3.fromRGB(34, 42, 58),
    ElementStroke2 = Color3.fromRGB(24, 31, 44),
    Accent         = Color3.fromRGB(72, 148, 228),
    AccentDark     = Color3.fromRGB(46, 105, 175),
    AccentLight    = Color3.fromRGB(112, 178, 248),
    AccentFg       = Color3.fromRGB(6,  12,  22),
    TextPrimary    = Color3.fromRGB(220, 228, 242),
    TextSecondary  = Color3.fromRGB(128, 142, 168),
    TextDisabled   = Color3.fromRGB(52,  62,  80),
    TabActive      = Color3.fromRGB(18, 24, 35),
    TabInactive    = Color3.fromRGB(11, 15, 21),
    TabHover       = Color3.fromRGB(15, 20, 30),
    TabStroke      = Color3.fromRGB(72, 148, 228),
    Notify         = Color3.fromRGB(13, 17, 26),
    NotifyStroke   = Color3.fromRGB(36, 46, 66),
    ScrollBar      = Color3.fromRGB(44, 58, 82),
    Danger         = Color3.fromRGB(210, 58,  58),
    DangerDark     = Color3.fromRGB(155, 38,  38),
    Success        = Color3.fromRGB(58,  188, 98),
    SuccessDark    = Color3.fromRGB(38,  138, 68),
    Warning        = Color3.fromRGB(218, 158, 38),
    WarningDark    = Color3.fromRGB(155, 110, 22),
    Info           = Color3.fromRGB(72,  148, 228),
    InfoDark       = Color3.fromRGB(48,  105, 175),
    InputBg        = Color3.fromRGB(11, 14, 20),
    CardBg         = Color3.fromRGB(14, 18, 27),
    CardStroke     = Color3.fromRGB(28, 36, 52),
    ProfileBg      = Color3.fromRGB(12, 16, 24),
    ShadowColor    = Color3.fromRGB(0,  0,  0),
}

TryxLib.Themes = Themes

local function tw(obj, props, t, style, dir)
    t     = t     or ANIM_FAST
    style = style or EASE_OUT
    dir   = dir   or EASE_DIR
    local info = TweenInfo.new(t, style, dir)
    TweenService:Create(obj, info, props):Play()
end

local function frame(parent, color, size, pos)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = color  or Color3.fromRGB(18,18,22)
    f.Size             = size   or UDim2.fromScale(1, 1)
    f.Position         = pos    or UDim2.new()
    f.BorderSizePixel  = 0
    f.Parent           = parent
    return f
end

local function lbl(parent, text, color, size, font, xAlign, yAlign)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text            = text   or ""
    l.TextColor3      = color  or Color3.fromRGB(238,238,238)
    l.TextSize        = size   or 13
    l.Font            = font   or Enum.Font.Gotham
    l.TextXAlignment  = xAlign or Enum.TextXAlignment.Left
    l.TextYAlignment  = yAlign or Enum.TextYAlignment.Center
    l.Size            = UDim2.fromScale(1, 1)
    l.TextWrapped     = false
    l.BorderSizePixel = 0
    l.Parent          = parent
    return l
end

local function btn(parent, size, pos, z)
    local b = Instance.new("TextButton")
    b.BackgroundTransparency = 1
    b.Size            = size or UDim2.fromScale(1, 1)
    b.Position        = pos  or UDim2.new()
    b.ZIndex          = z    or 2
    b.Text            = ""
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Parent          = parent
    return b
end

local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER_EL
    c.Parent       = inst
    return c
end

local function stroke(inst, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color        = color     or Color3.fromRGB(36,36,46)
    s.Thickness    = thickness or 1
    s.Transparency = trans     or 0
    s.Parent       = inst
    return s
end

local function pad(inst, top, bottom, left, right)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    p.Parent        = inst
    return p
end

local function listLayout(parent, padding, sortOrder)
    local l = Instance.new("UIListLayout")
    l.Padding   = UDim.new(0, padding   or 0)
    l.SortOrder = sortOrder or Enum.SortOrder.LayoutOrder
    l.Parent    = parent
    return l
end

local function shadow(inst, size, trans)
    local sh = Instance.new("ImageLabel")
    sh.Name                  = "Shadow"
    sh.BackgroundTransparency = 1
    sh.Image                 = "rbxassetid://6014261993"
    sh.ImageColor3           = Color3.fromRGB(0, 0, 0)
    sh.ImageTransparency     = trans or 0.55
    sh.ScaleType             = Enum.ScaleType.Slice
    sh.SliceCenter           = Rect.new(49, 49, 450, 450)
    sh.Size                  = UDim2.new(1, size or 22, 1, size or 22)
    sh.Position              = UDim2.new(0, -(size or 22) / 2, 0, -(size or 22) / 2)
    sh.ZIndex                = inst.ZIndex - 1
    sh.Parent                = inst
    return sh
end

local function scrollFrame(parent, size, pos, barColor)
    local s = Instance.new("ScrollingFrame")
    s.Size                   = size or UDim2.fromScale(1, 1)
    s.Position               = pos  or UDim2.new()
    s.BackgroundTransparency = 1
    s.BorderSizePixel        = 0
    s.ScrollBarThickness     = 3
    s.ScrollBarImageColor3   = barColor or Color3.fromRGB(48,48,62)
    s.CanvasSize             = UDim2.new(0, 0, 0, 0)
    s.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    s.ScrollingDirection     = Enum.ScrollingDirection.Y
    s.ElasticBehavior        = Enum.ElasticBehavior.Never
    s.Parent                 = parent
    return s
end

local function baseEl(theme, cfg)
    local f = frame(nil, cfg and cfg.Color or theme.Element, UDim2.new(1, 0, 0, cfg and cfg.Height or ELEMENT_H))
    if cfg and cfg.Transparency then
        f.BackgroundTransparency = cfg.Transparency
    end
    corner(f, CORNER_EL)
    stroke(f, theme.ElementStroke, 1)
    return f
end

local function titleDesc(parent, theme, cfg, rightPad)
    rightPad = rightPad or 16
    local hasDesc = cfg and cfg.Desc and cfg.Desc ~= ""
    if hasDesc then
        local titleLbl = lbl(parent, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        titleLbl.Size     = UDim2.new(1, -(rightPad + 16), 0, 20)
        titleLbl.Position = UDim2.new(0, 14, 0, 6)
        local descLbl = lbl(parent, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        descLbl.Size     = UDim2.new(1, -(rightPad + 16), 0, 16)
        descLbl.Position = UDim2.new(0, 14, 0, 26)
        descLbl.TextTruncate = Enum.TextTruncate.AtEnd
        return titleLbl, descLbl
    else
        local titleLbl = lbl(parent, cfg and cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        titleLbl.Size     = UDim2.new(1, -(rightPad + 16), 1, 0)
        titleLbl.Position = UDim2.new(0, 14, 0, 0)
        return titleLbl, nil
    end
end

local function makeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = i.Position
            startPos  = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
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
            ss = target.AbsoluteSize
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - rs
            target.Size = UDim2.new(0, math.max(MIN_W, ss.X + d.X), 0, math.max(MIN_H, ss.Y + d.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
end

local overlayStack = {}
local function registerOverlay(fn)
    table.insert(overlayStack, fn)
end
local function unregisterOverlay(fn)
    for i = #overlayStack, 1, -1 do
        if overlayStack[i] == fn then table.remove(overlayStack, i) end
    end
end
local function closeAllOverlays()
    for i = #overlayStack, 1, -1 do
        pcall(overlayStack[i])
    end
    overlayStack = {}
end

local function positionPopup(popup, anchor, offsetX, offsetY)
    offsetX = offsetX or 0
    offsetY = offsetY or 5
    local vp   = Camera.ViewportSize
    local abs  = anchor.AbsolutePosition
    local asiz = anchor.AbsoluteSize
    local psiz = popup.AbsoluteSize

    local x = abs.X + offsetX
    local y = abs.Y + asiz.Y + offsetY

    if y + psiz.Y > vp.Y - 10 then
        y = abs.Y - psiz.Y - offsetY
    end
    if x + psiz.X > vp.X - 10 then
        x = vp.X - psiz.X - 10
    end
    x = math.max(6, x)
    y = math.max(6, y)

    popup.Position = UDim2.new(0, x, 0, y)
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
    [Enum.KeyCode.Backspace]    = "BACK",
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
    [Enum.KeyCode.F1]  = "F1",  [Enum.KeyCode.F2]  = "F2",  [Enum.KeyCode.F3]  = "F3",
    [Enum.KeyCode.F4]  = "F4",  [Enum.KeyCode.F5]  = "F5",  [Enum.KeyCode.F6]  = "F6",
    [Enum.KeyCode.F7]  = "F7",  [Enum.KeyCode.F8]  = "F8",  [Enum.KeyCode.F9]  = "F9",
    [Enum.KeyCode.F10] = "F10", [Enum.KeyCode.F11] = "F11", [Enum.KeyCode.F12] = "F12",
    [Enum.KeyCode.Zero]  = "0", [Enum.KeyCode.One]   = "1", [Enum.KeyCode.Two]   = "2",
    [Enum.KeyCode.Three] = "3", [Enum.KeyCode.Four]  = "4", [Enum.KeyCode.Five]  = "5",
    [Enum.KeyCode.Six]   = "6", [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine]  = "9",
}
local function keyName(kc) return keyNames[kc] or kc.Name:upper() end

local notifyGui    = nil
local notifyHolder = nil
local notifyCount  = 0
local MAX_NOTIFY   = 5
local NOTIFY_W     = 280
local NOTIFY_H     = 70

local function ensureNotifyGui()
    if notifyGui and notifyGui.Parent then return end
    notifyGui = Instance.new("ScreenGui")
    notifyGui.Name              = "TryxNotifications"
    notifyGui.ResetOnSpawn      = false
    notifyGui.ZIndexBehavior    = Enum.ZIndexBehavior.Sibling
    notifyGui.DisplayOrder      = 999
    pcall(function() notifyGui.Parent = game:GetService("CoreGui") end)
    if not notifyGui.Parent then
        notifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    notifyHolder = frame(notifyGui, Color3.fromRGB(0,0,0), UDim2.new(0, NOTIFY_W, 1, 0), UDim2.new(1, -(NOTIFY_W + 16), 0, 0))
    notifyHolder.BackgroundTransparency = 1

    local l = Instance.new("UIListLayout")
    l.Padding         = UDim.new(0, 8)
    l.SortOrder       = Enum.SortOrder.LayoutOrder
    l.VerticalAlignment = Enum.VerticalAlignment.Top
    l.HorizontalAlignment = Enum.HorizontalAlignment.Right
    l.FillDirection   = Enum.FillDirection.Vertical
    l.Parent          = notifyHolder
    pad(notifyHolder, 16, 16, 0, 0)
end

local function notify(theme, cfg)
    cfg = cfg or {}
    ensureNotifyGui()

    notifyCount += 1
    if notifyCount > MAX_NOTIFY then return end

    local t = cfg.Type or "info"
    local accentColor = (t == "success" and theme.Success)
        or (t == "error"   and theme.Danger)
        or (t == "warn"    and theme.Warning)
        or theme.Info

    local card = frame(notifyHolder, theme.Notify, UDim2.new(1, 0, 0, NOTIFY_H))
    card.ClipsDescendants = true
    card.LayoutOrder      = notifyCount
    corner(card, CORNER_EL)
    stroke(card, theme.NotifyStroke, 1)
    shadow(card, 16, 0.62)

    local accent = frame(card, accentColor, UDim2.new(0, 3, 1, -14), UDim2.new(0, 0, 0, 7))
    corner(accent, UDim.new(0, 2))

    local titleLbl2 = lbl(card, cfg.Title or "Notification", theme.TextPrimary, 13, Enum.Font.GothamBold)
    titleLbl2.Size     = UDim2.new(1, -60, 0, 18)
    titleLbl2.Position = UDim2.new(0, 14, 0, 12)

    local descLbl2 = lbl(card, cfg.Desc or "", theme.TextSecondary, 11, Enum.Font.Gotham)
    descLbl2.Size       = UDim2.new(1, -60, 0, 32)
    descLbl2.Position   = UDim2.new(0, 14, 0, 30)
    descLbl2.TextWrapped = true
    descLbl2.TextYAlignment = Enum.TextYAlignment.Top

    local dotFrame = frame(card, accentColor, UDim2.new(0, 8, 0, 8), UDim2.new(1, -20, 0, 14))
    corner(dotFrame, CORNER_PILL)

    card.Position = UDim2.new(1, 20, 0, 0)
    tw(card, { Position = UDim2.new(0, 0, 0, 0) }, ANIM_MED)

    local dur = cfg.Duration or 4
    task.delay(dur, function()
        tw(card, { Position = UDim2.new(1, 20, 0, 0), BackgroundTransparency = 1 }, ANIM_FAST)
        task.delay(ANIM_FAST + 0.05, function()
            if card and card.Parent then card:Destroy() end
            notifyCount = math.max(0, notifyCount - 1)
        end)
    end)
end

local function injectElements(Tab, theme, page, gui, Library)


    function Tab:Button(cfg)
        cfg = cfg or {}
        local disabled = cfg.Disabled or false
        local f = baseEl(theme, cfg)
        titleDesc(f, theme, cfg, 38)

        local arrow = lbl(f, "›", theme.Accent, 20, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        arrow.Size     = UDim2.new(0, 22, 1, 0)
        arrow.Position = UDim2.new(1, -30, 0, 0)
        arrow.TextTruncate = Enum.TextTruncate.None

        if disabled then
            f.BackgroundTransparency = 0.5
            for _, c in ipairs(f:GetDescendants()) do
                if c:IsA("TextLabel") then c.TextTransparency = 0.5 end
            end
        end

        local b = btn(f)
        if not disabled then
            b.MouseEnter:Connect(function()
                tw(f, { BackgroundColor3 = theme.ElementHover })
                tw(arrow, { TextColor3 = theme.AccentLight, TextSize = 22 })
            end)
            b.MouseLeave:Connect(function()
                tw(f, { BackgroundColor3 = cfg.Color or theme.Element })
                tw(arrow, { TextColor3 = theme.Accent, TextSize = 20 })
            end)
            b.MouseButton1Click:Connect(function()
                tw(f, { BackgroundColor3 = theme.ElementActive })
                task.delay(0.08, function() tw(f, { BackgroundColor3 = cfg.Color or theme.Element }) end)
                task.spawn(function() pcall(cfg.Callback or function() end) end)
            end)
        end

        f.Parent = page
        local obj = { _frame = f }
        function obj:SetDisabled(v)
            disabled = v
            f.BackgroundTransparency = v and 0.5 or 0
        end
        return obj
    end


    function Tab:Toggle(cfg)
        cfg = cfg or {}
        local value    = cfg.Value    or false
        local disabled = cfg.Disabled or false
        local isCheck  = (cfg.Type == "Checkbox")

        local f = baseEl(theme, cfg)
        titleDesc(f, theme, cfg, 60)

        local control, indicator

        if isCheck then
            control = frame(f, value and theme.Accent or theme.InputBg, UDim2.new(0, 20, 0, 20))
            control.Position = UDim2.new(1, -34, 0.5, -10)
            corner(control, CORNER_SM)
            stroke(control, value and theme.Accent or theme.ElementStroke, 1)

            indicator = lbl(control, value and "✓" or "", value and theme.AccentFg or theme.TextPrimary, 12, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            indicator.Size = UDim2.fromScale(1, 1)
        else
            control = frame(f, value and theme.Accent or theme.InputBg, UDim2.new(0, 36, 0, 20))
            control.Position = UDim2.new(1, -50, 0.5, -10)
            corner(control, CORNER_PILL)
            stroke(control, value and theme.Accent or theme.ElementStroke, 1)

            indicator = frame(control, Color3.fromRGB(255,255,255), UDim2.new(0, 14, 0, 14))
            indicator.Position = UDim2.new(0, value and 19 or 3, 0.5, -7)
            corner(indicator, CORNER_PILL)
        end

        if disabled then
            f.BackgroundTransparency = 0.5
        end

        local function update(v)
            if isCheck then
                tw(control, { BackgroundColor3 = v and theme.Accent or theme.InputBg })
                local s = control:FindFirstChildOfClass("UIStroke")
                if s then tw(s, { Color = v and theme.Accent or theme.ElementStroke }) end
                indicator.Text = v and "✓" or ""
                indicator.TextColor3 = v and theme.AccentFg or theme.TextPrimary
            else
                tw(control, { BackgroundColor3 = v and theme.Accent or theme.InputBg })
                local s = control:FindFirstChildOfClass("UIStroke")
                if s then tw(s, { Color = v and theme.Accent or theme.ElementStroke }) end
                tw(indicator, { Position = UDim2.new(0, v and 19 or 3, 0.5, -7) })
            end
        end

        local b = btn(f)
        if not disabled then
            b.MouseEnter:Connect(function() tw(f, { BackgroundColor3 = theme.ElementHover }) end)
            b.MouseLeave:Connect(function() tw(f, { BackgroundColor3 = cfg.Color or theme.Element }) end)
            b.MouseButton1Click:Connect(function()
                value = not value
                update(value)
                task.spawn(function() pcall(cfg.Callback or function() end, value) end)
            end)
        end

        f.Parent = page
        local obj = { _frame = f }
        function obj:Get() return value end
        function obj:Set(v)
            value = v
            update(v)
        end
        function obj:SetDisabled(v)
            disabled = v
            f.BackgroundTransparency = v and 0.5 or 0
        end
        return obj
    end


    function Tab:Slider(cfg)
        cfg = cfg or {}
        local min      = cfg.Min      or 0
        local max      = cfg.Max      or 100
        local step     = cfg.Step     or 1
        local suffix   = cfg.Suffix   or ""
        local disabled = cfg.Disabled or false
        local value    = math.clamp(cfg.Value or min, min, max)
        local hasInput = cfg.Input

        local h = 48 + (cfg.Desc and cfg.Desc ~= "" and 0 or 0)
        local f = baseEl(theme, cfg)
        f.Size = UDim2.new(1, 0, 0, hasInput and 52 or 48)

        local titleLbl2 = lbl(f, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        titleLbl2.Size     = UDim2.new(1, -90, 0, 18)
        titleLbl2.Position = UDim2.new(0, 14, 0, 6)

        local valLbl = lbl(f, tostring(value) .. suffix, theme.Accent, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        valLbl.Size     = UDim2.new(0, 70, 0, 18)
        valLbl.Position = UDim2.new(1, -84, 0, 6)

        if cfg.Desc and cfg.Desc ~= "" then
            local descLbl2 = lbl(f, cfg.Desc, theme.TextSecondary, 10, Enum.Font.Gotham)
            descLbl2.Size     = UDim2.new(1, -100, 0, 14)
            descLbl2.Position = UDim2.new(0, 14, 0, 23)
            descLbl2.TextTruncate = Enum.TextTruncate.AtEnd
        end

        local trackY = (cfg.Desc and cfg.Desc ~= "") and 32 or 28
        local track = frame(f, theme.ElementStroke, UDim2.new(1, -28, 0, 4), UDim2.new(0, 14, 0, trackY))
        corner(track, CORNER_PILL)

        local fill = frame(track, theme.Accent, UDim2.new((value - min) / (max - min), 0, 1, 0))
        corner(fill, CORNER_PILL)

        local thumb = frame(track, Color3.fromRGB(255,255,255), UDim2.new(0, 13, 0, 13), UDim2.new((value - min) / (max - min), -6, 0.5, -7))
        corner(thumb, CORNER_PILL)
        stroke(thumb, theme.ElementStroke, 1)

        local inputBox = nil
        if hasInput then
            local iFrame = frame(f, theme.InputBg, UDim2.new(0, 60, 0, 18), UDim2.new(1, -74, 0, 4))
            corner(iFrame, CORNER_XS)
            stroke(iFrame, theme.ElementStroke, 1)
            inputBox = Instance.new("TextBox")
            inputBox.Size               = UDim2.new(1, -6, 1, 0)
            inputBox.Position           = UDim2.new(0, 3, 0, 0)
            inputBox.BackgroundTransparency = 1
            inputBox.Text               = tostring(value)
            inputBox.TextColor3         = theme.TextPrimary
            inputBox.TextSize           = 11
            inputBox.Font               = Enum.Font.GothamMono or Enum.Font.Gotham
            inputBox.ClearTextOnFocus   = true
            inputBox.TextEditable       = not disabled
            inputBox.Parent             = iFrame
            inputBox.FocusLost:Connect(function()
                local v = tonumber(inputBox.Text)
                if v then
                    v = math.clamp(math.round(v / step) * step, min, max)
                    value = v
                    fill.Size = UDim2.new((v - min) / (max - min), 0, 1, 0)
                    thumb.Position = UDim2.new((v - min) / (max - min), -6, 0.5, -7)
                    valLbl.Text = tostring(v) .. suffix
                end
                inputBox.Text = tostring(value)
                task.spawn(function() pcall(cfg.Callback or function() end, value) end)
            end)
        end

        if disabled then f.BackgroundTransparency = 0.5 end

        local sliding = false
        local function setFromX(mx)
            if disabled then return end
            local abs  = track.AbsolutePosition
            local siz  = track.AbsoluteSize
            local pct  = math.clamp((mx - abs.X) / siz.X, 0, 1)
            local raw  = min + pct * (max - min)
            local v    = math.clamp(math.round(raw / step) * step, min, max)
            value      = v
            local frac = (v - min) / (max - min)
            fill.Size  = UDim2.new(frac, 0, 1, 0)
            thumb.Position = UDim2.new(frac, -6, 0.5, -7)
            valLbl.Text = tostring(v) .. suffix
            if inputBox then inputBox.Text = tostring(v) end
            task.spawn(function() pcall(cfg.Callback or function() end, v) end)
        end

        local trackBtn = btn(track, UDim2.fromScale(1,1), nil, 3)
        trackBtn.MouseButton1Down:Connect(function(mx, _)
            sliding = true
            setFromX(mx)
        end)
        UserInputService.InputChanged:Connect(function(i)
            if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then
                setFromX(i.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
        end)

        f.Parent = page
        local obj = { _frame = f }
        function obj:Get() return value end
        function obj:Set(v)
            v = math.clamp(v, min, max)
            value = v
            local frac = (v - min) / (max - min)
            fill.Size  = UDim2.new(frac, 0, 1, 0)
            thumb.Position = UDim2.new(frac, -6, 0.5, -7)
            valLbl.Text = tostring(v) .. suffix
            if inputBox then inputBox.Text = tostring(v) end
        end
        function obj:SetDisabled(v)
            disabled = v
            f.BackgroundTransparency = v and 0.5 or 0
            if inputBox then inputBox.TextEditable = not v end
        end
        return obj
    end


    function Tab:Input(cfg)
        cfg = cfg or {}
        local disabled  = cfg.Disabled  or false
        local multiline = cfg.MultiLine  or false
        local h = multiline and 90 or 48
        if cfg.Desc and cfg.Desc ~= "" then h = h + 0 end

        local f = baseEl(theme, cfg)
        f.Size = UDim2.new(1, 0, 0, h)

        titleDesc(f, theme, cfg, 16)

        local boxY = (cfg.Desc and cfg.Desc ~= "") and 42 or 26
        local boxH = multiline and (h - boxY - 6) or 22

        local box = frame(f, theme.InputBg, UDim2.new(1, -28, 0, boxH), UDim2.new(0, 14, 0, boxY))
        corner(box, CORNER_SM)
        local boxStroke = stroke(box, theme.ElementStroke, 1)

        local input = Instance.new("TextBox")
        input.Size               = UDim2.new(1, -10, 1, 0)
        input.Position           = UDim2.new(0, 5, 0, 0)
        input.BackgroundTransparency = 1
        input.Text               = cfg.Default or ""
        input.PlaceholderText    = cfg.Placeholder or ""
        input.PlaceholderColor3  = theme.TextDisabled
        input.TextColor3         = theme.TextPrimary
        input.TextSize           = 12
        input.Font               = Enum.Font.Gotham
        input.TextXAlignment     = Enum.TextXAlignment.Left
        input.TextYAlignment     = multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
        input.ClearTextOnFocus   = false
        input.MultiLine          = multiline
        input.TextWrapped        = multiline
        input.TextEditable       = not disabled
        input.Interactable       = not disabled
        input.Parent             = box

        input.Focused:Connect(function()
            if disabled then input:ReleaseFocus() return end
            tw(box, { BackgroundColor3 = theme.ElementHover })
            tw(boxStroke, { Color = theme.Accent })
        end)
        input.FocusLost:Connect(function(enter)
            tw(box, { BackgroundColor3 = theme.InputBg })
            tw(boxStroke, { Color = theme.ElementStroke })
            if enter and not disabled then
                task.spawn(function() pcall(cfg.Callback or function() end, input.Text) end)
            end
        end)
        if cfg.LiveCallback then
            input:GetPropertyChangedSignal("Text"):Connect(function()
                if not disabled then task.spawn(function() pcall(cfg.LiveCallback, input.Text) end) end
            end)
        end

        if disabled then f.BackgroundTransparency = 0.5 end
        f.Parent = page

        local obj = {}
        function obj:Get() return input.Text end
        function obj:Set(v) input.Text = v end
        function obj:Clear() input.Text = "" end
        function obj:SetDisabled(v)
            disabled = v
            input.TextEditable = not v
            input.Interactable = not v
            f.BackgroundTransparency = v and 0.5 or 0
        end
        return obj
    end


    function Tab:NumberInput(cfg)
        cfg = cfg or {}
        local min      = cfg.Min   or 0
        local max      = cfg.Max   or 100
        local step     = cfg.Step  or 1
        local value    = math.clamp(cfg.Value or min, min, max)
        local disabled = cfg.Disabled or false

        local f = baseEl(theme, cfg)
        titleDesc(f, theme, cfg, 110)

        local rightW = 100
        local row = frame(f, Color3.fromRGB(0,0,0), UDim2.new(0, rightW, 0, 28))
        row.BackgroundTransparency = 1
        row.Position = UDim2.new(1, -(rightW + 12), 0.5, -14)

        local minusBtn = frame(row, theme.InputBg, UDim2.new(0, 28, 1, 0))
        corner(minusBtn, CORNER_SM)
        stroke(minusBtn, theme.ElementStroke, 1)
        local minusLbl = lbl(minusBtn, "−", theme.TextSecondary, 16, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        minusLbl.Size = UDim2.fromScale(1,1)

        local valBox = frame(row, theme.InputBg, UDim2.new(1, -64, 1, 0), UDim2.new(0, 32, 0, 0))
        corner(valBox, CORNER_SM)
        stroke(valBox, theme.ElementStroke, 1)
        local valInput = Instance.new("TextBox")
        valInput.Size               = UDim2.new(1, -4, 1, 0)
        valInput.Position           = UDim2.new(0, 2, 0, 0)
        valInput.BackgroundTransparency = 1
        valInput.Text               = tostring(value)
        valInput.TextColor3         = theme.TextPrimary
        valInput.TextSize           = 12
        valInput.Font               = Enum.Font.GothamMono or Enum.Font.Gotham
        valInput.TextXAlignment     = Enum.TextXAlignment.Center
        valInput.ClearTextOnFocus   = true
        valInput.TextEditable       = not disabled
        valInput.Parent             = valBox

        local plusBtn = frame(row, theme.InputBg, UDim2.new(0, 28, 1, 0), UDim2.new(1, -28, 0, 0))
        corner(plusBtn, CORNER_SM)
        stroke(plusBtn, theme.ElementStroke, 1)
        local plusLbl = lbl(plusBtn, "+", theme.TextSecondary, 14, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        plusLbl.Size = UDim2.fromScale(1,1)

        local function setValue(v)
            value = math.clamp(v, min, max)
            valInput.Text = tostring(value)
            task.spawn(function() pcall(cfg.Callback or function() end, value) end)
        end

        valInput.FocusLost:Connect(function()
            local v = tonumber(valInput.Text)
            if v then setValue(math.round(v / step) * step)
            else valInput.Text = tostring(value) end
        end)

        local mb = btn(minusBtn)
        mb.MouseButton1Click:Connect(function() if not disabled then setValue(value - step) end end)
        mb.MouseEnter:Connect(function() tw(minusBtn, { BackgroundColor3 = theme.ElementHover }); tw(minusLbl, { TextColor3 = theme.TextPrimary }) end)
        mb.MouseLeave:Connect(function() tw(minusBtn, { BackgroundColor3 = theme.InputBg }); tw(minusLbl, { TextColor3 = theme.TextSecondary }) end)

        local pb = btn(plusBtn)
        pb.MouseButton1Click:Connect(function() if not disabled then setValue(value + step) end end)
        pb.MouseEnter:Connect(function() tw(plusBtn, { BackgroundColor3 = theme.ElementHover }); tw(plusLbl, { TextColor3 = theme.TextPrimary }) end)
        pb.MouseLeave:Connect(function() tw(plusBtn, { BackgroundColor3 = theme.InputBg }); tw(plusLbl, { TextColor3 = theme.TextSecondary }) end)

        if disabled then f.BackgroundTransparency = 0.5 end
        f.Parent = page

        local obj = {}
        function obj:Get() return value end
        function obj:Set(v) setValue(v) end
        return obj
    end


    function Tab:ProgressBar(cfg)
        cfg = cfg or {}
        local value    = math.clamp(cfg.Value or 0, 0, 1)
        local barColor = cfg.BarColor or theme.Accent

        local f = baseEl(theme, cfg)
        f.Size = UDim2.new(1, 0, 0, 48)

        local pct = math.floor(value * 100)
        local titleText = cfg.Title or ""
        local titleLbl2 = lbl(f, titleText, theme.TextPrimary, 13, Enum.Font.GothamMedium)
        titleLbl2.Size     = UDim2.new(1, -80, 0, 18)
        titleLbl2.Position = UDim2.new(0, 14, 0, 6)

        local pctLbl = nil
        if cfg.ShowPercent then
            pctLbl = lbl(f, pct .. "%", theme.TextSecondary, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            pctLbl.Size     = UDim2.new(0, 50, 0, 18)
            pctLbl.Position = UDim2.new(1, -64, 0, 6)
        end

        if cfg.Desc and cfg.Desc ~= "" then
            local descLbl2 = lbl(f, cfg.Desc, theme.TextSecondary, 10, Enum.Font.Gotham)
            descLbl2.Size     = UDim2.new(1, -90, 0, 14)
            descLbl2.Position = UDim2.new(0, 14, 0, 23)
            descLbl2.TextTruncate = Enum.TextTruncate.AtEnd
        end

        local trackY = (cfg.Desc and cfg.Desc ~= "") and 34 or 30
        local track = frame(f, theme.ElementStroke, UDim2.new(1, -28, 0, 5), UDim2.new(0, 14, 0, trackY))
        corner(track, CORNER_PILL)

        local fill = frame(track, barColor, UDim2.new(value, 0, 1, 0))
        corner(fill, CORNER_PILL)

        f.Parent = page
        local obj = { _frame = f }
        function obj:Set(v)
            v = math.clamp(v, 0, 1)
            value = v
            tw(fill, { Size = UDim2.new(v, 0, 1, 0) })
            if pctLbl then pctLbl.Text = math.floor(v * 100) .. "%" end
        end
        function obj:Get() return value end
        return obj
    end


    function Tab:Dropdown(cfg)
        cfg = cfg or {}
        local values   = cfg.Values   or {}
        local multi    = cfg.Multi    or false
        local disabled = cfg.Disabled or false
        local selected = multi and {} or (cfg.Value or (values[1] or ""))
        local open     = false
        local list     = nil
        local listConn = nil
        local trackConn = nil

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 130)

        local selBox = frame(f, theme.InputBg, UDim2.new(0, 116, 0, 26))
        selBox.Position = UDim2.new(1, -130, 0.5, -13)
        corner(selBox, CORNER_SM)
        stroke(selBox, theme.ElementStroke, 1)

        local selLbl = lbl(selBox, "", theme.TextPrimary, 11, Enum.Font.Gotham)
        selLbl.Size     = UDim2.new(1, -26, 1, 0)
        selLbl.Position = UDim2.new(0, 8, 0, 0)
        selLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local chevron = lbl(selBox, "▾", theme.TextSecondary, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        chevron.Size     = UDim2.new(0, 18, 1, 0)
        chevron.Position = UDim2.new(1, -20, 0, 0)
        chevron.TextTruncate = Enum.TextTruncate.None

        local function getDisplayText()
            if multi then
                local count = 0
                for _ in pairs(selected) do count += 1 end
                return count == 0 and "Select..." or count .. " selected"
            end
            return tostring(selected)
        end
        selLbl.Text = getDisplayText()

        local function closeList()
            if not list then return end
            open = false
            tw(chevron, { Rotation = 0 })
            tw(selBox, { BackgroundColor3 = theme.InputBg })
            local cap = list
            tw(cap, { BackgroundTransparency = 1 }, ANIM_FAST)
            task.delay(ANIM_FAST + 0.05, function()
                if cap and cap.Parent then cap:Destroy() end
            end)
            list = nil
            if listConn  then listConn:Disconnect();  listConn  = nil end
            if trackConn then trackConn:Disconnect(); trackConn = nil end
            unregisterOverlay(closeList)
        end

        local function buildList()
            closeList()
            if disabled then return end

            list = frame(gui, theme.Element, UDim2.new(0, 130, 0, 0))
            list.ZIndex           = OVERLAY_Z
            list.ClipsDescendants = true
            list.BackgroundTransparency = 0
            corner(list, CORNER_EL)
            stroke(list, theme.ElementStroke, 1)
            shadow(list, 18, 0.6)

            local itemH   = 30
            local maxShow = math.min(#values, 6)
            local listH   = maxShow * itemH + 8

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size                   = UDim2.fromScale(1, 1)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel        = 0
            scroll.CanvasSize             = UDim2.new(0, 0, 0, #values * itemH + 8)
            scroll.ScrollBarThickness     = 3
            scroll.ScrollBarImageColor3   = theme.ScrollBar
            scroll.ScrollingDirection     = Enum.ScrollingDirection.Y
            scroll.AutomaticCanvasSize    = Enum.AutomaticSize.None
            scroll.ElasticBehavior        = Enum.ElasticBehavior.Never
            scroll.Parent                 = list
            listLayout(scroll, 0)
            pad(scroll, 4, 4, 4, 4)

            for _, v in ipairs(values) do
                local isSel = multi and selected[v] or (selected == v)
                local item = frame(scroll, Color3.fromRGB(0,0,0), UDim2.new(1, -8, 0, itemH))
                item.BackgroundTransparency = 1

                local itemBg = frame(item, isSel and theme.ElementActive or Color3.fromRGB(0,0,0), UDim2.fromScale(1,1))
                itemBg.BackgroundTransparency = isSel and 0 or 1
                corner(itemBg, CORNER_SM)

                local il = lbl(item, tostring(v), isSel and theme.Accent or theme.TextPrimary, 12, Enum.Font.Gotham)
                il.Size     = UDim2.new(1, -10, 1, 0)
                il.Position = UDim2.new(0, 8, 0, 0)
                il.TextTruncate = Enum.TextTruncate.AtEnd
                il.ZIndex   = OVERLAY_Z + 1

                if isSel and multi then
                    local chk = lbl(item, "✓", theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                    chk.Size     = UDim2.new(0, 18, 1, 0)
                    chk.Position = UDim2.new(1, -20, 0, 0)
                    chk.ZIndex   = OVERLAY_Z + 1
                    chk.TextTruncate = Enum.TextTruncate.None
                end

                local ib = btn(item, UDim2.fromScale(1,1), nil, OVERLAY_Z + 2)
                ib.MouseEnter:Connect(function()
                    tw(itemBg, { BackgroundColor3 = theme.ElementHover, BackgroundTransparency = 0 })
                    tw(il, { TextColor3 = theme.TextPrimary })
                end)
                ib.MouseLeave:Connect(function()
                    if (multi and selected[v]) or (not multi and selected == v) then
                        tw(itemBg, { BackgroundColor3 = theme.ElementActive, BackgroundTransparency = 0 })
                        tw(il, { TextColor3 = theme.Accent })
                    else
                        tw(itemBg, { BackgroundTransparency = 1 })
                        tw(il, { TextColor3 = theme.TextPrimary })
                    end
                end)
                ib.MouseButton1Click:Connect(function()
                    if multi then
                        selected[v] = selected[v] and nil or true
                    else
                        selected = v
                    end
                    selLbl.Text = getDisplayText()
                    task.spawn(function() pcall(cfg.Callback or function() end, selected) end)
                    if not multi then closeList() end
                end)
            end

            list.Size = UDim2.new(0, 130, 0, listH)
            positionPopup(list, selBox, 0, 4)
            list.ClipsDescendants = false
            list.Size = UDim2.new(0, 130, 0, 0)
            list.ClipsDescendants = true
            tw(list, { Size = UDim2.new(0, 130, 0, listH) }, ANIM_FAST)
            tw(chevron, { Rotation = 180 })
            tw(selBox, { BackgroundColor3 = theme.ElementHover })

            trackConn = RunService.Heartbeat:Connect(function()
                if list and list.Parent and selBox and selBox.Parent then
                    positionPopup(list, selBox, 0, 4)
                else
                    if trackConn then trackConn:Disconnect(); trackConn = nil end
                end
            end)

            listConn = UserInputService.InputBegan:Connect(function(i, gp)
                if gp then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mx, my = i.Position.X, i.Position.Y
                    if list then
                        local lp = list.AbsolutePosition; local ls = list.AbsoluteSize
                        local fp = f.AbsolutePosition;    local fs = f.AbsoluteSize
                        local inList = mx >= lp.X and mx <= lp.X+ls.X and my >= lp.Y and my <= lp.Y+ls.Y
                        local inEl   = mx >= fp.X and mx <= fp.X+fs.X and my >= fp.Y and my <= fp.Y+fs.Y
                        if not inList and not inEl then closeList() end
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
            if not open then tw(f, { BackgroundColor3 = cfg.Color or theme.Element }) end
        end)
        b.MouseButton1Click:Connect(function()
            if disabled then return end
            open = not open
            if open then closeAllOverlays(); open = true; buildList()
            else closeList() end
        end)

        if disabled then f.BackgroundTransparency = 0.5 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get() return selected end
        function obj:Set(v)
            selected = v
            selLbl.Text = getDisplayText()
        end
        function obj:Refresh(newValues)
            values = newValues
            closeList()
        end
        return obj
    end


    function Tab:Keybind(cfg)
        cfg = cfg or {}
        local value    = cfg.Key     or Enum.KeyCode.F
        local disabled = cfg.Disabled or false
        local binding  = false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 90)

        local keyBadge = frame(f, theme.InputBg, UDim2.new(0, 70, 0, 24))
        keyBadge.Position = UDim2.new(1, -84, 0.5, -12)
        corner(keyBadge, CORNER_SM)
        stroke(keyBadge, theme.ElementStroke, 1)

        local keyLbl = lbl(keyBadge, keyName(value), theme.TextPrimary, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        keyLbl.Size = UDim2.fromScale(1, 1)

        local function startBind()
            if disabled then return end
            binding = true
            keyLbl.Text = "..."
            tw(keyBadge, { BackgroundColor3 = theme.ElementActive })
            tw(keyBadge:FindFirstChildOfClass("UIStroke"), { Color = theme.Accent })
        end

        local function stopBind(kc)
            binding = false
            value = kc
            keyLbl.Text = keyName(kc)
            tw(keyBadge, { BackgroundColor3 = theme.InputBg })
            local s = keyBadge:FindFirstChildOfClass("UIStroke")
            if s then tw(s, { Color = theme.ElementStroke }) end
            task.spawn(function() pcall(cfg.Callback or function() end, kc) end)
        end

        UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            if binding then
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    stopBind(i.KeyCode)
                end
            else
                if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == value and not disabled then
                    task.spawn(function() pcall(cfg.OnPress or function() end) end)
                end
            end
        end)

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
            if not binding then startBind()
            else binding = false; keyLbl.Text = keyName(value); tw(keyBadge, { BackgroundColor3 = theme.InputBg }) end
        end)

        if disabled then f.BackgroundTransparency = 0.5 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get() return value end
        function obj:Set(kc) stopBind(kc) end
        return obj
    end


    function Tab:KeybindButton(cfg)
        cfg = cfg or {}
        local value    = cfg.Key        or Enum.KeyCode.F
        local disabled = cfg.Disabled   or false
        local btnText  = cfg.ButtonText or "Run"
        local binding  = false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 170)

        local keyBadge = frame(f, theme.InputBg, UDim2.new(0, 60, 0, 24))
        keyBadge.Position = UDim2.new(1, -148, 0.5, -12)
        corner(keyBadge, CORNER_SM)
        stroke(keyBadge, theme.ElementStroke, 1)
        local keyLbl = lbl(keyBadge, keyName(value), theme.TextSecondary, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        keyLbl.Size = UDim2.fromScale(1, 1)

        local runBtn = frame(f, theme.Accent, UDim2.new(0, 60, 0, 24))
        runBtn.Position = UDim2.new(1, -80, 0.5, -12)
        corner(runBtn, CORNER_SM)
        local runLbl = lbl(runBtn, btnText, theme.AccentFg, 12, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        runLbl.Size = UDim2.fromScale(1, 1)
        runLbl.TextTruncate = Enum.TextTruncate.None

        UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            if binding and i.UserInputType == Enum.UserInputType.Keyboard then
                value = i.KeyCode
                binding = false
                keyLbl.Text = keyName(value)
                tw(keyBadge, { BackgroundColor3 = theme.InputBg })
                local s = keyBadge:FindFirstChildOfClass("UIStroke")
                if s then tw(s, { Color = theme.ElementStroke }) end
            elseif not binding and i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == value and not disabled then
                task.spawn(function() pcall(cfg.Callback or function() end) end)
            end
        end)

        local runB = btn(runBtn, UDim2.fromScale(1,1), nil, 3)
        runB.MouseEnter:Connect(function() if not disabled then tw(runBtn, { BackgroundColor3 = theme.AccentLight }) end end)
        runB.MouseLeave:Connect(function() if not disabled then tw(runBtn, { BackgroundColor3 = theme.Accent }) end end)
        runB.MouseButton1Click:Connect(function()
            if disabled then return end
            tw(runBtn, { BackgroundColor3 = theme.AccentDark })
            task.delay(0.1, function() tw(runBtn, { BackgroundColor3 = theme.Accent }) end)
            task.spawn(function() pcall(cfg.Callback or function() end) end)
        end)

        local keyB = btn(keyBadge, UDim2.fromScale(1,1), nil, 3)
        keyB.MouseButton1Click:Connect(function()
            if disabled then return end
            binding = not binding
            if binding then
                keyLbl.Text = "..."
                tw(keyBadge, { BackgroundColor3 = theme.ElementActive })
                local s = keyBadge:FindFirstChildOfClass("UIStroke")
                if s then tw(s, { Color = theme.Accent }) end
            else
                keyLbl.Text = keyName(value)
                tw(keyBadge, { BackgroundColor3 = theme.InputBg })
            end
        end)

        local hover = btn(f)
        hover.MouseEnter:Connect(function() if not disabled then tw(f, { BackgroundColor3 = theme.ElementHover }) end end)
        hover.MouseLeave:Connect(function() if not disabled then tw(f, { BackgroundColor3 = cfg.Color or theme.Element }) end end)

        if disabled then f.BackgroundTransparency = 0.5 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get() return value end
        return obj
    end


    function Tab:ColorPicker(cfg)
        cfg = cfg or {}
        local value          = cfg.Value    or Color3.fromRGB(255, 255, 255)
        local disabled       = cfg.Disabled or false
        local open           = false
        local panel          = nil
        local panelConn      = nil
        local panelTrackConn = nil

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 56)

        local preview = frame(f, value, UDim2.new(0, 32, 0, 24))
        preview.Position = UDim2.new(1, -46, 0.5, -12)
        corner(preview, CORNER_SM)
        stroke(preview, theme.ElementStroke, 1)

        local chevron2 = lbl(f, "▾", theme.TextSecondary, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        chevron2.Size     = UDim2.new(0, 14, 1, 0)
        chevron2.Position = UDim2.new(1, -18, 0, 0)
        chevron2.TextTruncate = Enum.TextTruncate.None

        local rgb = { math.floor(value.R*255), math.floor(value.G*255), math.floor(value.B*255) }

        local function updateColor()
            value = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
            tw(preview, { BackgroundColor3 = value })
            task.spawn(function() pcall(cfg.Callback or function() end, value) end)
        end

        local function closePanel()
            if not panel then return end
            open = false
            tw(chevron2, { Rotation = 0 })
            local cap = panel
            tw(cap, { BackgroundTransparency = 1 }, ANIM_FAST)
            task.delay(ANIM_FAST + 0.05, function()
                if cap and cap.Parent then cap:Destroy() end
            end)
            panel = nil
            if panelConn      then panelConn:Disconnect();      panelConn      = nil end
            if panelTrackConn then panelTrackConn:Disconnect(); panelTrackConn = nil end
            unregisterOverlay(closePanel)
        end

        local function buildPanel()
            closePanel()
            local sg = gui
            if not sg then return end

            panel = frame(sg, theme.Element, UDim2.new(0, 220, 0, 0))
            panel.ZIndex             = OVERLAY_Z
            panel.BackgroundTransparency = 0
            panel.ClipsDescendants   = true
            corner(panel, CORNER_EL)
            stroke(panel, theme.ElementStroke, 1)
            shadow(panel, 18, 0.6)
            pad(panel, 10, 10, 12, 12)

            local innerLayout = listLayout(panel, 7)

            local function toHex(r, g, b)
                return string.format("%02X%02X%02X", r, g, b)
            end


            local hexRow = frame(panel, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, 26))
            hexRow.BackgroundTransparency = 1
            hexRow.ZIndex                 = OVERLAY_Z + 1
            hexRow.LayoutOrder            = 0

            local hexLbl = lbl(hexRow, "#", theme.TextSecondary, 11, Enum.Font.GothamBold)
            hexLbl.Size     = UDim2.new(0, 14, 1, 0)
            hexLbl.ZIndex   = OVERLAY_Z + 1

            local hexFr = frame(hexRow, theme.InputBg, UDim2.new(1, -18, 1, 0), UDim2.new(0, 18, 0, 0))
            corner(hexFr, CORNER_SM)
            stroke(hexFr, theme.ElementStroke, 1)
            hexFr.ZIndex = OVERLAY_Z + 1

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
            hexBox.Parent             = hexFr
            hexBox.FocusLost:Connect(function()
                local h = hexBox.Text:gsub("[^%x]",""):sub(1,6)
                if #h == 6 then
                    rgb[1] = tonumber(h:sub(1,2),16) or 0
                    rgb[2] = tonumber(h:sub(3,4),16) or 0
                    rgb[3] = tonumber(h:sub(5,6),16) or 0
                    updateColor()
                end
                hexBox.Text = toHex(rgb[1],rgb[2],rgb[3])
            end)


            local channels = {
                { name="R", idx=1, col=Color3.fromRGB(210,58,58)   },
                { name="G", idx=2, col=Color3.fromRGB(58,188,98)   },
                { name="B", idx=3, col=Color3.fromRGB(72,148,228)  },
            }
            for loIdx, ch in ipairs(channels) do
                local row = frame(panel, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, 26))
                row.BackgroundTransparency = 1
                row.ZIndex                 = OVERLAY_Z + 1
                row.LayoutOrder            = loIdx

                local nameLbl = lbl(row, ch.name, theme.TextSecondary, 10, Enum.Font.GothamBold)
                nameLbl.Size    = UDim2.new(0, 14, 1, 0)
                nameLbl.ZIndex  = OVERLAY_Z + 1

                local chTrack = frame(row, theme.ElementStroke2, UDim2.new(1, -72, 0, 4), UDim2.new(0, 18, 0.5, -2))
                chTrack.ZIndex = OVERLAY_Z + 1
                corner(chTrack, CORNER_PILL)

                local chFill = frame(chTrack, ch.col, UDim2.new(rgb[ch.idx]/255, 0, 1, 0))
                chFill.ZIndex = OVERLAY_Z + 2
                corner(chFill, CORNER_PILL)

                local chThumb = frame(chTrack, Color3.fromRGB(255,255,255), UDim2.new(0,11,0,11))
                chThumb.Position = UDim2.new(rgb[ch.idx]/255, -5, 0.5, -6)
                chThumb.ZIndex   = OVERLAY_Z + 3
                corner(chThumb, CORNER_PILL)

                local valFr = frame(row, theme.InputBg, UDim2.new(0, 38, 1, -2), UDim2.new(1, -40, 0, 1))
                corner(valFr, CORNER_XS)
                stroke(valFr, theme.ElementStroke, 1)
                valFr.ZIndex = OVERLAY_Z + 1

                local valBox = Instance.new("TextBox")
                valBox.Size               = UDim2.new(1, -4, 1, 0)
                valBox.Position           = UDim2.new(0, 2, 0, 0)
                valBox.BackgroundTransparency = 1
                valBox.Text               = tostring(rgb[ch.idx])
                valBox.TextColor3         = theme.TextPrimary
                valBox.TextSize           = 11
                valBox.Font               = Enum.Font.GothamMono or Enum.Font.Gotham
                valBox.TextXAlignment     = Enum.TextXAlignment.Center
                valBox.ClearTextOnFocus   = true
                valBox.ZIndex             = OVERLAY_Z + 2
                valBox.Parent             = valFr
                valBox.FocusLost:Connect(function()
                    local n = math.clamp(math.floor(tonumber(valBox.Text) or rgb[ch.idx]), 0, 255)
                    rgb[ch.idx] = n
                    chFill.Size  = UDim2.new(n/255, 0, 1, 0)
                    chThumb.Position = UDim2.new(n/255, -5, 0.5, -6)
                    updateColor()
                    if hexBox and hexBox.Parent then hexBox.Text = toHex(rgb[1],rgb[2],rgb[3]) end
                    valBox.Text = tostring(n)
                end)

                local sliding2 = false
                local chBtn = btn(chTrack, UDim2.fromScale(1,1), nil, OVERLAY_Z+4)
                chBtn.MouseButton1Down:Connect(function(mx,_)
                    sliding2 = true
                    local abs2 = chTrack.AbsolutePosition
                    local siz2 = chTrack.AbsoluteSize
                    local pct  = math.clamp((mx - abs2.X) / siz2.X, 0, 1)
                    local n    = math.floor(pct * 255)
                    rgb[ch.idx] = n
                    chFill.Size = UDim2.new(pct, 0, 1, 0)
                    chThumb.Position = UDim2.new(pct, -5, 0.5, -6)
                    valBox.Text = tostring(n)
                    updateColor()
                    if hexBox and hexBox.Parent then hexBox.Text = toHex(rgb[1],rgb[2],rgb[3]) end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if sliding2 and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local abs2 = chTrack.AbsolutePosition
                        local siz2 = chTrack.AbsoluteSize
                        local pct  = math.clamp((i.Position.X - abs2.X) / siz2.X, 0, 1)
                        local n    = math.floor(pct * 255)
                        rgb[ch.idx] = n
                        chFill.Size = UDim2.new(pct, 0, 1, 0)
                        chThumb.Position = UDim2.new(pct, -5, 0.5, -6)
                        valBox.Text = tostring(n)
                        updateColor()
                        if hexBox and hexBox.Parent then hexBox.Text = toHex(rgb[1],rgb[2],rgb[3]) end
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding2 = false end
                end)
            end


            local swatchRow = frame(panel, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, 26))
            swatchRow.BackgroundTransparency = 1
            swatchRow.LayoutOrder = 5

            local swatchFr = frame(swatchRow, value, UDim2.new(1, 0, 1, 0))
            corner(swatchFr, CORNER_SM)
            stroke(swatchFr, theme.ElementStroke, 1)
            swatchFr.ZIndex = OVERLAY_Z + 1


            local totalH = 10 + 26 + 7 + 3*(26+7) + 26 + 10
            panel.Size = UDim2.new(0, 220, 0, totalH)
            positionPopup(panel, preview, -172, 5)
            panel.Size = UDim2.new(0, 220, 0, 0)
            tw(panel, { Size = UDim2.new(0, 220, 0, totalH) }, ANIM_FAST)
            tw(chevron2, { Rotation = 180 })

            panelTrackConn = RunService.Heartbeat:Connect(function()
                if panel and panel.Parent and preview and preview.Parent then
                    positionPopup(panel, preview, -172, 5)

                    if swatchFr and swatchFr.Parent then
                        swatchFr.BackgroundColor3 = Color3.fromRGB(rgb[1],rgb[2],rgb[3])
                    end
                else
                    if panelTrackConn then panelTrackConn:Disconnect(); panelTrackConn = nil end
                end
            end)

            panelConn = UserInputService.InputBegan:Connect(function(i, gp)
                if gp then return end
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mx, my = i.Position.X, i.Position.Y
                    if panel then
                        local pp = panel.AbsolutePosition; local ps = panel.AbsoluteSize
                        local fp = f.AbsolutePosition;    local fs = f.AbsoluteSize
                        local inP = mx >= pp.X and mx <= pp.X+ps.X and my >= pp.Y and my <= pp.Y+ps.Y
                        local inF = mx >= fp.X and mx <= fp.X+fs.X and my >= fp.Y and my <= fp.Y+fs.Y
                        if not inP and not inF then closePanel() end
                    end
                end
            end)

            registerOverlay(closePanel)
        end

        local b = btn(f)
        b.MouseEnter:Connect(function() if not disabled then tw(f, { BackgroundColor3 = theme.ElementHover }) end end)
        b.MouseLeave:Connect(function()
            if not disabled and not open then tw(f, { BackgroundColor3 = cfg.Color or theme.Element }) end
        end)
        b.MouseButton1Click:Connect(function()
            if disabled then return end
            open = not open
            if open then closeAllOverlays(); open = true; buildPanel()
            else closePanel() end
        end)

        if disabled then f.BackgroundTransparency = 0.5 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get() return value end
        function obj:Set(col)
            value = col
            rgb[1] = math.floor(col.R*255)
            rgb[2] = math.floor(col.G*255)
            rgb[3] = math.floor(col.B*255)
            preview.BackgroundColor3 = col
            if open then closeAllOverlays(); open = true; buildPanel() end
        end
        function obj:SetDisabled(v)
            disabled = v
            f.BackgroundTransparency = v and 0.5 or 0
        end
        return obj
    end


    function Tab:Section(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, 22))
        f.BackgroundTransparency = 1

        local l = lbl(f, (cfg.Title or ""):upper(), theme.TextSecondary, 10, Enum.Font.GothamBold)
        l.Size     = UDim2.new(1, -28, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)

        local line = frame(f, theme.ElementStroke2, UDim2.new(1, -28, 0, 1), UDim2.new(0, 14, 1, -1))
        line.BackgroundTransparency = 0

        f.Parent = page
    end


    function Tab:Divider(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, cfg.Label and 22 or 10))
        f.BackgroundTransparency = 1

        if cfg.Label then
            local ll = lbl(f, cfg.Label, theme.TextSecondary, 10, Enum.Font.Gotham, Enum.TextXAlignment.Center)
            ll.Size = UDim2.new(1, 0, 1, 0)
        end

        local line = frame(f, cfg.Color or theme.ElementStroke2, UDim2.new(1, -28, 0, 1), UDim2.new(0, 14, 1, -1))
        f.Parent = page
    end


    function Tab:Space(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, cfg.Height or 8))
        f.BackgroundTransparency = 1
        f.Parent = page
    end


    function Tab:Label(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, 20))
        f.BackgroundTransparency = 1
        local l = lbl(f, cfg.Title or "", cfg.Color or theme.TextSecondary, 12, Enum.Font.Gotham)
        l.Size     = UDim2.new(1, -28, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        f.Parent = page
    end


    function Tab:Paragraph(cfg)
        cfg = cfg or {}
        local desc = cfg.Desc or ""
        local lineCount = math.max(1, math.ceil(utf8.len(desc) / 52))
        local h = 30 + lineCount * 16

        local f = frame(page, theme.Element, UDim2.new(1, 0, 0, h))
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)

        local titleLbl2 = lbl(f, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        titleLbl2.Size     = UDim2.new(1, -28, 0, 18)
        titleLbl2.Position = UDim2.new(0, 14, 0, 8)

        local descLbl2 = lbl(f, desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        descLbl2.Size       = UDim2.new(1, -28, 0, h - 30)
        descLbl2.Position   = UDim2.new(0, 14, 0, 26)
        descLbl2.TextWrapped = true
        descLbl2.TextYAlignment = Enum.TextYAlignment.Top

        f.Parent = page
    end


    function Tab:Badge(items)
        items = items or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, 28))
        f.BackgroundTransparency = 1
        pad(f, 0, 0, 14, 14)

        local rowLayout = Instance.new("UIListLayout")
        rowLayout.FillDirection  = Enum.FillDirection.Horizontal
        rowLayout.Padding        = UDim.new(0, 6)
        rowLayout.SortOrder      = Enum.SortOrder.LayoutOrder
        rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        rowLayout.Parent         = f

        for _, badge in ipairs(items) do
            local bg = frame(f, badge.Color or theme.Accent, UDim2.new(0, 0, 0, 20))
            bg.AutomaticSize = Enum.AutomaticSize.X
            corner(bg, CORNER_PILL)
            pad(bg, 0, 0, 8, 8)

            local bl = lbl(bg, badge.Text or "", Color3.fromRGB(255,255,255), 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            bl.Size = UDim2.new(0, 0, 1, 0)
            bl.AutomaticSize = Enum.AutomaticSize.X
        end

        f.Parent = page
    end


    function Tab:ProfileFrame(cfg)
        cfg = cfg or {}
        local h = 72 + (cfg.Badges and #cfg.Badges > 0 and 28 or 0)
        local f = frame(page, cfg.Color or theme.ProfileBg, UDim2.new(1, 0, 0, h))
        corner(f, CORNER_EL)
        stroke(f, theme.CardStroke, 1)

        local avatarBg = frame(f, theme.ElementStroke, UDim2.new(0, 40, 0, 40), UDim2.new(0, 12, 0.5, -20))
        corner(avatarBg, CORNER_PILL)

        if cfg.UserId and cfg.UserId ~= 0 then
            local avatar = Instance.new("ImageLabel")
            avatar.Size               = UDim2.fromScale(1, 1)
            avatar.BackgroundTransparency = 1
            avatar.ScaleType          = Enum.ScaleType.Crop
            avatar.ZIndex             = 2
            avatar.Parent             = avatarBg
            corner(avatar, CORNER_PILL)
            task.spawn(function()
                local ok, thumb = pcall(function()
                    return game:GetService("Players"):GetUserThumbnailAsync(
                        cfg.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48
                    )
                end)
                if ok then avatar.Image = thumb end
            end)
        else
            local initials = (cfg.Username or "?"):sub(1,1):upper()
            local initLbl = lbl(avatarBg, initials, theme.TextPrimary, 18, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            initLbl.Size  = UDim2.fromScale(1,1)
            initLbl.ZIndex = 2
        end

        local roleBadge = cfg.Role and cfg.Role ~= "" and cfg.Role or nil
        local nameText = cfg.Username or "Unknown"
        local nameLbl  = lbl(f, nameText, theme.TextPrimary, 14, Enum.Font.GothamBold)
        nameLbl.Size     = UDim2.new(1, -70, 0, 18)
        nameLbl.Position = UDim2.new(0, 60, 0, 10)

        if roleBadge then
            local rb = frame(f, theme.Accent, UDim2.new(0, 0, 0, 16))
            rb.AutomaticSize = Enum.AutomaticSize.X
            rb.Position      = UDim2.new(1, -12, 0, 10)
            rb.AnchorPoint   = Vector2.new(1, 0)
            corner(rb, CORNER_PILL)
            pad(rb, 0, 0, 6, 6)
            local rl = lbl(rb, roleBadge, theme.AccentFg, 9, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            rl.Size = UDim2.new(0, 0, 1, 0)
            rl.AutomaticSize = Enum.AutomaticSize.X
            rl.TextTruncate  = Enum.TextTruncate.None
        end

        local descLbl2 = lbl(f, cfg.Desc or "", theme.TextSecondary, 11, Enum.Font.Gotham)
        descLbl2.Size     = UDim2.new(1, -70, 0, 16)
        descLbl2.Position = UDim2.new(0, 60, 0, 30)
        descLbl2.TextTruncate = Enum.TextTruncate.AtEnd

        if cfg.Badges and #cfg.Badges > 0 then
            local badgeRow = frame(f, Color3.fromRGB(0,0,0), UDim2.new(1, -60, 0, 20))
            badgeRow.BackgroundTransparency = 1
            badgeRow.Position = UDim2.new(0, 60, 0, 50)
            local bl2 = Instance.new("UIListLayout")
            bl2.FillDirection = Enum.FillDirection.Horizontal
            bl2.Padding = UDim.new(0, 4)
            bl2.SortOrder = Enum.SortOrder.LayoutOrder
            bl2.VerticalAlignment = Enum.VerticalAlignment.Center
            bl2.Parent = badgeRow
            for _, badge in ipairs(cfg.Badges) do
                local bg2 = frame(badgeRow, badge.Color or theme.Accent, UDim2.new(0, 0, 0, 18))
                bg2.AutomaticSize = Enum.AutomaticSize.X
                corner(bg2, CORNER_PILL)
                pad(bg2, 0, 0, 5, 5)
                local btl = lbl(bg2, badge.Text or "", Color3.fromRGB(255,255,255), 9, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
                btl.Size = UDim2.new(0, 0, 1, 0)
                btl.AutomaticSize = Enum.AutomaticSize.X
                btl.TextTruncate = Enum.TextTruncate.None
            end
        end

        f.Parent = page
    end


    function Tab:Card(cfg)
        cfg = cfg or {}
        local h    = cfg.Height or 82
        local f    = frame(page, cfg.Color or theme.CardBg, UDim2.new(1, 0, 0, h))
        corner(f, CORNER_EL)
        stroke(f, cfg.AccentColor and cfg.AccentColor or theme.CardStroke, 1)

        if cfg.AccentColor then
            local accentBar = frame(f, cfg.AccentColor, UDim2.new(0, 3, 1, -14), UDim2.new(0, 0, 0, 7))
            corner(accentBar, UDim.new(0, 2))
        end

        local iconX = cfg.AccentColor and 16 or 14
        if cfg.Icon and cfg.Icon ~= "" then
            local iconLbl = lbl(f, cfg.Icon, cfg.AccentColor or theme.Accent, 22, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            iconLbl.Size     = UDim2.new(0, 32, 0, 32)
            iconLbl.Position = UDim2.new(0, iconX, 0, 10)
        end

        local textX = (cfg.Icon and cfg.Icon ~= "") and (iconX + 40) or (iconX)
        local titleLbl2 = lbl(f, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        titleLbl2.Size     = UDim2.new(1, -(textX + 80), 0, 18)
        titleLbl2.Position = UDim2.new(0, textX, 0, 10)

        local descLbl2 = lbl(f, cfg.Desc or "", theme.TextSecondary, 11, Enum.Font.Gotham)
        descLbl2.Size     = UDim2.new(1, -(textX + 80), 0, 16)
        descLbl2.Position = UDim2.new(0, textX, 0, 28)
        descLbl2.TextTruncate = Enum.TextTruncate.AtEnd

        local valLbl = lbl(f, tostring(cfg.Value or ""), cfg.ValueColor or theme.Accent, 22, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        valLbl.Size     = UDim2.new(0, 70, 0, 28)
        valLbl.Position = UDim2.new(1, -84, 0, 10)
        valLbl.TextTruncate = Enum.TextTruncate.AtEnd

        if cfg.Callback then
            local b = btn(f)
            b.MouseEnter:Connect(function() tw(f, { BackgroundColor3 = cfg.Color and cfg.Color or theme.ElementHover }) end)
            b.MouseLeave:Connect(function() tw(f, { BackgroundColor3 = cfg.Color or theme.CardBg }) end)
            b.MouseButton1Click:Connect(function() task.spawn(function() pcall(cfg.Callback) end) end)
        end

        f.Parent = page

        local obj = { _frame = f }
        function obj:SetValue(v)
            valLbl.Text = tostring(v)
        end
        function obj:SetDesc(v)
            descLbl2.Text = v
        end
        return obj
    end


    function Tab:CardRow(items)
        items = items or {}
        local n    = #items
        local f    = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1, 0, 0, 74))
        f.BackgroundTransparency = 1
        f.Parent = page

        local rowLayout2 = Instance.new("UIListLayout")
        rowLayout2.FillDirection         = Enum.FillDirection.Horizontal
        rowLayout2.Padding               = UDim.new(0, 6)
        rowLayout2.SortOrder             = Enum.SortOrder.LayoutOrder
        rowLayout2.HorizontalAlignment   = Enum.HorizontalAlignment.Center
        rowLayout2.FillDirection         = Enum.FillDirection.Horizontal
        rowLayout2.Parent                = f

        local objs = {}
        for i, item in ipairs(items) do
            local cardW = UDim2.new(1/n, i < n and -4 or -(n-1)*2, 1, 0)
            local c = frame(f, theme.CardBg, cardW)
            corner(c, CORNER_EL)
            stroke(c, theme.CardStroke, 1)

            local vl = lbl(c, tostring(item.Value or 0), item.ValueColor or theme.Accent, 20, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            vl.Size     = UDim2.new(1, 0, 0, 26)
            vl.Position = UDim2.new(0, 0, 0, 10)

            local tl = lbl(c, item.Title or "", theme.TextPrimary, 11, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
            tl.Size     = UDim2.new(1, 0, 0, 16)
            tl.Position = UDim2.new(0, 0, 0, 36)

            if item.Sub then
                local sl = lbl(c, item.Sub, theme.TextSecondary, 10, Enum.Font.Gotham, Enum.TextXAlignment.Center)
                sl.Size     = UDim2.new(1, 0, 0, 14)
                sl.Position = UDim2.new(0, 0, 0, 52)
            end

            local obj2 = { _frame = c }
            function obj2:SetValue(v) vl.Text = tostring(v) end
            function obj2:SetTitle(v) tl.Text = v end
            objs[i] = obj2
        end

        return objs
    end


    function Tab:Table(cfg)
        cfg = cfg or {}
        local headers = cfg.Headers or {}
        local rows    = cfg.Rows    or {}
        local rowH    = 32
        local headH   = 30
        local totalH  = headH + #rows * rowH + 2

        local f = frame(page, theme.CardBg, UDim2.new(1, 0, 0, totalH))
        corner(f, CORNER_EL)
        stroke(f, theme.CardStroke, 1)
        f.ClipsDescendants = true


        local headRow = frame(f, theme.ElementActive, UDim2.new(1, 0, 0, headH))
        corner(headRow, UDim.new(0, 7))

        local headLayout = Instance.new("UIListLayout")
        headLayout.FillDirection       = Enum.FillDirection.Horizontal
        headLayout.SortOrder           = Enum.SortOrder.LayoutOrder
        headLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        headLayout.Parent              = headRow

        local colW = 1 / math.max(1, #headers)
        for _, h in ipairs(headers) do
            local cell = frame(headRow, Color3.fromRGB(0,0,0), UDim2.new(colW, 0, 1, 0))
            cell.BackgroundTransparency = 1
            local hl = lbl(cell, h, theme.TextSecondary, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            hl.Size = UDim2.fromScale(1,1)
        end


        for ri, row in ipairs(rows) do
            local rowFrame = frame(f, ri % 2 == 0 and theme.Element or theme.CardBg, UDim2.new(1, 0, 0, rowH))
            rowFrame.Position = UDim2.new(0, 0, 0, headH + (ri - 1) * rowH)

            if ri == #rows then
                corner(rowFrame, UDim.new(0, 7))
            end

            local rLayout = Instance.new("UIListLayout")
            rLayout.FillDirection       = Enum.FillDirection.Horizontal
            rLayout.SortOrder           = Enum.SortOrder.LayoutOrder
            rLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            rLayout.Parent              = rowFrame

            for ci, cell in ipairs(row) do
                local cellFr = frame(rowFrame, Color3.fromRGB(0,0,0), UDim2.new(colW, 0, 1, 0))
                cellFr.BackgroundTransparency = 1
                local color = (ci == 1 and theme.TextPrimary) or theme.TextSecondary
                local cl = lbl(cellFr, tostring(cell), color, 11, Enum.Font.Gotham, Enum.TextXAlignment.Center)
                cl.Size = UDim2.fromScale(1,1)
                cl.TextTruncate = Enum.TextTruncate.AtEnd
            end
        end

        f.Parent = page
    end

end

function TryxLib.new(cfg)
    cfg = cfg or {}
    local theme     = cfg.Theme   or Themes.Default
    local titleText = cfg.Title   or "TryxLib"
    local toggleKey = cfg.Key     or Enum.KeyCode.RightAlt
    local startOpen = cfg.Open    ~= false

    local gui = Instance.new("ScreenGui")
    gui.Name             = "TryxLib_" .. titleText:gsub("%s","")
    gui.ResetOnSpawn     = false
    gui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder     = 100
    gui.IgnoreGuiInset   = true
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end


    local vp  = Camera.ViewportSize
    local win = frame(gui, theme.Background, UDim2.new(0, DEFAULT_W, 0, DEFAULT_H))
    win.Position         = UDim2.new(0, math.floor((vp.X - DEFAULT_W) / 2), 0, math.floor((vp.Y - DEFAULT_H) / 2))
    win.ClipsDescendants = false
    win.Visible          = startOpen
    corner(win, CORNER_WIN)
    stroke(win, theme.ElementStroke, 1)
    shadow(win, 28, 0.5)


    local topBar = frame(win, theme.TopBar, UDim2.new(1, 0, 0, TOPBAR_H))
    corner(topBar, CORNER_WIN)

    local topBarFill = frame(win, theme.TopBar, UDim2.new(1, 0, 0, TOPBAR_H / 2))
    topBarFill.Position = UDim2.new(0, 0, 0, TOPBAR_H / 2)
    topBarFill.ZIndex   = 0

    local titleLbl = lbl(topBar, titleText, theme.TextPrimary, 13, Enum.Font.GothamBold)
    titleLbl.Size     = UDim2.new(1, -100, 1, 0)
    titleLbl.Position = UDim2.new(0, 16, 0, 0)
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd


    local function winCtrl(parent, color, xOffset)
        local dot = frame(parent, color, UDim2.new(0, 11, 0, 11))
        dot.Position  = UDim2.new(1, xOffset, 0.5, -6)
        dot.ZIndex    = 3
        corner(dot, CORNER_PILL)
        local b2 = btn(parent, UDim2.new(0, 20, 0, 20), UDim2.new(1, xOffset - 5, 0.5, -10), 4)
        return dot, b2
    end

    local closeDot, closeB = winCtrl(topBar, theme.Danger, -22)
    closeB.MouseButton1Click:Connect(function()
        tw(win, { Size = UDim2.new(0, DEFAULT_W, 0, 0) }, ANIM_FAST)
        task.delay(ANIM_FAST + 0.02, function()
            win.Visible = false
            win.Size    = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H)
        end)
    end)

    local minimized   = false
    local prevSize    = win.Size
    local minDot, minB = winCtrl(topBar, theme.Warning, -40)
    minB.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            prevSize = win.Size
            tw(win, { Size = UDim2.new(0, win.AbsoluteSize.X, 0, TOPBAR_H) }, ANIM_MED)
        else
            tw(win, { Size = prevSize }, ANIM_MED)
        end
    end)


    local resizeHandle = frame(win, theme.ElementStroke, UDim2.new(0, 13, 0, 13))
    resizeHandle.Position    = UDim2.new(1, -13, 1, -13)
    resizeHandle.AnchorPoint = Vector2.new(1, 1)
    resizeHandle.ZIndex      = 5
    corner(resizeHandle, UDim.new(0, 3))
    makeResizable(resizeHandle, win)

    makeDraggable(topBar, win)


    local sideBar = frame(win, theme.Sidebar, UDim2.new(0, SIDEBAR_W, 1, -TOPBAR_H))
    sideBar.Position    = UDim2.new(0, 0, 0, TOPBAR_H)
    sideBar.ZIndex      = 1


    local sideBottom = frame(win, theme.Sidebar, UDim2.new(0, SIDEBAR_W, 0, CORNER_WIN.Offset))
    sideBottom.Position = UDim2.new(0, 0, 1, -CORNER_WIN.Offset)
    sideBottom.ZIndex   = 1

    local tabListSF = Instance.new("ScrollingFrame")
    tabListSF.Size                   = UDim2.fromScale(1, 1)
    tabListSF.BackgroundTransparency = 1
    tabListSF.BorderSizePixel        = 0
    tabListSF.ScrollBarThickness     = 0
    tabListSF.CanvasSize             = UDim2.new(0, 0, 0, 0)
    tabListSF.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    tabListSF.ScrollingDirection     = Enum.ScrollingDirection.Y
    tabListSF.Parent                 = sideBar
    pad(tabListSF, 8, 8, 0, 0)

    listLayout(tabListSF, 3)


    local activeIndicator = frame(sideBar, theme.Accent, UDim2.new(0, 2, 0, 22))
    activeIndicator.AnchorPoint = Vector2.new(0, 0.5)
    activeIndicator.Position    = UDim2.new(0, 0, 0, 0)
    activeIndicator.ZIndex      = 3
    corner(activeIndicator, CORNER_PILL)
    activeIndicator.Visible = false


    local contentArea = frame(win, theme.Background, UDim2.new(1, -SIDEBAR_W, 1, -TOPBAR_H))
    contentArea.Position    = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)
    contentArea.ClipsDescendants = true
    corner(contentArea, UDim.new(0, CORNER_WIN.Offset))


    local divider2 = frame(win, theme.ElementStroke, UDim2.new(0, 1, 1, -TOPBAR_H))
    divider2.Position = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)
    divider2.ZIndex   = 2

    local tabs          = {}
    local activeTabBtn  = nil
    local activeTabPage = nil

    local Library = {}

    function Library:Tab(tabCfg)
        tabCfg = tabCfg or {}
        local tabTitle = tabCfg.Title or "Tab"
        local tabIcon  = tabCfg.Icon  or ""


        local tabBtn = frame(tabListSF, theme.TabInactive, UDim2.new(1, 0, 0, 36))
        corner(tabBtn, CORNER_SM)

        local iconLbl2 = lbl(tabBtn, tabIcon, theme.TextSecondary, 14, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        iconLbl2.Size     = UDim2.new(0, 24, 1, 0)
        iconLbl2.Position = UDim2.new(0, 8, 0, 0)
        iconLbl2.TextTruncate = Enum.TextTruncate.None

        local tabTitleLbl = lbl(tabBtn, tabTitle, theme.TextSecondary, 11, Enum.Font.Gotham)
        tabTitleLbl.Size     = UDim2.new(1, -(tabIcon ~= "" and 38 or 14), 1, 0)
        tabTitleLbl.Position = UDim2.new(0, tabIcon ~= "" and 36 or 10, 0, 0)
        tabTitleLbl.TextTruncate = Enum.TextTruncate.AtEnd


        local page = scrollFrame(contentArea, UDim2.fromScale(1, 1), nil, theme.ScrollBar)
        page.Visible = false
        pad(page, 8, 8, 8, 8)
        listLayout(page, 5)

        local Tab = {}
        injectElements(Tab, theme, page, gui, Library)

        local function activate()
            if activeTabBtn then
                tw(activeTabBtn, { BackgroundColor3 = theme.TabInactive })
                local prevIcon = activeTabBtn:FindFirstChildOfClass("TextLabel")
                if prevIcon then tw(prevIcon, { TextColor3 = theme.TextSecondary }) end

                for _, c in ipairs(activeTabBtn:GetChildren()) do
                    if c:IsA("TextLabel") then tw(c, { TextColor3 = theme.TextSecondary }) end
                end
            end
            if activeTabPage then
                activeTabPage.Visible = false
            end
            activeTabBtn  = tabBtn
            activeTabPage = page

            tw(tabBtn, { BackgroundColor3 = theme.TabActive })
            tw(tabTitleLbl, { TextColor3 = theme.TextPrimary })
            tw(iconLbl2, { TextColor3 = theme.Accent })


            activeIndicator.Visible = true
            local yPos = tabBtn.AbsolutePosition.Y - sideBar.AbsolutePosition.Y + 7
            tw(activeIndicator, { Position = UDim2.new(0, 0, 0, yPos), Size = UDim2.new(0, 2, 0, 22) })

            page.Visible = true
        end

        local tabBtnB = btn(tabBtn)
        tabBtnB.MouseEnter:Connect(function()
            if activeTabBtn ~= tabBtn then
                tw(tabBtn, { BackgroundColor3 = theme.TabHover })
            end
        end)
        tabBtnB.MouseLeave:Connect(function()
            if activeTabBtn ~= tabBtn then
                tw(tabBtn, { BackgroundColor3 = theme.TabInactive })
            end
        end)
        tabBtnB.MouseButton1Click:Connect(function()
            closeAllOverlays()
            activate()
        end)

        table.insert(tabs, { btn = tabBtn, page = page, tab = Tab })

        if #tabs == 1 then
            activate()
        end

        return Tab
    end

    function Library:Notify(cfg2)
        notify(theme, cfg2)
    end

    function Library:SetTheme(newTheme)
        theme = newTheme
    end

    function Library:Destroy()
        closeAllOverlays()
        if gui and gui.Parent then gui:Destroy() end
        if notifyGui and notifyGui.Parent then notifyGui:Destroy() end
    end

    function Library:Toggle()
        win.Visible = not win.Visible
        if win.Visible then
            tw(win, { Size = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H) }, ANIM_MED)
        end
    end


    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == toggleKey then
            Library:Toggle()
        end
    end)

    return Library
end

TryxLib.Library = TryxLib

return TryxLib
