--[[
    TryxLib Titanium Edition | Core.lua
    Version: 4.0.0 (Ultimate Build)
    Description: High-Performance, Immersive & Robust UI Engine for Roblox.
    Style: Premium "Hidden" Modern Dark
    © 2026 TryxHub — Developed by Moon820
]]

local TryxLib = {
    Version = "4.0.0",
    Author = "Moon820",
    Project = "TryxLib Titanium",
    Connections = {},
    Flags = {},
    Themes = {}
}

TryxLib.__index = TryxLib

-- [[ SERVICES ]]
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local TextService      = game:GetService("TextService")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

-- [[ THEME ENGINE ]]
TryxLib.Themes.Default = {
    Background      = Color3.fromRGB(15, 15, 18),
    Sidebar         = Color3.fromRGB(20, 20, 24),
    TopBar          = Color3.fromRGB(18, 18, 22),
    Element         = Color3.fromRGB(28, 28, 34),
    ElementHover    = Color3.fromRGB(35, 35, 42),
    ElementStroke   = Color3.fromRGB(45, 45, 52),
    Accent          = Color3.fromRGB(220, 180, 60),
    AccentDark      = Color3.fromRGB(160, 130, 40),
    TextPrimary     = Color3.fromRGB(255, 255, 255),
    TextSecondary   = Color3.fromRGB(170, 170, 185),
    TextDisabled    = Color3.fromRGB(90, 90, 105),
    TabActive       = Color3.fromRGB(32, 32, 40),
    TabInactive     = Color3.fromRGB(20, 20, 24),
    Danger          = Color3.fromRGB(240, 80, 80),
    Success         = Color3.fromRGB(80, 220, 120),
    Warning         = Color3.fromRGB(240, 180, 60),
    Shadow          = Color3.fromRGB(0, 0, 0),
}

-- [[ UTILS ]]
local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 12)
    c.Parent = p
    return c
end

local function stroke(p, col, th, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(45, 45, 52)
    s.Thickness = th or 1.2
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

local function label(p, text, color, size, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    l.TextSize = size or 14
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.BorderSizePixel = 0
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = p
    return l
end

-- [[ INTERACTION ENGINE ]]
local function makeDraggable(handle, target)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = target.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function makeResizable(handle, target, minW, minH)
    local resizing, resizeStart, startSize
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = i.Position
            startSize = target.Size
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - resizeStart
            target.Size = UDim2.new(0, math.max(minW, startSize.X.Offset + delta.X), 0, math.max(minH, startSize.Y.Offset + delta.Y))
        end
    end)
end

-- [[ CORE WINDOW CLASS ]]
function TryxLib:CreateWindow(cfg)
    cfg = cfg or {}
    local theme = cfg.Theme or TryxLib.Themes.Default
    local vp = workspace.CurrentCamera.ViewportSize
    local isMobile = UserInputService.TouchEnabled and (vp.X <= 800)
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "TryxLib_Titanium_" .. math.random(1000, 9999)
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.IgnoreGuiInset = true
    gui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, cfg.Width or 680, 0, cfg.Height or 460)
    main.Position = UDim2.new(0.5, -(cfg.Width or 680)/2, 0.5, -(cfg.Height or 460)/2)
    main.BackgroundColor3 = theme.Background
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Parent = gui
    corner(main, UDim.new(0, 14))
    stroke(main, theme.ElementStroke, 1.5)

    -- Shadow Effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = theme.Shadow
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = -1
    shadow.Parent = main

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundTransparency = 1
    overlay.ZIndex = 10000
    overlay.Parent = gui

    -- TopBar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 52)
    topBar.BackgroundColor3 = theme.TopBar
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 100
    topBar.Parent = main
    padding(topBar, 0, 0, 20, 20)
    
    local icon = label(topBar, cfg.Icon or "🌙", theme.Accent, 20, Enum.Font.GothamBold)
    icon.Size = UDim2.new(0, 28, 1, 0)
    
    local title = label(topBar, cfg.Title or "TryxLib Titanium", theme.TextPrimary, 16, Enum.Font.GothamBold)
    title.Position = UDim2.new(0, 36, 0, 0)
    title.Size = UDim2.new(1, -180, 1, 0)
    
    if cfg.Subtitle then
        local sub = label(topBar, cfg.Subtitle, theme.TextSecondary, 12, Enum.Font.Gotham)
        sub.Position = UDim2.new(0, title.TextBounds.X + 45, 0, 0)
        sub.Size = UDim2.new(0, 250, 1, 0)
        sub.TextTransparency = 0.4
    end

    local btnCont = Instance.new("Frame")
    btnCont.Size = UDim2.new(0, 90, 1, 0)
    btnCont.Position = UDim2.new(1, -90, 0, 0)
    btnCont.BackgroundTransparency = 1
    btnCont.Parent = topBar
    local btnLay = Instance.new("UIListLayout")
    btnLay.FillDirection = Enum.FillDirection.Horizontal
    btnLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
    btnLay.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLay.Padding = UDim.new(0, 12)
    btnLay.Parent = btnCont

    local function makeWinBtn(col, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 18, 0, 18)
        b.BackgroundColor3 = col
        b.Text = ""
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Parent = btnCont
        corner(b, UDim.new(1, 0))
        b.MouseButton1Click:Connect(callback)
        return b
    end
    
    local closeBtn = makeWinBtn(theme.Danger, function() gui:Destroy() end)
    local minBtn = makeWinBtn(theme.Warning, function()
        local minimized = main.Size.Y.Offset <= 52
        tween(main, {Size = UDim2.new(0, main.Size.X.Offset, 0, minimized and 460 or 52)})
    end)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 68, 1, -52)
    sidebar.Position = UDim2.new(0, 0, 0, 52)
    sidebar.BackgroundColor3 = theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 90
    sidebar.Parent = main
    stroke(sidebar, theme.ElementStroke, 1)
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, 0, 1, -90)
    tabList.BackgroundTransparency = 1
    tabList.ScrollBarThickness = 0
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabList.Parent = sidebar
    local tabLay = Instance.new("UIListLayout")
    tabLay.Padding = UDim.new(0, 10)
    tabLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLay.Parent = tabList
    padding(tabList, 18, 0, 0, 0)

    -- User Avatar (Bottom Sidebar)
    local userAvatar = Instance.new("ImageLabel")
    userAvatar.Size = UDim2.new(0, 42, 0, 42)
    userAvatar.Position = UDim2.new(0.5, -21, 1, -60)
    userAvatar.BackgroundColor3 = theme.Element
    userAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    userAvatar.Parent = sidebar
    corner(userAvatar, UDim.new(1, 0))
    stroke(userAvatar, theme.Accent, 2)

    -- Content Area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -68, 1, -52)
    content.Position = UDim2.new(0, 68, 0, 52)
    content.BackgroundTransparency = 1
    content.Parent = main

    -- Resize Handle
    local resizeH = Instance.new("Frame")
    resizeH.Size = UDim2.new(0, 24, 0, 24)
    resizeH.Position = UDim2.new(1, -24, 1, -24)
    resizeH.BackgroundTransparency = 1
    resizeH.ZIndex = 200
    resizeH.Parent = main

    makeDraggable(topBar, main)
    makeResizable(resizeH, main, 580, 380)

    local Window = { _gui = gui, _main = main, _theme = theme, _overlay = overlay }
    local tabs = {}
    local activePage = nil

    function Window:Tab(tcfg)
        tcfg = tcfg or {}
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 46, 0, 46)
        tabBtn.BackgroundColor3 = theme.TabInactive
        tabBtn.Text = tcfg.Icon or "🏠"
        tabBtn.TextColor3 = theme.TextSecondary
        tabBtn.TextSize = 22
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.BorderSizePixel = 0
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = tabList
        corner(tabBtn, UDim.new(0, 12))
        
        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = theme.ElementStroke
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.Parent = content
        local pageLay = Instance.new("UIListLayout")
        pageLay.Padding = UDim.new(0, 14)
        pageLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageLay.Parent = page
        padding(page, 20, 20, 24, 24)

        local function activate()
            if activePage then activePage.Visible = false end
            activePage = page
            page.Visible = true
            for _, t in ipairs(tabs) do
                local active = (t.btn == tabBtn)
                tween(t.btn, {BackgroundColor3 = active and theme.TabActive or theme.TabInactive})
                tween(t.btn, {TextColor3 = active and theme.Accent or theme.TextSecondary})
            end
        end

        tabBtn.MouseButton1Click:Connect(activate)
        table.insert(tabs, {btn = tabBtn, page = page})
        if #tabs == 1 then activate() end

        local Tab = { _page = page, _theme = theme, _overlay = overlay, _window = main }
        function Tab:_addElement(e) e.Parent = page end
        
        -- Grid System (Row)
        function Tab:Row()
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 0)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.BackgroundTransparency = 1
            row.Parent = page
            local rowLay = Instance.new("UIListLayout")
            rowLay.FillDirection = Enum.FillDirection.Horizontal
            rowLay.Padding = UDim.new(0, 14)
            rowLay.Parent = row
            
            local RowObj = { _page = row, _theme = theme, _overlay = overlay, _window = main }
            function RowObj:_addElement(e) 
                e.Parent = row
                local count = 0
                for _, c in ipairs(row:GetChildren()) do if c:IsA("Frame") then count = count + 1 end end
                for _, c in ipairs(row:GetChildren()) do 
                    if c:IsA("Frame") then 
                        c.Size = UDim2.new(1/count, -((count-1)*14)/count, 0, c.Size.Y.Offset) 
                    end 
                end
            end
            if TryxLib._inject then TryxLib._inject(RowObj) end
            return RowObj
        end

        if TryxLib._inject then TryxLib._inject(Tab) end
        return Tab
    end

    function Window:Notify(ncfg)
        -- Notification logic here (Titanium level)
    end

    return Window
end

return TryxLib
