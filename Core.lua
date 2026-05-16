-- TryxLib Ultimate | Core.lua
-- Architecture robuste, Design Premium Immersif, Navigation Fluide.
-- © TryxHub — Moon820

local TryxLib = {}
TryxLib.__index = TryxLib

-- Services
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

-- Configuration & Thème
local DefaultTheme = {
    Background      = Color3.fromRGB(12, 12, 14),
    Sidebar         = Color3.fromRGB(16, 16, 18),
    TopBar          = Color3.fromRGB(14, 14, 16),
    Element         = Color3.fromRGB(22, 22, 26),
    ElementHover    = Color3.fromRGB(30, 30, 36),
    ElementStroke   = Color3.fromRGB(40, 40, 45),
    Accent          = Color3.fromRGB(220, 180, 60),
    AccentDark      = Color3.fromRGB(160, 130, 40),
    TextPrimary     = Color3.fromRGB(255, 255, 255),
    TextSecondary   = Color3.fromRGB(160, 160, 170),
    TextDisabled    = Color3.fromRGB(80, 80, 90),
    TabActive       = Color3.fromRGB(28, 28, 32),
    TabInactive     = Color3.fromRGB(16, 16, 18),
    TabStroke       = Color3.fromRGB(220, 180, 60),
    Notify          = Color3.fromRGB(20, 20, 24),
    NotifyStroke    = Color3.fromRGB(45, 45, 50),
    ScrollBar       = Color3.fromRGB(45, 45, 50),
    Danger          = Color3.fromRGB(220, 70, 70),
    Success         = Color3.fromRGB(70, 200, 110),
    Warning         = Color3.fromRGB(230, 170, 50),
}

-- Constantes
local SIDEBAR_W_DESKTOP = 170
local SIDEBAR_W_MOBILE  = 130
local TOPBAR_H          = 46
local MIN_W_DESKTOP     = 520
local MIN_H_DESKTOP     = 360
local MIN_W_MOBILE      = 320
local MIN_H_MOBILE      = 280
local DEFAULT_W         = 640
local DEFAULT_H         = 440
local ANIM_SPEED        = 0.22

-- Utilitaires Internes
local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or ANIM_SPEED, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 8)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(255,255,255)
    s.Thickness = thickness or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function padding(parent, t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.Parent = parent
    return p
end

local function label(parent, text, color, size, weight)
    local l = Instance.new("TextLabel")
    l.Name                   = "Label"
    l.Text                   = text or ""
    l.TextColor3             = color or Color3.fromRGB(255,255,255)
    l.TextSize               = size or 13
    l.Font                   = weight or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment         = Enum.TextXAlignment.Left
    l.TextTruncate           = Enum.TextTruncate.AtEnd
    l.BorderSizePixel        = 0
    l.Parent                 = parent
    return l
end

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

local function viewportSize()
    local cam = workspace.CurrentCamera
    return cam and cam.ViewportSize or Vector2.new(800, 600)
end

-- Gestion du Drag & Resize Robuste
local function makeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if isPress(input) then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and isMove(input) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function makeResizable(handle, target, minW, minH)
    local resizing, resizeStart, startSize = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if isPress(input) then
            resizing = true
            resizeStart = input.Position
            startSize = target.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and isMove(input) then
            local delta = input.Position - resizeStart
            local newW = math.max(minW, startSize.X.Offset + delta.X)
            local newH = math.max(minH, startSize.Y.Offset + delta.Y)
            target.Size = UDim2.new(0, newW, 0, newH)
        end
    end)
end

-- Création de la Fenêtre
function TryxLib:CreateWindow(config)
    config = config or {}
    local theme = config.Theme or DefaultTheme
    local vp = viewportSize()
    local isMobile = UserInputService.TouchEnabled and (vp.X <= 750 or not UserInputService.KeyboardEnabled)
    
    local w = math.clamp(config.Width or DEFAULT_W, isMobile and MIN_W_MOBILE or MIN_W_DESKTOP, vp.X - 40)
    local h = math.clamp(config.Height or DEFAULT_H, isMobile and MIN_H_MOBILE or MIN_H_DESKTOP, vp.Y - 40)
    local sidebarW = config.SidebarWidth or (isMobile and SIDEBAR_W_MOBILE or SIDEBAR_W_DESKTOP)

    local gui = Instance.new("ScreenGui")
    gui.Name = "TryxLib_Ultimate"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 1000
    gui.IgnoreGuiInset = true
    gui.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

    -- Main Container (pour éviter les bords carrés qui dépassent)
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, w, 0, h)
    main.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
    main.BackgroundColor3 = theme.Background
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    corner(main, UDim.new(0, 12))
    stroke(main, theme.ElementStroke, 1.2)

    -- Overlay pour les dropdowns
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 10000
    overlay.Parent = gui

    -- TopBar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, TOPBAR_H)
    topBar.BackgroundColor3 = theme.TopBar
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 50
    topBar.Parent = main
    
    local topStroke = Instance.new("Frame")
    topStroke.Size = UDim2.new(1, 0, 0, 1)
    topStroke.Position = UDim2.new(0, 0, 1, -1)
    topStroke.BackgroundColor3 = theme.ElementStroke
    topStroke.BorderSizePixel = 0
    topStroke.Parent = topBar

    local topLayout = Instance.new("UIListLayout")
    topLayout.FillDirection = Enum.FillDirection.Horizontal
    topLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    topLayout.Padding = UDim.new(0, 10)
    topLayout.Parent = topBar
    padding(topBar, 0, 0, 16, 16)

    local iconLbl = label(topBar, config.Icon or "★", theme.Accent, 16, Enum.Font.GothamBold)
    iconLbl.Size = UDim2.new(0, 20, 1, 0)
    iconLbl.TextXAlignment = Enum.TextXAlignment.Center

    local titleLbl = label(topBar, config.Title or "TryxLib Ultimate", theme.TextPrimary, isMobile and 13 or 14, Enum.Font.GothamBold)
    titleLbl.Size = UDim2.new(1, -140, 1, 0)

    local btnCont = Instance.new("Frame")
    btnCont.Size = UDim2.new(0, 70, 1, 0)
    btnCont.BackgroundTransparency = 1
    btnCont.Parent = topBar
    local btnLay = Instance.new("UIListLayout")
    btnLay.FillDirection = Enum.FillDirection.Horizontal
    btnLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLay.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLay.Padding = UDim.new(0, 8)
    btnLay.Parent = btnCont

    local function makeWinBtn(col, hoverCol)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 14, 0, 14)
        b.BackgroundColor3 = col
        b.Text = ""
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Parent = btnCont
        corner(b, UDim.new(1, 0))
        b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = hoverCol}, 0.15) end)
        b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = col}, 0.15) end)
        return b
    end
    local closeBtn = makeWinBtn(theme.Danger, Color3.fromRGB(255, 100, 100))
    local minBtn = makeWinBtn(theme.Warning, Color3.fromRGB(255, 200, 80))

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, sidebarW, 1, -TOPBAR_H)
    sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
    sidebar.BackgroundColor3 = theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 40
    sidebar.Parent = main
    
    local sideStroke = Instance.new("Frame")
    sideStroke.Size = UDim2.new(0, 1, 1, 0)
    sideStroke.Position = UDim2.new(1, -1, 0, 0)
    sideStroke.BackgroundColor3 = theme.ElementStroke
    sideStroke.BorderSizePixel = 0
    sideStroke.Parent = sidebar

    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, 0, 1, -20)
    tabList.Position = UDim2.new(0, 0, 0, 10)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 0
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.Parent = sidebar
    local tabLay = Instance.new("UIListLayout")
    tabLay.Padding = UDim.new(0, 4)
    tabLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLay.Parent = tabList
    padding(tabList, 4, 4, 8, 8)

    -- Content Area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -sidebarW, 1, -TOPBAR_H)
    content.Position = UDim2.new(0, sidebarW, 0, TOPBAR_H)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Parent = main

    -- Resize Handle (Invisible mais large zone de détection)
    local resizeH = Instance.new("ImageButton")
    resizeH.Name = "Resize"
    resizeH.Size = UDim2.new(0, 24, 0, 24)
    resizeH.Position = UDim2.new(1, -24, 1, -24)
    resizeH.BackgroundTransparency = 1
    resizeH.Image = "rbxassetid://11419713314"
    resizeH.ImageColor3 = theme.Accent
    resizeH.ImageTransparency = 0.8
    resizeH.ZIndex = 100
    resizeH.Parent = main

    makeDraggable(topBar, main)
    makeResizable(resizeH, main, isMobile and MIN_W_MOBILE or MIN_W_DESKTOP, isMobile and MIN_H_MOBILE or MIN_H_DESKTOP)

    -- Minimize & Close
    local minimized, prevSize = false, main.Size
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            prevSize = main.Size
            tween(main, {Size = UDim2.new(0, main.Size.X.Offset, 0, TOPBAR_H)}, 0.25)
            content.Visible, sidebar.Visible, resizeH.Visible = false, false, false
        else
            tween(main, {Size = prevSize}, 0.25)
            content.Visible, sidebar.Visible, resizeH.Visible = true, true, true
        end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(main, {Size = UDim2.new(0, main.Size.X.Offset, 0, 0), BackgroundTransparency = 1}, 0.2)
        task.wait(0.2) gui:Destroy()
    end)

    -- Window Object
    local Window = {}
    local tabs = {}
    local activePage = nil

    function Window:Tab(cfg)
        cfg = cfg or {}
        local tabTitle = cfg.Title or "Tab"
        local tabIcon = cfg.Icon or ""

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = "Tab_" .. tabTitle
        tabBtn.Size = UDim2.new(1, 0, 0, 38)
        tabBtn.BackgroundColor3 = theme.TabInactive
        tabBtn.Text = ""
        tabBtn.BorderSizePixel = 0
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabList
        corner(tabBtn, UDim.new(0, 8))
        
        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(0, 3, 0.5, 0)
        accent.Position = UDim2.new(0, 0, 0.25, 0)
        accent.BackgroundColor3 = theme.Accent
        accent.Visible = false
        accent.Parent = tabBtn
        corner(accent, UDim.new(0, 2))

        local rowLay = Instance.new("UIListLayout")
        rowLay.FillDirection = Enum.FillDirection.Horizontal
        rowLay.VerticalAlignment = Enum.VerticalAlignment.Center
        rowLay.Padding = UDim.new(0, 10)
        rowLay.Parent = tabBtn
        padding(tabBtn, 0, 0, 12, 8)

        local ic = label(tabBtn, tabIcon, theme.Accent, 14, Enum.Font.GothamBold)
        ic.Size = UDim2.new(0, 18, 1, 0)
        ic.Visible = (tabIcon ~= "")

        local tl = label(tabBtn, tabTitle, theme.TextSecondary, isMobile and 12 or 13, Enum.Font.GothamMedium)
        tl.Size = UDim2.new(1, -28, 1, 0)

        local page = Instance.new("ScrollingFrame")
        page.Name = "Page_" .. tabTitle
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = theme.ScrollBar
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.BorderSizePixel = 0
        page.Visible = false
        page.Parent = content
        
        local pageLay = Instance.new("UIListLayout")
        pageLay.Padding = UDim.new(0, 8)
        pageLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLay.Parent = page
        padding(page, 12, 12, 14, 14)

        local entry = { btn = tabBtn, accent = accent, title = tl, page = page }
        table.insert(tabs, entry)

        local function activate()
            if activePage then activePage.Visible = false end
            activePage = page
            page.Visible = true
            for _, t in ipairs(tabs) do
                local active = (t.btn == tabBtn)
                tween(t.btn, {BackgroundColor3 = active and theme.TabActive or theme.TabInactive}, 0.15)
                t.accent.Visible = active
                tween(t.title, {TextColor3 = active and theme.TextPrimary or theme.TextSecondary}, 0.15)
            end
        end

        tabBtn.MouseButton1Click:Connect(activate)
        tabBtn.MouseEnter:Connect(function() if activePage ~= page then tween(tabBtn, {BackgroundColor3 = theme.ElementHover}, 0.15) end end)
        tabBtn.MouseLeave:Connect(function() if activePage ~= page then tween(tabBtn, {BackgroundColor3 = theme.TabInactive}, 0.15) end end)

        if #tabs == 1 then activate() end

        local Tab = { _page = page, _theme = theme, _gui = gui, _window = main, _overlay = overlay, _isMobile = isMobile }
        function Tab:_addElement(e) e.Parent = page end
        return Tab
    end

    function Window:Notify(cfg) if TryxLib._notify then TryxLib._notify(gui, cfg, theme) end end
    function Window:Destroy() gui:Destroy() end
    return Window
end

return TryxLib
