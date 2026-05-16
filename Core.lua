-- TryxLib | Core.lua
-- Version 2.1 : Resize discret, visibilité accrue, corrections mobiles.

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

local function stroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.ElementStroke
    s.Thickness = thickness or 1
    s.Transparency = trans or 0
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

local function clampToScreen(target)
    local vp = viewportSize()
    local w, h = target.AbsoluteSize.X, target.AbsoluteSize.Y
    local x, y = target.Position.X.Offset, target.Position.Y.Offset
    if target.Position.X.Scale ~= 0 then x = (vp.X * target.Position.X.Scale) + x end
    if target.Position.Y.Scale ~= 0 then y = (vp.Y * target.Position.Y.Scale) + y end
    local nx = math.clamp(x, 4, math.max(4, vp.X - w - 4))
    local ny = math.clamp(y, 4, math.max(4, vp.Y - math.min(h, TOPBAR_H) - 4))
    target.Position = UDim2.new(0, nx, 0, ny)
end

local function makeDraggable(handle, target)
    local dragging, dragStart, startPos = false, nil, nil
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
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            clampToScreen(target)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if isPress(input) then dragging = false clampToScreen(target) end
    end)
end

local function makeResizable(handle, target, minW, minH)
    local resizing, resizeStart, startSize = false, nil, nil
    handle.InputBegan:Connect(function(input)
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
    local theme = config.Theme or Theme
    local vp = viewportSize()
    local isMobile = UserInputService.TouchEnabled and (vp.X <= 700 or not UserInputService.KeyboardEnabled)
    
    local w = math.clamp(config.Width or DEFAULT_W, isMobile and MIN_W_MOBILE or MIN_W_DESKTOP, vp.X - 20)
    local h = math.clamp(config.Height or DEFAULT_H, isMobile and MIN_H_MOBILE or MIN_H_DESKTOP, vp.Y - 20)
    local sidebarW = config.SidebarWidth or (isMobile and SIDEBAR_W_MOBILE or SIDEBAR_W_DESKTOP)

    local gui = Instance.new("ScreenGui")
    gui.Name = "TryxLib_" .. (config.Title or "UI"):gsub("%s", "")
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.DisplayOrder = 999
    gui.IgnoreGuiInset = true
    gui.Parent = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")

    local win = Instance.new("Frame")
    win.Name = "Window"
    win.Size = UDim2.new(0, w, 0, h)
    win.Position = UDim2.new(0.5, -w/2, 0.5, -h/2)
    win.BackgroundColor3 = theme.Background
    win.BorderSizePixel = 0
    win.ClipsDescendants = true
    win.Parent = gui
    corner(win, UDim.new(0, 10))
    stroke(win, theme.ElementStroke, 1)

    local overlay = Instance.new("Frame")
    overlay.Name = "__TryxOverlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 9000
    overlay.Parent = gui

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, TOPBAR_H)
    topBar.BackgroundColor3 = theme.TopBar
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 30
    topBar.Parent = win

    local topLayout = Instance.new("UIListLayout")
    topLayout.FillDirection = Enum.FillDirection.Horizontal
    topLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    topLayout.Padding = UDim.new(0, 8)
    topLayout.Parent = topBar
    padding(topBar, 0, 0, 14, 14)

    local iconLbl = label(topBar, config.Icon or "★", theme.Accent, 14, Enum.Font.GothamBold)
    iconLbl.Size = UDim2.new(0, 16, 1, 0)
    iconLbl.TextXAlignment = Enum.TextXAlignment.Center

    local titleLbl = label(topBar, config.Title or "TryxLib", theme.TextPrimary, isMobile and 12 or 13, Enum.Font.GothamBold)
    titleLbl.Size = UDim2.new(1, -120, 1, 0)

    local btnCont = Instance.new("Frame")
    btnCont.Size = UDim2.new(0, 60, 1, 0)
    btnCont.BackgroundTransparency = 1
    btnCont.Parent = topBar
    local btnLay = Instance.new("UIListLayout")
    btnLay.FillDirection = Enum.FillDirection.Horizontal
    btnLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLay.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLay.Padding = UDim.new(0, 6)
    btnLay.Parent = btnCont

    local function makeBtn(col)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 14, 0, 14)
        b.BackgroundColor3 = col
        b.Text = ""
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Parent = btnCont
        corner(b, UDim.new(1, 0))
        return b
    end
    local closeBtn = makeBtn(theme.Danger)
    local minBtn = makeBtn(theme.Warning)

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, sidebarW, 1, -TOPBAR_H)
    sidebar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
    sidebar.BackgroundColor3 = theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 20
    sidebar.Parent = win
    stroke(sidebar, theme.ElementStroke, 1)

    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, 0, 1, -10)
    tabList.Position = UDim2.new(0, 0, 0, 8)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 0
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.Parent = sidebar
    local tabLay = Instance.new("UIListLayout")
    tabLay.Padding = UDim.new(0, 3)
    tabLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLay.Parent = tabList
    padding(tabList, 4, 4, 6, 6)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -sidebarW, 1, -TOPBAR_H)
    content.Position = UDim2.new(0, sidebarW, 0, TOPBAR_H)
    content.BackgroundColor3 = theme.Background
    content.BorderSizePixel = 0
    content.Parent = win

    -- Resize Handle discret (petit triangle en bas à droite)
    local resizeH = Instance.new("ImageButton")
    resizeH.Name = "Resize"
    resizeH.Size = UDim2.new(0, 16, 0, 16)
    resizeH.Position = UDim2.new(1, -16, 1, -16)
    resizeH.BackgroundTransparency = 1
    resizeH.Image = "rbxassetid://11419713314" -- Icône de resize discrète
    resizeH.ImageColor3 = theme.TextDisabled
    resizeH.ImageTransparency = 0.5
    resizeH.ZIndex = 100
    resizeH.Parent = win

    makeDraggable(topBar, win)
    makeResizable(resizeH, win, isMobile and MIN_W_MOBILE or MIN_W_DESKTOP, isMobile and MIN_H_MOBILE or MIN_H_DESKTOP)

    local minimized, prevSize = false, win.Size
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            prevSize = win.Size
            tween(win, { Size = UDim2.new(0, win.Size.X.Offset, 0, TOPBAR_H) }, 0.2)
            content.Visible, sidebar.Visible, resizeH.Visible = false, false, false
        else
            tween(win, { Size = prevSize }, 0.2)
            content.Visible, sidebar.Visible, resizeH.Visible = true, true, true
        end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(win, { Size = UDim2.new(0, win.Size.X.Offset, 0, 0) }, 0.15)
        task.wait(0.15) gui:Destroy()
    end)

    local Window = {}
    local tabs = {}
    local activePage = nil

    function Window:Tab(cfg)
        cfg = cfg or {}
        local tabTitle = cfg.Title or "Tab"
        local tabIcon = cfg.Icon or ""

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, isMobile and 34 or 36)
        tabBtn.BackgroundColor3 = theme.TabInactive
        tabBtn.Text = ""
        tabBtn.BorderSizePixel = 0
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabList
        corner(tabBtn, UDim.new(0, 6))

        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(0, 3, 0.6, 0)
        accent.Position = UDim2.new(0, 0, 0.2, 0)
        accent.BackgroundColor3 = theme.TabStroke
        accent.Visible = false
        accent.Parent = tabBtn
        corner(accent, UDim.new(0, 2))

        local rowLay = Instance.new("UIListLayout")
        rowLay.FillDirection = Enum.FillDirection.Horizontal
        rowLay.VerticalAlignment = Enum.VerticalAlignment.Center
        rowLay.Padding = UDim.new(0, 8)
        rowLay.Parent = tabBtn
        padding(tabBtn, 0, 0, 10, 8)

        local ic = label(tabBtn, tabIcon, theme.Accent, 12, Enum.Font.GothamMedium)
        ic.Size = UDim2.new(0, 14, 1, 0)
        ic.Visible = (tabIcon ~= "")

        local tl = label(tabBtn, tabTitle, theme.TextSecondary, isMobile and 11 or 12, Enum.Font.GothamMedium)
        tl.Size = UDim2.new(1, -20, 1, 0)

        local page = Instance.new("ScrollingFrame")
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
        pageLay.Padding = UDim.new(0, 6)
        pageLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLay.Parent = page
        padding(page, 10, 10, 10, 10)

        local entry = { btn = tabBtn, accent = accent, title = tl, page = page }
        table.insert(tabs, entry)

        local function activate()
            if activePage then activePage.Visible = false end
            activePage = page
            page.Visible = true
            for _, t in ipairs(tabs) do
                local active = (t.btn == tabBtn)
                tween(t.btn, { BackgroundColor3 = active and theme.TabActive or theme.TabInactive }, 0.12)
                t.accent.Visible = active
                t.title.TextColor3 = active and theme.TextPrimary or theme.TextSecondary
            end
        end

        tabBtn.MouseButton1Click:Connect(activate)
        if #tabs == 1 then activate() end

        local Tab = { _page = page, _theme = theme, _gui = gui, _window = win, _overlay = overlay, _isMobile = isMobile }
        function Tab:_addElement(e) e.Parent = page end
        return Tab
    end

    function Window:Notify(cfg) if TryxLib._notify then TryxLib._notify(gui, cfg, theme) end end
    function Window:Destroy() gui:Destroy() end
    return Window
end

return TryxLib
