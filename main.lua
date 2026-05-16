-- TryxLib | dist/main.lua
-- Version compilée — loadstring(game:HttpGet("URL"))()
-- © TryxHub — Moon820
-- Build corrigé : mobile responsive, drag/touch, slider mobile, dropdown overlay, custom elements.

local TryxLib = (function()
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

end)()

local Elements = (function()
-- TryxLib | Elements.lua
-- Version 2.1 : Slider Input, UserProfile, Card vs Paragraph, Alignement Input.

local Elements = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local ANIM = 0.18
local CORNER_R = UDim.new(0, 6)
local ELEMENT_H = 38

local function tween(obj, props, t)
    pcall(function()
        TweenService:Create(obj, TweenInfo.new(t or ANIM, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
    end)
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
    l.Name = "Label"
    l.BackgroundTransparency = 1
    l.BorderSizePixel = 0
    l.Text = cfg.Text or ""
    l.TextColor3 = cfg.TextColor3 or Color3.fromRGB(255,255,255)
    l.TextSize = cfg.TextSize or 13
    l.Font = cfg.Font or Enum.Font.GothamMedium
    l.TextXAlignment = cfg.TextXAlignment or Enum.TextXAlignment.Left
    l.Size = cfg.Size or UDim2.fromScale(1, 1)
    l.Position = cfg.Position or UDim2.new(0,0,0,0)
    l.Parent = p
    return l
end

local function titleDesc(f, theme, title, desc, rightOffset)
    local tl = makeLabel(f, {
        Text = title,
        TextColor3 = theme.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, -(rightOffset or 20), 0, 16),
        Position = UDim2.new(0, 0, 0, 0)
    })
    if desc and desc ~= "" then
        tl.Position = UDim2.new(0, 0, 0, -2)
        local dl = makeLabel(f, {
            Text = desc,
            TextColor3 = theme.TextSecondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1, -(rightOffset or 20), 0, 14),
            Position = UDim2.new(0, 0, 0, 15)
        })
        dl.TextTransparency = 0.2
    end
end

-- ─── USER PROFILE (NEW) ──────────────────────────────────────────────────────
function Elements.UserProfile(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local player = cfg.Player or Players.LocalPlayer
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 70)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 10))
    stroke(f, theme.ElementStroke, 1)
    padding(f, 10, 10, 12, 12)
    
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, 50, 0, 50)
    avatar.BackgroundColor3 = theme.Background
    avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    avatar.Parent = f
    corner(avatar, UDim.new(1, 0))
    stroke(avatar, theme.Accent, 1.5)
    
    local info = Instance.new("Frame")
    info.Size = UDim2.new(1, -60, 1, 0)
    info.Position = UDim2.new(0, 60, 0, 0)
    info.BackgroundTransparency = 1
    info.Parent = f
    
    local name = makeLabel(info, {
        Text = player.DisplayName or player.Name,
        TextColor3 = theme.TextPrimary,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 18)
    })
    
    local sub = makeLabel(info, {
        Text = "@" .. player.Name .. " | ID: " .. player.UserId,
        TextColor3 = theme.TextSecondary,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 0, 18)
    })
    
    local tag = Instance.new("Frame")
    tag.Size = UDim2.new(0, 60, 0, 18)
    tag.Position = UDim2.new(0, 0, 0, 34)
    tag.BackgroundColor3 = theme.Accent
    tag.Parent = info
    corner(tag, UDim.new(0, 4))
    
    local tagLbl = makeLabel(tag, {
        Text = cfg.Tag or "PREMIUM",
        TextColor3 = Color3.fromRGB(0,0,0),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center
    })
    if cfg.Premium then tagLbl.TextColor3 = Color3.fromRGB(0,0,0) end

    tab:_addElement(f)
    return f
end

-- ─── BUTTON ──────────────────────────────────────────────────────────────────
function Elements.Button(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, ELEMENT_H + 4)
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 6, 6, 12, 12)
    
    titleDesc(f, theme, cfg.Title or "Button", cfg.Desc or "")
    
    local icon = makeLabel(f, {
        Text = ">",
        TextColor3 = theme.Accent,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = f
    
    btn.MouseEnter:Connect(function() tween(f, {BackgroundColor3 = cfg.HoverColor or theme.ElementHover}) end)
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
    f.Size = UDim2.new(1, 0, 0, ELEMENT_H + 4)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 6, 6, 12, 12)
    
    titleDesc(f, theme, cfg.Title or "Toggle", cfg.Desc or "", 50)
    
    local box = Instance.new("Frame")
    box.Size = isCheckbox and UDim2.new(0, 22, 0, 22) or UDim2.new(0, 38, 0, 20)
    box.Position = UDim2.new(1, isCheckbox and -22 or -38, 0.5, isCheckbox and -11 or -10)
    box.BackgroundColor3 = value and theme.Accent or theme.Background
    box.Parent = f
    corner(box, isCheckbox and UDim.new(0, 5) or UDim.new(1, 0))
    stroke(box, theme.ElementStroke, 1)
    
    local dot = Instance.new("Frame")
    if isCheckbox then
        dot.Size = UDim2.new(0, 12, 0, 12)
        dot.Position = UDim2.new(0.5, -6, 0.5, -6)
        dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
        dot.BackgroundTransparency = value and 0 or 1
    else
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = UDim2.new(0, value and 21 or 3, 0.5, -7)
        dot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    end
    dot.Parent = box
    corner(dot, isCheckbox and UDim.new(0, 3) or UDim.new(1, 0))
    
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
            tween(dot, {Position = UDim2.new(0, value and 21 or 3, 0.5, -7)})
        end
        pcall(cfg.Callback or function() end, value)
    end
    
    btn.MouseButton1Click:Connect(function() value = not value update() end)
    
    tab:_addElement(f)
    return { Set = function(_, v) value = v update() end, Get = function() return value end }
end

-- ─── SLIDER ──────────────────────────────────────────────────────────────────
function Elements.Slider(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local min, max = cfg.Min or 0, cfg.Max or 100
    local value = math.clamp(cfg.Value or min, min, max)
    local step = cfg.Step or 1
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 50)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 8, 8, 12, 12)
    
    titleDesc(f, theme, cfg.Title or "Slider", cfg.Desc or "", 60)
    
    local valCont = Instance.new("Frame")
    valCont.Size = UDim2.new(0, 50, 0, 22)
    valCont.Position = UDim2.new(1, -50, 0, 0)
    valCont.BackgroundColor3 = theme.Background
    valCont.Parent = f
    corner(valCont, UDim.new(0, 4))
    stroke(valCont, theme.ElementStroke, 1)
    
    local valInput = Instance.new("TextBox")
    valInput.Size = UDim2.fromScale(1, 1)
    valInput.BackgroundTransparency = 1
    valInput.Text = tostring(value) .. (cfg.Suffix or "")
    valInput.TextColor3 = theme.Accent
    valInput.TextSize = 11
    valInput.Font = Enum.Font.GothamBold
    valInput.TextEditable = cfg.Input == true
    valInput.ClearTextOnFocus = false
    valInput.Parent = valCont
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 1, -8)
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
    thumb.Size = UDim2.new(0, 12, 0, 12)
    thumb.Position = UDim2.new((value-min)/(max-min), 0, 0.5, 0)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
    thumb.Parent = track
    corner(thumb, UDim.new(1, 0))
    stroke(thumb, theme.Accent, 1)
    
    local dragging = false
    local function update(x)
        local rel = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = min + rel * (max - min)
        value = math.floor(raw / step + 0.5) * step
        value = math.clamp(value, min, max)
        local pct = (value - min) / (max - min)
        fill.Size = UDim2.fromScale(pct, 1)
        thumb.Position = UDim2.new(pct, 0, 0.5, 0)
        valInput.Text = tostring(value) .. (cfg.Suffix or "")
        pcall(cfg.Callback or function() end, value)
    end
    
    track.InputBegan:Connect(function(i) if isPress(i) then dragging = true update(i.Position.X) end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and isMove(i) then update(i.Position.X) end end)
    UserInputService.InputEnded:Connect(function(i) if isPress(i) then dragging = false end end)
    
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
    return { Set = function(_, v) value = math.clamp(v, min, max) update(track.AbsolutePosition.X + (value-min)/(max-min)*track.AbsoluteSize.X) end }
end

-- ─── INPUT ───────────────────────────────────────────────────────────────────
function Elements.Input(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 54)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 8, 8, 12, 12)
    
    titleDesc(f, theme, cfg.Title or "Input", cfg.Desc or "")
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 24)
    box.Position = UDim2.new(0, 0, 1, -24)
    box.BackgroundColor3 = cfg.BoxColor or theme.Background
    box.Parent = f
    corner(box, UDim.new(0, 5))
    stroke(box, theme.ElementStroke, 1)
    
    local inp = Instance.new("TextBox")
    inp.Size = UDim2.new(1, -16, 1, 0)
    inp.Position = UDim2.new(0, 8, 0, 0)
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
    
    inp.FocusLost:Connect(function(enter)
        if enter or not cfg.OnEnterOnly then pcall(cfg.Callback or function() end, inp.Text) end
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
    f.Size = UDim2.new(1, 0, 0, ELEMENT_H + 4)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 6, 6, 12, 12)
    
    titleDesc(f, theme, cfg.Title or "Dropdown", cfg.Desc or "", 110)
    
    local selBox = Instance.new("Frame")
    selBox.Size = UDim2.new(0, 100, 0, 26)
    selBox.Position = UDim2.new(1, -100, 0.5, -13)
    selBox.BackgroundColor3 = theme.Background
    selBox.Parent = f
    corner(selBox, UDim.new(0, 5))
    stroke(selBox, theme.ElementStroke, 1)
    
    local selLbl = makeLabel(selBox, {
        Text = value,
        TextColor3 = theme.TextPrimary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(1, -22, 1, 0),
        Position = UDim2.new(0, 8, 0, 0)
    })
    selLbl.TextTruncate = Enum.TextTruncate.AtEnd
    
    local chev = makeLabel(selBox, {
        Text = "v",
        TextColor3 = theme.TextSecondary,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(0, 18, 1, 0),
        Position = UDim2.new(1, -20, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center
    })
    
    local list = Instance.new("Frame")
    list.Size = UDim2.new(0, 100, 0, 0)
    list.BackgroundColor3 = theme.Element
    list.ClipsDescendants = true
    list.Visible = false
    list.ZIndex = 10000
    list.Parent = tab._overlay
    corner(list)
    stroke(list, theme.ElementStroke, 1)
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 2)
    lay.Parent = list
    padding(list, 4, 4, 4, 4)
    
    local function build()
        for _, c in ipairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, v in ipairs(values) do
            local item = Instance.new("TextButton")
            item.Size = UDim2.new(1, 0, 0, 26)
            item.BackgroundColor3 = (v == value) and theme.ElementHover or theme.Element
            item.Text = "  " .. v
            item.TextColor3 = (v == value) and theme.Accent or theme.TextPrimary
            item.TextSize = 12
            item.Font = Enum.Font.Gotham
            item.TextXAlignment = Enum.TextXAlignment.Left
            item.BorderSizePixel = 0
            item.AutoButtonColor = false
            item.ZIndex = 10001
            item.Parent = list
            corner(item, UDim.new(0, 4))
            item.MouseButton1Click:Connect(function()
                value = v selLbl.Text = v open = false
                tween(list, {Size = UDim2.new(0, 100, 0, 0)})
                tween(chev, {Rotation = 0})
                task.delay(ANIM, function() if not open then list.Visible = false end end)
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
            list.Position = UDim2.new(0, abs.X, 0, abs.Y + 30)
            list.Visible = true
            tween(list, {Size = UDim2.new(0, 100, 0, math.min(#values * 28 + 8, 150))})
            tween(chev, {Rotation = 180})
        else
            tween(list, {Size = UDim2.new(0, 100, 0, 0)})
            tween(chev, {Rotation = 0})
            task.delay(ANIM, function() if not open then list.Visible = false end end)
        end
    end)
    
    tab:_addElement(f)
    return { Refresh = function(_, new) values = new build() end }
end

-- ─── CARD (NEW) ──────────────────────────────────────────────────────────────
function Elements.Card(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0.05
    f.BorderSizePixel = 0
    corner(f, UDim.new(0, 10))
    stroke(f, theme.Accent, 1, 0.6) -- Bordure accentuée discrète
    padding(f, 12, 12, 14, 14)
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 8)
    lay.Parent = f
    
    if cfg.Title then
        makeLabel(f, {
            Text = cfg.Title,
            TextColor3 = cfg.TitleColor or theme.TextPrimary,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Size = UDim2.new(1, 0, 0, 18)
        })
    end
    
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
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    padding(f, 4, 4, 8, 8)
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 2)
    lay.Parent = f
    
    if cfg.Title then
        makeLabel(f, {
            Text = cfg.Title,
            TextColor3 = theme.TextPrimary,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
            Size = UDim2.new(1, 0, 0, 16)
        })
    end
    if cfg.Desc then
        local d = makeLabel(f, {
            Text = cfg.Desc,
            TextColor3 = theme.TextSecondary,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Size = UDim2.new(1, 0, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        })
        d.AutomaticSize = Enum.AutomaticSize.Y
        d.TextWrapped = true
    end
    
    tab:_addElement(f)
    return f
end

-- ─── SECTION ─────────────────────────────────────────────────────────────────
function Elements.Section(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = theme.Element
    f.BackgroundTransparency = 0.4
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 10, 10, 12, 12)
    
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 6)
    lay.Parent = f
    
    makeLabel(f, {
        Text = cfg.Title or "Section",
        TextColor3 = theme.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, 0, 0, 14)
    })
    
    tab:_addElement(f)
    local obj = { _page = f, _theme = theme, _overlay = tab._overlay, _gui = tab._gui, _window = tab._window, _isMobile = tab._isMobile }
    function obj:_addElement(e) e.Parent = f end
    Elements.inject(obj)
    return obj
end

-- ─── LABEL ───────────────────────────────────────────────────────────────────
function Elements.Label(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local l = makeLabel(nil, {
        Text = cfg.Text or "Label",
        TextColor3 = cfg.TextColor or theme.TextSecondary,
        TextSize = cfg.TextSize or 12,
        Font = cfg.Font or Enum.Font.Gotham,
        Size = UDim2.new(1, 0, 0, 20),
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
    f.Size = UDim2.new(1, 0, 0, 18)
    f.BackgroundTransparency = 1
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = theme.ElementStroke
    line.BorderSizePixel = 0
    line.Parent = f
    if cfg.Label then
        local l = makeLabel(f, {
            Text = "  " .. cfg.Label .. "  ",
            TextColor3 = theme.TextDisabled,
            TextSize = 10,
            Font = Enum.Font.Gotham,
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
    f.Size = UDim2.new(1, 0, 0, h or 8)
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
