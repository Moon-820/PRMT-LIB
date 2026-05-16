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
