local TryxLib = {}
TryxLib.__index = TryxLib

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer

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

local SIDEBAR_W   = 150
local TOPBAR_H    = 38
local MIN_W       = 460
local MIN_H       = 300
local DEFAULT_W   = 580
local DEFAULT_H   = 400
local ELEMENT_H   = 44
local ELEMENT_PAD = 6
local ANIM        = 0.14

local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or ANIM, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 8)
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
    f.Position         = pos or UDim2.new(0, 0, 0, 0)
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

local function baseEl(theme, h, cfg)
    cfg = cfg or {}
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, h or ELEMENT_H)
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel  = 0
    corner(f, cfg.CornerRadius)
    stroke(f, theme.ElementStroke, 1)
    return f
end

local function titleDesc(parent, theme, title, desc, offsetR)
    offsetR = offsetR or 0
    local hasDesc = desc and desc ~= ""

    local t = lbl(parent, title, theme.TextPrimary, 13, Enum.Font.GothamMedium)
    t.Size     = UDim2.new(1, -offsetR, 0, 16)
    t.Position = UDim2.new(0, 0, 0, hasDesc and 10 or 0)

    if hasDesc then
        local d = lbl(parent, desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        d.Size     = UDim2.new(1, -offsetR, 0, 14)
        d.Position = UDim2.new(0, 0, 0, 27)
        d.TextTruncate = Enum.TextTruncate.AtEnd
    end
end

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
        container = frame(gui, Color3.fromRGB(0, 0, 0), UDim2.new(0, 280, 1, 0), UDim2.new(1, -292, 0, 0))
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
        p.Parent        = container
    end

    local n = frame(container, theme.Notify, UDim2.new(1, 0, 0, 0))
    n.ZIndex = 101
    n.ClipsDescendants = true
    corner(n, UDim.new(0, 8))
    stroke(n, theme.NotifyStroke, 1)

    local bar = frame(n, accent, UDim2.new(0, 3, 1, 0))
    corner(bar, UDim.new(0, 2))

    local ic = frame(n, accent, UDim2.new(0, 26, 0, 26))
    ic.Position = UDim2.new(0, 12, 0.5, -13)
    ic.ZIndex = 102
    corner(ic, UDim.new(1, 0))
    local il = lbl(ic, icon, Color3.fromRGB(255, 255, 255), 12, Enum.Font.GothamBold)
    il.Size = UDim2.fromScale(1, 1)
    il.TextXAlignment = Enum.TextXAlignment.Center
    il.ZIndex = 103

    local tl = lbl(n, title, Color3.fromRGB(240, 240, 240), 13, Enum.Font.GothamBold)
    tl.Size = UDim2.new(1, -54, 0, 18)
    tl.Position = UDim2.new(0, 48, 0, 10)
    tl.ZIndex = 102

    local dl = lbl(n, desc, Color3.fromRGB(140, 140, 140), 11, Enum.Font.Gotham)
    dl.Size = UDim2.new(1, -54, 0, 16)
    dl.Position = UDim2.new(0, 48, 0, 29)
    dl.ZIndex = 102

    local prog = frame(n, accent, UDim2.new(1, 0, 0, 2))
    prog.Position = UDim2.new(0, 0, 1, -2)
    prog.ZIndex = 103

    tw(n, { Size = UDim2.new(1, 0, 0, 60) }, 0.18)
    tw(prog, { Size = UDim2.new(0, 0, 0, 2) }, duration)

    local function dismiss()
        tw(n, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
        task.wait(0.15)
        n:Destroy()
        notifyActive = math.max(0, notifyActive - 1)
    end

    task.delay(duration, dismiss)

    local cb = Instance.new("TextButton")
    cb.Size = UDim2.fromScale(1, 1)
    cb.BackgroundTransparency = 1
    cb.Text = ""
    cb.ZIndex = 104
    cb.Parent = n
    cb.MouseButton1Click:Connect(dismiss)
end

local TryxLib = require("./Elements")

function TryxLib:CreateWindow(config)
    config = config or {}
    local theme    = config.Theme    or DefaultTheme
    local title    = config.Title    or "TryxLib"
    local subtitle = config.Subtitle or ""

    local gui = Instance.new("ScreenGui")
    gui.Name             = "TryxLib_" .. title:gsub("%s", "")
    gui.ResetOnSpawn     = false
    gui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder     = 999
    gui.IgnoreGuiInset   = true
    gui.Parent           = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

    local win = frame(gui, theme.Background, UDim2.new(0, DEFAULT_W, 0, 0))
    win.Name             = "Window"
    win.Position         = UDim2.new(0.5, -DEFAULT_W / 2, 0.5, -DEFAULT_H / 2)
    win.ClipsDescendants = true
    corner(win, UDim.new(0, 10))
    stroke(win, theme.ElementStroke, 1)

    local sh = Instance.new("ImageLabel")
    sh.Size               = UDim2.new(1, 35, 1, 35)
    sh.Position           = UDim2.new(0, -17, 0, -17)
    sh.BackgroundTransparency = 1
    sh.Image              = "rbxassetid://6014261993"
    sh.ImageColor3        = Color3.fromRGB(0, 0, 0)
    sh.ImageTransparency  = 0.5
    sh.ScaleType          = Enum.ScaleType.Slice
    sh.SliceCenter        = Rect.new(49, 49, 450, 450)
    sh.ZIndex             = 0
    sh.Parent             = win

    local topBar = frame(win, theme.TopBar, UDim2.new(1, 0, 0, TOPBAR_H))
    topBar.Name  = "TopBar"
    topBar.ZIndex = 3

    local topLayout = Instance.new("UIListLayout")
    topLayout.FillDirection    = Enum.FillDirection.Horizontal
    topLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    topLayout.Padding          = UDim.new(0, 6)
    topLayout.Parent           = topBar
    pad(topBar, 0, 0, 12, 12)

    local iconLbl = lbl(topBar, config.Icon or "★", theme.Accent, 13, Enum.Font.GothamBold)
    iconLbl.Size = UDim2.new(0, 14, 1, 0)
    iconLbl.TextXAlignment = Enum.TextXAlignment.Center

    local titleLbl = lbl(topBar, title, theme.TextPrimary, 12, Enum.Font.GothamBold)
    titleLbl.Size = UDim2.new(1, -80, 1, 0)

    local btnCont = frame(topBar, Color3.fromRGB(0, 0, 0), UDim2.new(0, 44, 1, 0))
    btnCont.BackgroundTransparency = 1
    local btnLay = Instance.new("UIListLayout")
    btnLay.FillDirection         = Enum.FillDirection.Horizontal
    btnLay.HorizontalAlignment   = Enum.HorizontalAlignment.Right
    btnLay.VerticalAlignment     = Enum.VerticalAlignment.Center
    btnLay.Padding               = UDim.new(0, 5)
    btnLay.Parent                = btnCont

    local function winBtn(col)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 11, 0, 11)
        b.BackgroundColor3 = col
        b.Text = ""
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Parent = btnCont
        corner(b, UDim.new(1, 0))
        return b
    end
    local closeBtn  = winBtn(theme.Danger)
    local minBtn    = winBtn(theme.Warning)

    local sidebar = frame(win, theme.Sidebar, UDim2.new(0, SIDEBAR_W, 1, -TOPBAR_H), UDim2.new(0, 0, 0, TOPBAR_H))
    sidebar.Name  = "Sidebar"
    sidebar.ZIndex = 2

    local sideLine = frame(sidebar, theme.ElementStroke, UDim2.new(0, 1, 1, 0))
    sideLine.Position = UDim2.new(1, 0, 0, 0)

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Size                 = UDim2.new(1, 0, 1, -10)
    tabScroll.Position             = UDim2.new(0, 0, 0, 8)
    tabScroll.BackgroundTransparency = 1
    tabScroll.ScrollBarThickness   = 0
    tabScroll.CanvasSize           = UDim2.new(0, 0, 0, 0)
    tabScroll.AutomaticCanvasSize  = Enum.AutomaticSize.Y
    tabScroll.BorderSizePixel      = 0
    tabScroll.Parent               = sidebar

    local tabLay = Instance.new("UIListLayout")
    tabLay.Padding              = UDim.new(0, 3)
    tabLay.HorizontalAlignment  = Enum.HorizontalAlignment.Center
    tabLay.Parent               = tabScroll
    pad(tabScroll, 4, 4, 6, 6)

    local content = frame(win, theme.Background,
        UDim2.new(1, -SIDEBAR_W, 1, -TOPBAR_H),
        UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)
    )
    content.Name             = "Content"
    content.ClipsDescendants = true

    local resizeH = Instance.new("TextButton")
    resizeH.Size             = UDim2.new(0, 16, 0, 16)
    resizeH.Position         = UDim2.new(1, -16, 1, -16)
    resizeH.BackgroundColor3 = theme.ElementStroke
    resizeH.Text             = ""
    resizeH.BorderSizePixel  = 0
    resizeH.AutoButtonColor  = false
    resizeH.ZIndex           = 10
    resizeH.Parent           = win
    corner(resizeH, UDim.new(0, 4))

    local gripLay = Instance.new("UIListLayout")
    gripLay.FillDirection  = Enum.FillDirection.Horizontal
    gripLay.Padding        = UDim.new(0, 2)
    gripLay.VerticalAlignment = Enum.VerticalAlignment.Center
    gripLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    gripLay.Parent         = resizeH

    for i = 1, 3 do
        local d = frame(resizeH, theme.TextDisabled, UDim2.new(0, 2, 0, 2))
        d.ZIndex = 11
        corner(d, UDim.new(1, 0))
    end

    makeDraggable(topBar, win)
    makeResizable(resizeH, win)

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
        tw(win, { Size = UDim2.new(0, win.Size.X.Offset, 0, 0) }, 0.15)
        task.wait(0.15); gui:Destroy()
    end)

    tw(win, { Size = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H) }, 0.25)

    local Window     = {}
    local tabs       = {}
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
        tabBtn.Size             = UDim2.new(1, 0, 0, 34)
        tabBtn.BackgroundColor3 = theme.TabInactive
        tabBtn.Text             = ""
        tabBtn.BorderSizePixel  = 0
        tabBtn.AutoButtonColor  = false
        tabBtn.Parent           = tabScroll
        corner(tabBtn, UDim.new(0, 6))

        local accentBar = frame(tabBtn, theme.Accent, UDim2.new(0, 3, 0.6, 0))
        accentBar.Position = UDim2.new(0, 0, 0.2, 0)
        accentBar.Visible  = false
        corner(accentBar, UDim.new(0, 2))

        local rowLay = Instance.new("UIListLayout")
        rowLay.FillDirection    = Enum.FillDirection.Horizontal
        rowLay.VerticalAlignment = Enum.VerticalAlignment.Center
        rowLay.Padding          = UDim.new(0, 6)
        rowLay.Parent           = tabBtn
        pad(tabBtn, 0, 0, 12, 8)

        if cfg.Icon then
            local ic = lbl(tabBtn, cfg.Icon, theme.Accent, 11, Enum.Font.GothamMedium)
            ic.Size = UDim2.new(0, 13, 1, 0)
            ic.TextXAlignment = Enum.TextXAlignment.Center
        end

        local titleL = lbl(tabBtn, tabTitle, theme.TextSecondary, 11, Enum.Font.GothamMedium)
        titleL.Size = UDim2.new(1, -30, 1, 0)

        local page = Instance.new("ScrollingFrame")
        page.Size                 = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness   = 3
        page.ScrollBarImageColor3 = theme.ScrollBar
        page.CanvasSize           = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize  = Enum.AutomaticSize.Y
        page.BorderSizePixel      = 0
        page.Visible              = false
        page.Parent               = content

        local pageLay = Instance.new("UIListLayout")
        pageLay.Padding             = UDim.new(0, ELEMENT_PAD)
        pageLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLay.Parent              = page
        pad(page, 10, 10, 10, 10)

        local entry = { btn = tabBtn, accent = accentBar, title = titleL, page = page }
        table.insert(tabs, entry)

        tabBtn.MouseEnter:Connect(function()
            if not accentBar.Visible then tw(tabBtn, { BackgroundColor3 = theme.ElementHover }, 0.1) end
        end)
        tabBtn.MouseLeave:Connect(function()
            if not accentBar.Visible then tw(tabBtn, { BackgroundColor3 = theme.TabInactive }, 0.1) end
        end)
        tabBtn.MouseButton1Click:Connect(function()
            setActive(page, tabBtn, accentBar, titleL)
        end)

        if #tabs == 1 then setActive(page, tabBtn, accentBar, titleL) end

        local Tab = {}
        Tab._theme = theme
        Tab._page  = page

        function Tab:_addElement(e)
            e.Parent = page
        end

        Elements.inject(Tab)

        return Tab
    end

    function Window:Notify(cfg)
        doNotify(gui, cfg, theme)
    end

    function Window:Destroy()
        gui:Destroy()
    end

    function Window:SetTheme(newTheme)
    end

    return Window
end

return TryxLib
