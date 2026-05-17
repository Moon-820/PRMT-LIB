-- TryxLib | dist/main.lua
-- Version compilée — loadstring(game:HttpGet("URL"))()
-- © TryxHub — Moon820

local TryxLib = {}
TryxLib.__index = TryxLib

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer

-- ══════════════════════════════════════════════════════
--  THEME
-- ══════════════════════════════════════════════════════
local DefaultTheme = {
    Background      = Color3.fromRGB(10, 10, 10),
    Sidebar         = Color3.fromRGB(15, 15, 15),
    TopBar          = Color3.fromRGB(12, 12, 12),
    Element         = Color3.fromRGB(20, 20, 20),
    ElementHover    = Color3.fromRGB(28, 28, 28),
    ElementStroke   = Color3.fromRGB(35, 35, 35),
    Accent          = Color3.fromRGB(220, 180, 60),
    AccentDark      = Color3.fromRGB(160, 130, 40),
    TextPrimary     = Color3.fromRGB(240, 240, 240),
    TextSecondary   = Color3.fromRGB(140, 140, 140),
    TextDisabled    = Color3.fromRGB(70, 70, 70),
    TabActive       = Color3.fromRGB(22, 22, 22),
    TabInactive     = Color3.fromRGB(15, 15, 15),
    TabStroke       = Color3.fromRGB(220, 180, 60),
    Notify          = Color3.fromRGB(18, 18, 18),
    NotifyStroke    = Color3.fromRGB(40, 40, 40),
    ScrollBar       = Color3.fromRGB(40, 40, 40),
    Danger          = Color3.fromRGB(200, 60, 60),
    Success         = Color3.fromRGB(60, 180, 100),
    Warning         = Color3.fromRGB(220, 160, 40),
}

-- ══════════════════════════════════════════════════════
--  CONSTANTES
-- ══════════════════════════════════════════════════════
local SIDEBAR_W  = 160
local TOPBAR_H   = 42
local MIN_W      = 480
local MIN_H      = 320
local DEFAULT_W  = 620
local DEFAULT_H  = 420
local ELEMENT_H  = 44
local ELEMENT_PAD = 6
local ANIM       = 0.14

-- ══════════════════════════════════════════════════════
--  UTILS
-- ══════════════════════════════════════════════════════
local function tw(obj, props, t)
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
    s.Color = col or DefaultTheme.ElementStroke
    s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 6)
    u.PaddingBottom = UDim.new(0, b or 6)
    u.PaddingLeft   = UDim.new(0, l or 12)
    u.PaddingRight  = UDim.new(0, r or 12)
    u.Parent = p
end

local function frame(parent, bg, size, pos)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or DefaultTheme.Background
    f.Size             = size or UDim2.fromScale(1, 1)
    f.Position         = pos or UDim2.new(0,0,0,0)
    f.BorderSizePixel  = 0
    f.Parent           = parent
    return f
end

local function lbl(parent, text, col, size, font)
    local l = Instance.new("TextLabel")
    l.Text             = text or ""
    l.TextColor3       = col  or DefaultTheme.TextPrimary
    l.TextSize         = size or 13
    l.Font             = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment   = Enum.TextXAlignment.Left
    l.TextTruncate     = Enum.TextTruncate.AtEnd
    l.Parent           = parent
    return l
end

local function baseEl(theme, h)
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, h or ELEMENT_H)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel  = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    return f
end

local function titleDesc(parent, theme, title, desc, offsetR)
    offsetR = offsetR or 0
    local t = lbl(parent, title, theme.TextPrimary, 13, Enum.Font.GothamMedium)
    t.Size     = UDim2.new(1, -offsetR, 0, 16)
    t.Position = UDim2.new(0, 0, 0, desc ~= "" and 10 or 0)
    if desc and desc ~= "" then
        local d = lbl(parent, desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        d.Size     = UDim2.new(1, -offsetR, 0, 14)
        d.Position = UDim2.new(0, 0, 0, 27)
        d.TextTruncate = Enum.TextTruncate.AtEnd
    end
end

-- ══════════════════════════════════════════════════════
--  DRAG + RESIZE
-- ══════════════════════════════════════════════════════
local function makeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = i.Position; startPos = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

local function makeResizable(handle, target)
    local resizing, resizeStart, startSize = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true; resizeStart = i.Position; startSize = target.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - resizeStart
            target.Size = UDim2.new(0, math.max(MIN_W, startSize.X.Offset + d.X), 0, math.max(MIN_H, startSize.Y.Offset + d.Y))
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
    end)
end

-- ══════════════════════════════════════════════════════
--  NOTIFY
-- ══════════════════════════════════════════════════════
local notifyActive = 0
local MAX_NOTIF    = 4

local typeColors = {
    success = Color3.fromRGB(60, 180, 100),
    error   = Color3.fromRGB(200, 60, 60),
    warn    = Color3.fromRGB(220, 160, 40),
    info    = Color3.fromRGB(80, 140, 220),
}
local typeIcons = { success = "✓", error = "✕", warn = "!", info = "i" }

local function doNotify(gui, cfg, theme)
    if notifyActive >= MAX_NOTIF then return end
    notifyActive += 1

    local title    = cfg.Title    or ""
    local desc     = cfg.Desc     or cfg.Content or ""
    local ntype    = cfg.Type     or "info"
    local duration = cfg.Duration or 4
    local accent   = typeColors[ntype] or theme.Accent
    local icon     = typeIcons[ntype]  or "i"

    local container = gui:FindFirstChild("__NotifyContainer")
    if not container then
        container = frame(gui, Color3.fromRGB(0,0,0), UDim2.new(0, 290, 1, 0), UDim2.new(1, -302, 0, 0))
        container.Name = "__NotifyContainer"
        container.BackgroundTransparency = 1
        container.ZIndex = 100
        local lay = Instance.new("UIListLayout")
        lay.VerticalAlignment   = Enum.VerticalAlignment.Bottom
        lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
        lay.Padding             = UDim.new(0, 6)
        lay.Parent              = container
        local p = Instance.new("UIPadding")
        p.PaddingBottom = UDim.new(0, 14)
        p.PaddingRight  = UDim.new(0, 0)
        p.Parent        = container
    end

    local n = frame(container, theme.Notify, UDim2.new(1, 0, 0, 0))
    n.ZIndex = 101
    n.ClipsDescendants = true
    corner(n, UDim.new(0, 8))
    stroke(n, theme.NotifyStroke, 1)

    -- Barre accent
    local bar = frame(n, accent, UDim2.new(0, 3, 1, 0))
    corner(bar, UDim.new(0, 2))

    -- Icon
    local ic = frame(n, accent, UDim2.new(0, 28, 0, 28))
    ic.Position = UDim2.new(0, 14, 0.5, -14)
    ic.ZIndex = 102
    corner(ic, UDim.new(1, 0))
    local il = lbl(ic, icon, Color3.fromRGB(255,255,255), 13, Enum.Font.GothamBold)
    il.Size = UDim2.fromScale(1,1)
    il.TextXAlignment = Enum.TextXAlignment.Center
    il.ZIndex = 103

    -- Textes
    local tl = lbl(n, title, Color3.fromRGB(240,240,240), 13, Enum.Font.GothamBold)
    tl.Size = UDim2.new(1, -58, 0, 18)
    tl.Position = UDim2.new(0, 50, 0, 10)
    tl.ZIndex = 102

    local dl = lbl(n, desc, Color3.fromRGB(140,140,140), 11, Enum.Font.Gotham)
    dl.Size = UDim2.new(1, -58, 0, 16)
    dl.Position = UDim2.new(0, 50, 0, 29)
    dl.ZIndex = 102

    -- Progress
    local prog = frame(n, accent, UDim2.new(1, 0, 0, 2))
    prog.Position = UDim2.new(0, 0, 1, -2)
    prog.ZIndex = 103

    -- Apparition
    tw(n, { Size = UDim2.new(1, 0, 0, 64) }, 0.18)
    tw(prog, { Size = UDim2.new(0, 0, 0, 2) }, duration)

    local function dismiss()
        tw(n, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
        task.wait(0.15)
        n:Destroy()
        notifyActive = math.max(0, notifyActive - 1)
    end

    task.delay(duration, dismiss)

    local cb = Instance.new("TextButton")
    cb.Size = UDim2.fromScale(1,1)
    cb.BackgroundTransparency = 1
    cb.Text = ""
    cb.ZIndex = 104
    cb.Parent = n
    cb.MouseButton1Click:Connect(dismiss)
end

-- ══════════════════════════════════════════════════════
--  ELEMENTS
-- ══════════════════════════════════════════════════════
local function injectElements(Tab, theme, page)

    function Tab:Button(cfg)
        cfg = cfg or {}
        local f = baseEl(theme)
        pad(f, 0, 0, 12, 12)
        titleDesc(f, theme, cfg.Title or "Button", cfg.Desc or "", 32)

        local arr = lbl(f, "›", theme.Accent, 20, Enum.Font.GothamBold)
        arr.Size = UDim2.new(0, 20, 1, 0)
        arr.Position = UDim2.new(1, -26, 0, 0)
        arr.TextXAlignment = Enum.TextXAlignment.Center

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromScale(1,1)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 2
        btn.Parent = f

        btn.MouseEnter:Connect(function() tw(f, { BackgroundColor3 = theme.ElementHover }) end)
        btn.MouseLeave:Connect(function() tw(f, { BackgroundColor3 = theme.Element }) end)
        btn.MouseButton1Down:Connect(function() tw(f, { BackgroundColor3 = theme.AccentDark }) end)
        btn.MouseButton1Up:Connect(function() tw(f, { BackgroundColor3 = theme.ElementHover }) end)
        btn.MouseButton1Click:Connect(function() pcall(cfg.Callback or function() end) end)

        f.Parent = page
        return f
    end

    function Tab:Toggle(cfg)
        cfg = cfg or {}
        local value = cfg.Value ~= nil and cfg.Value or false
        local f = baseEl(theme)
        pad(f, 0, 0, 12, 12)
        titleDesc(f, theme, cfg.Title or "Toggle", cfg.Desc or "", 52)

        local track = frame(f, value and theme.Accent or theme.ElementStroke, UDim2.new(0,36,0,20))
        track.Position = UDim2.new(1,-46,0.5,-10)
        corner(track, UDim.new(1,0))

        local thumb = frame(track, Color3.fromRGB(255,255,255), UDim2.new(0,14,0,14))
        thumb.Position = value and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
        corner(thumb, UDim.new(1,0))

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromScale(1,1)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 2
        btn.Parent = f

        btn.MouseEnter:Connect(function() tw(f, { BackgroundColor3 = theme.ElementHover }) end)
        btn.MouseLeave:Connect(function() tw(f, { BackgroundColor3 = theme.Element }) end)
        btn.MouseButton1Click:Connect(function()
            value = not value
            tw(track, { BackgroundColor3 = value and theme.Accent or theme.ElementStroke })
            tw(thumb, { Position = value and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) })
            pcall(cfg.Callback or function() end, value)
        end)

        f.Parent = page

        local obj = {}
        function obj:Set(v)
            value = v
            tw(track, { BackgroundColor3 = value and theme.Accent or theme.ElementStroke })
            tw(thumb, { Position = value and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7) })
            pcall(cfg.Callback or function() end, value)
        end
        function obj:Get() return value end
        return obj
    end

    function Tab:Input(cfg)
        cfg = cfg or {}
        local f = baseEl(theme, 70)
        pad(f, 8, 8, 12, 12)

        local tl = lbl(f, cfg.Title or "Input", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        tl.Size = UDim2.new(1,0,0,16)
        tl.Position = UDim2.new(0,0,0,0)

        local box = frame(f, theme.Background, UDim2.new(1,0,0,28))
        box.Position = UDim2.new(0,0,0,22)
        corner(box, UDim.new(0,5))
        stroke(box, theme.ElementStroke, 1)

        local inp = Instance.new("TextBox")
        inp.Size = UDim2.new(1,-12,1,0)
        inp.Position = UDim2.new(0,6,0,0)
        inp.BackgroundTransparency = 1
        inp.Text = cfg.Value or ""
        inp.PlaceholderText = cfg.Placeholder or "Type here..."
        inp.TextColor3 = theme.TextPrimary
        inp.PlaceholderColor3 = theme.TextDisabled
        inp.TextSize = 12
        inp.Font = Enum.Font.Gotham
        inp.TextXAlignment = Enum.TextXAlignment.Left
        inp.ClearTextOnFocus = false
        inp.Parent = box

        inp.Focused:Connect(function()
            tw(box, { BackgroundColor3 = theme.ElementHover })
        end)
        inp.FocusLost:Connect(function(enter)
            tw(box, { BackgroundColor3 = theme.Background })
            if enter then pcall(cfg.Callback or function() end, inp.Text) end
        end)
        inp:GetPropertyChangedSignal("Text"):Connect(function()
            pcall(cfg.Callback or function() end, inp.Text)
        end)

        f.Parent = page

        local obj = {}
        function obj:Get() return inp.Text end
        function obj:Set(v) inp.Text = v end
        return obj
    end

    function Tab:Slider(cfg)
        cfg = cfg or {}
        local min   = cfg.Min    or 0
        local max   = cfg.Max    or 100
        local value = cfg.Value  or min
        local suffix = cfg.Suffix or ""

        local f = baseEl(theme, 60)
        pad(f, 0, 0, 12, 12)

        local vl = lbl(f, tostring(value)..suffix, theme.Accent, 12, Enum.Font.GothamBold)
        vl.Size = UDim2.new(0,50,0,16)
        vl.Position = UDim2.new(1,-54,0,10)
        vl.TextXAlignment = Enum.TextXAlignment.Right

        local tl = lbl(f, cfg.Title or "Slider", theme.TextPrimary, 13, Enum.Font.GothamMedium)
        tl.Size = UDim2.new(1,-60,0,16)
        tl.Position = UDim2.new(0,0,0,10)

        local track = frame(f, theme.ElementStroke, UDim2.new(1,0,0,6))
        track.Position = UDim2.new(0,0,0,36)
        corner(track, UDim.new(1,0))

        local fill = frame(track, theme.Accent, UDim2.new((value-min)/(max-min),0,1,0))
        corner(fill, UDim.new(1,0))

        local thumb = frame(track, Color3.fromRGB(255,255,255), UDim2.new(0,14,0,14))
        thumb.AnchorPoint = Vector2.new(0.5,0.5)
        thumb.Position = UDim2.new((value-min)/(max-min),0,0.5,0)
        thumb.ZIndex = 3
        corner(thumb, UDim.new(1,0))

        local dragging = false
        local function update(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            value = math.floor(min + rel*(max-min) + 0.5)
            local pct = (value-min)/(max-min)
            tw(fill, { Size = UDim2.new(pct,0,1,0) }, 0.05)
            tw(thumb, { Position = UDim2.new(pct,0,0.5,0) }, 0.05)
            vl.Text = tostring(value)..suffix
            pcall(cfg.Callback or function() end, value)
        end

        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true update(i.Position.X) end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i.Position.X) end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
        end)

        f.Parent = page

        local obj = {}
        function obj:Get() return value end
        function obj:Set(v)
            value = math.clamp(v,min,max)
            local pct = (value-min)/(max-min)
            tw(fill, { Size = UDim2.new(pct,0,1,0) })
            tw(thumb, { Position = UDim2.new(pct,0,0.5,0) })
            vl.Text = tostring(value)..suffix
        end
        return obj
    end

    function Tab:Dropdown(cfg)
        cfg = cfg or {}
        local values = cfg.Values or {}
        local value  = cfg.Value  or (values[1] or "")
        local open   = false

        local f = Instance.new("Frame")
        f.Size = UDim2.new(1,0,0,ELEMENT_H)
        f.BackgroundColor3 = theme.Element
        f.BorderSizePixel = 0
        f.ClipsDescendants = false
        corner(f)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 0, 0, 12, 12)

        titleDesc(f, theme, cfg.Title or "Dropdown", cfg.Desc or "", 110)

        local selBox = frame(f, theme.Background, UDim2.new(0,100,0,26))
        selBox.Position = UDim2.new(1,-108,0.5,-13)
        corner(selBox, UDim.new(0,5))
        stroke(selBox, theme.ElementStroke, 1)

        local selLbl = lbl(selBox, value, theme.TextPrimary, 12, Enum.Font.Gotham)
        selLbl.Size = UDim2.new(1,-22,1,0)
        selLbl.Position = UDim2.new(0,8,0,0)
        selLbl.TextTruncate = Enum.TextTruncate.AtEnd

        local chev = lbl(selBox, "v", theme.TextSecondary, 10, Enum.Font.GothamBold)
        chev.Size = UDim2.new(0,18,1,0)
        chev.Position = UDim2.new(1,-20,0,0)
        chev.TextXAlignment = Enum.TextXAlignment.Center

        local list = frame(f, theme.Element, UDim2.new(0,100,0,0))
        list.Position = UDim2.new(1,-108,0,ELEMENT_H+2)
        list.ClipsDescendants = true
        list.ZIndex = 10
        corner(list)
        stroke(list, theme.ElementStroke, 1)

        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0,2)
        lay.Parent = list
        pad(list, 4,4,4,4)

        local function build()
            for _, c in ipairs(list:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            for _, v in ipairs(values) do
                local item = Instance.new("TextButton")
                item.Size = UDim2.new(1,0,0,26)
                item.BackgroundColor3 = v==value and theme.ElementHover or theme.Element
                item.Text = v
                item.TextColor3 = v==value and theme.Accent or theme.TextPrimary
                item.TextSize = 12
                item.Font = Enum.Font.Gotham
                item.TextXAlignment = Enum.TextXAlignment.Left
                item.BorderSizePixel = 0
                item.AutoButtonColor = false
                item.ZIndex = 11
                corner(item, UDim.new(0,4))
                pad(item,0,0,8,8)
                item.Parent = list
                item.MouseEnter:Connect(function() tw(item,{BackgroundColor3=theme.ElementHover},0.08) end)
                item.MouseLeave:Connect(function() tw(item,{BackgroundColor3=v==value and theme.ElementHover or theme.Element},0.08) end)
                item.MouseButton1Click:Connect(function()
                    value = v; selLbl.Text = v; open = false
                    tw(list,{Size=UDim2.new(0,100,0,0)}); tw(chev,{Rotation=0})
                    build(); pcall(cfg.Callback or function() end, value)
                end)
            end
        end
        build()

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,ELEMENT_H)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.ZIndex = 2
        btn.Parent = f

        btn.MouseEnter:Connect(function() tw(f,{BackgroundColor3=theme.ElementHover}) end)
        btn.MouseLeave:Connect(function() tw(f,{BackgroundColor3=theme.Element}) end)
        btn.MouseButton1Click:Connect(function()
            open = not open
            tw(list,{Size=UDim2.new(0,100,0,open and #values*28+8 or 0)})
            tw(chev,{Rotation=open and 180 or 0})
        end)

        f.Parent = page

        local obj = {}
        function obj:Get() return value end
        function obj:Set(v) value=v; selLbl.Text=v; build() end
        function obj:Refresh(newVals) values=newVals; build() end
        return obj
    end

    function Tab:Paragraph(cfg)
        cfg = cfg or {}
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1,0,0,0)
        f.AutomaticSize = Enum.AutomaticSize.Y
        f.BackgroundColor3 = theme.Element
        f.BorderSizePixel = 0
        corner(f); stroke(f, theme.ElementStroke, 1)
        pad(f,10,10,12,12)

        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0,4)
        lay.Parent = f

        if cfg.Title and cfg.Title ~= "" then
            local t = lbl(f, cfg.Title, theme.TextPrimary, 13, Enum.Font.GothamBold)
            t.Size = UDim2.new(1,0,0,0)
            t.AutomaticSize = Enum.AutomaticSize.Y
            t.TextWrapped = true
        end
        if cfg.Desc and cfg.Desc ~= "" then
            local d = lbl(f, cfg.Desc, theme.TextSecondary, 12, Enum.Font.Gotham)
            d.Size = UDim2.new(1,0,0,0)
            d.AutomaticSize = Enum.AutomaticSize.Y
            d.TextWrapped = true
        end

        f.Parent = page
        return f
    end

    function Tab:Divider(cfg)
        cfg = cfg or {}
        local f = frame(page, Color3.fromRGB(0,0,0), UDim2.new(1,0,0,18))
        f.BackgroundTransparency = 1

        local line = frame(f, theme.ElementStroke, UDim2.new(1,0,0,1))
        line.Position = UDim2.new(0,0,0.5,0)

        if cfg.Label and cfg.Label ~= "" then
            local lbg = frame(f, theme.Background, UDim2.new(0,0,1,0))
            lbg.AutomaticSize = Enum.AutomaticSize.X
            lbg.AnchorPoint = Vector2.new(0.5,0)
            lbg.Position = UDim2.new(0.5,0,0,0)
            lbg.BorderSizePixel = 0
            local ll = lbl(lbg, "  "..cfg.Label.."  ", theme.TextDisabled, 11, Enum.Font.Gotham)
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
end

-- ══════════════════════════════════════════════════════
--  CREATE WINDOW
-- ══════════════════════════════════════════════════════
function TryxLib:CreateWindow(config)
    config = config or {}
    local theme = config.Theme or DefaultTheme
    local title = config.Title or "TryxLib"

    local gui = Instance.new("ScreenGui")
    gui.Name = "TryxLib"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 999
    gui.IgnoreGuiInset = true
    gui.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

    -- Fenetre
    local win = frame(gui, theme.Background, UDim2.new(0,DEFAULT_W,0,0))
    win.Name = "Window"
    win.Position = UDim2.new(0.5,-DEFAULT_W/2,0.5,-DEFAULT_H/2)
    win.ClipsDescendants = true
    corner(win, UDim.new(0,10))
    stroke(win, theme.ElementStroke, 1)

    -- Ombre
    local sh = Instance.new("ImageLabel")
    sh.Size = UDim2.new(1,30,1,30)
    sh.Position = UDim2.new(0,-15,0,-15)
    sh.BackgroundTransparency = 1
    sh.Image = "rbxassetid://6014261993"
    sh.ImageColor3 = Color3.fromRGB(0,0,0)
    sh.ImageTransparency = 0.55
    sh.ScaleType = Enum.ScaleType.Slice
    sh.SliceCenter = Rect.new(49,49,450,450)
    sh.ZIndex = 0
    sh.Parent = win

    -- TopBar
    local topBar = frame(win, theme.TopBar, UDim2.new(1,0,0,TOPBAR_H))
    topBar.Name = "TopBar"
    topBar.ZIndex = 3

    local topLayout = Instance.new("UIListLayout")
    topLayout.FillDirection = Enum.FillDirection.Horizontal
    topLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    topLayout.Padding = UDim.new(0,8)
    topLayout.Parent = topBar
    pad(topBar,0,0,14,14)

    local iconLbl = lbl(topBar, config.Icon or "★", theme.Accent, 14, Enum.Font.GothamBold)
    iconLbl.Size = UDim2.new(0,16,1,0)
    iconLbl.TextXAlignment = Enum.TextXAlignment.Center

    local titleLbl = lbl(topBar, title, theme.TextPrimary, 13, Enum.Font.GothamBold)
    titleLbl.Size = UDim2.new(1,-90,1,0)

    local btnCont = frame(topBar, Color3.fromRGB(0,0,0), UDim2.new(0,52,1,0))
    btnCont.BackgroundTransparency = 1
    local btnLay = Instance.new("UIListLayout")
    btnLay.FillDirection = Enum.FillDirection.Horizontal
    btnLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLay.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLay.Padding = UDim.new(0,6)
    btnLay.Parent = btnCont

    local function winBtn(col)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0,12,0,12)
        b.BackgroundColor3 = col
        b.Text = ""
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Parent = btnCont
        corner(b, UDim.new(1,0))
        return b
    end
    local closeBtn = winBtn(theme.Danger)
    local minBtn   = winBtn(theme.Warning)

    -- Sidebar
    local sidebar = frame(win, theme.Sidebar, UDim2.new(0,SIDEBAR_W,1,-TOPBAR_H), UDim2.new(0,0,0,TOPBAR_H))
    sidebar.Name = "Sidebar"
    sidebar.ZIndex = 2

    local sideLine = frame(sidebar, theme.ElementStroke, UDim2.new(0,1,1,0))
    sideLine.Position = UDim2.new(1,0,0,0)

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size = UDim2.new(1,0,1,-10)
    tabScroll.Position = UDim2.new(0,0,0,8)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness = 0
    tabScroll.CanvasSize = UDim2.new(0,0,0,0)
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScroll.BorderSizePixel = 0
    tabScroll.Parent = sidebar

    local tabLay = Instance.new("UIListLayout")
    tabLay.Padding = UDim.new(0,3)
    tabLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLay.Parent = tabScroll
    pad(tabScroll,4,4,6,6)

    -- Content
    local content = frame(win, theme.Background,
        UDim2.new(1,-SIDEBAR_W,1,-TOPBAR_H),
        UDim2.new(0,SIDEBAR_W,0,TOPBAR_H)
    )
    content.Name = "Content"
    content.ClipsDescendants = true

    -- Resize handle
    local resizeH = Instance.new("TextButton")
    resizeH.Size = UDim2.new(0,14,0,14)
    resizeH.Position = UDim2.new(1,-14,1,-14)
    resizeH.BackgroundColor3 = theme.ElementStroke
    resizeH.Text = ""
    resizeH.BorderSizePixel = 0
    resizeH.AutoButtonColor = false
    resizeH.ZIndex = 10
    resizeH.Parent = win
    corner(resizeH, UDim.new(0,3))
    for i=1,3 do
        local d = frame(resizeH, theme.TextDisabled, UDim2.new(0,2,0,2))
        d.Position = UDim2.new(0,2+(i-1)*4,0,8)
        d.ZIndex = 11
        corner(d, UDim.new(1,0))
    end

    makeDraggable(topBar, win)
    makeResizable(resizeH, win)

    -- Minimize
    local minimized, prevSize = false, nil
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            prevSize = win.Size
            tw(win, { Size = UDim2.new(0, win.Size.X.Offset, 0, TOPBAR_H) }, 0.2)
            content.Visible = false; sidebar.Visible = false; resizeH.Visible = false
        else
            tw(win, { Size = prevSize }, 0.2)
            content.Visible = true; sidebar.Visible = true; resizeH.Visible = true
        end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tw(win, { Size = UDim2.new(0,win.Size.X.Offset,0,0) }, 0.15)
        task.wait(0.15); gui:Destroy()
    end)

    -- Apparition
    tw(win, { Size = UDim2.new(0,DEFAULT_W,0,DEFAULT_H) }, 0.25)

    -- ── Window object ──
    local Window  = {}
    local tabs    = {}
    local activePage = nil

    local function setActive(page, tabBtn, accentBar, titleL)
        if activePage then activePage.Visible = false end
        activePage = page
        page.Visible = true
        for _, t in ipairs(tabs) do
            local active = t.btn == tabBtn
            tw(t.btn, { BackgroundColor3 = active and theme.TabActive or theme.TabInactive }, 0.12)
            t.accent.Visible = active
            t.title.TextColor3 = active and theme.TextPrimary or theme.TextSecondary
        end
    end

    function Window:Tab(cfg)
        cfg = cfg or {}
        local tabTitle = cfg.Title or "Tab"

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1,0,0,36)
        tabBtn.BackgroundColor3 = theme.TabInactive
        tabBtn.Text = ""
        tabBtn.BorderSizePixel = 0
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabScroll
        corner(tabBtn, UDim.new(0,6))

        local accentBar = frame(tabBtn, theme.Accent, UDim2.new(0,3,0.6,0))
        accentBar.Position = UDim2.new(0,0,0.2,0)
        accentBar.Visible = false
        corner(accentBar, UDim.new(0,2))

        local rowLay = Instance.new("UIListLayout")
        rowLay.FillDirection = Enum.FillDirection.Horizontal
        rowLay.VerticalAlignment = Enum.VerticalAlignment.Center
        rowLay.Padding = UDim.new(0,7)
        rowLay.Parent = tabBtn
        pad(tabBtn,0,0,12,8)

        if cfg.Icon then
            local ic = lbl(tabBtn, cfg.Icon, theme.Accent, 12, Enum.Font.GothamMedium)
            ic.Size = UDim2.new(0,14,1,0)
            ic.TextXAlignment = Enum.TextXAlignment.Center
        end

        local titleL = lbl(tabBtn, tabTitle, theme.TextSecondary, 12, Enum.Font.GothamMedium)
        titleL.Size = UDim2.new(1,-30,1,0)

        -- Page
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.fromScale(1,1)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = theme.ScrollBar
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.BorderSizePixel = 0
        page.Visible = false
        page.Parent = content

        local pageLay = Instance.new("UIListLayout")
        pageLay.Padding = UDim.new(0,ELEMENT_PAD)
        pageLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLay.Parent = page
        pad(page,10,10,10,10)

        local entry = { btn=tabBtn, accent=accentBar, title=titleL, page=page }
        table.insert(tabs, entry)

        tabBtn.MouseEnter:Connect(function()
            if not accentBar.Visible then tw(tabBtn,{BackgroundColor3=theme.ElementHover},0.1) end
        end)
        tabBtn.MouseLeave:Connect(function()
            if not accentBar.Visible then tw(tabBtn,{BackgroundColor3=theme.TabInactive},0.1) end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            setActive(page, tabBtn, accentBar, titleL)
        end)

        if #tabs == 1 then setActive(page, tabBtn, accentBar, titleL) end

        local Tab = {}
        Tab._theme = theme
        Tab._page  = page
        function Tab:_addElement(e) e.Parent = page end
        injectElements(Tab, theme, page)

        return Tab
    end

    function Window:Notify(cfg)
        doNotify(gui, cfg, theme)
    end

    function Window:Destroy()
        gui:Destroy()
    end

    function Window:SetTheme(newTheme)
        -- Pour les updates de thème futures
    end

    return Window
end

return TryxLib
