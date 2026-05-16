-- TryxLib | Core.lua
-- Fenetre, Drag, Resize, Sidebar, Tabs
-- Version améliorée : mobile responsive, drag/touch, resize/touch, overlay dropdown.

local TryxLib = {}
TryxLib.__index = TryxLib

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer

local Theme = {
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

local SIDEBAR_W_DESKTOP = 160
local SIDEBAR_W_MOBILE  = 118
local TOPBAR_H          = 42
local MIN_W_DESKTOP     = 480
local MIN_H_DESKTOP     = 320
local MIN_W_MOBILE      = 300
local MIN_H_MOBILE      = 260
local DEFAULT_W         = 620
local DEFAULT_H         = 420
local ELEMENT_PAD       = 6
local ANIM_SPEED        = 0.18

local function tween(obj, props, t)
    pcall(function()
        TweenService:Create(obj, TweenInfo.new(t or ANIM_SPEED, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
    end)
end

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.ElementStroke
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function padding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 6)
    p.PaddingBottom = UDim.new(0, b or 6)
    p.PaddingLeft   = UDim.new(0, l or 10)
    p.PaddingRight  = UDim.new(0, r or 10)
    p.Parent = parent
    return p
end

local function label(parent, text, color, size, weight)
    local l = Instance.new("TextLabel")
    l.Text                   = text or ""
    l.TextColor3             = color or Theme.TextPrimary
    l.TextSize               = size or 13
    l.Font                   = weight or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment         = Enum.TextXAlignment.Left
    l.TextTruncate           = Enum.TextTruncate.AtEnd
    l.BorderSizePixel        = 0
    l.Parent                 = parent
    return l
end

local function newFrame(parent, bg, size, pos)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or Theme.Background
    f.Size             = size or UDim2.fromScale(1, 1)
    f.Position         = pos or UDim2.new(0, 0, 0, 0)
    f.BorderSizePixel  = 0
    f.Parent           = parent
    return f
end

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

local function viewportSize()
    local cam = workspace.CurrentCamera
    if cam then return cam.ViewportSize end
    return Vector2.new(800, 600)
end

local function computeWindowSize(config)
    local vp = viewportSize()
    local margin = config.MobileMargin or 18
    local isMobile = UserInputService.TouchEnabled and (vp.X <= 700 or not UserInputService.KeyboardEnabled)

    local minW = config.MinWidth or (isMobile and MIN_W_MOBILE or MIN_W_DESKTOP)
    local minH = config.MinHeight or (isMobile and MIN_H_MOBILE or MIN_H_DESKTOP)
    local maxW = math.max(minW, vp.X - margin)
    local maxH = math.max(minH, vp.Y - margin)

    local w = config.Width or DEFAULT_W
    local h = config.Height or DEFAULT_H
    if isMobile then
        w = config.MobileWidth or math.min(w, maxW)
        h = config.MobileHeight or math.min(h, maxH)
    end

    w = math.clamp(w, minW, maxW)
    h = math.clamp(h, minH, maxH)
    return w, h, minW, minH, isMobile
end

local function centerWindow(target, w, h)
    target.Position = UDim2.new(0.5, -w / 2, 0.5, -h / 2)
end

local function clampToScreen(target)
    local vp = viewportSize()
    local w = target.AbsoluteSize.X
    local h = target.AbsoluteSize.Y
    local x = target.Position.X.Offset
    local y = target.Position.Y.Offset
    if target.Position.X.Scale ~= 0 then x = (vp.X * target.Position.X.Scale) + x end
    if target.Position.Y.Scale ~= 0 then y = (vp.Y * target.Position.Y.Scale) + y end
    local nx = math.clamp(x, 4, math.max(4, vp.X - w - 4))
    local ny = math.clamp(y, 4, math.max(4, vp.Y - math.min(h, TOPBAR_H) - 4))
    target.Position = UDim2.new(0, nx, 0, ny)
end

local function makeDraggable(handle, target, clampEnabled)
    local dragging = false
    local dragStart, startPos

    handle.Active = true
    handle.InputBegan:Connect(function(input)
        if isPress(input) then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and isMove(input) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            if clampEnabled ~= false then clampToScreen(target) end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if isPress(input) then
            dragging = false
            if clampEnabled ~= false then clampToScreen(target) end
        end
    end)
end

local function makeResizable(resizeHandle, target, minW, minH)
    local resizing = false
    local resizeStart, startSize

    resizeHandle.Active = true
    resizeHandle.InputBegan:Connect(function(input)
        if isPress(input) then
            resizing = true
            resizeStart = input.Position
            startSize = target.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and isMove(input) then
            local vp = viewportSize()
            local delta = input.Position - resizeStart
            local newW = math.clamp(startSize.X.Offset + delta.X, minW or MIN_W_DESKTOP, vp.X - 8)
            local newH = math.clamp(startSize.Y.Offset + delta.Y, minH or MIN_H_DESKTOP, vp.Y - 8)
            target.Size = UDim2.new(0, newW, 0, newH)
            clampToScreen(target)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if isPress(input) then resizing = false end
    end)
end

function TryxLib:CreateWindow(config)
    config = config or {}
    local title    = config.Title or "TryxLib"
    local subtitle = config.Subtitle or ""
    local icon     = config.Icon or "star"
    local theme    = config.Theme or Theme

    local w, h, minW, minH, isMobile = computeWindowSize(config)
    local sidebarW = config.SidebarWidth or (isMobile and SIDEBAR_W_MOBILE or SIDEBAR_W_DESKTOP)

    local gui = Instance.new("ScreenGui")
    gui.Name           = "TryxLib_" .. title:gsub("%s", "")
    gui.ResetOnSpawn   = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder   = config.DisplayOrder or 999
    gui.IgnoreGuiInset = config.IgnoreGuiInset ~= false
    gui.Parent         = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

    local win = Instance.new("Frame")
    win.Name             = "Window"
    win.Size             = UDim2.new(0, w, 0, 0)
    win.BackgroundColor3 = theme.Background
    win.BorderSizePixel  = 0
    win.ClipsDescendants = true
    win.Parent           = gui
    centerWindow(win, w, h)
    corner(win, UDim.new(0, 10))
    stroke(win, theme.ElementStroke, 1)

    local shadow = Instance.new("ImageLabel")
    shadow.Name                  = "Shadow"
    shadow.Size                  = UDim2.new(1, 30, 1, 30)
    shadow.Position              = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image                 = "rbxassetid://6014261993"
    shadow.ImageColor3           = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency     = isMobile and 0.65 or 0.5
    shadow.ScaleType             = Enum.ScaleType.Slice
    shadow.SliceCenter           = Rect.new(49, 49, 450, 450)
    shadow.ZIndex                = 0
    shadow.Parent                = win

    local overlay = Instance.new("Frame")
    overlay.Name = "__TryxOverlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.ClipsDescendants = false
    overlay.ZIndex = 9000
    overlay.Parent = gui

    local topBar = newFrame(win, theme.TopBar, UDim2.new(1, 0, 0, TOPBAR_H))
    topBar.Name = "TopBar"
    topBar.ZIndex = 30
    topBar.Active = true

    local topLayout = Instance.new("UIListLayout")
    topLayout.FillDirection = Enum.FillDirection.Horizontal
    topLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    topLayout.Padding = UDim.new(0, 8)
    topLayout.Parent = topBar
    padding(topBar, 0, 0, 14, 14)

    local iconLabel = label(topBar, icon, theme.Accent, 14, Enum.Font.GothamBold)
    iconLabel.Size = UDim2.new(0, 16, 1, 0)
    iconLabel.Name = "Icon"
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center

    local titleLabel = label(topBar, title .. (subtitle ~= "" and "  -  " .. subtitle or ""), theme.TextPrimary, isMobile and 12 or 13, Enum.Font.GothamBold)
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Name = "Title"

    local btnContainer = newFrame(topBar, Color3.fromRGB(0, 0, 0), UDim2.new(0, 60, 1, 0))
    btnContainer.BackgroundTransparency = 1
    btnContainer.Name = "Buttons"

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0, 6)
    btnLayout.Parent = btnContainer

    local function makeWinBtn(color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, isMobile and 16 or 14, 0, isMobile and 16 or 14)
        btn.BackgroundColor3 = color
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Parent = btnContainer
        corner(btn, UDim.new(1, 0))
        return btn
    end

    local closeBtn = makeWinBtn(theme.Danger)
    local minimizeBtn = makeWinBtn(theme.Warning)

    local sidebar = newFrame(win, theme.Sidebar, UDim2.new(0, sidebarW, 1, -TOPBAR_H), UDim2.new(0, 0, 0, TOPBAR_H))
    sidebar.Name = "Sidebar"
    sidebar.ZIndex = 20

    local sideStroke = newFrame(sidebar, theme.ElementStroke, UDim2.new(0, 1, 1, 0), UDim2.new(1, 0, 0, 0))
    sideStroke.Name = "Stroke"

    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.Size = UDim2.new(1, 0, 1, -10)
    tabList.Position = UDim2.new(0, 0, 0, 8)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 0
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.BorderSizePixel = 0
    tabList.Parent = sidebar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 3)
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabListLayout.Parent = tabList
    padding(tabList, 4, 4, 6, 6)

    local contentArea = newFrame(win, theme.Background, UDim2.new(1, -sidebarW, 1, -TOPBAR_H), UDim2.new(0, sidebarW, 0, TOPBAR_H))
    contentArea.Name = "Content"
    contentArea.ClipsDescendants = false

    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name = "ResizeHandle"
    resizeHandle.Size = UDim2.new(0, isMobile and 18 or 14, 0, isMobile and 18 or 14)
    resizeHandle.Position = UDim2.new(1, -(isMobile and 18 or 14), 1, -(isMobile and 18 or 14))
    resizeHandle.BackgroundColor3 = theme.ElementStroke
    resizeHandle.Text = ""
    resizeHandle.BorderSizePixel = 0
    resizeHandle.AutoButtonColor = false
    resizeHandle.ZIndex = 80
    resizeHandle.Parent = win
    corner(resizeHandle, UDim.new(0, 3))

    for i = 1, 3 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 2, 0, 2)
        dot.Position = UDim2.new(0, 2 + (i - 1) * 4, 0, isMobile and 11 or 8)
        dot.BackgroundColor3 = theme.TextDisabled
        dot.BorderSizePixel = 0
        dot.ZIndex = 81
        dot.Parent = resizeHandle
        corner(dot, UDim.new(1, 0))
    end

    makeDraggable(topBar, win, config.ClampToScreen ~= false)
    if config.Resizable ~= false then
        makeResizable(resizeHandle, win, minW, minH)
    else
        resizeHandle.Visible = false
    end

    local minimized = false
    local prevSize = win.Size
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            prevSize = win.Size
            tween(win, { Size = UDim2.new(0, win.Size.X.Offset, 0, TOPBAR_H) }, 0.2)
            contentArea.Visible = false
            sidebar.Visible = false
            resizeHandle.Visible = false
        else
            tween(win, { Size = prevSize }, 0.2)
            contentArea.Visible = true
            sidebar.Visible = true
            resizeHandle.Visible = config.Resizable ~= false
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        tween(win, { Size = UDim2.new(0, win.Size.X.Offset, 0, 0) }, 0.15)
        task.wait(0.15)
        gui:Destroy()
    end)

    local Window = {}
    local tabs = {}
    local activePage = nil

    local function setActiveTab(page, tabBtn)
        if activePage then activePage.Visible = false end
        activePage = page
        page.Visible = true
        for _, t in ipairs(tabs) do
            local isActive = t.btn == tabBtn
            tween(t.btn, { BackgroundColor3 = isActive and theme.TabActive or theme.TabInactive }, 0.12)
            t.accent.Visible = isActive
            t.titleLbl.TextColor3 = isActive and theme.TextPrimary or theme.TextSecondary
        end
    end

    function Window:Tab(cfg)
        cfg = cfg or {}
        local tabTitle = cfg.Title or "Tab"
        local tabIcon = cfg.Icon or ""

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. tabTitle
        tabBtn.Size = UDim2.new(1, 0, 0, isMobile and 34 or 36)
        tabBtn.BackgroundColor3 = theme.TabInactive
        tabBtn.Text = ""
        tabBtn.BorderSizePixel = 0
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabList
        corner(tabBtn, UDim.new(0, 6))

        local accentBar = Instance.new("Frame")
        accentBar.Name = "Accent"
        accentBar.Size = UDim2.new(0, 3, 0.6, 0)
        accentBar.Position = UDim2.new(0, 0, 0.2, 0)
        accentBar.BackgroundColor3 = theme.TabStroke
        accentBar.BorderSizePixel = 0
        accentBar.Visible = false
        accentBar.Parent = tabBtn
        corner(accentBar, UDim.new(0, 2))

        local tabRowLayout = Instance.new("UIListLayout")
        tabRowLayout.FillDirection = Enum.FillDirection.Horizontal
        tabRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        tabRowLayout.Padding = UDim.new(0, isMobile and 5 or 7)
        tabRowLayout.Parent = tabBtn
        padding(tabBtn, 0, 0, 10, 8)

        local iconLbl = label(tabBtn, tabIcon, theme.Accent, 12, Enum.Font.GothamMedium)
        iconLbl.Size = UDim2.new(0, 14, 1, 0)
        iconLbl.TextXAlignment = Enum.TextXAlignment.Center

        local titleLbl = label(tabBtn, tabTitle, theme.TextSecondary, isMobile and 11 or 12, Enum.Font.GothamMedium)
        titleLbl.Size = UDim2.new(1, -30, 1, 0)

        local page = Instance.new("ScrollingFrame")
        page.Name = "Page_" .. tabTitle
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = theme.ScrollBar
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.BorderSizePixel = 0
        page.Visible = false
        page.ClipsDescendants = false
        page.Parent = contentArea

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, ELEMENT_PAD)
        pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLayout.Parent = page
        padding(page, 10, 10, 10, 10)

        local tabEntry = { btn = tabBtn, accent = accentBar, titleLbl = titleLbl, page = page }
        table.insert(tabs, tabEntry)

        tabBtn.MouseEnter:Connect(function()
            if accentBar.Visible then return end
            tween(tabBtn, { BackgroundColor3 = theme.ElementHover }, 0.1)
        end)
        tabBtn.MouseLeave:Connect(function()
            if accentBar.Visible then return end
            tween(tabBtn, { BackgroundColor3 = theme.TabInactive }, 0.1)
        end)
        tabBtn.MouseButton1Click:Connect(function()
            setActiveTab(page, tabBtn)
        end)

        if #tabs == 1 then setActiveTab(page, tabBtn) end

        local Tab = {}
        Tab._page = page
        Tab._layout = pageLayout
        Tab._theme = theme
        Tab._gui = gui
        Tab._window = win
        Tab._overlay = overlay
        Tab._isMobile = isMobile

        function Tab:_addElement(elem)
            elem.Parent = page
        end

        return Tab
    end

    function Window:Notify(cfg)
        if TryxLib._notify then TryxLib._notify(gui, cfg, theme) end
    end

    function Window:Destroy()
        gui:Destroy()
    end

    function Window:GetGui() return gui end
    function Window:GetWindowFrame() return win end
    function Window:IsMobile() return isMobile end

    tween(win, { Size = UDim2.new(0, w, 0, h) }, 0.25)

    return Window
end

return TryxLib
