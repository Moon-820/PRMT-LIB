-- TryxLib | dist/main.lua
-- Version compilée — loadstring(game:HttpGet("URL"))()
-- © TryxHub — Moon820
-- Build corrigé : mobile responsive, drag/touch, slider mobile, dropdown overlay, custom elements.

local TryxLib = (function()
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
        iconLbl.Visible = (tabIcon ~= "")

        local titleLbl = label(tabBtn, tabTitle, theme.TextSecondary, isMobile and 11 or 12, Enum.Font.GothamMedium)
        titleLbl.Size = UDim2.new(1, -20, 1, 0)

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

end)()

local Elements = (function()
-- TryxLib | Elements.lua
-- Button, Toggle, Input, Slider, Dropdown, Paragraph, Divider, Space, Section, Label, Card
-- Version améliorée : support mobile, dropdown au premier plan, personnalisation étendue.

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ELEMENT_H  = 44
local CORNER_R   = UDim.new(0, 7)
local ANIM       = 0.14
local TOP_Z      = 1000

local function safeColor(value, fallback)
    if typeof(value) == "Color3" then return value end
    return fallback
end

local function clampNumber(value, minValue, maxValue)
    value = tonumber(value) or minValue
    return math.clamp(value, minValue, maxValue)
end

local function tween(obj, props, t)
    local ok = pcall(function()
        TweenService:Create(obj, TweenInfo.new(t or ANIM, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
    end)
    return ok
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER_R
    c.Parent = p
    return c
end

local function stroke(p, col, th, transparency)
    local s = Instance.new("UIStroke")
    s.Color = col
    s.Thickness = th or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function padding(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop = UDim.new(0, t or 6)
    u.PaddingBottom = UDim.new(0, b or 6)
    u.PaddingLeft = UDim.new(0, l or 12)
    u.PaddingRight = UDim.new(0, r or 12)
    u.Parent = p
    return u
end

local function setZRecursive(obj, z)
    if obj:IsA("GuiObject") then
        obj.ZIndex = z
    end
    for _, child in ipairs(obj:GetChildren()) do
        setZRecursive(child, z + 1)
    end
end

local function cfgTransparency(cfg, key, fallback)
    local v = cfg[key]
    if v == nil then v = cfg.Transparency end
    if v == nil then v = fallback or 0 end
    return clampNumber(v, 0, 1)
end

local function resolveTheme(theme)
    theme = theme or {}
    return {
        Background    = theme.Background    or Color3.fromRGB(18, 18, 22),
        Element       = theme.Element       or Color3.fromRGB(30, 30, 36),
        ElementHover  = theme.ElementHover  or Color3.fromRGB(38, 38, 45),
        ElementStroke = theme.ElementStroke or Color3.fromRGB(55, 55, 65),
        Accent        = theme.Accent        or Color3.fromRGB(120, 92, 255),
        AccentDark    = theme.AccentDark    or Color3.fromRGB(84, 60, 200),
        TextPrimary   = theme.TextPrimary   or Color3.fromRGB(245, 245, 250),
        TextSecondary = theme.TextSecondary or Color3.fromRGB(175, 175, 185),
        TextDisabled  = theme.TextDisabled  or Color3.fromRGB(115, 115, 125),
    }
end

local function baseFrame(theme, h, cfg)
    cfg = cfg or {}
    local f = Instance.new("Frame")
    f.Size                   = UDim2.new(1, 0, 0, h or cfg.Height or ELEMENT_H)
    f.BackgroundColor3       = safeColor(cfg.Color or cfg.BackgroundColor, theme.Element)
    f.BackgroundTransparency = cfgTransparency(cfg, "BackgroundTransparency", 0)
    f.BorderSizePixel        = 0
    f.ClipsDescendants       = cfg.ClipsDescendants == true
    corner(f, cfg.Radius or cfg.CornerRadius or CORNER_R)
    stroke(
        f,
        safeColor(cfg.StrokeColor, theme.ElementStroke),
        cfg.StrokeThickness or 1,
        cfg.StrokeTransparency or 0
    )
    return f
end

local function makeLabel(parent, props)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.BorderSizePixel = 0
    lbl.Size = props.Size or UDim2.new(1, 0, 0, 16)
    lbl.Position = props.Position or UDim2.new(0, 0, 0, 0)
    lbl.Text = props.Text or ""
    lbl.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
    lbl.TextSize = props.TextSize or 12
    lbl.Font = props.Font or Enum.Font.Gotham
    lbl.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    lbl.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
    lbl.TextWrapped = props.TextWrapped == true
    lbl.TextTruncate = props.TextTruncate or Enum.TextTruncate.None
    lbl.AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.None
    lbl.ZIndex = props.ZIndex or parent.ZIndex
    lbl.Parent = parent
    return lbl
end

local function titleDesc(parent, theme, title, desc, offsetRight, cfg)
    cfg = cfg or {}
    offsetRight = offsetRight or 0

    local hasDesc = desc and desc ~= ""
    local titleY = hasDesc and (cfg.TitleY or 8) or (cfg.TitleYNoDesc or 0)
    local titleH = hasDesc and 16 or parent.AbsoluteSize.Y

    local titleLbl = makeLabel(parent, {
        Size = UDim2.new(1, -offsetRight, 0, hasDesc and 16 or ELEMENT_H),
        Position = UDim2.new(0, 0, 0, titleY),
        Text = title or "",
        TextColor3 = safeColor(cfg.TextColor or cfg.TitleColor, theme.TextPrimary),
        TextSize = cfg.TitleSize or 13,
        Font = cfg.TitleFont or Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = hasDesc and Enum.TextYAlignment.Center or Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    if hasDesc then
        makeLabel(parent, {
            Size = UDim2.new(1, -offsetRight, 0, 14),
            Position = UDim2.new(0, 0, 0, cfg.DescY or 26),
            Text = desc,
            TextColor3 = safeColor(cfg.DescColor, theme.TextSecondary),
            TextSize = cfg.DescSize or 11,
            Font = cfg.DescFont or Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
    end

    return titleLbl
end

local function isPressInput(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

local function isMoveInput(input)
    return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

local function roundToStep(value, step)
    step = tonumber(step) or 1
    if step <= 0 then return value end
    return math.floor((value / step) + 0.5) * step
end

local function formatNumber(value, decimals)
    decimals = tonumber(decimals) or 0
    if decimals <= 0 then
        return tostring(math.floor(value + 0.5))
    end
    return string.format("%." .. decimals .. "f", value)
end

local Elements = {}

-- ─── BUTTON ───────────────────────────────────────────────────────────────────
function Elements.Button(tab, cfg)
    cfg = cfg or {}
    local theme    = resolveTheme(tab._theme)
    local title    = cfg.Title or cfg.Name or "Button"
    local desc     = cfg.Desc or cfg.Description or ""
    local callback = cfg.Callback or function() end

    local height = cfg.Height or (desc ~= "" and 44 or ELEMENT_H)
    local f = baseFrame(theme, height, cfg)
    padding(f, cfg.PaddingTop or 0, cfg.PaddingBottom or 0, cfg.PaddingLeft or 12, cfg.PaddingRight or 12)

    titleDesc(f, theme, title, desc, cfg.Icon and 64 or 36, cfg)

    local arrowText = cfg.Arrow == false and "" or (cfg.ArrowText or "›")
    local arrow = makeLabel(f, {
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        Text = arrowText,
        TextColor3 = safeColor(cfg.AccentColor, theme.Accent),
        TextSize = cfg.ArrowSize or 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    if cfg.Icon then
        makeLabel(f, {
            Size = UDim2.new(0, 22, 1, 0),
            Position = UDim2.new(1, -58, 0, 0),
            Text = tostring(cfg.Icon),
            TextColor3 = safeColor(cfg.IconColor, theme.TextSecondary),
            TextSize = cfg.IconSize or 14,
            Font = cfg.IconFont or Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = f.ZIndex + 5
    btn.Parent = f

    btn.MouseEnter:Connect(function()
        tween(f, { BackgroundColor3 = safeColor(cfg.HoverColor, theme.ElementHover) })
    end)
    btn.MouseLeave:Connect(function()
        tween(f, { BackgroundColor3 = safeColor(cfg.Color or cfg.BackgroundColor, theme.Element) })
    end)
    btn.MouseButton1Down:Connect(function()
        tween(f, { BackgroundColor3 = safeColor(cfg.ActiveColor, theme.AccentDark) })
    end)
    btn.MouseButton1Up:Connect(function()
        tween(f, { BackgroundColor3 = safeColor(cfg.HoverColor, theme.ElementHover) })
    end)
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)

    tab:_addElement(f)
    return f
end

-- ─── TOGGLE ───────────────────────────────────────────────────────────────────
function Elements.Toggle(tab, cfg)
    cfg = cfg or {}
    local theme    = resolveTheme(tab._theme)
    local title    = cfg.Title or cfg.Name or "Toggle"
    local desc     = cfg.Desc or cfg.Description or ""
    local value    = cfg.Value ~= nil and cfg.Value or (cfg.Default ~= nil and cfg.Default or false)
    local callback = cfg.Callback or function() end
    local toggleType = string.lower(tostring(cfg.Type or "Default"))

    local f = baseFrame(theme, cfg.Height or ELEMENT_H, cfg)
    padding(f, cfg.PaddingTop or 0, cfg.PaddingBottom or 0, cfg.PaddingLeft or 12, cfg.PaddingRight or 12)
    titleDesc(f, theme, title, desc, 58, cfg)

    local indicator
    local thumb
    local check

    if toggleType == "checkbox" or toggleType == "check" then
        indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, cfg.BoxSize or 22, 0, cfg.BoxSize or 22)
        indicator.Position = UDim2.new(1, -(cfg.BoxSize or 22) - 12, 0.5, -((cfg.BoxSize or 22) / 2))
        indicator.BackgroundColor3 = value and safeColor(cfg.ActiveColor, theme.Accent) or safeColor(cfg.BoxColor, theme.Background)
        indicator.BackgroundTransparency = cfg.BoxTransparency or 0
        indicator.BorderSizePixel = 0
        indicator.Parent = f
        corner(indicator, cfg.BoxRadius or UDim.new(0, 5))
        stroke(indicator, safeColor(cfg.BoxStrokeColor, theme.ElementStroke), cfg.BoxStrokeThickness or 1)

        check = makeLabel(indicator, {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.new(0, 0, 0, 0),
            Text = cfg.Checkmark or "✓",
            TextColor3 = safeColor(cfg.CheckColor, Color3.fromRGB(255, 255, 255)),
            TextSize = cfg.CheckSize or 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        check.TextTransparency = value and 0 or 1
    else
        indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, cfg.TrackWidth or 36, 0, cfg.TrackHeight or 20)
        indicator.Position = UDim2.new(1, -(cfg.TrackWidth or 36) - 10, 0.5, -((cfg.TrackHeight or 20) / 2))
        indicator.BackgroundColor3 = value and safeColor(cfg.ActiveColor, theme.Accent) or safeColor(cfg.InactiveColor, theme.ElementStroke)
        indicator.BackgroundTransparency = cfg.TrackTransparency or 0
        indicator.BorderSizePixel = 0
        indicator.Parent = f
        corner(indicator, cfg.TrackRadius or UDim.new(1, 0))

        local thumbSize = cfg.ThumbSize or 14
        thumb = Instance.new("Frame")
        thumb.Size = UDim2.new(0, thumbSize, 0, thumbSize)
        thumb.Position = value and UDim2.new(1, -thumbSize - 3, 0.5, -(thumbSize / 2)) or UDim2.new(0, 3, 0.5, -(thumbSize / 2))
        thumb.BackgroundColor3 = safeColor(cfg.ThumbColor, Color3.fromRGB(255, 255, 255))
        thumb.BackgroundTransparency = cfg.ThumbTransparency or 0
        thumb.BorderSizePixel = 0
        thumb.Parent = indicator
        corner(thumb, cfg.ThumbRadius or UDim.new(1, 0))
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = f.ZIndex + 5
    btn.Parent = f

    local function render(skipCallback)
        if toggleType == "checkbox" or toggleType == "check" then
            tween(indicator, { BackgroundColor3 = value and safeColor(cfg.ActiveColor, theme.Accent) or safeColor(cfg.BoxColor, theme.Background) })
            tween(check, { TextTransparency = value and 0 or 1 })
        else
            local thumbSize = cfg.ThumbSize or 14
            tween(indicator, { BackgroundColor3 = value and safeColor(cfg.ActiveColor, theme.Accent) or safeColor(cfg.InactiveColor, theme.ElementStroke) })
            tween(thumb, { Position = value and UDim2.new(1, -thumbSize - 3, 0.5, -(thumbSize / 2)) or UDim2.new(0, 3, 0.5, -(thumbSize / 2)) })
        end
        if not skipCallback then pcall(callback, value) end
    end

    btn.MouseEnter:Connect(function()
        tween(f, { BackgroundColor3 = safeColor(cfg.HoverColor, theme.ElementHover) })
    end)
    btn.MouseLeave:Connect(function()
        tween(f, { BackgroundColor3 = safeColor(cfg.Color or cfg.BackgroundColor, theme.Element) })
    end)
    btn.MouseButton1Click:Connect(function()
        value = not value
        render(false)
    end)

    tab:_addElement(f)

    local obj = {}
    function obj:Set(v)
        value = not not v
        render(false)
    end
    function obj:Get() return value end
    function obj:Destroy() f:Destroy() end
    return obj
end

-- ─── INPUT ────────────────────────────────────────────────────────────────────
function Elements.Input(tab, cfg)
    cfg = cfg or {}
    local theme       = resolveTheme(tab._theme)
    local title       = cfg.Title or cfg.Name or "Input"
    local desc        = cfg.Desc or cfg.Description or ""
    local placeholder = cfg.Placeholder or "Type here..."
    local default     = cfg.Value or cfg.Default or ""
    local callback    = cfg.Callback or function() end

    local height = cfg.Height or (desc ~= "" and 84 or 70)
    local f = baseFrame(theme, height, cfg)
    padding(f, cfg.PaddingTop or 0, cfg.PaddingBottom or 0, cfg.PaddingLeft or 12, cfg.PaddingRight or 12)

    titleDesc(f, theme, title, desc, 0, {
        TitleY = 7,
        DescY = 23,
        TextColor = cfg.TextColor,
        DescColor = cfg.DescColor,
        TitleSize = cfg.TitleSize,
        DescSize = cfg.DescSize,
    })

    local boxY = desc ~= "" and 48 or 30
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, cfg.BoxHeight or 28)
    box.Position = UDim2.new(0, 0, 0, boxY)
    box.BackgroundColor3 = safeColor(cfg.BoxColor, theme.Background)
    box.BackgroundTransparency = cfg.BoxTransparency or 0
    box.BorderSizePixel = 0
    box.Parent = f
    corner(box, cfg.BoxRadius or UDim.new(0, 5))
    stroke(box, safeColor(cfg.BoxStrokeColor, theme.ElementStroke), cfg.BoxStrokeThickness or 1)

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -12, 1, 0)
    input.Position = UDim2.new(0, 6, 0, 0)
    input.BackgroundTransparency = 1
    input.Text = tostring(default)
    input.PlaceholderText = placeholder
    input.TextColor3 = safeColor(cfg.InputTextColor, theme.TextPrimary)
    input.PlaceholderColor3 = safeColor(cfg.PlaceholderColor, theme.TextDisabled)
    input.TextSize = cfg.InputTextSize or 12
    input.Font = cfg.InputFont or Enum.Font.Gotham
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.ClearTextOnFocus = cfg.ClearTextOnFocus == true
    input.MultiLine = cfg.MultiLine == true
    input.TextEditable = cfg.Disabled ~= true
    input.Parent = box

    input.Focused:Connect(function()
        tween(box, { BackgroundColor3 = safeColor(cfg.BoxFocusColor, theme.ElementHover) })
        local st = box:FindFirstChildOfClass("UIStroke")
        if st then tween(st, { Color = safeColor(cfg.FocusStrokeColor, theme.Accent) }) end
    end)
    input.FocusLost:Connect(function(enter)
        tween(box, { BackgroundColor3 = safeColor(cfg.BoxColor, theme.Background) })
        local st = box:FindFirstChildOfClass("UIStroke")
        if st then tween(st, { Color = safeColor(cfg.BoxStrokeColor, theme.ElementStroke) }) end
        if enter or cfg.CallbackOnEnter == false then pcall(callback, input.Text) end
    end)

    if cfg.CallbackOnChange ~= false then
        input:GetPropertyChangedSignal("Text"):Connect(function()
            pcall(callback, input.Text)
        end)
    end

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return input.Text end
    function obj:Set(v) input.Text = tostring(v or "") end
    function obj:Focus() input:CaptureFocus() end
    function obj:Destroy() f:Destroy() end
    return obj
end

-- ─── SLIDER ───────────────────────────────────────────────────────────────────
function Elements.Slider(tab, cfg)
    cfg = cfg or {}
    local theme    = resolveTheme(tab._theme)
    local title    = cfg.Title or cfg.Name or "Slider"
    local desc     = cfg.Desc or cfg.Description or ""
    local min      = tonumber(cfg.Min) or 0
    local max      = tonumber(cfg.Max) or 100
    if max == min then max = min + 1 end
    local step     = tonumber(cfg.Step or cfg.Increment) or 1
    local decimals = tonumber(cfg.Decimals) or (step < 1 and 2 or 0)
    local value    = tonumber(cfg.Value or cfg.Default) or min
    local suffix   = cfg.Suffix or ""
    local prefix   = cfg.Prefix or ""
    local callback = cfg.Callback or function() end

    value = math.clamp(roundToStep(value, step), min, max)

    local height = cfg.Height or (desc ~= "" and 76 or 60)
    local f = baseFrame(theme, height, cfg)
    padding(f, cfg.PaddingTop or 0, cfg.PaddingBottom or 0, cfg.PaddingLeft or 12, cfg.PaddingRight or 12)

    local valLbl = makeLabel(f, {
        Size = UDim2.new(0, cfg.ValueWidth or 64, 0, 16),
        Position = UDim2.new(1, -(cfg.ValueWidth or 64), 0, 8),
        Text = prefix .. formatNumber(value, decimals) .. suffix,
        TextColor3 = safeColor(cfg.ValueColor, theme.Accent),
        TextSize = cfg.ValueSize or 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
    })

    titleDesc(f, theme, title, desc, (cfg.ValueWidth or 64) + 8, {
        TitleY = 7,
        DescY = 23,
        TextColor = cfg.TextColor,
        DescColor = cfg.DescColor,
        TitleSize = cfg.TitleSize,
        DescSize = cfg.DescSize,
    })

    local trackY = desc ~= "" and 56 or 38
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, cfg.TrackHeight or 6)
    track.Position = UDim2.new(0, 0, 0, trackY)
    track.BackgroundColor3 = safeColor(cfg.TrackColor, theme.ElementStroke)
    track.BackgroundTransparency = cfg.TrackTransparency or 0
    track.BorderSizePixel = 0
    track.Active = true
    track.Parent = f
    corner(track, cfg.TrackRadius or UDim.new(1, 0))

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = safeColor(cfg.FillColor or cfg.AccentColor, theme.Accent)
    fill.BackgroundTransparency = cfg.FillTransparency or 0
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, cfg.TrackRadius or UDim.new(1, 0))

    local thumbSize = cfg.ThumbSize or 14
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, thumbSize, 0, thumbSize)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
    thumb.BackgroundColor3 = safeColor(cfg.ThumbColor, Color3.fromRGB(255, 255, 255))
    thumb.BackgroundTransparency = cfg.ThumbTransparency or 0
    thumb.BorderSizePixel = 0
    thumb.Active = true
    thumb.ZIndex = track.ZIndex + 3
    thumb.Parent = track
    corner(thumb, cfg.ThumbRadius or UDim.new(1, 0))
    if cfg.ThumbStroke ~= false then
        stroke(thumb, safeColor(cfg.ThumbStrokeColor, theme.Background), cfg.ThumbStrokeThickness or 1)
    end

    local dragging = false

    local function render(call)
        local pct = (value - min) / (max - min)
        pct = math.clamp(pct, 0, 1)
        tween(fill,  { Size = UDim2.new(pct, 0, 1, 0) }, 0.05)
        tween(thumb, { Position = UDim2.new(pct, 0, 0.5, 0) }, 0.05)
        valLbl.Text = prefix .. formatNumber(value, decimals) .. suffix
        if call then pcall(callback, value) end
    end

    local function updateSlider(inputX)
        local trackAbs = track.AbsolutePosition.X
        local trackW = math.max(track.AbsoluteSize.X, 1)
        local rel = math.clamp((inputX - trackAbs) / trackW, 0, 1)
        value = math.clamp(roundToStep(min + rel * (max - min), step), min, max)
        render(true)
    end

    local function beginDrag(input)
        if isPressInput(input) then
            dragging = true
            updateSlider(input.Position.X)
        end
    end

    track.InputBegan:Connect(beginDrag)
    thumb.InputBegan:Connect(beginDrag)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and isMoveInput(input) then
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return value end
    function obj:Set(v)
        value = math.clamp(roundToStep(tonumber(v) or min, step), min, max)
        render(false)
    end
    function obj:Destroy() f:Destroy() end
    return obj
end

-- ─── DROPDOWN ─────────────────────────────────────────────────────────────────
function Elements.Dropdown(tab, cfg)
    cfg = cfg or {}
    local theme    = resolveTheme(tab._theme)
    local title    = cfg.Title or cfg.Name or "Dropdown"
    local desc     = cfg.Desc or cfg.Description or ""
    local values   = cfg.Values or cfg.Options or {}
    local value    = cfg.Value or cfg.Default or (values[1] or "")
    local callback = cfg.Callback or function() end
    local open = false

    local width = cfg.Width or 120
    local itemHeight = cfg.ItemHeight or 28
    local maxVisible = cfg.MaxVisible or cfg.VisibleItems or 6
    local listPad = 8

    local f = baseFrame(theme, cfg.Height or ELEMENT_H, cfg)
    f.ClipsDescendants = false
    padding(f, cfg.PaddingTop or 0, cfg.PaddingBottom or 0, cfg.PaddingLeft or 12, cfg.PaddingRight or 12)
    titleDesc(f, theme, title, desc, width + 18, cfg)

    local selBox = Instance.new("Frame")
    selBox.Size = UDim2.new(0, width, 0, cfg.BoxHeight or 26)
    selBox.Position = UDim2.new(1, -width - 8, 0.5, -((cfg.BoxHeight or 26) / 2))
    selBox.BackgroundColor3 = safeColor(cfg.BoxColor, theme.Background)
    selBox.BackgroundTransparency = cfg.BoxTransparency or 0
    selBox.BorderSizePixel = 0
    selBox.Parent = f
    corner(selBox, cfg.BoxRadius or UDim.new(0, 5))
    stroke(selBox, safeColor(cfg.BoxStrokeColor, theme.ElementStroke), cfg.BoxStrokeThickness or 1)

    local selLbl = makeLabel(selBox, {
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Text = tostring(value),
        TextColor3 = safeColor(cfg.SelectedColor, theme.TextPrimary),
        TextSize = cfg.SelectedSize or 12,
        Font = cfg.SelectedFont or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    local chevron = makeLabel(selBox, {
        Size = UDim2.new(0, 18, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        Text = cfg.Chevron or "v",
        TextColor3 = safeColor(cfg.ChevronColor, theme.TextSecondary),
        TextSize = cfg.ChevronSize or 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
    })

    local useOverlay = tab._overlay ~= nil
    local list = Instance.new("Frame")
    list.Name = "DropList"
    list.Size = UDim2.new(0, width, 0, 0)
    list.Position = useOverlay and UDim2.new(0, 0, 0, 0) or UDim2.new(1, -width - 8, 0, (cfg.Height or ELEMENT_H) + 2)
    list.BackgroundColor3 = safeColor(cfg.ListColor, theme.Element)
    list.BackgroundTransparency = cfg.ListTransparency or 0
    list.BorderSizePixel = 0
    list.ClipsDescendants = true
    list.Visible = false
    list.ZIndex = TOP_Z + 1
    list.Parent = useOverlay and tab._overlay or f
    corner(list, cfg.ListRadius or CORNER_R)
    stroke(list, safeColor(cfg.ListStrokeColor, theme.ElementStroke), cfg.ListStrokeThickness or 1)

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, cfg.ItemPadding or 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = list
    padding(list, 4, 4, 4, 4)

    local function positionList()
        if not useOverlay then return end
        local abs = selBox.AbsolutePosition
        local size = selBox.AbsoluteSize
        list.Position = UDim2.new(0, abs.X, 0, abs.Y + size.Y + 4)
    end

    local function closeDropdown()
        open = false
        tween(list, { Size = UDim2.new(0, width, 0, 0) })
        tween(chevron, { Rotation = 0 })
        task.delay(ANIM, function()
            if not open then
                list.Visible = false
                if not useOverlay then setZRecursive(f, 1) end
            end
        end)
    end

    local function openDropdown()
        open = true
        positionList()
        list.Visible = true
        if not useOverlay then setZRecursive(f, TOP_Z) end
        list.ZIndex = TOP_Z + 10
        for _, child in ipairs(list:GetDescendants()) do
            if child:IsA("GuiObject") then child.ZIndex = TOP_Z + 11 end
        end
        local itemCount = #values
        local visibleCount = math.min(itemCount, maxVisible)
        local listH = visibleCount * itemHeight + listPad + math.max(visibleCount - 1, 0) * (cfg.ItemPadding or 2)
        tween(list, { Size = UDim2.new(0, width, 0, listH) })
        tween(chevron, { Rotation = 180 })
    end

    local function buildList()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for i, v in ipairs(values) do
            local item = Instance.new("TextButton")
            item.Name = "Item_" .. tostring(i)
            item.Size = UDim2.new(1, 0, 0, itemHeight)
            item.BackgroundColor3 = v == value and safeColor(cfg.ItemSelectedColor, theme.ElementHover) or safeColor(cfg.ItemColor, theme.Element)
            item.BackgroundTransparency = cfg.ItemTransparency or 0
            item.Text = tostring(v)
            item.TextColor3 = v == value and safeColor(cfg.ItemSelectedTextColor, theme.Accent) or safeColor(cfg.ItemTextColor, theme.TextPrimary)
            item.TextSize = cfg.ItemTextSize or 12
            item.Font = cfg.ItemFont or Enum.Font.Gotham
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.BorderSizePixel = 0
            item.AutoButtonColor = false
            item.ZIndex = TOP_Z + 11
            item.LayoutOrder = i
            item.Parent = list
            corner(item, cfg.ItemRadius or UDim.new(0, 4))
            padding(item, 0, 0, cfg.ItemTextPadding or 8, cfg.ItemTextPadding or 8)

            item.MouseEnter:Connect(function()
                tween(item, { BackgroundColor3 = safeColor(cfg.ItemHoverColor, theme.ElementHover) }, 0.08)
            end)
            item.MouseLeave:Connect(function()
                tween(item, { BackgroundColor3 = v == value and safeColor(cfg.ItemSelectedColor, theme.ElementHover) or safeColor(cfg.ItemColor, theme.Element) }, 0.08)
            end)
            item.MouseButton1Click:Connect(function()
                value = v
                selLbl.Text = tostring(v)
                closeDropdown()
                buildList()
                pcall(callback, value)
            end)
        end
    end

    buildList()

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, cfg.Height or ELEMENT_H)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = f.ZIndex + 5
    btn.Parent = f

    btn.MouseButton1Click:Connect(function()
        if open then closeDropdown() else openDropdown() end
    end)
    btn.MouseEnter:Connect(function()
        tween(f, { BackgroundColor3 = safeColor(cfg.HoverColor, theme.ElementHover) })
    end)
    btn.MouseLeave:Connect(function()
        if not open then tween(f, { BackgroundColor3 = safeColor(cfg.Color or cfg.BackgroundColor, theme.Element) }) end
    end)

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return value end
    function obj:Set(v)
        value = v
        selLbl.Text = tostring(v)
        buildList()
    end
    function obj:Refresh(newValues, newValue)
        values = newValues or {}
        if newValue ~= nil then
            value = newValue
        elseif not table.find(values, value) then
            value = values[1] or ""
        end
        selLbl.Text = tostring(value)
        buildList()
        if open then openDropdown() end
    end
    function obj:Close() closeDropdown() end
    function obj:Destroy()
        if list then list:Destroy() end
        f:Destroy()
    end
    return obj
end

-- ─── PARAGRAPH ────────────────────────────────────────────────────────────────
function Elements.Paragraph(tab, cfg)
    cfg = cfg or {}
    local theme = resolveTheme(tab._theme)
    local title = cfg.Title or ""
    local desc  = cfg.Desc or cfg.Text or cfg.Description or ""

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = safeColor(cfg.Color or cfg.BackgroundColor, theme.Element)
    f.BackgroundTransparency = cfgTransparency(cfg, "BackgroundTransparency", 0)
    f.BorderSizePixel = 0
    f.ClipsDescendants = false
    corner(f, cfg.Radius or cfg.CornerRadius or CORNER_R)
    stroke(f, safeColor(cfg.StrokeColor, theme.ElementStroke), cfg.StrokeThickness or 1, cfg.StrokeTransparency or 0)
    padding(f, cfg.PaddingTop or 10, cfg.PaddingBottom or 10, cfg.PaddingLeft or 12, cfg.PaddingRight or 12)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, cfg.Gap or 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = f

    if title ~= "" then
        local t = makeLabel(f, {
            Size = UDim2.new(1, 0, 0, 16),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = title,
            TextColor3 = safeColor(cfg.TitleColor or cfg.TextColor, theme.TextPrimary),
            TextSize = cfg.TitleSize or 13,
            Font = cfg.TitleFont or Enum.Font.GothamBold,
            TextWrapped = true,
        })
        t.LayoutOrder = 1
    end

    if desc ~= "" then
        local d = makeLabel(f, {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = desc,
            TextColor3 = safeColor(cfg.DescColor, theme.TextSecondary),
            TextSize = cfg.DescSize or 12,
            Font = cfg.DescFont or Enum.Font.Gotham,
            TextWrapped = true,
        })
        d.LayoutOrder = 2
    end

    tab:_addElement(f)
    return f
end

-- ─── SECTION / FRAME / CARD ──────────────────────────────────────────────────
function Elements.Section(tab, cfg)
    cfg = cfg or {}
    local theme = resolveTheme(tab._theme)
    local title = cfg.Title or cfg.Name or "Section"
    local desc = cfg.Desc or cfg.Description or ""

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = safeColor(cfg.Color or cfg.BackgroundColor, theme.Element)
    f.BackgroundTransparency = cfgTransparency(cfg, "BackgroundTransparency", 0.12)
    f.BorderSizePixel = 0
    corner(f, cfg.Radius or cfg.CornerRadius or UDim.new(0, 10))
    stroke(f, safeColor(cfg.StrokeColor, theme.ElementStroke), cfg.StrokeThickness or 1, cfg.StrokeTransparency or 0)
    padding(f, cfg.PaddingTop or 12, cfg.PaddingBottom or 12, cfg.PaddingLeft or 12, cfg.PaddingRight or 12)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, cfg.Gap or 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = f

    local titleLbl = makeLabel(f, {
        Size = UDim2.new(1, 0, 0, 18),
        AutomaticSize = Enum.AutomaticSize.Y,
        Text = title,
        TextColor3 = safeColor(cfg.TitleColor or cfg.TextColor, theme.TextPrimary),
        TextSize = cfg.TitleSize or 14,
        Font = cfg.TitleFont or Enum.Font.GothamBold,
        TextWrapped = true,
    })
    titleLbl.LayoutOrder = 1

    if desc ~= "" then
        local descLbl = makeLabel(f, {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = desc,
            TextColor3 = safeColor(cfg.DescColor, theme.TextSecondary),
            TextSize = cfg.DescSize or 12,
            Font = cfg.DescFont or Enum.Font.Gotham,
            TextWrapped = true,
        })
        descLbl.LayoutOrder = 2
    end

    tab:_addElement(f)

    local sectionObj = {}
    sectionObj._page = f
    sectionObj._theme = tab._theme
    sectionObj._overlay = tab._overlay
    sectionObj._gui = tab._gui
    sectionObj._window = tab._window
    sectionObj._isMobile = tab._isMobile

    function sectionObj:_addElement(elem)
        elem.Parent = f
    end

    Elements.inject(sectionObj)

    function sectionObj:Destroy() f:Destroy() end
    function sectionObj:SetTitle(t) titleLbl.Text = t end

    return sectionObj
end

Elements.Frame = Elements.Section
Elements.Card = Elements.Section

-- ─── LABEL ───────────────────────────────────────────────────────────────────
function Elements.Label(tab, cfg)
    cfg = cfg or {}
    local theme = resolveTheme(tab._theme)
    local text = cfg.Text or cfg.Title or "Label"

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, cfg.Height or 24)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0

    local lbl = makeLabel(f, {
        Size = UDim2.fromScale(1, 1),
        Position = UDim2.new(0, 0, 0, 0),
        Text = text,
        TextColor3 = safeColor(cfg.TextColor, theme.TextSecondary),
        TextSize = cfg.TextSize or 12,
        Font = cfg.Font or Enum.Font.Gotham,
        TextXAlignment = cfg.Align or Enum.TextXAlignment.Left,
        TextWrapped = cfg.Wrapped == true,
    })

    tab:_addElement(f)

    local obj = {}
    function obj:Set(v) lbl.Text = tostring(v or "") end
    function obj:Get() return lbl.Text end
    function obj:Destroy() f:Destroy() end
    return obj
end

-- ─── DIVIDER ──────────────────────────────────────────────────────────────────
function Elements.Divider(tab, cfg)
    cfg = cfg or {}
    local theme = resolveTheme(tab._theme)
    local label = cfg.Label or cfg.Title or ""

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, cfg.Height or 18)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0

    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, cfg.Thickness or 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = safeColor(cfg.Color, theme.ElementStroke)
    line.BackgroundTransparency = cfg.Transparency or 0
    line.BorderSizePixel = 0
    line.Parent = f

    if label ~= "" then
        local lbl = makeLabel(f, {
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Text = "  " .. label .. "  ",
            TextColor3 = safeColor(cfg.TextColor, theme.TextDisabled),
            TextSize = cfg.TextSize or 11,
            Font = cfg.Font or Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        lbl.AnchorPoint = Vector2.new(0.5, 0)
        lbl.Position = UDim2.new(0.5, 0, 0, 0)
        lbl.BackgroundTransparency = cfg.LabelTransparency or 0
        lbl.BackgroundColor3 = safeColor(cfg.LabelColor, theme.Background)
        lbl.BorderSizePixel = 0
    end

    tab:_addElement(f)
    return f
end

-- ─── SPACE ────────────────────────────────────────────────────────────────────
function Elements.Space(tab, cfg)
    cfg = cfg or {}
    local h = cfg.Height or cfg.Size or 8

    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, h)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0

    tab:_addElement(f)
    return f
end

-- Injecte tous les éléments dans un Tab
function Elements.inject(Tab)
    function Tab:Button(cfg)    return Elements.Button(self, cfg) end
    function Tab:Toggle(cfg)    return Elements.Toggle(self, cfg) end
    function Tab:Input(cfg)     return Elements.Input(self, cfg) end
    function Tab:Slider(cfg)    return Elements.Slider(self, cfg) end
    function Tab:Dropdown(cfg)  return Elements.Dropdown(self, cfg) end
    function Tab:Paragraph(cfg) return Elements.Paragraph(self, cfg) end
    function Tab:Divider(cfg)   return Elements.Divider(self, cfg) end
    function Tab:Space(cfg)     return Elements.Space(self, cfg) end
    function Tab:Section(cfg)   return Elements.Section(self, cfg) end
    function Tab:Frame(cfg)     return Elements.Frame(self, cfg) end
    function Tab:Card(cfg)      return Elements.Card(self, cfg) end
    function Tab:Label(cfg)     return Elements.Label(self, cfg) end
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
