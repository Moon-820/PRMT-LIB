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
