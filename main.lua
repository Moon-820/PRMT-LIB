
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

local SIDEBAR_W   = 168
local TOPBAR_H    = 44
local MIN_W       = 500
local MIN_H       = 340
local DEFAULT_W   = 630
local DEFAULT_H   = 430
local ELEMENT_H   = 46
local ELEMENT_PAD = 5
local CORNER_WIN  = UDim.new(0, 10)
local CORNER_EL   = UDim.new(0, 7)
local CORNER_SM   = UDim.new(0, 5)
local ANIM_FAST   = 0.10
local ANIM_MED    = 0.16
local ANIM_SLOW   = 0.25

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
    s.Color             = col or Color3.fromRGB(40,40,40)
    s.Thickness         = th or 1
    s.LineJoinMode      = Enum.LineJoinMode.Round
    s.ApplyStrokeMode   = Enum.ApplyStrokeMode.Border
    s.Parent            = p
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

local function gradient(p, seq, rot)
    local g = Instance.new("UIGradient")
    g.Color    = seq or ColorSequence.new({ ColorSequenceKeypoint.new(0,Color3.new(1,1,1)), ColorSequenceKeypoint.new(1,Color3.fromRGB(200,200,200)) })
    g.Rotation = rot or 90
    g.Parent   = p
    return g
end

local function frame(parent, bg, size, pos, zi)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or Color3.fromRGB(20,20,20)
    f.Size             = size or UDim2.fromScale(1,1)
    f.Position         = pos  or UDim2.new(0,0,0,0)
    f.BorderSizePixel  = 0
    if zi then f.ZIndex = zi end
    f.Parent = parent
    return f
end

local function lbl(parent, text, col, sz, font, xa)
    local l = Instance.new("TextLabel")
    l.Text                  = text or ""
    l.TextColor3            = col  or Color3.fromRGB(240,240,240)
    l.TextSize              = sz   or 13
    l.Font                  = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment        = xa   or Enum.TextXAlignment.Left
    l.TextYAlignment        = Enum.TextYAlignment.Center
    l.TextTruncate          = Enum.TextTruncate.AtEnd
    l.Parent                = parent
    return l
end

local function btn(parent, size, pos, zi)
    local b = Instance.new("TextButton")
    b.Size                  = size or UDim2.fromScale(1,1)
    b.Position              = pos  or UDim2.new(0,0,0,0)
    b.BackgroundTransparency = 1
    b.Text                  = ""
    b.BorderSizePixel       = 0
    b.AutoButtonColor       = false
    b.ZIndex                = zi or 2
    b.Parent                = parent
    return b
end

local function shadow(parent)
    local s = Instance.new("ImageLabel")
    s.Name               = "Shadow"
    s.Size               = UDim2.new(1,40,1,40)
    s.Position           = UDim2.new(0,-20,0,-20)
    s.BackgroundTransparency = 1
    s.Image              = "rbxassetid://6014261993"
    s.ImageColor3        = Color3.fromRGB(0,0,0)
    s.ImageTransparency  = 0.48
    s.ScaleType          = Enum.ScaleType.Slice
    s.SliceCenter        = Rect.new(49,49,450,450)
    s.ZIndex             = 0
    s.Parent             = parent
    return s
end

local function ripple(parent, theme)
    local r = frame(parent, theme.Accent, UDim2.new(0,0,0,0))
    r.AnchorPoint           = Vector2.new(0.5,0.5)
    r.Position              = UDim2.new(0.5,0,0.5,0)
    r.BackgroundTransparency = 0.82
    r.ZIndex                = 8
    corner(r, UDim.new(1,0))
    local sz = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.4
    tw(r, { Size=UDim2.new(0,sz,0,sz), BackgroundTransparency=1 }, 0.48, Enum.EasingStyle.Quart)
    task.delay(0.5, function() r:Destroy() end)
end

local function makeDraggable(handle, target)
    local dragging, ds, sp = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; ds = i.Position; sp = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            local vp = workspace.CurrentCamera.ViewportSize
            target.Position = UDim2.new(0,
                math.clamp(sp.X.Offset+d.X, 0, vp.X-target.AbsoluteSize.X),
                0,
                math.clamp(sp.Y.Offset+d.Y, 0, vp.Y-target.AbsoluteSize.Y)
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

local function makeResizable(handle, target)
    local resizing, rs, ss = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true; rs = i.Position; ss = target.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - rs
            target.Size = UDim2.new(0,math.max(MIN_W,ss.X.Offset+d.X),0,math.max(MIN_H,ss.Y.Offset+d.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
    end)
end

local keyNames = {
    [Enum.KeyCode.LeftControl]="L-CTRL",[Enum.KeyCode.RightControl]="R-CTRL",
    [Enum.KeyCode.LeftShift]="L-SHIFT",[Enum.KeyCode.RightShift]="R-SHIFT",
    [Enum.KeyCode.LeftAlt]="L-ALT",[Enum.KeyCode.RightAlt]="R-ALT",
    [Enum.KeyCode.Return]="ENTER",[Enum.KeyCode.BackSpace]="BKSP",
    [Enum.KeyCode.Space]="SPACE",[Enum.KeyCode.Tab]="TAB",
    [Enum.KeyCode.Delete]="DEL",[Enum.KeyCode.Home]="HOME",
    [Enum.KeyCode.End]="END",[Enum.KeyCode.Up]="↑",
    [Enum.KeyCode.Down]="↓",[Enum.KeyCode.Left]="←",[Enum.KeyCode.Right]="→",
    [Enum.KeyCode.F1]="F1",[Enum.KeyCode.F2]="F2",[Enum.KeyCode.F3]="F3",
    [Enum.KeyCode.F4]="F4",[Enum.KeyCode.F5]="F5",[Enum.KeyCode.F6]="F6",
    [Enum.KeyCode.F7]="F7",[Enum.KeyCode.F8]="F8",[Enum.KeyCode.F9]="F9",
    [Enum.KeyCode.F10]="F10",[Enum.KeyCode.F11]="F11",[Enum.KeyCode.F12]="F12",
}
local function keyName(kc) return keyNames[kc] or kc.Name:upper() end

local notifyCount = 0
local MAX_NOTIFY  = 5
local notifyGui   = nil

local ntypes = {
    success = {col=Color3.fromRGB(58,188,98),  icon="✓"},
    error   = {col=Color3.fromRGB(210,58,58),  icon="✕"},
    warn    = {col=Color3.fromRGB(218,158,38), icon="!"},
    info    = {col=Color3.fromRGB(72,148,228), icon="i"},
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

    local cont = frame(g, Color3.fromRGB(0,0,0), UDim2.new(0,298,1,-20), UDim2.new(1,-312,0,10))
    cont.Name                = "Container"
    cont.BackgroundTransparency = 1
    local lay = Instance.new("UIListLayout")
    lay.VerticalAlignment   = Enum.VerticalAlignment.Bottom
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    lay.Padding             = UDim.new(0,6)
    lay.SortOrder           = Enum.SortOrder.LayoutOrder
    lay.Parent              = cont
    pad(cont, 0,14,0,0)
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

    local wrapper = frame(cont, Color3.fromRGB(0,0,0), UDim2.new(1,0,0,0))
    wrapper.BackgroundTransparency = 1
    wrapper.ClipsDescendants       = true

    local n = frame(wrapper, theme.Notify, UDim2.new(1,-2,0,70))
    n.Position         = UDim2.new(0,2,0,0)
    n.ClipsDescendants = true
    n.ZIndex           = 10
    corner(n, UDim.new(0,9))
    stroke(n, theme.NotifyStroke, 1)

    local accentBar = frame(n, accent, UDim2.new(0,3,1,0))
    corner(accentBar, UDim.new(0,2))

    local iconBg = frame(n, accent, UDim2.new(0,28,0,28))
    iconBg.Position           = UDim2.new(0,14,0.5,-14)
    iconBg.ZIndex             = 11
    iconBg.BackgroundTransparency = 0.12
    corner(iconBg, UDim.new(1,0))

    local iconL = lbl(iconBg, td.icon, Color3.fromRGB(255,255,255), 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    iconL.Size   = UDim2.fromScale(1,1)
    iconL.ZIndex = 12

    local tl = lbl(n, title, Color3.fromRGB(238,238,238), 13, Enum.Font.GothamBold)
    tl.Size     = UDim2.new(1,-58,0,17)
    tl.Position = UDim2.new(0,50,0,10)
    tl.ZIndex   = 11

    local dl = lbl(n, desc, Color3.fromRGB(148,148,158), 11, Enum.Font.Gotham)
    dl.Size        = UDim2.new(1,-58,0,14)
    dl.Position    = UDim2.new(0,50,0,28)
    dl.ZIndex      = 11
    dl.TextWrapped = true

    local prog = frame(n, accent, UDim2.new(1,0,0,2))
    prog.Position           = UDim2.new(0,0,1,-2)
    prog.ZIndex             = 12
    prog.BackgroundTransparency = 0.25

    tw(wrapper, { Size=UDim2.new(1,0,0,76) }, ANIM_MED)
    tw(prog, { Size=UDim2.new(0,0,0,2) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        tw(wrapper, { Size=UDim2.new(1,0,0,0) }, ANIM_FAST)
        task.wait(ANIM_FAST+0.05)
        wrapper:Destroy()
        notifyCount = math.max(0, notifyCount-1)
    end

    task.delay(duration, dismiss)
    local cb = btn(n, UDim2.fromScale(1,1), nil, 13)
    cb.MouseButton1Click:Connect(dismiss)
end

local function baseEl(theme, cfg, h)
    local height = h or ELEMENT_H
    if cfg.Desc and cfg.Desc ~= "" then height = height + 16 end

    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1,0,0,height)
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BorderSizePixel  = 0
    f.ClipsDescendants = true
    if cfg.Transparency then f.BackgroundTransparency = cfg.Transparency end
    corner(f, CORNER_EL)
    stroke(f, theme.ElementStroke, 1)
    pad(f, 0,0,14,14)
    return f, height
end

local function titleDesc(parent, theme, cfg, offsetR, y)
    y       = y or 0
    offsetR = offsetR or 0
    local hasDesc = cfg.Desc and cfg.Desc ~= ""
    local ty      = hasDesc and (y+8) or (y + math.floor((ELEMENT_H-16)/2))

    local iconOff = 0
    if cfg.Icon and cfg.Icon ~= "" then
        local ic = lbl(parent, cfg.Icon, theme.Accent, 13, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        ic.Size     = UDim2.new(0,18,0,18)
        ic.Position = UDim2.new(0,0,0,ty)
        iconOff     = 22
    end

    local tl = lbl(parent, cfg.Title or "", theme.TextPrimary, 13, Enum.Font.GothamMedium)
    tl.Size     = UDim2.new(1,-(offsetR+iconOff),0,16)
    tl.Position = UDim2.new(0,iconOff,0,ty)

    if hasDesc then
        local dl = lbl(parent, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        dl.Size     = UDim2.new(1,-(offsetR+iconOff),0,14)
        dl.Position = UDim2.new(0,iconOff,0,ty+18)
    end
    return tl
end

local function injectElements(Tab, theme, page)

    function Tab:Button(cfg)
        cfg = cfg or {}
        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 34)

        local arr = lbl(f, "›", theme.Accent, 22, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        arr.Size     = UDim2.new(0,22,1,0)
        arr.Position = UDim2.new(1,-26,0,0)

        local disabled = cfg.Disabled or false
        local b = btn(f)

        b.MouseEnter:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=theme.ElementHover})
            tw(arr,{TextColor3=theme.AccentLight})
        end)
        b.MouseLeave:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=cfg.Color or theme.Element})
            tw(arr,{TextColor3=theme.Accent})
        end)
        b.MouseButton1Down:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=theme.ElementActive})
        end)
        b.MouseButton1Up:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=theme.ElementHover})
        end)
        b.MouseButton1Click:Connect(function()
            if disabled then return end
            ripple(f,theme)
            task.spawn(function() pcall(cfg.Callback or function()end) end)
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = {_frame=f}
        function obj:SetDisabled(v) disabled=v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
        function obj:Trigger() task.spawn(function() pcall(cfg.Callback or function()end) end) end
        return obj
    end

    function Tab:Toggle(cfg)
        cfg = cfg or {}
        local toggleType = cfg.Type  or "Default"
        local value      = cfg.Value ~= nil and cfg.Value or false
        local disabled   = cfg.Disabled or false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 58)

        local updateFn

        if toggleType == "Checkbox" then
            local box = frame(f, value and theme.Accent or theme.InputBg, UDim2.new(0,20,0,20))
            box.Position = UDim2.new(1,-24,0.5,-10)
            corner(box, UDim.new(0,5))
            local bs = stroke(box, value and theme.Accent or theme.ElementStroke, 1.5)

            local chk = lbl(box, "✓", Color3.fromRGB(255,255,255), 12, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            chk.Size           = UDim2.fromScale(1,1)
            chk.TextTransparency = value and 0 or 1

            updateFn = function(v)
                tw(box,{BackgroundColor3=v and theme.Accent or theme.InputBg})
                tw(chk,{TextTransparency=v and 0 or 1})
                bs.Color = v and theme.Accent or theme.ElementStroke
            end
        else
            local track = frame(f, value and theme.Accent or theme.ElementStroke, UDim2.new(0,38,0,20))
            track.Position = UDim2.new(1,-44,0.5,-10)
            corner(track, UDim.new(1,0))

            local thumb = frame(track, Color3.fromRGB(255,255,255), UDim2.new(0,14,0,14))
            thumb.AnchorPoint = Vector2.new(0,0.5)
            thumb.Position    = value and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)
            corner(thumb, UDim.new(1,0))

            updateFn = function(v)
                tw(track,{BackgroundColor3=v and theme.Accent or theme.ElementStroke})
                tw(thumb,{Position=v and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)})
            end
        end

        local b = btn(f)
        b.MouseEnter:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=theme.ElementHover})
        end)
        b.MouseLeave:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=cfg.Color or theme.Element})
        end)
        b.MouseButton1Click:Connect(function()
            if disabled then return end
            value = not value
            updateFn(value)
            task.spawn(function() pcall(cfg.Callback or function()end, value) end)
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = {_frame=f}
        function obj:Set(v) value=v; updateFn(v); task.spawn(function() pcall(cfg.Callback or function()end,v) end) end
        function obj:Get() return value end
        function obj:SetDisabled(v) disabled=v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
        return obj
    end

    function Tab:Input(cfg)
        cfg = cfg or {}
        local multiline = cfg.MultiLine or false
        local disabled  = cfg.Disabled  or false
        local boxH      = multiline and 52 or 28
        local totalH    = 12 + 16 + 6 + boxH + 8

        local f = frame(page, cfg.Color or theme.Element, UDim2.new(1,0,0,totalH))
        f.BorderSizePixel  = 0
        f.ClipsDescendants = true
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 0,0,14,14)

        local tl = lbl(f, cfg.Title or "Input", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        tl.Size     = UDim2.new(1,0,0,16)
        tl.Position = UDim2.new(0,0,0,12)

        local box = frame(f, theme.InputBg, UDim2.new(1,0,0,boxH))
        box.Position = UDim2.new(0,0,0,34)
        corner(box, CORNER_SM)
        local bs = stroke(box, theme.ElementStroke2, 1)

        local inp = Instance.new("TextBox")
        inp.Size               = UDim2.new(1,-12,1,0)
        inp.Position           = UDim2.new(0,6,0,0)
        inp.BackgroundTransparency = 1
        inp.Text               = cfg.Value       or ""
        inp.PlaceholderText    = cfg.Placeholder  or "Enter value..."
        inp.TextColor3         = theme.TextPrimary
        inp.PlaceholderColor3  = theme.TextDisabled
        inp.TextSize           = 12
        inp.Font               = Enum.Font.Gotham
        inp.TextXAlignment     = Enum.TextXAlignment.Left
        inp.ClearTextOnFocus   = cfg.ClearOnFocus ~= nil and cfg.ClearOnFocus or false
        inp.MultiLine          = multiline
        inp.TextWrapped        = multiline
        inp.TextEditable       = not disabled
        inp.Parent             = box

        inp.Focused:Connect(function()
            tw(box,{BackgroundColor3=theme.ElementHover})
            tw(bs,{Color=theme.Accent},ANIM_FAST)
        end)
        inp.FocusLost:Connect(function(enter)
            tw(box,{BackgroundColor3=theme.InputBg})
            tw(bs,{Color=theme.ElementStroke2},ANIM_FAST)
            if enter then task.spawn(function() pcall(cfg.Callback or function()end, inp.Text) end) end
        end)
        if cfg.OnChange then
            inp:GetPropertyChangedSignal("Text"):Connect(function()
                task.spawn(function() pcall(cfg.Callback, inp.Text) end)
            end)
        end

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = {_frame=f}
        function obj:Get() return inp.Text end
        function obj:Set(v) inp.Text=v end
        function obj:SetDisabled(v) disabled=v; inp.TextEditable=not v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
        return obj
    end

    function Tab:Slider(cfg)
        cfg = cfg or {}
        local mn       = cfg.Min    or 0
        local mx       = cfg.Max    or 100
        local value    = math.clamp(cfg.Value or mn, mn, mx)
        local suffix   = cfg.Suffix or ""
        local step     = cfg.Step   or 1
        local showInp  = cfg.Input  or false
        local disabled = cfg.Disabled or false

        local hasDesc = cfg.Desc and cfg.Desc ~= ""
        local h       = (hasDesc and 82 or 66) + (showInp and 0 or 0)

        local f = frame(page, cfg.Color or theme.Element, UDim2.new(1,0,0,h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 0,0,14,14)

        local valDisplay
        if not showInp then
            valDisplay = lbl(f, tostring(value)..suffix, theme.Accent, 12, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            valDisplay.Size     = UDim2.new(0,60,0,16)
            valDisplay.Position = UDim2.new(1,-62,0,10)
        end

        local tl = lbl(f, cfg.Title or "Slider", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        tl.Size     = UDim2.new(1,(showInp and -70 or -68),0,16)
        tl.Position = UDim2.new(0,0,0,10)

        if hasDesc then
            local dl = lbl(f, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
            dl.Size     = UDim2.new(1,-68,0,13)
            dl.Position = UDim2.new(0,0,0,27)
        end

        local trackY = hasDesc and 50 or 36

        local trackBg = frame(f, theme.ElementStroke, UDim2.new(1,0,0,6))
        trackBg.Position = UDim2.new(0,0,0,trackY)
        corner(trackBg, UDim.new(1,0))

        local pct  = (value-mn)/(mx-mn)
        local fill = frame(trackBg, theme.Accent, UDim2.new(pct,0,1,0))
        corner(fill, UDim.new(1,0))

        local thumb = frame(trackBg, Color3.fromRGB(255,255,255), UDim2.new(0,16,0,16))
        thumb.AnchorPoint = Vector2.new(0.5,0.5)
        thumb.Position    = UDim2.new(pct,0,0.5,0)
        thumb.ZIndex      = 3
        corner(thumb, UDim.new(1,0))
        stroke(thumb, theme.Accent, 2)

        local inputBox = nil
        if showInp then
            local ib = frame(f, theme.InputBg, UDim2.new(0,52,0,22))
            ib.Position = UDim2.new(1,-54,0,8)
            corner(ib, CORNER_SM)
            stroke(ib, theme.ElementStroke2, 1)

            local inp = Instance.new("TextBox")
            inp.Size               = UDim2.new(1,-4,1,0)
            inp.Position           = UDim2.new(0,2,0,0)
            inp.BackgroundTransparency = 1
            inp.Text               = tostring(value)
            inp.TextColor3         = theme.Accent
            inp.TextSize           = 11
            inp.Font               = Enum.Font.GothamBold
            inp.TextXAlignment     = Enum.TextXAlignment.Center
            inp.ClearTextOnFocus   = true
            inp.Parent             = ib

            inp.FocusLost:Connect(function()
                local v = tonumber(inp.Text)
                if v then value = math.clamp(math.floor(v/step+0.5)*step, mn, mx) end
                inp.Text = tostring(value)
                local p2 = (value-mn)/(mx-mn)
                tw(fill,{Size=UDim2.new(p2,0,1,0)},0.08)
                tw(thumb,{Position=UDim2.new(p2,0,0.5,0)},0.08)
                task.spawn(function() pcall(cfg.Callback or function()end, value) end)
            end)
            inputBox = inp
        end

        local dragging = false
        local function updateSlider(x)
            if disabled then return end
            local rel = math.clamp((x-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X, 0, 1)
            value = math.clamp(math.floor((mn+rel*(mx-mn))/step+0.5)*step, mn, mx)
            local p2 = (value-mn)/(mx-mn)
            tw(fill,{Size=UDim2.new(p2,0,1,0)},0.06)
            tw(thumb,{Position=UDim2.new(p2,0,0.5,0)},0.06)
            if valDisplay then valDisplay.Text = tostring(value)..suffix end
            if inputBox   then inputBox.Text   = tostring(value) end
            task.spawn(function() pcall(cfg.Callback or function()end, value) end)
        end

        trackBg.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; updateSlider(i.Position.X) end
        end)
        thumb.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then updateSlider(i.Position.X) end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
        end)

        if disabled then f.BackgroundTransparency=0.4 end
        f.Parent = page

        local obj = {_frame=f}
        function obj:Get() return value end
        function obj:Set(v)
            value = math.clamp(v,mn,mx)
            local p2 = (value-mn)/(mx-mn)
            tw(fill,{Size=UDim2.new(p2,0,1,0)})
            tw(thumb,{Position=UDim2.new(p2,0,0.5,0)})
            if valDisplay then valDisplay.Text=tostring(value)..suffix end
            if inputBox   then inputBox.Text=tostring(value) end
        end
        function obj:SetDisabled(v) disabled=v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
        return obj
    end

    function Tab:Dropdown(cfg)
        cfg = cfg or {}
        local values   = cfg.Values  or {}
        local value    = cfg.Value   or (values[1] or "")
        local multi    = cfg.Multi   or false
        local selected = {}
        local open     = false
        local disabled = cfg.Disabled or false

        local f = frame(page, cfg.Color or theme.Element, UDim2.new(1,0,0,ELEMENT_H))
        f.BorderSizePixel  = 0
        f.ClipsDescendants = false
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 0,0,14,14)

        titleDesc(f, theme, cfg, 116)

        local selBox = frame(f, theme.InputBg, UDim2.new(0,104,0,26))
        selBox.Position = UDim2.new(1,-106,0.5,-13)
        corner(selBox, CORNER_SM)
        stroke(selBox, theme.ElementStroke2, 1)

        local selLbl = lbl(selBox, value, theme.TextPrimary, 11, Enum.Font.Gotham)
        selLbl.Size     = UDim2.new(1,-22,1,0)
        selLbl.Position = UDim2.new(0,7,0,0)
        selLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local chev = lbl(selBox, "▾", theme.TextSecondary, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        chev.Size     = UDim2.new(0,18,1,0)
        chev.Position = UDim2.new(1,-20,0,0)

        local listCont = frame(nil, theme.Element, UDim2.new(0,104,0,0))
        listCont.ClipsDescendants = true
        listCont.ZIndex           = 999
        corner(listCont, CORNER_EL)
        stroke(listCont, theme.ElementStroke, 1)

        local function positionList()
            local sg = Tab._gui
            if not sg then return end
            listCont.Parent = sg
            local abs = selBox.AbsolutePosition
            local sz  = selBox.AbsoluteSize
            listCont.Position = UDim2.new(0, abs.X, 0, abs.Y + sz.Y + 4)
            listCont.Size     = UDim2.new(0, 104, 0, 0)
        end

        local listScroll = Instance.new("ScrollingFrame")
        listScroll.Size                = UDim2.fromScale(1,1)
        listScroll.BackgroundTransparency = 1
        listScroll.ScrollBarThickness  = 2
        listScroll.ScrollBarImageColor3 = theme.ScrollBar
        listScroll.CanvasSize          = UDim2.new(0,0,0,0)
        listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        listScroll.BorderSizePixel     = 0
        listScroll.ZIndex              = 1000
        listScroll.Parent              = listCont
        pad(listScroll, 4,4,4,4)

        local listLay = Instance.new("UIListLayout")
        listLay.Padding = UDim.new(0,2)
        listLay.Parent  = listScroll

        local function getDisplay()
            if multi then
                if #selected==0 then return "None" end
                if #selected==1 then return selected[1] end
                return selected[1].." +"..#selected-1
            end
            return value
        end

        local function buildList()
            for _,c in ipairs(listScroll:GetChildren()) do
                if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
            end
            for _,v in ipairs(values) do
                local isSel = multi and (table.find(selected,v)~=nil) or (v==value)

                local itemF = frame(listScroll, isSel and theme.ElementActive or theme.Element, UDim2.new(1,0,0,28))
                itemF.BorderSizePixel = 0
                itemF.ZIndex          = 102
                corner(itemF, UDim.new(0,5))
                if isSel then stroke(itemF, theme.Accent, 1) end

                local itemL = lbl(itemF, v, isSel and theme.Accent or theme.TextPrimary, 11, Enum.Font.Gotham)
                itemL.Size     = UDim2.new(1,-28,1,0)
                itemL.Position = UDim2.new(0,8,0,0)
                itemL.ZIndex   = 103

                if isSel then
                    local ck = lbl(itemF, "✓", theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
                    ck.Size     = UDim2.new(0,18,1,0)
                    ck.Position = UDim2.new(1,-20,0,0)
                    ck.ZIndex   = 103
                end

                local ib = btn(itemF, UDim2.fromScale(1,1), nil, 104)
                ib.MouseEnter:Connect(function() if not isSel then tw(itemF,{BackgroundColor3=theme.ElementHover}) end end)
                ib.MouseLeave:Connect(function() if not isSel then tw(itemF,{BackgroundColor3=theme.Element}) end end)
                ib.MouseButton1Click:Connect(function()
                    if multi then
                        local idx = table.find(selected,v)
                        if idx then table.remove(selected,idx) else table.insert(selected,v) end
                        selLbl.Text = getDisplay()
                        buildList()
                        task.spawn(function() pcall(cfg.Callback or function()end, selected) end)
                    else
                        value = v
                        selLbl.Text = v
                        open = false
                        tw(listCont,{Size=UDim2.new(0,104,0,0)})
                        task.delay(0.15, function() listCont.Parent=nil end)
                        tw(chev,{Rotation=0})
                        buildList()
                        task.spawn(function() pcall(cfg.Callback or function()end, value) end)
                    end
                end)
            end
        end
        buildList()

        local mb = btn(f, UDim2.new(1,0,0,ELEMENT_H))
        mb.MouseEnter:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=theme.ElementHover})
        end)
        mb.MouseLeave:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=cfg.Color or theme.Element})
        end)
        mb.MouseButton1Click:Connect(function()
            if disabled then return end
            open = not open
            local ih = math.min(#values,6)*30+8
            if open then
                positionList()
                tw(listCont,{Size=UDim2.new(0,104,0,ih)})
            else
                tw(listCont,{Size=UDim2.new(0,104,0,0)})
                task.delay(0.15, function() if not open then listCont.Parent=nil end end)
            end
            tw(chev,{Rotation=open and 180 or 0})
        end)

        if disabled then f.BackgroundTransparency=0.4 end
        f.Parent = page

        local obj = {_frame=f}
        function obj:Get() return multi and selected or value end
        function obj:Set(v) if multi then selected=v else value=v end; selLbl.Text=getDisplay(); buildList() end
        function obj:Refresh(nv) values=nv; buildList() end
        function obj:SetDisabled(v) disabled=v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
        return obj
    end

    function Tab:Paragraph(cfg)
        cfg = cfg or {}

        local f = Instance.new("Frame")
        f.Size              = UDim2.new(1,0,0,0)
        f.AutomaticSize     = Enum.AutomaticSize.Y
        f.BackgroundColor3  = cfg.Color or theme.Element
        f.BorderSizePixel   = 0
        if cfg.Transparency then f.BackgroundTransparency=cfg.Transparency end
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 10,10,14,14)

        if cfg.AccentBar then
            local abar = frame(f, cfg.AccentBar, UDim2.new(0,3,1,0))
            abar.Position = UDim2.new(0,-14,0,0)
            corner(abar, UDim.new(0,2))
        end

        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0,5)
        lay.Parent  = f

        if cfg.Title and cfg.Title~="" then
            local tl = lbl(f, cfg.Title, theme.TextPrimary, 13, Enum.Font.GothamBold)
            tl.Size          = UDim2.new(1,0,0,0)
            tl.AutomaticSize = Enum.AutomaticSize.Y
            tl.TextWrapped   = true
            tl.TextYAlignment = Enum.TextYAlignment.Top
        end
        if cfg.Desc and cfg.Desc~="" then
            local dl = lbl(f, cfg.Desc, theme.TextSecondary, 12, Enum.Font.Gotham)
            dl.Size          = UDim2.new(1,0,0,0)
            dl.AutomaticSize = Enum.AutomaticSize.Y
            dl.TextWrapped   = true
            dl.TextYAlignment = Enum.TextYAlignment.Top
        end

        f.Parent = page
        return f
    end

    function Tab:Divider(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1,0,0,20))
        f.BackgroundTransparency = 1

        local line = frame(f, cfg.Color or theme.ElementStroke, UDim2.new(1,0,0,1))
        line.Position    = UDim2.new(0,0,0.5,0)
        line.AnchorPoint = Vector2.new(0,0.5)

        if cfg.Label and cfg.Label~="" then
            local bg = frame(f, theme.Background, UDim2.new(0,0,1,0))
            bg.AutomaticSize  = Enum.AutomaticSize.X
            bg.AnchorPoint    = Vector2.new(0.5,0)
            bg.Position       = UDim2.new(0.5,0,0,0)
            bg.BorderSizePixel = 0
            local ll = lbl(bg, "  "..cfg.Label.."  ", theme.TextDisabled, 11, Enum.Font.Gotham, Enum.TextXAlignment.Center)
            ll.Size = UDim2.new(1,0,1,0)
        end

        f.Parent = page
        return f
    end

    function Tab:Space(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1,0,0,cfg.Height or 8))
        f.BackgroundTransparency = 1
        f.Parent = page
        return f
    end

    function Tab:Keybind(cfg)
        cfg = cfg or {}
        local value     = cfg.Key      or Enum.KeyCode.F
        local disabled  = cfg.Disabled or false
        local listening = false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 92)

        local keyBox = frame(f, theme.InputBg, UDim2.new(0,80,0,26))
        keyBox.Position = UDim2.new(1,-82,0.5,-13)
        corner(keyBox, CORNER_SM)
        stroke(keyBox, theme.ElementStroke2, 1)

        local keyL = lbl(keyBox, "["..keyName(value).."]", theme.Accent, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        keyL.Size = UDim2.fromScale(1,1)

        local b = btn(f)
        b.MouseEnter:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=theme.ElementHover})
        end)
        b.MouseLeave:Connect(function()
            if disabled then return end
            tw(f,{BackgroundColor3=cfg.Color or theme.Element})
        end)
        b.MouseButton1Click:Connect(function()
            if disabled or listening then return end
            listening = true
            keyL.Text      = "[ ... ]"
            keyL.TextColor3 = theme.Warning
            tw(keyBox,{BackgroundColor3=theme.ElementActive})
            local conn
            conn = UserInputService.InputBegan:Connect(function(i,gp)
                if gp then return end
                if i.UserInputType==Enum.UserInputType.Keyboard then
                    value       = i.KeyCode
                    listening   = false
                    keyL.Text   = "["..keyName(value).."]"
                    keyL.TextColor3 = theme.Accent
                    tw(keyBox,{BackgroundColor3=theme.InputBg})
                    conn:Disconnect()
                    task.spawn(function() pcall(cfg.Callback or function()end, value) end)
                end
            end)
        end)

        if cfg.OnPress then
            UserInputService.InputBegan:Connect(function(i,gp)
                if gp or listening then return end
                if i.KeyCode==value then task.spawn(function() pcall(cfg.OnPress,value) end) end
            end)
        end

        if disabled then f.BackgroundTransparency=0.4 end
        f.Parent = page

        local obj = {_frame=f}
        function obj:Get() return value end
        function obj:Set(kc) value=kc; keyL.Text="["..keyName(kc).."]" end
        return obj
    end

    function Tab:KeybindButton(cfg)
        cfg = cfg or {}
        local value     = cfg.Key       or Enum.KeyCode.F
        local disabled  = cfg.Disabled  or false
        local listening = false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = true
        titleDesc(f, theme, cfg, 126)

        local keyBox = frame(f, theme.InputBg, UDim2.new(0,48,0,22))
        keyBox.Position = UDim2.new(1,-120,0.5,-11)
        corner(keyBox, CORNER_SM)
        stroke(keyBox, theme.ElementStroke2, 1)

        local keyL = lbl(keyBox, keyName(value), theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        keyL.Size = UDim2.fromScale(1,1)

        local execBox = frame(f, theme.Accent, UDim2.new(0,58,0,26))
        execBox.Position = UDim2.new(1,-62,0.5,-13)
        corner(execBox, CORNER_SM)

        local execL = lbl(execBox, cfg.ButtonText or "Run", Color3.fromRGB(10,10,10), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        execL.Size = UDim2.fromScale(1,1)

        local eb = btn(execBox, UDim2.fromScale(1,1), nil, 3)
        eb.MouseButton1Click:Connect(function()
            if disabled then return end
            ripple(execBox,theme)
            task.spawn(function() pcall(cfg.Callback or function()end) end)
        end)
        eb.MouseEnter:Connect(function() tw(execBox,{BackgroundColor3=theme.AccentLight}) end)
        eb.MouseLeave:Connect(function() tw(execBox,{BackgroundColor3=theme.Accent}) end)

        local kb = btn(keyBox, UDim2.fromScale(1,1), nil, 3)
        kb.MouseButton1Click:Connect(function()
            if disabled or listening then return end
            listening = true
            keyL.Text      = "..."
            keyL.TextColor3 = theme.Warning
            local conn
            conn = UserInputService.InputBegan:Connect(function(i,gp)
                if gp then return end
                if i.UserInputType==Enum.UserInputType.Keyboard then
                    value       = i.KeyCode
                    listening   = false
                    keyL.Text   = keyName(value)
                    keyL.TextColor3 = theme.Accent
                    conn:Disconnect()
                end
            end)
        end)

        UserInputService.InputBegan:Connect(function(i,gp)
            if gp or listening or disabled then return end
            if i.KeyCode==value then task.spawn(function() pcall(cfg.Callback or function()end) end) end
        end)

        local hb = btn(f, UDim2.new(1,-190,1,0))
        hb.MouseEnter:Connect(function() if not disabled then tw(f,{BackgroundColor3=theme.ElementHover}) end end)
        hb.MouseLeave:Connect(function() if not disabled then tw(f,{BackgroundColor3=cfg.Color or theme.Element}) end end)

        if disabled then f.BackgroundTransparency=0.4 end
        f.Parent = page

        local obj = {_frame=f}
        function obj:GetKey() return value end
        function obj:SetKey(kc) value=kc; keyL.Text=keyName(kc) end
        function obj:SetDisabled(v) disabled=v; tw(f,{BackgroundTransparency=v and 0.4 or 0}) end
        return obj
    end

    function Tab:Card(cfg)
        cfg = cfg or {}
        local h = cfg.Height or 78

        local f = frame(page, cfg.Color or theme.CardBg, UDim2.new(1,0,0,h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.CardStroke, 1)
        pad(f, 10,10,14,14)

        if cfg.AccentColor then
            local abar = frame(f, cfg.AccentColor, UDim2.new(0,3,0.65,0))
            abar.Position = UDim2.new(0,-14,0.175,0)
            corner(abar, UDim.new(0,2))
        end

        if cfg.Icon then
            local ic = lbl(f, cfg.Icon, theme.Accent, 20, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            ic.Size     = UDim2.new(0,26,0,26)
            ic.Position = UDim2.new(1,-30,0,0)
        end

        if cfg.Title and cfg.Title~="" then
            local tl = lbl(f, cfg.Title, theme.TextPrimary, 13, Enum.Font.GothamBold)
            tl.Size     = UDim2.new(1,-36,0,17)
            tl.Position = UDim2.new(0,0,0,2)
        end

        local valLbl = nil
        if cfg.Value~=nil then
            valLbl = lbl(f, tostring(cfg.Value), cfg.ValueColor or theme.Accent, 22, Enum.Font.GothamBold)
            valLbl.Size     = UDim2.new(1,0,0,28)
            valLbl.Position = UDim2.new(0,0,0,22)
        end

        if cfg.Desc and cfg.Desc~="" then
            local dl = lbl(f, cfg.Desc, theme.TextSecondary, 11, Enum.Font.Gotham)
            dl.Size     = UDim2.new(1,0,0,14)
            dl.Position = UDim2.new(0,0,1,-18)
        end

        if cfg.Callback then
            local b = btn(f)
            b.MouseButton1Click:Connect(function()
                ripple(f,theme)
                task.spawn(function() pcall(cfg.Callback) end)
            end)
            b.MouseEnter:Connect(function() tw(f,{BackgroundColor3=theme.ElementHover}) end)
            b.MouseLeave:Connect(function() tw(f,{BackgroundColor3=cfg.Color or theme.CardBg}) end)
        end

        f.Parent = page

        local obj = {_frame=f}
        function obj:SetValue(v)
            if valLbl then valLbl.Text=tostring(v) end
        end
        return obj
    end

    function Tab:CardRow(cards)
        cards = cards or {}
        local rowH = 0
        for _,c in ipairs(cards) do rowH = math.max(rowH, c.Height or 76) end

        local rowF = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1,0,0,rowH))
        rowF.BackgroundTransparency = 1

        local rlay = Instance.new("UIListLayout")
        rlay.FillDirection       = Enum.FillDirection.Horizontal
        rlay.VerticalAlignment   = Enum.VerticalAlignment.Center
        rlay.HorizontalAlignment = Enum.HorizontalAlignment.Left
        rlay.Padding             = UDim.new(0,6)
        rlay.Parent              = rowF

        local n   = #cards
        local objs = {}

        for i, cc in ipairs(cards) do
            local cw = math.floor((1/n)*100)
            local cf = frame(rowF, cc.Color or theme.CardBg, UDim2.new(cw/100, i<n and -4 or 0, 1,0))
            cf.BorderSizePixel = 0
            corner(cf, CORNER_EL)
            stroke(cf, theme.CardStroke, 1)
            pad(cf, 10,10,12,12)

            if cc.Title then
                local tl = lbl(cf, cc.Title, theme.TextSecondary, 11, Enum.Font.Gotham)
                tl.Size = UDim2.new(1,0,0,14)
                tl.Position = UDim2.new(0,0,0,0)
            end

            local vl = nil
            if cc.Value~=nil then
                vl = lbl(cf, tostring(cc.Value), cc.ValueColor or theme.Accent, 18, Enum.Font.GothamBold)
                vl.Size     = UDim2.new(1,0,0,22)
                vl.Position = UDim2.new(0,0,0,16)
            end

            if cc.Sub then
                local sl = lbl(cf, cc.Sub, theme.TextDisabled, 10, Enum.Font.Gotham)
                sl.Size     = UDim2.new(1,0,0,12)
                sl.Position = UDim2.new(0,0,1,-14)
            end

            local o = {_frame=cf}
            function o:SetValue(v) if vl then vl.Text=tostring(v) end end
            table.insert(objs,o)
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

        local h = 82 + (#badges>0 and 10 or 0)
        local f = frame(page, cfg.Color or theme.ProfileBg, UDim2.new(1,0,0,h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.CardStroke, 1)

        local strip = frame(f, theme.Accent, UDim2.new(1,0,0,3))
        strip.BackgroundTransparency = 0.75
        corner(strip, UDim.new(0,2))

        local avBg = frame(f, theme.ElementStroke, UDim2.new(0,52,0,52))
        avBg.Position = UDim2.new(0,14,0.5,-26)
        corner(avBg, UDim.new(1,0))
        stroke(avBg, theme.Accent, 2)

        local av = Instance.new("ImageLabel")
        av.Size             = UDim2.new(1,-4,1,-4)
        av.Position         = UDim2.new(0,2,0,2)
        av.BackgroundColor3 = theme.Element
        av.Image            = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=150&height=150&format=png"
        av.ScaleType        = Enum.ScaleType.Crop
        av.ZIndex           = 2
        corner(av, UDim.new(1,0))
        av.Parent = avBg

        local dot = frame(avBg, theme.Success, UDim2.new(0,11,0,11))
        dot.Position  = UDim2.new(1,-11,1,-11)
        dot.ZIndex    = 3
        corner(dot, UDim.new(1,0))
        stroke(dot, theme.ProfileBg, 2)

        local nameLbl = lbl(f, username, theme.TextPrimary, 13, Enum.Font.GothamBold)
        nameLbl.Size     = UDim2.new(1,-120,0,17)
        nameLbl.Position = UDim2.new(0,74,0,14)

        local descLbl = lbl(f, desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        descLbl.Size     = UDim2.new(1,-120,0,14)
        descLbl.Position = UDim2.new(0,74,0,32)

        if #badges>0 then
            local badgeRow = frame(f, Color3.fromRGB(0,0,0), UDim2.new(1,-120,0,17))
            badgeRow.Position           = UDim2.new(0,74,0,48)
            badgeRow.BackgroundTransparency = 1

            local blay = Instance.new("UIListLayout")
            blay.FillDirection     = Enum.FillDirection.Horizontal
            blay.VerticalAlignment = Enum.VerticalAlignment.Center
            blay.Padding           = UDim.new(0,4)
            blay.Parent            = badgeRow

            for _,badge in ipairs(badges) do
                local bf = frame(badgeRow, badge.Color or theme.Accent, UDim2.new(0,0,0,15))
                bf.AutomaticSize          = Enum.AutomaticSize.X
                bf.BackgroundTransparency = 0.76
                corner(bf, UDim.new(0,4))
                pad(bf,0,0,5,5)
                local bl = lbl(bf, badge.Text or "•", badge.Color or theme.Accent, 9, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
                bl.Size          = UDim2.new(0,0,1,0)
                bl.AutomaticSize = Enum.AutomaticSize.X
            end
        end

        if cfg.Role then
            local rl = lbl(f, cfg.Role, theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            rl.Size     = UDim2.new(0,90,0,16)
            rl.Position = UDim2.new(1,-98,0,14)
        end

        f.Parent = page
        return {_frame=f}
    end

    function Tab:Badge(cfg)
        cfg = cfg or {}
        local wrapper = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1,0,0,34))
        wrapper.BackgroundTransparency = 1

        local lay = Instance.new("UIListLayout")
        lay.FillDirection     = Enum.FillDirection.Horizontal
        lay.VerticalAlignment = Enum.VerticalAlignment.Center
        lay.Padding           = UDim.new(0,6)
        lay.Parent            = wrapper

        local badges = type(cfg[1])=="table" and cfg or {cfg}
        for _,badge in ipairs(badges) do
            local bf = frame(wrapper, badge.Color or theme.Accent, UDim2.new(0,0,0,22))
            bf.AutomaticSize          = Enum.AutomaticSize.X
            bf.BackgroundTransparency = 0.78
            corner(bf, UDim.new(1,0))
            pad(bf,0,0,8,8)
            local bl = lbl(bf, badge.Text or "Badge", badge.Color or theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            bl.Size          = UDim2.new(0,0,1,0)
            bl.AutomaticSize = Enum.AutomaticSize.X
        end

        wrapper.Parent = page
        return {_frame=wrapper}
    end

    function Tab:ColorPicker(cfg)
        cfg = cfg or {}
        local value    = cfg.Value    or Color3.fromRGB(255,255,255)
        local disabled = cfg.Disabled or false
        local open     = false

        local f = baseEl(theme, cfg)
        f.ClipsDescendants = false
        titleDesc(f, theme, cfg, 48)

        local preview = frame(f, value, UDim2.new(0,30,0,22))
        preview.Position = UDim2.new(1,-32,0.5,-11)
        corner(preview, CORNER_SM)
        stroke(preview, theme.ElementStroke, 1)

        local panel = frame(f, theme.Element, UDim2.new(0,210,0,0))
        panel.Position         = UDim2.new(0,0,0,(f.Size.Y.Offset or ELEMENT_H)+4)
        panel.ClipsDescendants = true
        panel.ZIndex           = 20
        corner(panel, CORNER_EL)
        stroke(panel, theme.ElementStroke, 1)
        pad(panel,10,10,12,12)

        local play = Instance.new("UIListLayout")
        play.Padding = UDim.new(0,6)
        play.Parent  = panel

        local rgb = { math.floor(value.R*255), math.floor(value.G*255), math.floor(value.B*255) }

        local function updateColor()
            value = Color3.fromRGB(rgb[1],rgb[2],rgb[3])
            tw(preview,{BackgroundColor3=value})
            task.spawn(function() pcall(cfg.Callback or function()end, value) end)
        end

        local channels = {{name="R",idx=1,col=Color3.fromRGB(220,60,60)},{name="G",idx=2,col=Color3.fromRGB(60,200,80)},{name="B",idx=3,col=Color3.fromRGB(60,120,220)}}

        for _,ch in ipairs(channels) do
            local row = frame(panel, Color3.fromRGB(0,0,0), UDim2.new(1,0,0,22))
            row.BackgroundTransparency = 1

            local cl = lbl(row, ch.name, theme.TextSecondary, 10, Enum.Font.GothamBold)
            cl.Size = UDim2.new(0,14,1,0)

            local tr = frame(row, theme.ElementStroke, UDim2.new(1,-54,0,5))
            tr.Position = UDim2.new(0,18,0.5,-2)
            corner(tr, UDim.new(1,0))

            local fi = frame(tr, ch.col, UDim2.new(rgb[ch.idx]/255,0,1,0))
            corner(fi, UDim.new(1,0))
            fi.BackgroundTransparency = 0.2

            local th2 = frame(tr, Color3.fromRGB(255,255,255), UDim2.new(0,12,0,12))
            th2.AnchorPoint = Vector2.new(0.5,0.5)
            th2.Position    = UDim2.new(rgb[ch.idx]/255,0,0.5,0)
            th2.ZIndex      = 3
            corner(th2, UDim.new(1,0))
            stroke(th2, ch.col, 1.5)

            local vi = Instance.new("TextBox")
            vi.Size              = UDim2.new(0,30,0,18)
            vi.Position          = UDim2.new(1,-30,0.5,-9)
            vi.BackgroundColor3  = theme.InputBg
            vi.Text              = tostring(rgb[ch.idx])
            vi.TextColor3        = theme.TextPrimary
            vi.TextSize          = 10
            vi.Font              = Enum.Font.Gotham
            vi.TextXAlignment    = Enum.TextXAlignment.Center
            vi.ClearTextOnFocus  = true
            vi.BorderSizePixel   = 0
            vi.ZIndex            = 21
            corner(vi, UDim.new(0,3))
            vi.Parent = row

            vi.FocusLost:Connect(function()
                local v = math.clamp(tonumber(vi.Text) or rgb[ch.idx],0,255)
                rgb[ch.idx] = math.floor(v)
                vi.Text = tostring(rgb[ch.idx])
                tw(fi,{Size=UDim2.new(v/255,0,1,0)},0.06)
                tw(th2,{Position=UDim2.new(v/255,0,0.5,0)},0.06)
                updateColor()
            end)

            local drag2 = false
            tr.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then
                    drag2=true
                    local r2=math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
                    rgb[ch.idx]=math.floor(r2*255); vi.Text=tostring(rgb[ch.idx])
                    tw(fi,{Size=UDim2.new(r2,0,1,0)},0.05); tw(th2,{Position=UDim2.new(r2,0,0.5,0)},0.05)
                    updateColor()
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if drag2 and i.UserInputType==Enum.UserInputType.MouseMovement then
                    local r2=math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
                    rgb[ch.idx]=math.floor(r2*255); vi.Text=tostring(rgb[ch.idx])
                    tw(fi,{Size=UDim2.new(r2,0,1,0)},0.05); tw(th2,{Position=UDim2.new(r2,0,0.5,0)},0.05)
                    updateColor()
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then drag2=false end
            end)
        end

        local b = btn(f)
        b.MouseButton1Click:Connect(function()
            if disabled then return end
            open = not open
            local ph = open and (22*3+6*2+20) or 0
            tw(panel,{Size=UDim2.new(0,210,0,ph)})
        end)
        b.MouseEnter:Connect(function() if not disabled then tw(f,{BackgroundColor3=theme.ElementHover}) end end)
        b.MouseLeave:Connect(function() if not disabled then tw(f,{BackgroundColor3=cfg.Color or theme.Element}) end end)

        if disabled then f.BackgroundTransparency=0.4 end
        f.Parent = page

        local obj = {_frame=f}
        function obj:Get() return value end
        function obj:Set(col)
            value=col; rgb={math.floor(col.R*255),math.floor(col.G*255),math.floor(col.B*255)}
            tw(preview,{BackgroundColor3=value})
        end
        return obj
    end

    function Tab:Label(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1,0,0,cfg.Height or 22))
        f.BackgroundTransparency = 1

        local l = lbl(f, cfg.Text or "", cfg.Color or theme.TextSecondary, cfg.Size or 12, cfg.Font or Enum.Font.Gotham, cfg.Align or Enum.TextXAlignment.Left)
        l.Size        = UDim2.fromScale(1,1)
        l.TextWrapped = cfg.Wrap or false

        f.Parent = page

        local obj = {_frame=f,_lbl=l}
        function obj:Set(v) l.Text=v end
        function obj:SetColor(v) l.TextColor3=v end
        return obj
    end

    function Tab:Section(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1,0,0,26))
        f.BackgroundTransparency = 1

        local accent = frame(f, theme.Accent, UDim2.new(0,3,0.7,0))
        accent.Position = UDim2.new(0,0,0.15,0)
        corner(accent, UDim.new(0,2))

        local sl = lbl(f, cfg.Title or "Section", theme.TextSecondary, 11, Enum.Font.GothamBold)
        sl.Size     = UDim2.new(1,-10,1,0)
        sl.Position = UDim2.new(0,10,0,0)

        f.Parent = page
        return f
    end

end

function TryxLib:CreateWindow(config)
    config = config or {}

    local theme     = config.Theme    or Themes.Default
    local title     = config.Title    or "TryxLib"
    local subtitle  = config.Subtitle or ""
    local icon      = config.Icon     or "★"
    local winSize   = config.Size     or Vector2.new(DEFAULT_W, DEFAULT_H)
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightAlt

    local gui = Instance.new("ScreenGui")
    gui.Name            = "TryxLib_"..title:gsub("%s","")
    gui.ResetOnSpawn    = false
    gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder    = 500
    gui.IgnoreGuiInset  = true
    gui.Parent          = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

    local win = frame(gui, theme.Background,
        UDim2.new(0,winSize.X,0,0),
        UDim2.new(0.5,-winSize.X/2,0.5,-winSize.Y/2)
    )
    win.Name            = "Window"
    win.ClipsDescendants = false
    corner(win, CORNER_WIN)
    stroke(win, theme.ElementStroke, 1)
    shadow(win)

    local topBar = frame(win, theme.TopBar, UDim2.new(1,0,0,TOPBAR_H))
    topBar.ZIndex = 4
    corner(topBar, CORNER_WIN)

    local topFix = frame(win, theme.TopBar, UDim2.new(1,0,0,TOPBAR_H/2))
    topFix.Position = UDim2.new(0,0,0,TOPBAR_H/2)
    topFix.ZIndex   = 3

    local topSep = frame(win, theme.ElementStroke, UDim2.new(1,0,0,1))
    topSep.Position = UDim2.new(0,0,0,TOPBAR_H)
    topSep.ZIndex   = 5

    local topLay = Instance.new("UIListLayout")
    topLay.FillDirection     = Enum.FillDirection.Horizontal
    topLay.VerticalAlignment = Enum.VerticalAlignment.Center
    topLay.Padding           = UDim.new(0,10)
    topLay.Parent            = topBar
    pad(topBar,0,0,14,14)

    local iconLbl = lbl(topBar, icon, theme.Accent, 15, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    iconLbl.Size = UDim2.new(0,18,1,0)

    local titleCont = frame(topBar, Color3.fromRGB(0,0,0), UDim2.new(1,-100,1,0))
    titleCont.BackgroundTransparency = 1

    local titleLbl = lbl(titleCont, title, theme.TextPrimary, 13, Enum.Font.GothamBold)
    titleLbl.Size     = UDim2.new(1,0,0,16)
    titleLbl.Position = subtitle~="" and UDim2.new(0,0,0,6) or UDim2.new(0,0,0.5,-8)

    if subtitle~="" then
        local subLbl = lbl(titleCont, subtitle, theme.TextSecondary, 10, Enum.Font.Gotham)
        subLbl.Size     = UDim2.new(1,0,0,12)
        subLbl.Position = UDim2.new(0,0,0,23)
    end

    local btnCont = frame(topBar, Color3.fromRGB(0,0,0), UDim2.new(0,60,1,0))
    btnCont.BackgroundTransparency = 1
    local btnLay = Instance.new("UIListLayout")
    btnLay.FillDirection        = Enum.FillDirection.Horizontal
    btnLay.HorizontalAlignment  = Enum.HorizontalAlignment.Right
    btnLay.VerticalAlignment    = Enum.VerticalAlignment.Center
    btnLay.Padding              = UDim.new(0,7)
    btnLay.Parent               = btnCont

    local function winBtn(col, darkCol)
        local b = Instance.new("TextButton")
        b.Size             = UDim2.new(0,12,0,12)
        b.BackgroundColor3 = col
        b.Text             = ""
        b.BorderSizePixel  = 0
        b.AutoButtonColor  = false
        b.Parent           = btnCont
        corner(b, UDim.new(1,0))
        b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=darkCol or col}) end)
        b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=col}) end)
        return b
    end

    local closeBtn = winBtn(theme.Danger,   theme.DangerDark)
    local minBtn   = winBtn(theme.Warning,  theme.WarningDark)
    local maxBtn   = winBtn(theme.Success,  theme.SuccessDark)

    local sidebar = frame(win, theme.Sidebar,
        UDim2.new(0,SIDEBAR_W,1,-TOPBAR_H),
        UDim2.new(0,0,0,TOPBAR_H)
    )
    sidebar.ZIndex = 3

    local sideSep = frame(sidebar, theme.ElementStroke, UDim2.new(0,1,1,0))
    sideSep.Position = UDim2.new(1,0,0,0)

    local verLbl = lbl(sidebar, "TryxLib v2.0", theme.TextDisabled, 9, Enum.Font.Gotham, Enum.TextXAlignment.Center)
    verLbl.Size     = UDim2.new(1,0,0,16)
    verLbl.Position = UDim2.new(0,0,1,-18)

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size                   = UDim2.new(1,0,1,-28)
    tabScroll.Position               = UDim2.new(0,0,0,6)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness     = 0
    tabScroll.CanvasSize             = UDim2.new(0,0,0,0)
    tabScroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    tabScroll.BorderSizePixel        = 0
    tabScroll.ZIndex                 = 4
    tabScroll.Parent                 = sidebar

    local tabLay = Instance.new("UIListLayout")
    tabLay.Padding             = UDim.new(0,2)
    tabLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLay.Parent              = tabScroll
    pad(tabScroll,6,6,6,6)

    local content = frame(win, theme.Background,
        UDim2.new(1,-SIDEBAR_W,1,-TOPBAR_H),
        UDim2.new(0,SIDEBAR_W,0,TOPBAR_H)
    )
    content.Name             = "Content"
    content.ClipsDescendants = true

    local resizeH = Instance.new("TextButton")
    resizeH.Size             = UDim2.new(0,16,0,16)
    resizeH.Position         = UDim2.new(1,-16,1,-16)
    resizeH.BackgroundColor3 = theme.ElementStroke
    resizeH.Text             = ""
    resizeH.BorderSizePixel  = 0
    resizeH.AutoButtonColor  = false
    resizeH.ZIndex           = 10
    resizeH.Parent           = win
    corner(resizeH, UDim.new(0,3))
    for row=0,2 do
        for col=0,2 do
            if row+col>=2 then
                local d = frame(resizeH, theme.TextDisabled, UDim2.new(0,2,0,2))
                d.Position = UDim2.new(0,2+col*4,0,2+row*4)
                d.ZIndex   = 11
                corner(d, UDim.new(1,0))
            end
        end
    end

    makeDraggable(topBar, win)
    makeResizable(resizeH, win)

    local visible   = true
    local minimized = false
    local maximized = false
    local prevSize  = UDim2.new(0,winSize.X,0,winSize.Y)
    local prevPos   = win.Position

    tw(win, {Size=UDim2.new(0,winSize.X,0,winSize.Y)}, ANIM_SLOW)

    closeBtn.MouseButton1Click:Connect(function()
        tw(win,{Size=UDim2.new(0,win.Size.X.Offset,0,0),BackgroundTransparency=1},ANIM_FAST)
        task.wait(ANIM_FAST+0.06); gui:Destroy()
    end)

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            prevSize = win.Size
            content.Visible=false; sidebar.Visible=false; resizeH.Visible=false
            tw(win,{Size=UDim2.new(0,win.Size.X.Offset,0,TOPBAR_H)},ANIM_MED)
        else
            tw(win,{Size=prevSize},ANIM_MED)
            task.wait(ANIM_MED)
            content.Visible=true; sidebar.Visible=true; resizeH.Visible=true
        end
    end)

    maxBtn.MouseButton1Click:Connect(function()
        maximized = not maximized
        if maximized then
            prevSize=win.Size; prevPos=win.Position
            local vp=workspace.CurrentCamera.ViewportSize
            tw(win,{Size=UDim2.new(0,vp.X,0,vp.Y),Position=UDim2.new(0,0,0,0)},ANIM_MED)
        else
            tw(win,{Size=prevSize,Position=prevPos},ANIM_MED)
        end
    end)

    UserInputService.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.KeyCode==toggleKey then
            visible=not visible
            if visible then
                win.Visible=true
                tw(win,{Size=minimized and UDim2.new(0,win.Size.X.Offset,0,TOPBAR_H) or prevSize},ANIM_MED)
            else
                tw(win,{Size=UDim2.new(0,win.Size.X.Offset,0,0)},ANIM_FAST)
                task.wait(ANIM_FAST+0.05); win.Visible=false
            end
        end
    end)

    local Window = {}
    local tabs   = {}
    local active = nil

    local function setActive(page, entry)
        if active then active.page.Visible=false end
        active = entry
        page.Visible = true
        for _,t in ipairs(tabs) do
            local isActive = t==entry
            tw(t.btn,{BackgroundColor3=isActive and theme.TabActive or theme.TabInactive},ANIM_FAST)
            t.accent.Visible      = isActive
            t.titleLbl.TextColor3 = isActive and theme.TextPrimary or theme.TextSecondary
            if t.iconLbl then t.iconLbl.TextColor3=isActive and theme.Accent or theme.TextDisabled end
        end
    end

    function Window:Tab(cfg)
        cfg = cfg or {}
        local tabTitle = cfg.Title or "Tab"
        local tabIcon  = cfg.Icon

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size             = UDim2.new(1,0,0,34)
        tabBtn.BackgroundColor3 = theme.TabInactive
        tabBtn.Text             = ""
        tabBtn.BorderSizePixel  = 0
        tabBtn.AutoButtonColor  = false
        tabBtn.ZIndex           = 4
        tabBtn.Parent           = tabScroll
        corner(tabBtn, UDim.new(0,6))

        local accentBar = frame(tabBtn, theme.TabStroke, UDim2.new(0,3,0.55,0))
        accentBar.Position = UDim2.new(0,0,0.225,0)
        accentBar.Visible  = false
        accentBar.ZIndex   = 5
        corner(accentBar, UDim.new(0,2))

        local rowLay = Instance.new("UIListLayout")
        rowLay.FillDirection     = Enum.FillDirection.Horizontal
        rowLay.VerticalAlignment = Enum.VerticalAlignment.Center
        rowLay.Padding           = UDim.new(0,7)
        rowLay.Parent            = tabBtn
        pad(tabBtn,0,0,12,8)

        local iconLbl = nil
        if tabIcon then
            iconLbl = lbl(tabBtn, tabIcon, theme.TextDisabled, 12, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
            iconLbl.Size  = UDim2.new(0,14,1,0)
            iconLbl.ZIndex = 5
        end

        local titleLbl = lbl(tabBtn, tabTitle, theme.TextSecondary, 12, Enum.Font.GothamMedium)
        titleLbl.Size   = UDim2.new(1,-36,1,0)
        titleLbl.ZIndex = 5

        local page = Instance.new("ScrollingFrame")
        page.Size                   = UDim2.fromScale(1,1)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness     = 3
        page.ScrollBarImageColor3   = theme.ScrollBar
        page.CanvasSize             = UDim2.new(0,0,0,0)
        page.AutomaticCanvasSize    = Enum.AutomaticSize.Y
        page.BorderSizePixel        = 0
        page.Visible                = false
        page.Parent                 = content

        local pageLay = Instance.new("UIListLayout")
        pageLay.Padding             = UDim.new(0,ELEMENT_PAD)
        pageLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLay.Parent              = page
        pad(page,10,12,10,10)

        local entry = {btn=tabBtn,accent=accentBar,titleLbl=titleLbl,iconLbl=iconLbl,page=page}
        table.insert(tabs,entry)

        tabBtn.MouseEnter:Connect(function()
            if active==entry then return end
            tw(tabBtn,{BackgroundColor3=theme.TabHover},ANIM_FAST)
        end)
        tabBtn.MouseLeave:Connect(function()
            if active==entry then return end
            tw(tabBtn,{BackgroundColor3=theme.TabInactive},ANIM_FAST)
        end)
        tabBtn.MouseButton1Click:Connect(function()
            setActive(page,entry)
        end)

        if #tabs==1 then setActive(page,entry) end

        local Tab = {}
        Tab._theme = theme
        Tab._page  = page
        Tab._gui   = gui
        function Tab:_addElement(e) e.Parent=page end
        injectElements(Tab,theme,page)
        return Tab
    end

    function Window:Notify(cfg)
        doNotify(cfg,theme)
    end

    function Window:SetTheme(t)
        theme = type(t)=="string" and (Themes[t] or Themes.Default) or t
    end

    function Window:Destroy()
        tw(win,{Size=UDim2.new(0,win.Size.X.Offset,0,0)},ANIM_FAST)
        task.wait(ANIM_FAST+0.05); gui:Destroy()
    end

    function Window:Toggle()
        visible=not visible; win.Visible=visible
    end

    function Window:GetThemes()
        return Themes
    end

    return Window
end

TryxLib.Themes = Themes

function TryxLib:Notify(cfg)
    doNotify(cfg, Themes.Default)
end

return TryxLib
