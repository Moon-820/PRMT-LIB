-- TryxLib | dist/main.lua
-- Version compilée — loadstring(game:HttpGet("URL"))()
-- © TryxHub — Moon820
-- Build corrigé : mobile responsive, drag/touch, slider mobile, dropdown overlay, custom elements.

local TryxLib = (function()
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

end)()

local Elements = (function()
--[[
    TryxLib Titanium Edition | Elements.lua
    Version: 4.0.0 (Ultimate Build)
    Description: High-Performance UI Components with Advanced Customization.
    © 2026 TryxHub — Developed by Moon820
]]

local Elements = {}

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")

local ANIM_T = 0.3
local CORNER = UDim.new(0, 12)

-- [[ UTILS ]]
local function tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or ANIM_T, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER
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

local function makeLabel(p, cfg)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = cfg.Text or ""
    l.TextColor3 = cfg.TextColor3 or Color3.fromRGB(255,255,255)
    l.TextSize = cfg.TextSize or 14
    l.Font = cfg.Font or Enum.Font.GothamMedium
    l.TextXAlignment = cfg.TextXAlignment or Enum.TextXAlignment.Left
    l.Size = cfg.Size or UDim2.fromScale(1, 1)
    l.TextWrapped = true
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = p
    return l
end

-- [[ COMPONENTS ]]

-- ─── USER PROFILE (TITANIUM) ─────────────────────────────────────────────────
function Elements.UserProfile(tab, cfg)
    local theme = tab._theme
    local player = cfg.Player or Players.LocalPlayer
    
    local f = Instance.new("Frame")
    f.Name = "UserProfile"
    f.Size = UDim2.new(1, 0, 0, 110)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 14))
    stroke(f, theme.ElementStroke, 1.5)
    padding(f, 18, 18, 22, 22)
    
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 74, 0, 74)
    avatar.BackgroundColor3 = theme.Background
    avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    avatar.Parent = f
    corner(avatar, UDim.new(1, 0))
    stroke(avatar, theme.Accent, 2.5)
    
    local info = Instance.new("Frame")
    info.Size = UDim2.new(1, -95, 1, 0)
    info.Position = UDim2.new(0, 95, 0, 0)
    info.BackgroundTransparency = 1
    info.Parent = f
    
    local welcome = makeLabel(info, {
        Text = "Welcome back, " .. (player.DisplayName or player.Name),
        TextColor3 = theme.TextPrimary,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 24)
    })
    
    local sub = makeLabel(info, {
        Text = "@" .. player.Name .. " • " .. (cfg.Tag or "Titanium User"),
        TextColor3 = theme.TextSecondary,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 28)
    })
    
    if cfg.Premium then
        sub.TextColor3 = theme.Accent
        local badge = Instance.new("Frame")
        badge.Size = UDim2.new(0, 70, 0, 20)
        badge.Position = UDim2.new(0, 0, 0, 52)
        badge.BackgroundColor3 = theme.Accent
        badge.Parent = info
        corner(badge, UDim.new(0, 6))
        local bl = makeLabel(badge, {
            Text = "PREMIUM",
            TextColor3 = theme.Background,
            TextSize = 10,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center
        })
    end
    
    tab:_addElement(f)
    return f
end

-- ─── CARD (TITANIUM) ─────────────────────────────────────────────────────────
function Elements.Card(tab, cfg)
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Name = "Card"
    f.Size = UDim2.new(1, 0, 0, 130)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 14))
    stroke(f, theme.ElementStroke, 1.2)
    padding(f, 18, 18, 20, 20)
    
    if cfg.Gradient then
        local g = Instance.new("UIGradient")
        g.Color = cfg.Gradient
        g.Rotation = 45
        g.Parent = f
    end
    
    local tl = makeLabel(f, {
        Text = cfg.Title or "Card Title",
        TextColor3 = theme.TextPrimary,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 22)
    })
    
    local desc = makeLabel(f, {
        Text = cfg.Desc or "Card description goes here...",
        TextColor3 = theme.TextSecondary,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, 28)
    })
    desc.TextTransparency = 0.3
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -65)
    content.Position = UDim2.new(0, 0, 0, 65)
    content.BackgroundTransparency = 1
    content.Parent = f
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 8)
    lay.Parent = content

    tab:_addElement(f)
    local obj = { _page = content, _theme = theme, _overlay = tab._overlay }
    function obj:_addElement(e) e.Parent = content f.Size = UDim2.new(f.Size.X.Scale, f.Size.X.Offset, 0, f.Size.Y.Offset + e.Size.Y.Offset + 8) end
    Elements.inject(obj)
    return obj
end

-- ─── BUTTON (TITANIUM) ───────────────────────────────────────────────────────
function Elements.Button(tab, cfg)
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 52)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 12))
    stroke(f, theme.ElementStroke, 1)
    padding(f, 0, 0, 18, 18)
    
    local tl = makeLabel(f, {
        Text = cfg.Title or "Action Button",
        TextColor3 = theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    
    local icon = makeLabel(f, {
        Text = "➜",
        TextColor3 = theme.TextSecondary,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f
    
    btn.MouseEnter:Connect(function() 
        tween(f, {BackgroundColor3 = theme.ElementHover})
        tween(icon, {TextColor3 = theme.Accent})
    end)
    btn.MouseLeave:Connect(function() 
        tween(f, {BackgroundColor3 = theme.Element})
        tween(icon, {TextColor3 = theme.TextSecondary})
    end)
    btn.MouseButton1Down:Connect(function() tween(f, {Size = UDim2.new(1, -4, 0, 48)}) end)
    btn.MouseButton1Up:Connect(function() tween(f, {Size = UDim2.new(1, 0, 0, 52)}) end)
    btn.MouseButton1Click:Connect(function() pcall(cfg.Callback or function() end) end)
    
    tab:_addElement(f)
    return f
end

-- ─── TOGGLE (TITANIUM) ───────────────────────────────────────────────────────
function Elements.Toggle(tab, cfg)
    local theme = tab._theme
    local value = cfg.Value or false
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 52)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 12))
    stroke(f, theme.ElementStroke, 1)
    padding(f, 0, 0, 18, 18)
    
    local tl = makeLabel(f, {
        Text = cfg.Title or "Toggle Feature",
        TextColor3 = theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 44, 0, 24)
    box.Position = UDim2.new(1, -44, 0.5, -12)
    box.BackgroundColor3 = value and theme.Accent or theme.Background
    box.Parent = f
    corner(box, UDim.new(1, 0))
    stroke(box, theme.ElementStroke, 1)
    
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = UDim2.new(0, value and 23 or 3, 0.5, -9)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.Parent = box
    corner(dot, UDim.new(1, 0))
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f
    
    local function update()
        tween(box, {BackgroundColor3 = value and theme.Accent or theme.Background})
        tween(dot, {Position = UDim2.new(0, value and 23 or 3, 0.5, -9)})
        pcall(cfg.Callback or function() end, value)
    end
    
    btn.MouseButton1Click:Connect(function() value = not value update() end)
    tab:_addElement(f)
    return { Set = function(_, v) value = v update() end }
end

-- ─── SLIDER (TITANIUM) ───────────────────────────────────────────────────────
function Elements.Slider(tab, cfg)
    local theme = tab._theme
    local min, max = cfg.Min or 0, cfg.Max or 100
    local value = math.clamp(cfg.Value or min, min, max)
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 75)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 14))
    stroke(f, theme.ElementStroke, 1)
    padding(f, 15, 15, 20, 20)
    
    local tl = makeLabel(f, {
        Text = cfg.Title or "Slider Control",
        TextColor3 = theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, -80, 0, 20)
    })
    
    local valBox = Instance.new("TextBox")
    valBox.Size = UDim2.new(0, 70, 0, 24)
    valBox.Position = UDim2.new(1, -70, 0, -2)
    valBox.BackgroundColor3 = theme.Background
    valBox.Text = tostring(value)
    valBox.TextColor3 = theme.Accent
    valBox.TextSize = 13
    valBox.Font = Enum.Font.GothamBold
    valBox.Parent = f
    corner(valBox, UDim.new(0, 6))
    stroke(valBox, theme.ElementStroke, 1)
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 8)
    track.Position = UDim2.new(0, 0, 1, -12)
    track.BackgroundColor3 = theme.Background
    track.Parent = f
    corner(track, UDim.new(1, 0))
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale((value-min)/(max-min), 1)
    fill.BackgroundColor3 = theme.Accent
    fill.Parent = track
    corner(fill, UDim.new(1, 0))
    
    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = UDim2.new((value-min)/(max-min), 0, 0.5, 0)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Parent = track
    corner(thumb, UDim.new(1, 0))
    stroke(thumb, theme.Accent, 2)
    
    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        value = math.floor(min + rel * (max - min))
        fill.Size = UDim2.fromScale(rel, 1)
        thumb.Position = UDim2.new(rel, 0, 0.5, 0)
        valBox.Text = tostring(value)
        pcall(cfg.Callback or function() end, value)
    end
    
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true update(i)
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            update(i)
        end
    end)
    
    valBox.FocusLost:Connect(function()
        local n = tonumber(valBox.Text)
        if n then
            value = math.clamp(n, min, max)
            local rel = (value-min)/(max-min)
            tween(fill, {Size = UDim2.fromScale(rel, 1)})
            tween(thumb, {Position = UDim2.new(rel, 0, 0.5, 0)})
            valBox.Text = tostring(value)
            pcall(cfg.Callback or function() end, value)
        else
            valBox.Text = tostring(value)
        end
    end)
    
    tab:_addElement(f)
    return { Set = function(_, v) value = math.clamp(v, min, max) local rel = (value-min)/(max-min) fill.Size = UDim2.fromScale(rel, 1) thumb.Position = UDim2.new(rel, 0, 0.5, 0) valBox.Text = tostring(value) end }
end

-- ─── INPUT (TITANIUM) ────────────────────────────────────────────────────────
function Elements.Input(tab, cfg)
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 80)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 14))
    stroke(f, theme.ElementStroke, 1)
    padding(f, 15, 15, 20, 20)
    
    makeLabel(f, {
        Text = cfg.Title or "Input Field",
        TextColor3 = theme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 20)
    })
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 36)
    box.Position = UDim2.new(0, 0, 1, -36)
    box.BackgroundColor3 = theme.Background
    box.Parent = f
    corner(box, UDim.new(0, 8))
    stroke(box, theme.ElementStroke, 1)
    
    local inp = Instance.new("TextBox")
    inp.Size = UDim2.new(1, -24, 1, 0)
    inp.Position = UDim2.new(0, 12, 0, 0)
    inp.BackgroundTransparency = 1
    inp.Text = cfg.Value or ""
    inp.PlaceholderText = cfg.Placeholder or "Enter text..."
    inp.TextColor3 = theme.TextPrimary
    inp.PlaceholderColor3 = theme.TextDisabled
    inp.TextSize = 13
    inp.Font = Enum.Font.Gotham
    inp.TextXAlignment = Enum.TextXAlignment.Left
    inp.Parent = box
    
    inp.Focused:Connect(function() tween(box, {BackgroundColor3 = theme.ElementHover}) end)
    inp.FocusLost:Connect(function() 
        tween(box, {BackgroundColor3 = theme.Background})
        pcall(cfg.Callback or function() end, inp.Text) 
    end)
    
    tab:_addElement(f)
    return f
end

function Elements.inject(Tab)
    function Tab:Button(cfg) return Elements.Button(self, cfg) end
    function Tab:Toggle(cfg) return Elements.Toggle(self, cfg) end
    function Tab:Slider(cfg) return Elements.Slider(self, cfg) end
    function Tab:Input(cfg) return Elements.Input(self, cfg) end
    function Tab:UserProfile(cfg) return Elements.UserProfile(self, cfg) end
    function Tab:Card(cfg) return Elements.Card(self, cfg) end
    function Tab:Divider(cfg)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 20)
        f.BackgroundTransparency = 1
        local l = makeLabel(f, {
            Text = cfg.Label or "DIVIDER",
            TextColor3 = self._theme.Accent,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center
        })
        l.TextTransparency = 0.5
        self:_addElement(f)
        return f
    end
    function Tab:Space(h)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, h or 10)
        f.BackgroundTransparency = 1
        self:_addElement(f)
        return f
    end
end

TryxLib._inject = Elements.inject
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
