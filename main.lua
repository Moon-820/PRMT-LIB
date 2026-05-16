-- TryxLib | dist/main.lua
-- Version compilée — loadstring(game:HttpGet("URL"))()
-- © TryxHub — Moon820
-- Build corrigé : mobile responsive, drag/touch, slider mobile, dropdown overlay, custom elements.

local TryxLib = (function()
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

end)()

local Elements = (function()
-- TryxLib Ultimate | Elements.lua
-- Slider Tactile/Souris parfait, UserProfile Immersif, Customisation Totale.
-- © TryxHub — Moon820

local Elements = {}

-- Services
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

-- Constantes de Design
local ANIM_SPEED = 0.22
local CORNER_R   = UDim.new(0, 10)
local ELEMENT_H  = 42
local GAP        = 8

-- Utilitaires
local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or ANIM_SPEED, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER_R
    c.Parent = p
    return c
end

local function stroke(p, col, th, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(255,255,255)
    s.Thickness = th or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function padding(p, t, b, l, r)
    local pd = Instance.new("UIPadding")
    pd.PaddingTop = UDim.new(0, t or 0)
    pd.PaddingBottom = UDim.new(0, b or 0)
    pd.PaddingLeft = UDim.new(0, l or 0)
    pd.PaddingRight = UDim.new(0, r or 0)
    pd.Parent = p
    return pd
end

local function makeLabel(p, cfg)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.BorderSizePixel = 0
    l.Text = cfg.Text or ""
    l.TextColor3 = cfg.TextColor3 or Color3.fromRGB(255,255,255)
    l.TextSize = cfg.TextSize or 13
    l.Font = cfg.Font or Enum.Font.GothamMedium
    l.TextXAlignment = cfg.TextXAlignment or Enum.TextXAlignment.Left
    l.Size = cfg.Size or UDim2.fromScale(1, 1)
    l.Position = cfg.Position or UDim2.new(0,0,0,0)
    l.TextWrapped = cfg.Wrapped or false
    l.Parent = p
    return l
end

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

-- ─── USER PROFILE (IMMERSIVE) ────────────────────────────────────────────────
function Elements.UserProfile(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local player = cfg.Player or Players.LocalPlayer
    
    local f = Instance.new("Frame")
    f.Name = "UserProfile"
    f.Size = UDim2.new(1, 0, 0, 90)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 12))
    stroke(f, theme.ElementStroke, 1.2)
    padding(f, 14, 14, 16, 16)
    
    -- Background Gradient pour l'effet Premium
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, theme.Element),
        ColorSequenceKeypoint.new(1, theme.ElementHover)
    })
    grad.Rotation = 45
    grad.Parent = f
    
    local avatarCont = Instance.new("Frame")
    avatarCont.Size = UDim2.new(0, 62, 0, 62)
    avatarCont.BackgroundColor3 = theme.Background
    avatarCont.Parent = f
    corner(avatarCont, UDim.new(1, 0))
    stroke(avatarCont, theme.Accent, 2)
    
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(1, -4, 1, -4)
    avatar.Position = UDim2.new(0, 2, 0, 2)
    avatar.BackgroundTransparency = 1
    avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    avatar.Parent = avatarCont
    corner(avatar, UDim.new(1, 0))
    
    local info = Instance.new("Frame")
    info.Size = UDim2.new(1, -78, 1, 0)
    info.Position = UDim2.new(0, 78, 0, 0)
    info.BackgroundTransparency = 1
    info.Parent = f
    
    local name = makeLabel(info, {
        Text = player.DisplayName or player.Name,
        TextColor3 = theme.TextPrimary,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 22)
    })
    
    local sub = makeLabel(info, {
        Text = "@" .. player.Name .. " | ID: " .. player.UserId,
        TextColor3 = theme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 22)
    })
    
    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0, 75, 0, 20)
    badge.Position = UDim2.new(0, 0, 0, 42)
    badge.BackgroundColor3 = theme.Accent
    badge.Parent = info
    corner(badge, UDim.new(0, 6))
    
    local badgeLbl = makeLabel(badge, {
        Text = cfg.Tag or "PREMIUM",
        TextColor3 = Color3.fromRGB(10, 10, 12),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    
    tab:_addElement(f)
    return f
end

-- ─── BUTTON ──────────────────────────────────────────────────────────────────
function Elements.Button(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, ELEMENT_H + 10)
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 8, 8, 16, 16)
    
    local tl = makeLabel(f, {
        Text = cfg.Title or "Button",
        TextColor3 = theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, -30, 0, 18)
    })
    
    if cfg.Desc and cfg.Desc ~= "" then
        tl.Position = UDim2.new(0, 0, 0, -2)
        local dl = makeLabel(f, {
            Text = cfg.Desc,
            TextColor3 = theme.TextSecondary,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1, -30, 0, 16),
            Position = UDim2.new(0, 0, 0, 18)
        })
        dl.TextTransparency = 0.3
    end
    
    local icon = makeLabel(f, {
        Text = "→",
        TextColor3 = theme.Accent,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f
    
    btn.MouseEnter:Connect(function() tween(f, {BackgroundColor3 = theme.ElementHover}) end)
    btn.MouseLeave:Connect(function() tween(f, {BackgroundColor3 = cfg.Color or theme.Element}) end)
    btn.MouseButton1Click:Connect(function() pcall(cfg.Callback or function() end) end)
    
    tab:_addElement(f)
    return f
end

-- ─── TOGGLE ──────────────────────────────────────────────────────────────────
function Elements.Toggle(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local value = cfg.Value or false
    local isCheckbox = (cfg.Type == "Checkbox")
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, ELEMENT_H + 10)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 8, 8, 16, 16)
    
    local tl = makeLabel(f, {
        Text = cfg.Title or "Toggle",
        TextColor3 = theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, -60, 0, 18)
    })
    
    if cfg.Desc and cfg.Desc ~= "" then
        tl.Position = UDim2.new(0, 0, 0, -2)
        local dl = makeLabel(f, {
            Text = cfg.Desc,
            TextColor3 = theme.TextSecondary,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1, -60, 0, 16),
            Position = UDim2.new(0, 0, 0, 18)
        })
        dl.TextTransparency = 0.3
    end
    
    local box = Instance.new("Frame")
    box.Size = isCheckbox and UDim2.new(0, 24, 0, 24) or UDim2.new(0, 42, 0, 22)
    box.Position = UDim2.new(1, isCheckbox and -24 or -42, 0.5, isCheckbox and -12 or -11)
    box.BackgroundColor3 = value and theme.Accent or theme.Background
    box.Parent = f
    corner(box, isCheckbox and UDim.new(0, 6) or UDim.new(1, 0))
    stroke(box, theme.ElementStroke, 1.2)
    
    local dot = Instance.new("Frame")
    if isCheckbox then
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = UDim2.new(0.5, -7, 0.5, -7)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BackgroundTransparency = value and 0 or 1
    else
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, value and 23 or 3, 0.5, -8)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
    dot.Parent = box
    corner(dot, isCheckbox and UDim.new(0, 4) or UDim.new(1, 0))
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f
    
    local function update()
        tween(box, {BackgroundColor3 = value and theme.Accent or theme.Background})
        if isCheckbox then
            tween(dot, {BackgroundTransparency = value and 0 or 1})
        else
            tween(dot, {Position = UDim2.new(0, value and 23 or 3, 0.5, -8)})
        end
        pcall(cfg.Callback or function() end, value)
    end
    
    btn.MouseButton1Click:Connect(function() value = not value update() end)
    
    tab:_addElement(f)
    return { Set = function(_, v) value = v update() end, Get = function() return value end }
end

-- ─── SLIDER (ULTIMATE) ───────────────────────────────────────────────────────
function Elements.Slider(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local min, max = cfg.Min or 0, cfg.Max or 100
    local value = math.clamp(cfg.Value or min, min, max)
    local step = cfg.Step or 1
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 64)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 10, 10, 16, 16)
    
    local tl = makeLabel(f, {
        Text = cfg.Title or "Slider",
        TextColor3 = theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, -80, 0, 18)
    })
    
    if cfg.Desc and cfg.Desc ~= "" then
        tl.Position = UDim2.new(0, 0, 0, -2)
        local dl = makeLabel(f, {
            Text = cfg.Desc,
            TextColor3 = theme.TextSecondary,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1, -80, 0, 16),
            Position = UDim2.new(0, 0, 0, 18)
        })
        dl.TextTransparency = 0.3
    end
    
    local valCont = Instance.new("Frame")
    valCont.Size = UDim2.new(0, 65, 0, 24)
    valCont.Position = UDim2.new(1, -65, 0, 0)
    valCont.BackgroundColor3 = theme.Background
    valCont.Parent = f
    corner(valCont, UDim.new(0, 6))
    stroke(valCont, theme.ElementStroke, 1)
    
    local valInput = Instance.new("TextBox")
    valInput.Size = UDim2.fromScale(1, 1)
    valInput.BackgroundTransparency = 1
    valInput.Text = tostring(value) .. (cfg.Suffix or "")
    valInput.TextColor3 = theme.Accent
    valInput.TextSize = 12
    valInput.Font = Enum.Font.GothamBold
    valInput.TextEditable = cfg.Input == true
    valInput.ClearTextOnFocus = false
    valInput.Parent = valCont
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 1, -10)
    track.BackgroundColor3 = theme.Background
    track.BorderSizePixel = 0
    track.Parent = f
    corner(track, UDim.new(1, 0))
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale((value-min)/(max-min), 1)
    fill.BackgroundColor3 = theme.Accent
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, UDim.new(1, 0))
    
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 16, 0, 16)
    thumb.Position = UDim2.new((value-min)/(max-min), 0, 0.5, 0)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Parent = track
    corner(thumb, UDim.new(1, 0))
    stroke(thumb, theme.Accent, 1.5)
    
    local function update(input)
        local pos = input.Position.X
        local rel = math.clamp((pos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = min + rel * (max - min)
        value = math.floor(raw / step + 0.5) * step
        value = math.clamp(value, min, max)
        
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.fromScale(pct, 1)
        thumb.Position = UDim2.new(pct, 0, 0.5, 0)
        valInput.Text = tostring(value) .. (cfg.Suffix or "")
        pcall(cfg.Callback or function() end, value)
    end
    
    local dragging = false
    track.InputBegan:Connect(function(i)
        if isPress(i) then
            dragging = true
            update(i)
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i) if dragging and isMove(i) then update(i) end end)
    
    if cfg.Input then
        valInput.FocusLost:Connect(function()
            local n = tonumber(valInput.Text:gsub("[^%d%.%-]", ""))
            if n then
                value = math.clamp(math.floor(n / step + 0.5) * step, min, max)
                local pct = (value - min) / (max - min)
                tween(fill, {Size = UDim2.fromScale(pct, 1)})
                tween(thumb, {Position = UDim2.new(pct, 0, 0.5, 0)})
                valInput.Text = tostring(value) .. (cfg.Suffix or "")
                pcall(cfg.Callback or function() end, value)
            else
                valInput.Text = tostring(value) .. (cfg.Suffix or "")
            end
        end)
    end
    
    tab:_addElement(f)
    return { Set = function(_, v) value = math.clamp(v, min, max) local pct = (value-min)/(max-min) fill.Size = UDim2.fromScale(pct, 1) thumb.Position = UDim2.new(pct, 0, 0.5, 0) valInput.Text = tostring(value) .. (cfg.Suffix or "") end }
end

-- ─── INPUT ───────────────────────────────────────────────────────────────────
function Elements.Input(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 68)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 10, 10, 16, 16)
    
    local tl = makeLabel(f, {
        Text = cfg.Title or "Input",
        TextColor3 = theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 18)
    })
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 30)
    box.Position = UDim2.new(0, 0, 1, -30)
    box.BackgroundColor3 = theme.Background
    box.Parent = f
    corner(box, UDim.new(0, 8))
    stroke(box, theme.ElementStroke, 1)
    
    local inp = Instance.new("TextBox")
    inp.Size = UDim2.new(1, -20, 1, 0)
    inp.Position = UDim2.new(0, 10, 0, 0)
    inp.BackgroundTransparency = 1
    inp.Text = cfg.Value or ""
    inp.PlaceholderText = cfg.Placeholder or "Type here..."
    inp.TextColor3 = theme.TextPrimary
    inp.PlaceholderColor3 = theme.TextDisabled
    inp.TextSize = 13
    inp.Font = Enum.Font.Gotham
    inp.TextXAlignment = Enum.TextXAlignment.Left
    inp.ClearTextOnFocus = false
    inp.Parent = box
    
    inp.FocusLost:Connect(function(enter)
        pcall(cfg.Callback or function() end, inp.Text)
    end)
    
    tab:_addElement(f)
    return { Set = function(_, v) inp.Text = v end, Get = function() return inp.Text end }
end

-- ─── DROPDOWN ────────────────────────────────────────────────────────────────
function Elements.Dropdown(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local values = cfg.Values or {}
    local value = cfg.Value or (values[1] or "")
    local open = false
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, ELEMENT_H + 10)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 8, 8, 16, 16)
    
    local tl = makeLabel(f, {
        Text = cfg.Title or "Dropdown",
        TextColor3 = theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, -130, 0, 18)
    })
    
    local selBox = Instance.new("Frame")
    selBox.Size = UDim2.new(0, 120, 0, 30)
    selBox.Position = UDim2.new(1, -120, 0.5, -15)
    selBox.BackgroundColor3 = theme.Background
    selBox.Parent = f
    corner(selBox, UDim.new(0, 8))
    stroke(selBox, theme.ElementStroke, 1)
    
    local selLbl = makeLabel(selBox, {
        Text = value,
        TextColor3 = theme.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -25, 1, 0),
        Position = UDim2.new(0, 10, 0, 0)
    })
    
    local chev = makeLabel(selBox, {
        Text = "▼",
        TextColor3 = theme.TextSecondary,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center
    })
    
    local list = Instance.new("Frame")
    list.Size = UDim2.new(0, 120, 0, 0)
    list.BackgroundColor3 = theme.Element
    list.ClipsDescendants = true
    list.Visible = false
    list.ZIndex = 10000
    list.Parent = tab._overlay
    corner(list, UDim.new(0, 8))
    stroke(list, theme.ElementStroke, 1.2)
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 4)
    lay.Parent = list
    padding(list, 6, 6, 6, 6)
    
    local function build()
        for _, c in ipairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, v in ipairs(values) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, 0, 0, 30)
            item.BackgroundColor3 = (v == value) and theme.ElementHover or theme.Element
            item.Text = "  " .. v
            item.TextColor3 = (v == value) and theme.Accent or theme.TextPrimary
            item.TextSize = 13
            item.Font = Enum.Font.Gotham
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.BorderSizePixel = 0
            item.AutoButtonColor = false
            item.ZIndex = 10001
            item.Parent = list
            corner(item, UDim.new(0, 6))
            item.MouseButton1Click:Connect(function()
                value = v selLbl.Text = v open = false
                tween(list, {Size = UDim2.new(0, 120, 0, 0)})
                tween(chev, {Rotation = 0})
                task.delay(ANIM_SPEED, function() if not open then list.Visible = false end end)
                build() pcall(cfg.Callback or function() end, value)
            end)
        end
    end
    build()
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f
    
    btn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            local abs = selBox.AbsolutePosition
            list.Position = UDim2.new(0, abs.X, 0, abs.Y + 34)
            list.Visible = true
            tween(list, {Size = UDim2.new(0, 120, 0, math.min(#values * 34 + 12, 200))})
            tween(chev, {Rotation = 180})
        else
            tween(list, {Size = UDim2.new(0, 120, 0, 0)})
            tween(chev, {Rotation = 0})
            task.delay(ANIM_SPEED, function() if not open then list.Visible = false end end)
        end
    end)
    
    tab:_addElement(f)
    return { Refresh = function(_, new) values = new build() end }
end

-- ─── CARD (PREMIUM) ──────────────────────────────────────────────────────────
function Elements.Card(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Name = "Card"
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 12))
    stroke(f, theme.Accent, 1.2, 0.5)
    padding(f, 16, 16, 18, 18)
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 10)
    lay.Parent = f
    
    if cfg.Title then
        makeLabel(f, {
            Text = cfg.Title,
            TextColor3 = theme.Accent,
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            Size = UDim2.new(1, 0, 0, 20)
        })
    end
    
    tab:_addElement(f)
    local obj = { _page = f, _theme = theme, _overlay = tab._overlay, _gui = tab._gui, _window = tab._window, _isMobile = tab._isMobile }
    function obj:_addElement(e) e.Parent = f end
    Elements.inject(obj)
    return obj
end

-- ─── SECTION ─────────────────────────────────────────────────────────────────
function Elements.Section(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Name = "Section"
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    padding(f, 10, 4, 4, 4)
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 8)
    lay.Parent = f
    
    local tl = makeLabel(f, {
        Text = (cfg.Title or "Section"):upper(),
        TextColor3 = theme.Accent,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 14)
    })
    tl.TextTransparency = 0.2
    
    tab:_addElement(f)
    local obj = { _page = f, _theme = theme, _overlay = tab._overlay, _gui = tab._gui, _window = tab._window, _isMobile = tab._isMobile }
    function obj:_addElement(e) e.Parent = f end
    Elements.inject(obj)
    return obj
end

-- ─── PARAGRAPH ───────────────────────────────────────────────────────────────
function Elements.Paragraph(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = theme.Element
    f.BackgroundTransparency = 0.5
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 12, 12, 16, 16)
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 4)
    lay.Parent = f
    
    if cfg.Title then
        makeLabel(f, {
            Text = cfg.Title,
            TextColor3 = theme.TextPrimary,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Size = UDim2.new(1, 0, 0, 18)
        })
    end
    if cfg.Desc then
        local d = makeLabel(f, {
            Text = cfg.Desc,
            TextColor3 = theme.TextSecondary,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1, 0, 0, 0),
            Wrapped = true
        })
        d.AutomaticSize = Enum.AutomaticSize.Y
    end
    
    tab:_addElement(f)
    return f
end

-- ─── LABEL ───────────────────────────────────────────────────────────────────
function Elements.Label(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local l = makeLabel(nil, {
        Text = cfg.Text or "Label",
        TextColor3 = cfg.TextColor or theme.TextSecondary,
        TextSize = cfg.TextSize or 13,
        Font = cfg.Font or Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 22),
        TextXAlignment = cfg.Align or Enum.TextXAlignment.Left
    })
    tab:_addElement(l)
    return { Set = function(_, v) l.Text = v end }
end

-- ─── DIVIDER ──────────────────────────────────────────────────────────────────
function Elements.Divider(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 24)
    f.BackgroundTransparency = 1
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = theme.ElementStroke
    line.BorderSizePixel = 0
    line.Parent = f
    if cfg.Label then
        local l = makeLabel(f, {
            Text = "  " .. cfg.Label:upper() .. "  ",
            TextColor3 = theme.TextDisabled,
            TextSize = 10,
            Font = Enum.Font.GothamBold,
            Size = UDim2.new(0, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Center
        })
        l.AutomaticSize = Enum.AutomaticSize.X
        l.AnchorPoint = Vector2.new(0.5, 0)
        l.Position = UDim2.new(0.5, 0, 0, 0)
        l.BackgroundColor3 = theme.Background
        l.BorderSizePixel = 0
    end
    tab:_addElement(f)
    return f
end

function Elements.Space(tab, h)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, h or 10)
    f.BackgroundTransparency = 1
    tab:_addElement(f)
    return f
end

function Elements.inject(Tab)
    function Tab:Button(cfg) return Elements.Button(self, cfg) end
    function Tab:Toggle(cfg) return Elements.Toggle(self, cfg) end
    function Tab:Slider(cfg) return Elements.Slider(self, cfg) end
    function Tab:Input(cfg) return Elements.Input(self, cfg) end
    function Tab:Dropdown(cfg) return Elements.Dropdown(self, cfg) end
    function Tab:Section(cfg) return Elements.Section(self, cfg) end
    function Tab:Card(cfg) return Elements.Card(self, cfg) end
    function Tab:Paragraph(cfg) return Elements.Paragraph(self, cfg) end
    function Tab:Label(cfg) return Elements.Label(self, cfg) end
    function Tab:Divider(cfg) return Elements.Divider(self, cfg) end
    function Tab:Space(h) return Elements.Space(self, h) end
    function Tab:UserProfile(cfg) return Elements.UserProfile(self, cfg) end
end

return Elements

end)()


-- Notify intégré pour la version dist/main.lua
local notifyActive = 0
local MAX_NOTIF = 4
local typeColors = {
    success = Color3.fromRGB(60, 180, 100),
    error   = Color3.fromRGB(200, 60, 60),
    warn    = Color3.fromRGB(220, 160, 40),
    info    = Color3.fromRGB(80, 140, 220),
}
local typeIcons = { success = "✓", error = "✕", warn = "!", info = "i" }

TryxLib._notify = function(gui, cfg, theme)
    cfg = cfg or {}
    if notifyActive >= MAX_NOTIF then return end
    notifyActive += 1

    local TweenService = game:GetService("TweenService")
    local function tw(obj, props, t)
        pcall(function()
            TweenService:Create(obj, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
        end)
    end
    local function corner(p, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = r or UDim.new(0, 8)
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

    local title = cfg.Title or ""
    local desc = cfg.Desc or cfg.Content or ""
    local ntype = cfg.Type or "info"
    local duration = cfg.Duration or 4
    local accent = cfg.Color or typeColors[ntype] or theme.Accent
    local icon = cfg.Icon or typeIcons[ntype] or "i"

    local container = gui:FindFirstChild("__NotifyContainer")
    if not container then
        container = Instance.new("Frame")
        container.Name = "__NotifyContainer"
        container.Size = UDim2.new(0, 290, 1, 0)
        container.Position = UDim2.new(1, -302, 0, 0)
        container.BackgroundTransparency = 1
        container.BorderSizePixel = 0
        container.ZIndex = 9500
        container.Parent = gui

        local lay = Instance.new("UIListLayout")
        lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
        lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
        lay.Padding = UDim.new(0, 6)
        lay.Parent = container

        local pad = Instance.new("UIPadding")
        pad.PaddingBottom = UDim.new(0, 14)
        pad.Parent = container
    end

    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 0)
    n.BackgroundColor3 = theme.Notify or theme.Element
    n.BorderSizePixel = 0
    n.ClipsDescendants = true
    n.ZIndex = 9501
    n.Parent = container
    corner(n, UDim.new(0, 8))
    stroke(n, theme.NotifyStroke or theme.ElementStroke, 1)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, 0)
    bar.BackgroundColor3 = accent
    bar.BorderSizePixel = 0
    bar.ZIndex = 9502
    bar.Parent = n
    corner(bar, UDim.new(0, 2))

    local ic = Instance.new("TextLabel")
    ic.Size = UDim2.new(0, 28, 0, 28)
    ic.Position = UDim2.new(0, 14, 0.5, -14)
    ic.BackgroundColor3 = accent
    ic.Text = icon
    ic.TextColor3 = Color3.fromRGB(255, 255, 255)
    ic.TextSize = 13
    ic.Font = Enum.Font.GothamBold
    ic.TextXAlignment = Enum.TextXAlignment.Center
    ic.BorderSizePixel = 0
    ic.ZIndex = 9502
    ic.Parent = n
    corner(ic, UDim.new(1, 0))

    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, -58, 0, 18)
    tl.Position = UDim2.new(0, 50, 0, 10)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.TextColor3 = theme.TextPrimary
    tl.TextSize = 13
    tl.Font = Enum.Font.GothamBold
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.TextTruncate = Enum.TextTruncate.AtEnd
    tl.ZIndex = 9502
    tl.Parent = n

    local dl = Instance.new("TextLabel")
    dl.Size = UDim2.new(1, -58, 0, 16)
    dl.Position = UDim2.new(0, 50, 0, 29)
    dl.BackgroundTransparency = 1
    dl.Text = desc
    dl.TextColor3 = theme.TextSecondary
    dl.TextSize = 11
    dl.Font = Enum.Font.Gotham
    dl.TextXAlignment = Enum.TextXAlignment.Left
    dl.TextTruncate = Enum.TextTruncate.AtEnd
    dl.ZIndex = 9502
    dl.Parent = n

    local prog = Instance.new("Frame")
    prog.Size = UDim2.new(1, 0, 0, 2)
    prog.Position = UDim2.new(0, 0, 1, -2)
    prog.BackgroundColor3 = accent
    prog.BorderSizePixel = 0
    prog.ZIndex = 9503
    prog.Parent = n

    local function dismiss()
        if not n.Parent then return end
        tw(n, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
        task.wait(0.15)
        if n then n:Destroy() end
        notifyActive = math.max(0, notifyActive - 1)
    end

    tw(n, { Size = UDim2.new(1, 0, 0, 64) }, 0.18)
    tw(prog, { Size = UDim2.new(0, 0, 0, 2) }, duration)
    task.delay(duration, dismiss)

    local click = Instance.new("TextButton")
    click.Size = UDim2.fromScale(1, 1)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.ZIndex = 9504
    click.Parent = n
    click.MouseButton1Click:Connect(dismiss)
end


local __CreateWindow = TryxLib.CreateWindow
function TryxLib:CreateWindow(config)
    local Window = __CreateWindow(self, config)
    local __Tab = Window.Tab
    function Window:Tab(cfg)
        local Tab = __Tab(Window, cfg)
        Elements.inject(Tab)
        return Tab
    end
    return Window
end

return TryxLib
