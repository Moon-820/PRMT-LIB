--[[
    ████████╗██████╗ ██╗   ██╗██╗  ██╗██╗     ██╗██████╗
       ██╔══╝██╔══██╗╚██╗ ██╔╝╚██╗██╔╝██║     ██║██╔══██╗
       ██║   ██████╔╝ ╚████╔╝  ╚███╔╝ ██║     ██║██████╔╝
       ██║   ██╔══██╗  ╚██╔╝   ██╔██╗ ██║     ██║██╔══██╗
       ██║   ██║  ██║   ██║   ██╔╝ ██╗███████╗██║██████╔╝
       ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝╚═════╝
    
    Version  : 2.0
    License  : MIT
    Author   : TryxLib Team
    
    CHANGELOG v2.0
    ──────────────
    • Hello !
--]]

local TryxLib = {}
TryxLib.__index = TryxLib

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

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
    OverlayBg      = Color3.fromRGB(16, 16, 20),
    OverlayStroke  = Color3.fromRGB(44, 44, 54),
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
    OverlayBg      = Color3.fromRGB(14, 14, 14),
    OverlayStroke  = Color3.fromRGB(38, 38, 38),
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
    OverlayBg      = Color3.fromRGB(12, 12, 26),
    OverlayStroke  = Color3.fromRGB(42, 42, 80),
}

local SIDEBAR_W   = 168
local TOPBAR_H    = 44
local MIN_W       = 500
local MIN_H       = 340
local DEFAULT_W   = 630
local DEFAULT_H   = 430
local ELEMENT_H   = 46
local CORNER_WIN  = UDim.new(0, 10)
local CORNER_EL   = UDim.new(0, 7)
local CORNER_SM   = UDim.new(0, 5)
local ANIM_FAST   = 0.10
local ANIM_MED    = 0.16
local ANIM_SLOW   = 0.25

local _activeOverlayCloser = nil
local function registerOverlay(closeFn)
    if _activeOverlayCloser then
        pcall(_activeOverlayCloser)
        _activeOverlayCloser = nil
    end
    _activeOverlayCloser = closeFn
end

local function closeActiveOverlay()
    if _activeOverlayCloser then
        pcall(_activeOverlayCloser)
        _activeOverlayCloser = nil
    end
end

TryxLib._registerOverlay   = registerOverlay
TryxLib._closeOverlay      = closeActiveOverlay

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
    l.Text               = text or ""
    l.TextColor3         = col or Color3.fromRGB(240, 240, 240)
    l.TextSize           = sz or 13
    l.Font               = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment     = xa or Enum.TextXAlignment.Left
    l.TextYAlignment     = Enum.TextYAlignment.Center
    l.TextTruncate       = Enum.TextTruncate.AtEnd
    l.Parent             = parent
    return l
end

local function btn(parent, size, pos, zi)
    local b = Instance.new("TextButton")
    b.Size               = size or UDim2.fromScale(1, 1)
    b.Position           = pos or UDim2.new(0, 0, 0, 0)
    b.BackgroundTransparency = 1
    b.Text               = ""
    b.BorderSizePixel    = 0
    b.AutoButtonColor    = false
    b.ZIndex             = zi or 2
    b.Parent             = parent
    return b
end

local function shadow(parent)
    local s = Instance.new("ImageLabel")
    s.Name               = "Shadow"
    s.Size               = UDim2.new(1, 40, 1, 40)
    s.Position           = UDim2.new(0, -20, 0, -20)
    s.BackgroundTransparency = 1
    s.Image              = "rbxassetid://6014261993"
    s.ImageColor3        = Color3.fromRGB(0, 0, 0)
    s.ImageTransparency  = 0.5
    s.ScaleType          = Enum.ScaleType.Slice
    s.SliceCenter        = Rect.new(49, 49, 450, 450)
    s.ZIndex             = 0
    s.Parent             = parent
    return s
end

local function ripple(parent, theme)
    local r = frame(parent, theme.Accent, UDim2.new(0, 0, 0, 0))
    r.AnchorPoint        = Vector2.new(0.5, 0.5)
    r.Position           = UDim2.new(0.5, 0, 0.5, 0)
    r.BackgroundTransparency = 0.82
    r.ZIndex             = 8
    corner(r, UDim.new(1, 0))
    local sz = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.4
    tw(r, { Size = UDim2.new(0, sz, 0, sz), BackgroundTransparency = 1 }, 0.48, Enum.EasingStyle.Quart)
    task.delay(0.5, function() r:Destroy() end)
end

local function makeDraggable(handle, target)
    local dragging = false
    local ds, sp

    local function onStart(pos)
        dragging = true
        ds = pos
        sp = target.Position
    end

    local function onMove(pos)
        if not dragging then return end
        local d = pos - ds
        local vp = workspace.CurrentCamera.ViewportSize
        target.Position = UDim2.new(0,
            math.clamp(sp.X.Offset + d.X, 0, vp.X - target.AbsoluteSize.X),
            0,
            math.clamp(sp.Y.Offset + d.Y, 0, vp.Y - target.AbsoluteSize.Y)
        )
    end

    local function onEnd()
        dragging = false
    end

    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            onStart(i.Position)
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            onMove(i.Position)
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            onEnd()
        end
    end)
end

local function makeResizable(handle, target)
    local resizing = false
    local rs, ss

    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            rs = i.Position
            ss = target.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if not resizing then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            local d = i.Position - rs
            target.Size = UDim2.new(0,
                math.max(MIN_W, ss.X.Offset + d.X),
                0,
                math.max(MIN_H, ss.Y.Offset + d.Y)
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
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
    [Enum.KeyCode.Home]         = "HOME",
    [Enum.KeyCode.End]          = "END",
    [Enum.KeyCode.Up]           = "↑",
    [Enum.KeyCode.Down]         = "↓",
    [Enum.KeyCode.Left]         = "←",
    [Enum.KeyCode.Right]        = "→",
    [Enum.KeyCode.F1]  = "F1",  [Enum.KeyCode.F2]  = "F2",  [Enum.KeyCode.F3]  = "F3",
    [Enum.KeyCode.F4]  = "F4",  [Enum.KeyCode.F5]  = "F5",  [Enum.KeyCode.F6]  = "F6",
    [Enum.KeyCode.F7]  = "F7",  [Enum.KeyCode.F8]  = "F8",  [Enum.KeyCode.F9]  = "F9",
    [Enum.KeyCode.F10] = "F10", [Enum.KeyCode.F11] = "F11", [Enum.KeyCode.F12] = "F12",
}

local function keyName(kc)
    return keyNames[kc] or kc.Name:upper()
end

local notifyCount = 0
local MAX_NOTIFY  = 5
local notifyGui   = nil

local ntypes = {
    success = { col = Color3.fromRGB(58,  188, 98),  icon = "✓" },
    error   = { col = Color3.fromRGB(210, 58,  58),  icon = "✕" },
    warn    = { col = Color3.fromRGB(218, 158, 38),  icon = "!" },
    info    = { col = Color3.fromRGB(72,  148, 228), icon = "i" },
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

    local cont = frame(g, Color3.fromRGB(0, 0, 0), UDim2.new(0, 300, 1, -20), UDim2.new(1, -314, 0, 10))
    cont.Name                   = "Container"
    cont.BackgroundTransparency = 1
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
    local accent   = cfg.Color or td.col

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
    iconBg.Position           = UDim2.new(0, 14, 0.5, -14)
    iconBg.ZIndex             = 11
    iconBg.BackgroundTransparency = 0.1
    corner(iconBg, UDim.new(1, 0))

    local iconL = lbl(iconBg, td.icon, Color3.fromRGB(255, 255, 255), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    iconL.Size   = UDim2.fromScale(1, 1)
    iconL.ZIndex = 12

    local tl = lbl(n, title, theme.TextPrimary, 13, Enum.Font.GothamBold)
    tl.Size     = UDim2.new(1, -58, 0, 17)
    tl.Position = UDim2.new(0, 50, 0, 10)
    tl.ZIndex   = 11

    local dl = lbl(n, desc, theme.TextSecondary, 11, Enum.Font.Gotham)
    dl.Size        = UDim2.new(1, -58, 0, 14)
    dl.Position    = UDim2.new(0, 50, 0, 29)
    dl.ZIndex      = 11
    dl.TextWrapped = true

    local prog = frame(n, accent, UDim2.new(1, 0, 0, 2))
    prog.Position           = UDim2.new(0, 0, 1, -2)
    prog.ZIndex             = 12
    prog.BackgroundTransparency = 0.2

    tw(wrapper, { Size = UDim2.new(1, 0, 0, 76) }, ANIM_MED)
    tw(prog, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        tw(wrapper, { Size = UDim2.new(1, 0, 0, 0) }, ANIM_FAST)
        task.delay(ANIM_FAST + 0.05, function()
            pcall(function() wrapper:Destroy() end)
            notifyCount = math.max(0, notifyCount - 1)
        end)
    end

    task.delay(duration, dismiss)
    local cb = btn(n, UDim2.fromScale(1, 1), nil, 13)
    cb.MouseButton1Click:Connect(dismiss)
end

local function baseEl(theme, cfg, h)
    local hasDesc = cfg.Desc and cfg.Desc ~= ""
    local height  = (h or ELEMENT_H) + (hasDesc and 16 or 0)

    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, height)
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BorderSizePixel  = 0
    f.ClipsDescendants = true
    if cfg.Transparency then
        f.BackgroundTransparency = cfg.Transparency
    end
    corner(f, CORNER_EL)
    stroke(f, theme.ElementStroke, 1)
    pad(f, 0, 0, 14, 14)
    return f, height
end

local function titleDescEl(parent, theme, cfg, offsetR, y)
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
    tl.Size        = UDim2.new(1, -(offsetR + iconOff), 0, 16)
    tl.Position    = UDim2.new(0, iconOff, 0, ty)
    tl.TextTruncate = Enum.TextTruncate.AtEnd

    if hasDesc then
        local dl = lbl(parent, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        dl.Size        = UDim2.new(1, -(offsetR + iconOff), 0, 14)
        dl.Position    = UDim2.new(0, iconOff, 0, ty + 18)
        dl.TextTruncate = Enum.TextTruncate.AtEnd
    end
    return tl
end

local function injectElements(Tab, theme, page)
  
     function Tab:Button(cfg)
        cfg = cfg or {}
        local disabled = cfg.Disabled or false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDescEl(f, theme, cfg, 34)

        local arr = lbl(f, "›", theme.Accent, 22, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        arr.Size     = UDim2.new(0, 22, 1, 0)
        arr.Position = UDim2.new(1, -26, 0, 0)

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
        return obj
    end

    function Tab:Toggle(cfg)
        cfg = cfg or {}
        local toggleType = cfg.Type or "Default"
        local value      = cfg.Value ~= nil and cfg.Value or false
        local disabled   = cfg.Disabled or false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDescEl(f, theme, cfg, 58)

        local updateFn

        if toggleType == "Checkbox" then
            local box = frame(f, value and theme.Accent or theme.InputBg, UDim2.new(0, 20, 0, 20))
            box.Position = UDim2.new(1, -24, 0.5, -10)
            corner(box, UDim.new(0, 5))
            local bs = stroke(box, value and theme.Accent or theme.ElementStroke, 1.5)

            local chk = lbl(box, "✓", Color3.fromRGB(255, 255, 255), 12, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            chk.Size             = UDim2.fromScale(1, 1)
            chk.TextTransparency = value and 0 or 1

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
        function obj:SetDisabled(v)
            disabled = v
            tw(f, { BackgroundTransparency = v and 0.4 or 0 })
        end
        return obj
    end
    
    function Tab:Input(cfg)
        cfg = cfg or {}
        local multiline = cfg.MultiLine or false
        local disabled  = cfg.Disabled or false
        local boxH      = multiline and 52 or 28
        local h         = multiline and (ELEMENT_H + boxH - 10) or (ELEMENT_H + 22)

        local f = baseEl(theme, cfg, h)

        local titleLbl = lbl(f, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        titleLbl.Size     = UDim2.new(1, 0, 0, 16)
        titleLbl.Position = UDim2.new(0, 0, 0, 8)

        if cfg.Desc and cfg.Desc ~= "" then
            local dl = lbl(f, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
            dl.Size     = UDim2.new(1, 0, 0, 14)
            dl.Position = UDim2.new(0, 0, 0, 24)
        end

        local boxY = (cfg.Desc and cfg.Desc ~= "") and 42 or 28

        local box = frame(f, theme.InputBg, UDim2.new(1, 0, 0, boxH))
        box.Position = UDim2.new(0, 0, 0, boxY)
        corner(box, CORNER_SM)
        local bStroke = stroke(box, theme.ElementStroke, 1)

        local input = Instance.new("TextBox")
        input.Size               = UDim2.new(1, -12, 1, multiline and -8 or 0)
        input.Position           = UDim2.new(0, 6, 0, multiline and 4 or 0)
        input.BackgroundTransparency = 1
        input.Text               = cfg.Default or ""
        input.PlaceholderText    = cfg.Placeholder or "Type here..."
        input.TextColor3         = theme.TextPrimary
        input.PlaceholderColor3  = theme.TextDisabled
        input.TextSize           = 12
        input.Font               = Enum.Font.Gotham
        input.TextXAlignment     = Enum.TextXAlignment.Left
        input.ClearTextOnFocus   = false
        input.MultiLine          = multiline
        input.TextWrapped        = multiline
        input.Editable           = not disabled
        input.TextEditable       = not disabled
        input.Parent             = box

        input.Focused:Connect(function()
            tw(box, { BackgroundColor3 = theme.ElementHover })
            tw(bStroke, { Color = theme.Accent })
        end)
        input.FocusLost:Connect(function(enter)
            tw(box, { BackgroundColor3 = theme.InputBg })
            tw(bStroke, { Color = theme.ElementStroke })
            if enter then
                task.spawn(function() pcall(cfg.Callback or function() end, input.Text) end)
            end
        end)
        if cfg.LiveCallback then
            input:GetPropertyChangedSignal("Text"):Connect(function()
                task.spawn(function() pcall(cfg.Callback or function() end, input.Text) end)
            end)
        end

        f.Parent = page
        local obj = { _frame = f }
        function obj:Get() return input.Text end
        function obj:Set(v) input.Text = v end
        return obj
    end

    -- ─── SLIDER ──────────────────────────────────────────────────────
    function Tab:Slider(cfg)
        cfg = cfg or {}
        local min      = cfg.Min    or 0
        local max      = cfg.Max    or 100
        local value    = math.clamp(cfg.Value or min, min, max)
        local suffix   = cfg.Suffix or ""
        local step     = cfg.Step   or 1
        local disabled = cfg.Disabled or false

        local h = 66
        local f = baseEl(theme, cfg, h)

        local titleLbl = lbl(f, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        titleLbl.Size     = UDim2.new(1, -60, 0, 16)
        titleLbl.Position = UDim2.new(0, 0, 0, 8)

        local valLbl = lbl(f, tostring(value) .. suffix, theme.Accent, 12, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        valLbl.Size     = UDim2.new(0, 56, 0, 16)
        valLbl.Position = UDim2.new(1, -56, 0, 8)

        local trackY = cfg.Desc and cfg.Desc ~= "" and 42 or 34

        local track = frame(f, theme.ElementStroke2, UDim2.new(1, 0, 0, 6))
        track.Position = UDim2.new(0, 0, 0, trackY)
        corner(track, UDim.new(1, 0))

        local fill = frame(track, cfg.AccentColor or theme.Accent, UDim2.new((value - min) / (max - min), 0, 1, 0))
        corner(fill, UDim.new(1, 0))

        local thumb = frame(track, Color3.fromRGB(255, 255, 255), UDim2.new(0, 14, 0, 14))
        thumb.AnchorPoint = Vector2.new(0.5, 0.5)
        thumb.Position    = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
        corner(thumb, UDim.new(1, 0))
        thumb.ZIndex = 3
        stroke(thumb, theme.ElementStroke, 1)

        local dragging = false

        local function snap(v)
            return math.clamp(math.floor(v / step + 0.5) * step, min, max)
        end

        local function updateSlider(posX)
            if disabled then return end
            local abs = track.AbsolutePosition.X
            local w   = track.AbsoluteSize.X
            if w <= 0 then return end
            local pct = math.clamp((posX - abs) / w, 0, 1)
            value = snap(min + pct * (max - min))
            pct   = (value - min) / (max - min)
            tw(fill,  { Size     = UDim2.new(pct, 0, 1, 0) }, 0.05)
            tw(thumb, { Position = UDim2.new(pct, 0, 0.5, 0) }, 0.05)
            valLbl.Text = tostring(value) .. suffix
            task.spawn(function() pcall(cfg.Callback or function() end, value) end)
        end

        -- Mouse + Touch input
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateSlider(i.Position.X)
            end
        end)

        UserInputService.InputChanged:Connect(function(i)
            if not dragging then return end
            if i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch then
                updateSlider(i.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get() return value end
        function obj:Set(v)
            value = snap(v)
            local pct = (value - min) / (max - min)
            tw(fill,  { Size     = UDim2.new(pct, 0, 1, 0) })
            tw(thumb, { Position = UDim2.new(pct, 0, 0.5, 0) })
            valLbl.Text = tostring(value) .. suffix
        end
        function obj:SetDisabled(v)
            disabled = v
            tw(f, { BackgroundTransparency = v and 0.4 or 0 })
        end
        return obj
    end

    -- ─── DROPDOWN ────────────────────────────────────────────────────
    function Tab:Dropdown(cfg)
        cfg = cfg or {}
        local values   = cfg.Values   or {}
        local value    = cfg.Value    or (values[1] or "")
        local multi    = cfg.Multi    == true
        local disabled = cfg.Disabled or false
        local selected = multi and {} or value

        local open = false
        local list = nil
        local listConn = nil

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = false
        titleDescEl(f, theme, cfg, 116)

        -- Selection display box
        local selBox = frame(f, theme.InputBg, UDim2.new(0, 104, 0, 26))
        selBox.Position = UDim2.new(1, -108, 0.5, -13)
        corner(selBox, CORNER_SM)
        stroke(selBox, theme.ElementStroke, 1)

        local selLbl = lbl(selBox, multi and "Select..." or value, theme.TextPrimary, 12, Enum.Font.Gotham)
        selLbl.Size     = UDim2.new(1, -24, 1, 0)
        selLbl.Position = UDim2.new(0, 8, 0, 0)
        selLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local chevron = lbl(selBox, "▾", theme.TextSecondary, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        chevron.Size     = UDim2.new(0, 18, 1, 0)
        chevron.Position = UDim2.new(1, -20, 0, 0)

        local function getDisplay()
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
            local l = list
            list = nil
            tw(l, { BackgroundTransparency = 1 }, ANIM_FAST)
            task.delay(ANIM_FAST + 0.02, function() pcall(function() l:Destroy() end) end)
            if listConn then listConn:Disconnect() listConn = nil end
            _activeOverlayCloser = nil
        end

        local function buildList()
            closeList()

            local sg = Tab._gui
            if not sg then return end

            open = true
            tw(chevron, { Rotation = 180 }, ANIM_FAST)

            -- Calculer la position à partir de l'élément parent
            -- On attend un frame pour que AbsolutePosition soit à jour
            RunService.Heartbeat:Wait()

            local abs  = selBox.AbsolutePosition
            local absS = selBox.AbsoluteSize
            local vp   = workspace.CurrentCamera.ViewportSize

            local itemH    = 30
            local maxItems = math.min(#values, 6)
            local listH    = maxItems * itemH + 8

            -- Déterminer si on ouvre en dessous ou en dessus
            local openBelow = (abs.Y + absS.Y + listH + 4) < vp.Y
            local listY     = openBelow and (abs.Y + absS.Y + 4) or (abs.Y - listH - 4)
            local listX     = math.clamp(abs.X, 4, vp.X - 108)

            list = Instance.new("Frame")
            list.Name              = "TryxLib_DropList"
            list.Size              = UDim2.new(0, 104, 0, listH)
            list.Position          = UDim2.new(0, listX, 0, listY)
            list.BackgroundColor3  = theme.OverlayBg or theme.Element
            list.BackgroundTransparency = 1  -- Commence transparent
            list.BorderSizePixel   = 0
            list.ZIndex            = 999
            list.ClipsDescendants  = true
            corner(list, CORNER_SM)
            stroke(list, theme.OverlayStroke or theme.ElementStroke, 1)
            list.Parent = sg

            -- Fade in propre
            tw(list, { BackgroundTransparency = 0 }, ANIM_FAST)

            local scroll = Instance.new("ScrollingFrame")
            scroll.Size                  = UDim2.fromScale(1, 1)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel       = 0
            scroll.ScrollBarThickness    = 3
            scroll.ScrollBarImageColor3  = theme.ScrollBar
            scroll.CanvasSize            = UDim2.new(0, 0, 0, #values * itemH)
            scroll.ScrollingDirection    = Enum.ScrollingDirection.Y
            scroll.ElasticBehavior       = Enum.ElasticBehavior.Never
            scroll.ZIndex                = 1000
            scroll.Parent                = list

            local lay = Instance.new("UIListLayout")
            lay.Padding    = UDim.new(0, 0)
            lay.SortOrder  = Enum.SortOrder.LayoutOrder
            lay.Parent     = scroll
            pad(scroll, 4, 4, 0, 0)

            for _, v in ipairs(values) do
                local isSelected = multi and selected[v] or (selected == v)

                local item = frame(scroll, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, itemH))
                item.BackgroundTransparency = 1
                item.ZIndex = 1001

                local itemLbl = lbl(item, tostring(v), isSelected and theme.Accent or theme.TextPrimary, 12, Enum.Font.Gotham)
                itemLbl.Size     = UDim2.new(1, -16, 1, 0)
                itemLbl.Position = UDim2.new(0, 8, 0, 0)
                itemLbl.ZIndex   = 1002
                itemLbl.TextTruncate = Enum.TextTruncate.AtEnd

                if multi and selected[v] then
                    local chk = lbl(item, "✓", theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
                    chk.Size     = UDim2.new(0, 14, 1, 0)
                    chk.Position = UDim2.new(1, -18, 0, 0)
                    chk.ZIndex   = 1002
                end

                local ibtn = btn(item, UDim2.fromScale(1, 1), nil, 1003)

                ibtn.MouseEnter:Connect(function()
                    tw(item, { BackgroundTransparency = 0 })
                    item.BackgroundColor3 = theme.ElementHover
                end)
                ibtn.MouseLeave:Connect(function()
                    tw(item, { BackgroundTransparency = 1 })
                end)
                ibtn.MouseButton1Click:Connect(function()
                    if multi then
                        selected[v] = not selected[v] or nil
                    else
                        selected = v
                    end
                    selLbl.Text = getDisplay()
                    task.spawn(function() pcall(cfg.Callback or function() end, selected) end)
                    if not multi then
                        closeList()
                    end
                end)
            end

            -- Fermer si on clique ailleurs
            listConn = UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
                -- Vérifier si le clic est hors de la liste
                task.wait()
                local mPos = UserInputService:GetMouseLocation()
                local lAbs = list and list.AbsolutePosition
                local lSz  = list and list.AbsoluteSize
                if not lAbs then return end
                if mPos.X < lAbs.X or mPos.X > lAbs.X + lSz.X
                or mPos.Y < lAbs.Y or mPos.Y > lAbs.Y + lSz.Y then
                    closeList()
                end
            end)

            -- Enregistrer comme overlay actif
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
            if open then
                closeList()
            else
                buildList()
            end
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get()     return selected end
        function obj:Set(v)
            selected = v
            selLbl.Text = getDisplay()
        end
        function obj:SetValues(v)
            values = v
            if not multi then
                selected = v[1] or ""
                selLbl.Text = getDisplay()
            end
        end
        function obj:SetDisabled(v)
            disabled = v
            tw(f, { BackgroundTransparency = v and 0.4 or 0 })
        end
        return obj
    end

    -- ─── COLOR PICKER ────────────────────────────────────────────────
    function Tab:ColorPicker(cfg)
        cfg = cfg or {}
        local value    = cfg.Value    or Color3.fromRGB(218, 175, 55)
        local disabled = cfg.Disabled or false
        local open     = false
        local panel    = nil

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = false
        titleDescEl(f, theme, cfg, 48)

        local preview = frame(f, value, UDim2.new(0, 30, 0, 22))
        preview.Position = UDim2.new(1, -32, 0.5, -11)
        corner(preview, CORNER_SM)
        stroke(preview, theme.ElementStroke, 1)

        local rgb = {
            math.round(value.R * 255),
            math.round(value.G * 255),
            math.round(value.B * 255),
        }

        local function updateColor()
            value = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
            tw(preview, { BackgroundColor3 = value }, 0.06)
            task.spawn(function() pcall(cfg.Callback or function() end, value) end)
        end

        local function closePanel()
            if not panel then return end
            open = false
            local p = panel
            panel = nil
            tw(p, { BackgroundTransparency = 1 }, ANIM_FAST)
            task.delay(ANIM_FAST + 0.02, function() pcall(function() p:Destroy() end) end)
            _activeOverlayCloser = nil
        end

        local function buildPanel()
            closePanel()
            local sg = Tab._gui
            if not sg then return end

            open = true

            RunService.Heartbeat:Wait()

            local abs  = preview.AbsolutePosition
            local absS = preview.AbsoluteSize
            local vp   = workspace.CurrentCamera.ViewportSize

            local panelW = 220
            local panelH = 114 -- 3 sliders × 30 + padding

            local px = math.clamp(abs.X - panelW + absS.X, 4, vp.X - panelW - 4)
            local openBelow = (abs.Y + absS.Y + panelH + 4) < vp.Y
            local py = openBelow and (abs.Y + absS.Y + 4) or (abs.Y - panelH - 4)

            panel = Instance.new("Frame")
            panel.Size              = UDim2.new(0, panelW, 0, panelH)
            panel.Position          = UDim2.new(0, px, 0, py)
            panel.BackgroundColor3  = theme.OverlayBg or theme.Element
            panel.BackgroundTransparency = 1
            panel.BorderSizePixel   = 0
            panel.ZIndex            = 999
            corner(panel, CORNER_EL)
            stroke(panel, theme.OverlayStroke or theme.ElementStroke, 1)
            pad(panel, 10, 10, 12, 12)
            panel.Parent = sg

            tw(panel, { BackgroundTransparency = 0 }, ANIM_FAST)

            local play = Instance.new("UIListLayout")
            play.Padding  = UDim.new(0, 6)
            play.Parent   = panel

            local channels = {
                { name = "R", idx = 1, col = Color3.fromRGB(220, 60,  60)  },
                { name = "G", idx = 2, col = Color3.fromRGB(60,  200, 80)  },
                { name = "B", idx = 3, col = Color3.fromRGB(60,  120, 220) },
            }

            for _, ch in ipairs(channels) do
                local row = frame(panel, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 24))
                row.BackgroundTransparency = 1
                row.ZIndex = 1000

                local cl = lbl(row, ch.name, theme.TextSecondary, 10, Enum.Font.GothamBold)
                cl.Size   = UDim2.new(0, 14, 1, 0)
                cl.ZIndex = 1001

                local tr = frame(row, theme.ElementStroke2, UDim2.new(1, -58, 0, 5))
                tr.Position = UDim2.new(0, 18, 0.5, -2)
                corner(tr, UDim.new(1, 0))
                tr.ZIndex = 1001

                local fi = frame(tr, ch.col, UDim2.new(rgb[ch.idx] / 255, 0, 1, 0))
                fi.BackgroundTransparency = 0.15
                corner(fi, UDim.new(1, 0))
                fi.ZIndex = 1002

                local th2 = frame(tr, Color3.fromRGB(255, 255, 255), UDim2.new(0, 12, 0, 12))
                th2.AnchorPoint = Vector2.new(0.5, 0.5)
                th2.Position    = UDim2.new(rgb[ch.idx] / 255, 0, 0.5, 0)
                th2.ZIndex      = 1003
                corner(th2, UDim.new(1, 0))
                stroke(th2, ch.col, 1.5)

                local vi = Instance.new("TextBox")
                vi.Size              = UDim2.new(0, 32, 0, 20)
                vi.Position          = UDim2.new(1, -32, 0.5, -10)
                vi.BackgroundColor3  = theme.InputBg
                vi.Text              = tostring(rgb[ch.idx])
                vi.TextColor3        = theme.TextPrimary
                vi.TextSize          = 10
                vi.Font              = Enum.Font.Gotham
                vi.TextXAlignment    = Enum.TextXAlignment.Center
                vi.ClearTextOnFocus  = true
                vi.BorderSizePixel   = 0
                vi.ZIndex            = 1003
                corner(vi, UDim.new(0, 3))
                vi.Parent = row

                -- Drag slider (souris + tactile)
                local sDrag = false

                local function applySlider(posX)
                    local r2 = math.clamp((posX - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
                    rgb[ch.idx] = math.round(r2 * 255)
                    vi.Text = tostring(rgb[ch.idx])
                    tw(fi,  { Size     = UDim2.new(r2, 0, 1, 0) },  0.04)
                    tw(th2, { Position = UDim2.new(r2, 0, 0.5, 0) }, 0.04)
                    updateColor()
                end

                tr.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        sDrag = true
                        applySlider(i.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if not sDrag then return end
                    if i.UserInputType == Enum.UserInputType.MouseMovement
                    or i.UserInputType == Enum.UserInputType.Touch then
                        applySlider(i.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                    or i.UserInputType == Enum.UserInputType.Touch then
                        sDrag = false
                    end
                end)

                vi.FocusLost:Connect(function()
                    local v = math.clamp(math.round(tonumber(vi.Text) or rgb[ch.idx]), 0, 255)
                    rgb[ch.idx] = v
                    vi.Text = tostring(v)
                    local r2 = v / 255
                    tw(fi,  { Size     = UDim2.new(r2, 0, 1, 0) },  0.06)
                    tw(th2, { Position = UDim2.new(r2, 0, 0.5, 0) }, 0.06)
                    updateColor()
                end)
            end

            -- Hex row
            local hexRow = frame(panel, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 22))
            hexRow.BackgroundTransparency = 1
            hexRow.ZIndex = 1000

            local hexLbl = lbl(hexRow, "#", theme.TextSecondary, 10, Enum.Font.GothamBold)
            hexLbl.Size   = UDim2.new(0, 14, 1, 0)
            hexLbl.ZIndex = 1001

            local hexBox = Instance.new("TextBox")
            hexBox.Size              = UDim2.new(1, -18, 0, 20)
            hexBox.Position          = UDim2.new(0, 18, 0.5, -10)
            hexBox.BackgroundColor3  = theme.InputBg
            hexBox.BorderSizePixel   = 0
            hexBox.Text              = string.format("%02X%02X%02X", rgb[1], rgb[2], rgb[3])
            hexBox.TextColor3        = theme.TextPrimary
            hexBox.TextSize          = 11
            hexBox.Font              = Enum.Font.GothamMedium
            hexBox.TextXAlignment    = Enum.TextXAlignment.Center
            hexBox.ClearTextOnFocus  = true
            hexBox.ZIndex            = 1002
            corner(hexBox, UDim.new(0, 3))
            hexBox.Parent = hexRow

            hexBox.FocusLost:Connect(function()
                local hex = hexBox.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber("0x" .. hex:sub(1,2)) or rgb[1]
                    local g = tonumber("0x" .. hex:sub(3,4)) or rgb[2]
                    local b_ = tonumber("0x" .. hex:sub(5,6)) or rgb[3]
                    rgb[1] = r; rgb[2] = g; rgb[3] = b_
                    updateColor()
                end
                hexBox.Text = string.format("%02X%02X%02X", rgb[1], rgb[2], rgb[3])
            end)

            -- Fermer si clic externe
            UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
                task.wait()
                local mPos = UserInputService:GetMouseLocation()
                local pAbs = panel and panel.AbsolutePosition
                local pSz  = panel and panel.AbsoluteSize
                if not pAbs then return end
                if mPos.X < pAbs.X or mPos.X > pAbs.X + pSz.X
                or mPos.Y < pAbs.Y or mPos.Y > pAbs.Y + pSz.Y then
                    closePanel()
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
            if open then
                closePanel()
            else
                buildPanel()
            end
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get() return value end
        function obj:Set(c)
            value    = c
            rgb[1]   = math.round(c.R * 255)
            rgb[2]   = math.round(c.G * 255)
            rgb[3]   = math.round(c.B * 255)
            preview.BackgroundColor3 = c
        end
        return obj
    end

    -- ─── KEYBIND ─────────────────────────────────────────────────────
    function Tab:Keybind(cfg)
        cfg = cfg or {}
        local value     = cfg.Key      or Enum.KeyCode.F
        local disabled  = cfg.Disabled or false
        local listening = false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDescEl(f, theme, cfg, 92)

        local keyBox = frame(f, theme.InputBg, UDim2.new(0, 80, 0, 26))
        keyBox.Position = UDim2.new(1, -82, 0.5, -13)
        corner(keyBox, CORNER_SM)
        stroke(keyBox, theme.ElementStroke2, 1)

        local keyL = lbl(keyBox, "[" .. keyName(value) .. "]", theme.Accent, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        keyL.Size = UDim2.fromScale(1, 1)

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
            listening = true
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
                if gp or listening then return end
                if i.KeyCode == value then
                    task.spawn(function() pcall(cfg.OnPress, value) end)
                end
            end)
        end

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get() return value end
        function obj:Set(kc)
            value   = kc
            keyL.Text = "[" .. keyName(kc) .. "]"
        end
        function obj:SetDisabled(v)
            disabled = v
            tw(f, { BackgroundTransparency = v and 0.4 or 0 })
        end
        return obj
    end

    -- ─── SECTION ─────────────────────────────────────────────────────
    function Tab:Section(cfg)
        cfg = cfg or {}
        local label = cfg.Label or cfg.Title or ""

        local wrapper = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 20))
        wrapper.BackgroundTransparency = 1

        local line = frame(wrapper, theme.ElementStroke, UDim2.new(1, 0, 0, 1))
        line.Position    = UDim2.new(0, 0, 0.5, 0)
        line.AnchorPoint = Vector2.new(0, 0.5)

        if label ~= "" then
            local bg = frame(wrapper, theme.Background, UDim2.new(0, 0, 1, 0))
            bg.AutomaticSize  = Enum.AutomaticSize.X
            bg.AnchorPoint    = Vector2.new(0, 0)
            bg.Position       = UDim2.new(0, 0, 0, 0)
            bg.BorderSizePixel = 0
            local ll = lbl(bg, "  " .. label .. "  ", theme.TextDisabled, 10, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
            ll.Size = UDim2.new(1, 0, 1, 0)
        end

        wrapper.Parent = page
        return { _frame = wrapper }
    end

    -- ─── DIVIDER ─────────────────────────────────────────────────────
    function Tab:Divider(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, cfg.Height or 1))
        f.BackgroundTransparency = 1
        local line = frame(f, cfg.Color or theme.ElementStroke, UDim2.fromScale(1, 1))
        line.BorderSizePixel = 0
        f.Parent = page
        return { _frame = f }
    end

    -- ─── SPACE ───────────────────────────────────────────────────────
    function Tab:Space(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, cfg.Height or 8))
        f.BackgroundTransparency = 1
        f.Parent = page
        return { _frame = f }
    end

    -- ─── LABEL ───────────────────────────────────────────────────────
    function Tab:Label(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 0))
        f.BackgroundTransparency = 1
        f.AutomaticSize          = Enum.AutomaticSize.Y

        local l = lbl(f, cfg.Title or cfg.Text or "", cfg.Color or theme.TextSecondary, cfg.Size or 12, Enum.Font.Gotham)
        l.Size        = UDim2.new(1, 0, 0, 0)
        l.AutomaticSize = Enum.AutomaticSize.Y
        l.TextWrapped = true

        f.Parent = page
        local obj = { _frame = f }
        function obj:Set(text) l.Text = text end
        function obj:Get()     return l.Text end
        return obj
    end

    -- ─── CARD ────────────────────────────────────────────────────────
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

        if cfg.Title and cfg.Title ~= "" then
            local tl = lbl(f, cfg.Title, theme.TextPrimary, 13, Enum.Font.GothamBold)
            tl.Size     = UDim2.new(1, 0, 0, 17)
            tl.Position = UDim2.new(0, 0, 0, 2)
        end

        local valLbl = nil
        if cfg.Value ~= nil then
            valLbl = lbl(f, tostring(cfg.Value), cfg.ValueColor or theme.Accent, 22, Enum.Font.GothamBold)
            valLbl.Size     = UDim2.new(1, 0, 0, 28)
            valLbl.Position = UDim2.new(0, 0, 0, 22)
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
        function obj:SetValue(v) if valLbl then valLbl.Text = tostring(v) end end
        return obj
    end

    -- ─── PROFILE FRAME ───────────────────────────────────────────────
    function Tab:ProfileFrame(cfg)
        cfg = cfg or {}
        local userId   = cfg.UserId   or LocalPlayer.UserId
        local username = cfg.Username or LocalPlayer.Name
        local desc     = cfg.Desc     or "@" .. LocalPlayer.Name
        local badges   = cfg.Badges   or {}
        local h        = 82 + (#badges > 0 and 22 or 0)

        local f = frame(page, cfg.Color or theme.ProfileBg, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.CardStroke, 1)

        local strip = frame(f, theme.Accent, UDim2.new(1, 0, 0, 3))
        strip.BackgroundTransparency = 0.7
        corner(strip, UDim.new(0, 2))

        local avBg = frame(f, theme.ElementStroke, UDim2.new(0, 52, 0, 52))
        avBg.Position = UDim2.new(0, 14, 0.5, -26)
        corner(avBg, UDim.new(1, 0))
        stroke(avBg, theme.Accent, 2)

        local av = Instance.new("ImageLabel")
        av.Size      = UDim2.new(1, -4, 1, -4)
        av.Position  = UDim2.new(0, 2, 0, 2)
        av.BackgroundColor3 = theme.Element
        av.Image     = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
        av.ScaleType = Enum.ScaleType.Crop
        av.ZIndex    = 2
        corner(av, UDim.new(1, 0))
        av.Parent    = avBg

        local dot = frame(avBg, theme.Success, UDim2.new(0, 11, 0, 11))
        dot.Position = UDim2.new(1, -11, 1, -11)
        dot.ZIndex   = 3
        corner(dot, UDim.new(1, 0))
        stroke(dot, theme.ProfileBg, 2)

        local nameLbl = lbl(f, username, theme.TextPrimary, 13, Enum.Font.GothamBold)
        nameLbl.Size     = UDim2.new(1, -80, 0, 17)
        nameLbl.Position = UDim2.new(0, 74, 0, 14)
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local descLbl = lbl(f, desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        descLbl.Size     = UDim2.new(1, -80, 0, 14)
        descLbl.Position = UDim2.new(0, 74, 0, 32)
        descLbl.TextTruncate = Enum.TextTruncate.AtEnd

        if cfg.Role then
            local rl = lbl(f, cfg.Role, theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            rl.Size     = UDim2.new(0, 90, 0, 16)
            rl.Position = UDim2.new(1, -98, 0, 14)
        end

        if #badges > 0 then
            local badgeRow = frame(f, Color3.fromRGB(0, 0, 0), UDim2.new(1, -80, 0, 17))
            badgeRow.Position           = UDim2.new(0, 74, 0, 50)
            badgeRow.BackgroundTransparency = 1

            local blay = Instance.new("UIListLayout")
            blay.FillDirection     = Enum.FillDirection.Horizontal
            blay.VerticalAlignment = Enum.VerticalAlignment.Center
            blay.Padding           = UDim.new(0, 4)
            blay.Parent            = badgeRow

            for _, badge in ipairs(badges) do
                local bf = frame(badgeRow, badge.Color or theme.Accent, UDim2.new(0, 0, 0, 15))
                bf.AutomaticSize          = Enum.AutomaticSize.X
                bf.BackgroundTransparency = 0.78
                corner(bf, UDim.new(0, 4))
                pad(bf, 0, 0, 5, 5)
                local bl = lbl(bf, badge.Text or "•", badge.Color or theme.Accent, 9, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
                bl.Size          = UDim2.new(0, 0, 1, 0)
                bl.AutomaticSize = Enum.AutomaticSize.X
            end
        end

        f.Parent = page
        local obj = { _frame = f }
        function obj:SetUsername(n) nameLbl.Text = n end
        function obj:SetDesc(d)     descLbl.Text = d end
        return obj
    end

    -- ─── BADGE ROW ───────────────────────────────────────────────────
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
            bf.AutomaticSize          = Enum.AutomaticSize.X
            bf.BackgroundTransparency = 0.8
            corner(bf, UDim.new(1, 0))
            pad(bf, 0, 0, 8, 8)
            local bl = lbl(bf, badge.Text or "Badge", badge.Color or theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            bl.Size          = UDim2.new(0, 0, 1, 0)
            bl.AutomaticSize = Enum.AutomaticSize.X
        end

        wrapper.Parent = page
        return { _frame = wrapper }
    end

end -- injectElements

-- ═══════════════════════════════════════════════════════════════════
--  WINDOW CREATION
-- ═══════════════════════════════════════════════════════════════════
function TryxLib:CreateWindow(cfg)
    cfg = cfg or {}
    local title    = cfg.Title    or "TryxLib"
    local subtitle = cfg.Subtitle or ""
    local theme    = Themes[cfg.Theme] or Themes.Default
    local keybind  = cfg.Keybind  or Enum.KeyCode.RightControl
    local size     = cfg.Size     or Vector2.new(DEFAULT_W, DEFAULT_H)

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name             = "TryxLib_" .. title:gsub("%s", "_")
    gui.ResetOnSpawn     = false
    gui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder     = 100
    gui.IgnoreGuiInset   = true
    gui.Parent           = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

    -- Main window frame
    local win = frame(gui, theme.Background, UDim2.new(0, size.X, 0, size.Y))
    win.Position    = UDim2.new(0.5, -math.floor(size.X / 2), 0.5, -math.floor(size.Y / 2))
    win.ClipsDescendants = false
    corner(win, CORNER_WIN)
    stroke(win, theme.ElementStroke, 1)
    shadow(win)

    -- Topbar
    local topbar = frame(win, theme.TopBar, UDim2.new(1, 0, 0, TOPBAR_H))
    corner(topbar, UDim.new(0, 10))
    local topbarFix = frame(topbar, theme.TopBar, UDim2.new(1, 0, 0.5, 0))
    topbarFix.Position = UDim2.new(0, 0, 0.5, 0)
    stroke(topbar, theme.ElementStroke, 1)

    -- Title label
    local titleLbl = lbl(topbar, title, theme.TextPrimary, 13, Enum.Font.GothamBold)
    titleLbl.Size     = UDim2.new(1, -140, 0, 18)
    titleLbl.Position = UDim2.new(0, 14, 0.5, -9)
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd

    if subtitle ~= "" then
        titleLbl.Size     = UDim2.new(1, -140, 0, 14)
        titleLbl.Position = UDim2.new(0, 14, 0.5, -14)
        local subLbl = lbl(topbar, subtitle, theme.TextSecondary, 11, Enum.Font.Gotham)
        subLbl.Size     = UDim2.new(1, -140, 0, 12)
        subLbl.Position = UDim2.new(0, 14, 0.5, 2)
        subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    end

    -- Accent bar
    local accentBar = frame(topbar, theme.Accent, UDim2.new(0, 2, 0.6, 0))
    accentBar.Position           = UDim2.new(0, 0, 0.2, 0)
    accentBar.BackgroundTransparency = 0.5
    corner(accentBar, UDim.new(1, 0))

    -- Minimize / Close buttons
    local closeBtn = frame(topbar, theme.ElementHover, UDim2.new(0, 26, 0, 26))
    closeBtn.Position = UDim2.new(1, -34, 0.5, -13)
    corner(closeBtn, UDim.new(0, 6))
    local closeLbl = lbl(closeBtn, "✕", theme.TextSecondary, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    closeLbl.Size = UDim2.fromScale(1, 1)
    local closeb = btn(closeBtn, UDim2.fromScale(1, 1), nil, 3)
    closeb.MouseEnter:Connect(function()
        tw(closeBtn, { BackgroundColor3 = theme.Danger })
        tw(closeLbl, { TextColor3 = Color3.fromRGB(255, 255, 255) })
    end)
    closeb.MouseLeave:Connect(function()
        tw(closeBtn, { BackgroundColor3 = theme.ElementHover })
        tw(closeLbl, { TextColor3 = theme.TextSecondary })
    end)
    closeb.MouseButton1Click:Connect(function()
        closeActiveOverlay()
        tw(win, { Size = UDim2.new(0, win.AbsoluteSize.X, 0, 0), BackgroundTransparency = 1 }, ANIM_FAST)
        task.delay(ANIM_FAST + 0.05, function() gui:Destroy() end)
    end)

    local minBtn = frame(topbar, theme.ElementHover, UDim2.new(0, 26, 0, 26))
    minBtn.Position = UDim2.new(1, -66, 0.5, -13)
    corner(minBtn, UDim.new(0, 6))
    local minLbl = lbl(minBtn, "–", theme.TextSecondary, 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    minLbl.Size = UDim2.fromScale(1, 1)
    local minimized = false
    local prevH = size.Y
    local minb = btn(minBtn, UDim2.fromScale(1, 1), nil, 3)
    minb.MouseEnter:Connect(function()
        tw(minBtn, { BackgroundColor3 = theme.Warning })
        tw(minLbl, { TextColor3 = Color3.fromRGB(255, 255, 255) })
    end)
    minb.MouseLeave:Connect(function()
        tw(minBtn, { BackgroundColor3 = theme.ElementHover })
        tw(minLbl, { TextColor3 = theme.TextSecondary })
    end)
    minb.MouseButton1Click:Connect(function()
        minimized = not minimized
        closeActiveOverlay()
        if minimized then
            prevH = win.AbsoluteSize.Y
            tw(win, { Size = UDim2.new(0, win.AbsoluteSize.X, 0, TOPBAR_H) }, ANIM_MED)
        else
            tw(win, { Size = UDim2.new(0, win.AbsoluteSize.X, 0, prevH) }, ANIM_MED)
        end
    end)

    makeDraggable(topbar, win)

    -- Resize handle
    local resizeHandle = frame(win, Color3.fromRGB(0, 0, 0), UDim2.new(0, 16, 0, 16))
    resizeHandle.Position           = UDim2.new(1, -16, 1, -16)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.ZIndex             = 10
    local resizeLbl = lbl(resizeHandle, "◢", theme.ElementStroke, 12, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    resizeLbl.Size = UDim2.fromScale(1, 1)
    resizeLbl.ZIndex = 11
    makeResizable(resizeHandle, win)

    -- Sidebar
    local sidebar = frame(win, theme.Sidebar, UDim2.new(0, SIDEBAR_W, 1, -TOPBAR_H))
    sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
    local sidebarFix = frame(sidebar, theme.Sidebar, UDim2.new(0.5, 0, 1, 0))
    sidebarFix.Position = UDim2.new(0, 0, 0, 0)

    local tabListFrame = Instance.new("ScrollingFrame")
    tabListFrame.Size                  = UDim2.new(1, 0, 1, -8)
    tabListFrame.Position              = UDim2.new(0, 0, 0, 8)
    tabListFrame.BackgroundTransparency = 1
    tabListFrame.BorderSizePixel       = 0
    tabListFrame.ScrollBarThickness    = 0
    tabListFrame.CanvasSize            = UDim2.new(0, 0, 0, 0)
    tabListFrame.ScrollingDirection    = Enum.ScrollingDirection.Y
    tabListFrame.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    tabListFrame.Parent                = sidebar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding             = UDim.new(0, 2)
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabListLayout.SortOrder           = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent              = tabListFrame
    pad(tabListFrame, 4, 4, 6, 6)

    -- Content area
    local contentArea = frame(win, theme.Background, UDim2.new(1, -SIDEBAR_W, 1, -TOPBAR_H))
    contentArea.Position = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)

    -- Separator
    local sep = frame(win, theme.ElementStroke, UDim2.new(0, 1, 1, -TOPBAR_H))
    sep.Position = UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)

    -- Tab tracking
    local tabs         = {}
    local activeTabKey = nil
    local pages        = {}
    local tabBtns      = {}

    local Window = {}
    Window._gui  = gui

    -- Toggle visibility with keybind
    local visible = true
    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == keybind then
            visible = not visible
            closeActiveOverlay()
            tw(win, { Size = visible
                and UDim2.new(0, win.AbsoluteSize.X, 0, prevH)
                or  UDim2.new(0, win.AbsoluteSize.X, 0, 0)
            }, ANIM_MED)
            win.Visible = visible
        end
    end)

    function Window:CreateTab(tabCfg)
        tabCfg = tabCfg or {}
        local tabTitle = tabCfg.Title or "Tab"
        local tabKey   = tabTitle

        -- Tab button in sidebar
        local tabBtn = frame(tabListFrame, theme.TabInactive, UDim2.new(1, -4, 0, 34))
        corner(tabBtn, UDim.new(0, 7))
        local tabStroke = stroke(tabBtn, Color3.fromRGB(0, 0, 0), 1)
        tabStroke.Transparency = 1

        local tabIcon = nil
        local lblOff  = 0
        if tabCfg.Icon and tabCfg.Icon ~= "" then
            tabIcon = lbl(tabBtn, tabCfg.Icon, theme.TextSecondary, 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            tabIcon.Size     = UDim2.new(0, 18, 1, 0)
            tabIcon.Position = UDim2.new(0, 8, 0, 0)
            lblOff = 22
        end

        local tabLbl = lbl(tabBtn, tabTitle, theme.TextSecondary, 12, Enum.Font.GothamMedium)
        tabLbl.Size     = UDim2.new(1, -(24 + lblOff), 1, 0)
        tabLbl.Position = UDim2.new(0, 10 + lblOff, 0, 0)
        tabLbl.TextTruncate = Enum.TextTruncate.AtEnd

        -- Content page (ScrollingFrame)
        local page = Instance.new("ScrollingFrame")
        page.Size                  = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.BorderSizePixel       = 0
        page.ScrollBarThickness    = 4
        page.ScrollBarImageColor3  = theme.ScrollBar
        page.CanvasSize            = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize   = Enum.AutomaticSize.Y
        page.ScrollingDirection    = Enum.ScrollingDirection.Y
        page.ElasticBehavior       = Enum.ElasticBehavior.Never
        page.Visible               = false
        page.Parent                = contentArea

        -- Fermer overlay si scroll
        page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            closeActiveOverlay()
        end)

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding             = UDim.new(0, 5)
        pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLayout.SortOrder           = Enum.SortOrder.LayoutOrder
        pageLayout.Parent              = page
        pad(page, 8, 8, 8, 8)

        -- Tab object
        local Tab = {}
        Tab._theme = theme
        Tab._gui   = gui
        Tab._page  = page

        injectElements(Tab, theme, page)

        Tab.Notify = function(self, ncfg)
            doNotify(ncfg or {}, theme)
        end

        local function activate()
            -- Fermer l'overlay actif
            closeActiveOverlay()

            -- Désactiver tous les tabs
            for k, p in pairs(pages) do
                p.Visible = false
                local tb  = tabBtns[k]
                if tb then
                    tw(tb.btn,    { BackgroundColor3 = theme.TabInactive })
                    tw(tb.lbl,    { TextColor3       = theme.TextSecondary })
                    tb.stroke.Transparency = 1
                    if tb.icon then
                        tw(tb.icon, { TextColor3 = theme.TextSecondary })
                    end
                end
            end

            -- Activer ce tab
            page.Visible    = true
            activeTabKey    = tabKey
            tw(tabBtn, { BackgroundColor3 = theme.TabActive })
            tw(tabLbl,  { TextColor3      = theme.TextPrimary })
            tabStroke.Transparency = 0
            tabStroke.Color        = theme.TabStroke
            if tabIcon then
                tw(tabIcon, { TextColor3 = theme.Accent })
            end
        end

        -- Hover
        local hoverBtn = btn(tabBtn, UDim2.fromScale(1, 1))
        hoverBtn.MouseEnter:Connect(function()
            if activeTabKey == tabKey then return end
            tw(tabBtn, { BackgroundColor3 = theme.TabHover })
        end)
        hoverBtn.MouseLeave:Connect(function()
            if activeTabKey == tabKey then return end
            tw(tabBtn, { BackgroundColor3 = theme.TabInactive })
        end)
        hoverBtn.MouseButton1Click:Connect(function()
            activate()
        end)

        pages[tabKey]   = page
        tabBtns[tabKey] = { btn = tabBtn, lbl = tabLbl, icon = tabIcon, stroke = tabStroke }
        table.insert(tabs, tabKey)

        -- Activer le premier tab automatiquement
        if #tabs == 1 then
            activate()
        end

        return Tab
    end

    function Window:Notify(cfg)
        doNotify(cfg or {}, theme)
    end

    function Window:SetTheme(newTheme)
        theme = Themes[newTheme] or Themes.Default
    end

    return Window
end

TryxLib.Themes = Themes

return TryxLib
