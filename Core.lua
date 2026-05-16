-- TryxLib | Core.lua
-- Fenetre, Drag, Resize, Sidebar, Tabs

local TryxLib = {}
TryxLib.__index = TryxLib

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer    = Players.LocalPlayer
local Mouse          = LocalPlayer:GetMouse()

-- Theme par defaut
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

local SIDEBAR_W     = 160
local TOPBAR_H      = 42
local MIN_W         = 480
local MIN_H         = 320
local DEFAULT_W     = 620
local DEFAULT_H     = 420
local CORNER_R      = UDim.new(0, 8)
local ELEMENT_H     = 44
local ELEMENT_PAD   = 6
local ANIM_SPEED    = 0.18

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or ANIM_SPEED, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER_R
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
    l.Text              = text or ""
    l.TextColor3        = color or Theme.TextPrimary
    l.TextSize          = size or 13
    l.Font              = weight or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment    = Enum.TextXAlignment.Left
    l.TextTruncate      = Enum.TextTruncate.AtEnd
    l.Parent            = parent
    return l
end

local function newFrame(parent, bg, size, pos)
    local f = Instance.new("Frame")
    f.BackgroundColor3  = bg or Theme.Background
    f.Size              = size or UDim2.fromScale(1, 1)
    f.Position          = pos or UDim2.new(0, 0, 0, 0)
    f.BorderSizePixel   = 0
    f.Parent            = parent
    return f
end

-- Drag
local function makeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Resize
local function makeResizable(resizeHandle, target, minW, minH)
    local resizing, resizeStart, startSize = false, nil, nil
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing    = true
            resizeStart = input.Position
            startSize   = target.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newW  = math.max(minW or MIN_W, startSize.X.Offset + delta.X)
            local newH  = math.max(minH or MIN_H, startSize.Y.Offset + delta.Y)
            target.Size = UDim2.new(0, newW, 0, newH)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

function TryxLib:CreateWindow(config)
    config = config or {}
    local title    = config.Title   or "TryxLib"
    local subtitle = config.Subtitle or ""
    local icon     = config.Icon    or "star"
    local theme    = config.Theme   or Theme

    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name                  = "TryxLib_" .. title:gsub("%s", "")
    gui.ResetOnSpawn          = false
    gui.ZIndexBehavior        = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder          = 999
    gui.IgnoreGuiInset        = true
    gui.Parent                = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

    -- Fenetre principale
    local win = Instance.new("Frame")
    win.Name                  = "Window"
    win.Size                  = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H)
    win.Position              = UDim2.new(0.5, -DEFAULT_W / 2, 0.5, -DEFAULT_H / 2)
    win.BackgroundColor3      = theme.Background
    win.BorderSizePixel       = 0
    win.ClipsDescendants      = true
    win.Parent                = gui
    corner(win, UDim.new(0, 10))
    stroke(win, theme.ElementStroke, 1)

    -- Ombre
    local shadow = Instance.new("ImageLabel")
    shadow.Name               = "Shadow"
    shadow.Size               = UDim2.new(1, 30, 1, 30)
    shadow.Position           = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image              = "rbxassetid://6014261993"
    shadow.ImageColor3        = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency  = 0.5
    shadow.ScaleType          = Enum.ScaleType.Slice
    shadow.SliceCenter        = Rect.new(49, 49, 450, 450)
    shadow.ZIndex             = 0
    shadow.Parent             = win

    -- TopBar
    local topBar = newFrame(win, theme.TopBar, UDim2.new(1, 0, 0, TOPBAR_H))
    topBar.Name = "TopBar"
    topBar.ZIndex = 3

    local topLayout = Instance.new("UIListLayout")
    topLayout.FillDirection  = Enum.FillDirection.Horizontal
    topLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    topLayout.Padding        = UDim.new(0, 8)
    topLayout.Parent         = topBar
    padding(topBar, 0, 0, 14, 14)

    -- Icon + Titre dans topbar
    local iconLabel = label(topBar, icon, theme.Accent, 14, Enum.Font.GothamBold)
    iconLabel.Size  = UDim2.new(0, 16, 1, 0)
    iconLabel.Name  = "Icon"
    iconLabel.TextXAlignment = Enum.TextXAlignment.Center

    local titleLabel = label(topBar, title, theme.TextPrimary, 13, Enum.Font.GothamBold)
    titleLabel.Size  = UDim2.new(1, -120, 1, 0)
    titleLabel.Name  = "Title"

    -- Boutons topbar (close, minimize)
    local btnContainer = newFrame(topBar, Color3.fromRGB(0,0,0), UDim2.new(0, 60, 1, 0))
    btnContainer.BackgroundTransparency = 1
    btnContainer.Name = "Buttons"
    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection   = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
    btnLayout.Padding         = UDim.new(0, 6)
    btnLayout.Parent          = btnContainer

    local function makeWinBtn(color, icon2)
        local btn = Instance.new("TextButton")
        btn.Size                  = UDim2.new(0, 14, 0, 14)
        btn.BackgroundColor3      = color
        btn.Text                  = ""
        btn.BorderSizePixel       = 0
        btn.AutoButtonColor       = false
        btn.Parent                = btnContainer
        corner(btn, UDim.new(1, 0))
        return btn
    end

    local closeBtn    = makeWinBtn(theme.Danger)
    local minimizeBtn = makeWinBtn(theme.Warning)

    -- Sidebar
    local sidebar = newFrame(win, theme.Sidebar, UDim2.new(0, SIDEBAR_W, 1, -TOPBAR_H), UDim2.new(0, 0, 0, TOPBAR_H))
    sidebar.Name = "Sidebar"
    sidebar.ZIndex = 2

    local sideStroke = Instance.new("Frame")
    sideStroke.Size             = UDim2.new(0, 1, 1, 0)
    sideStroke.Position         = UDim2.new(1, 0, 0, 0)
    sideStroke.BackgroundColor3 = theme.ElementStroke
    sideStroke.BorderSizePixel  = 0
    sideStroke.Parent           = sidebar

    local tabList = Instance.new("ScrollingFrame")
    tabList.Name                    = "TabList"
    tabList.Size                    = UDim2.new(1, 0, 1, -10)
    tabList.Position                = UDim2.new(0, 0, 0, 8)
    tabList.BackgroundTransparency  = 1
    tabList.ScrollBarThickness      = 0
    tabList.CanvasSize              = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize     = Enum.AutomaticSize.Y
    tabList.BorderSizePixel         = 0
    tabList.Parent                  = sidebar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding           = UDim.new(0, 3)
    tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabListLayout.Parent            = tabList
    padding(tabList, 4, 4, 6, 6)

    -- Zone contenu
    local contentArea = newFrame(win, theme.Background,
        UDim2.new(1, -SIDEBAR_W, 1, -TOPBAR_H),
        UDim2.new(0, SIDEBAR_W, 0, TOPBAR_H)
    )
    contentArea.Name            = "Content"
    contentArea.ClipsDescendants = true

    -- Resize handle
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Name             = "ResizeHandle"
    resizeHandle.Size             = UDim2.new(0, 14, 0, 14)
    resizeHandle.Position         = UDim2.new(1, -14, 1, -14)
    resizeHandle.BackgroundColor3 = theme.ElementStroke
    resizeHandle.Text             = ""
    resizeHandle.BorderSizePixel  = 0
    resizeHandle.AutoButtonColor  = false
    resizeHandle.ZIndex           = 10
    resizeHandle.Parent           = win
    corner(resizeHandle, UDim.new(0, 3))

    -- Grip visuel resize
    for i = 1, 3 do
        local dot = Instance.new("Frame")
        dot.Size               = UDim2.new(0, 2, 0, 2)
        dot.Position           = UDim2.new(0, 2 + (i-1)*4, 0, 8)
        dot.BackgroundColor3   = theme.TextDisabled
        dot.BorderSizePixel    = 0
        dot.ZIndex             = 11
        corner(dot, UDim.new(1,0))
        dot.Parent = resizeHandle
    end

    makeDraggable(topBar, win)
    makeResizable(resizeHandle, win, MIN_W, MIN_H)

    -- Minimize
    local minimized = false
    local prevSize  = win.Size
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            prevSize = win.Size
            tween(win, { Size = UDim2.new(0, win.Size.X.Offset, 0, TOPBAR_H) }, 0.2)
            contentArea.Visible = false
            sidebar.Visible     = false
            resizeHandle.Visible = false
        else
            tween(win, { Size = prevSize }, 0.2)
            contentArea.Visible = true
            sidebar.Visible     = true
            resizeHandle.Visible = true
        end
    end)

    -- Close
    closeBtn.MouseButton1Click:Connect(function()
        tween(win, { Size = UDim2.new(0, win.Size.X.Offset, 0, 0) }, 0.15)
        task.wait(0.15)
        gui:Destroy()
    end)

    -- Objet Window exposé
    local Window  = {}
    local tabs    = {}
    local activePage = nil

    local function setActiveTab(page, tabBtn)
        if activePage then
            activePage.Visible = false
        end
        activePage = page
        page.Visible = true

        for _, t in ipairs(tabs) do
            local isActive = t.btn == tabBtn
            tween(t.btn, {
                BackgroundColor3 = isActive and theme.TabActive or theme.TabInactive
            }, 0.12)
            t.accent.Visible = isActive
            t.titleLbl.TextColor3 = isActive and theme.TextPrimary or theme.TextSecondary
        end
    end

    function Window:Tab(cfg)
        cfg = cfg or {}
        local tabTitle = cfg.Title or "Tab"
        local tabIcon  = cfg.Icon  or ""

        -- Bouton tab dans sidebar
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name               = "Tab_" .. tabTitle
        tabBtn.Size               = UDim2.new(1, 0, 0, 36)
        tabBtn.BackgroundColor3   = theme.TabInactive
        tabBtn.Text               = ""
        tabBtn.BorderSizePixel    = 0
        tabBtn.AutoButtonColor    = false
        tabBtn.Parent             = tabList
        corner(tabBtn, UDim.new(0, 6))

        -- Accent bar gauche
        local accentBar = Instance.new("Frame")
        accentBar.Name            = "Accent"
        accentBar.Size            = UDim2.new(0, 3, 0.6, 0)
        accentBar.Position        = UDim2.new(0, 0, 0.2, 0)
        accentBar.BackgroundColor3 = theme.TabStroke
        accentBar.BorderSizePixel = 0
        accentBar.Visible         = false
        corner(accentBar, UDim.new(0, 2))
        accentBar.Parent          = tabBtn

        local tabRowLayout = Instance.new("UIListLayout")
        tabRowLayout.FillDirection   = Enum.FillDirection.Horizontal
        tabRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        tabRowLayout.Padding         = UDim.new(0, 7)
        tabRowLayout.Parent          = tabBtn
        padding(tabBtn, 0, 0, 12, 8)

        local iconLbl = label(tabBtn, tabIcon, theme.Accent, 12, Enum.Font.GothamMedium)
        iconLbl.Size  = UDim2.new(0, 14, 1, 0)
        iconLbl.TextXAlignment = Enum.TextXAlignment.Center

        local titleLbl = label(tabBtn, tabTitle, theme.TextSecondary, 12, Enum.Font.GothamMedium)
        titleLbl.Size  = UDim2.new(1, -30, 1, 0)

        -- Page contenu
        local page = Instance.new("ScrollingFrame")
        page.Name                   = "Page_" .. tabTitle
        page.Size                   = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness     = 3
        page.ScrollBarImageColor3   = theme.ScrollBar
        page.CanvasSize             = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize    = Enum.AutomaticSize.Y
        page.BorderSizePixel        = 0
        page.Visible                = false
        page.Parent                 = contentArea

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding              = UDim.new(0, ELEMENT_PAD)
        pageLayout.HorizontalAlignment  = Enum.HorizontalAlignment.Center
        pageLayout.Parent               = page
        padding(page, 10, 10, 10, 10)

        local tabEntry = { btn = tabBtn, accent = accentBar, titleLbl = titleLbl, page = page }
        table.insert(tabs, tabEntry)

        -- Hover
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

        if #tabs == 1 then
            setActiveTab(page, tabBtn)
        end

        -- Retourne un Tab object avec tous les éléments
        local Tab = {}
        Tab._page   = page
        Tab._layout = pageLayout
        Tab._theme  = theme

        -- Elements sera chargé depuis Elements.lua
        -- On expose une fonction pour ajouter n'importe quel élément
        function Tab:_addElement(elem)
            elem.Parent = page
        end

        return Tab
    end

    function Window:Notify(cfg)
        -- Délégué à Notify.lua — appelé depuis TryxLib principal
        if TryxLib._notify then
            TryxLib._notify(gui, cfg, theme)
        end
    end

    function Window:Destroy()
        gui:Destroy()
    end

    -- Apparition
    win.Size = UDim2.new(0, DEFAULT_W, 0, 0)
    tween(win, { Size = UDim2.new(0, DEFAULT_W, 0, DEFAULT_H) }, 0.25)

    return Window
end

return TryxLib
