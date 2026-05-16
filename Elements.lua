-- TryxLib | Elements.lua
-- Button, Toggle, Input, Slider, Dropdown, Paragraph, Divider, Space

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ELEMENT_H  = 44
local CORNER_R   = UDim.new(0, 7)
local ANIM       = 0.14

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or ANIM, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r) local c = Instance.new("UICorner") c.CornerRadius = r or CORNER_R c.Parent = p return c end
local function stroke(p, col, th) local s = Instance.new("UIStroke") s.Color = col s.Thickness = th or 1 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border s.Parent = p return s end
local function padding(p, t, b, l, r) local u = Instance.new("UIPadding") u.PaddingTop = UDim.new(0,t or 6) u.PaddingBottom = UDim.new(0,b or 6) u.PaddingLeft = UDim.new(0,l or 12) u.PaddingRight = UDim.new(0,r or 12) u.Parent = p end

local function baseFrame(theme, h)
    local f = Instance.new("Frame")
    f.Size               = UDim2.new(1, 0, 0, h or ELEMENT_H)
    f.BackgroundColor3   = theme.Element
    f.BorderSizePixel    = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    return f
end

local function titleDesc(parent, theme, title, desc, offsetRight)
    offsetRight = offsetRight or 0

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size            = UDim2.new(1, -offsetRight, 0, 16)
    titleLbl.Position        = UDim2.new(0, 0, 0, 10)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text            = title or ""
    titleLbl.TextColor3      = theme.TextPrimary
    titleLbl.TextSize        = 13
    titleLbl.Font            = Enum.Font.GothamMedium
    titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
    titleLbl.Parent          = parent

    if desc and desc ~= "" then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size             = UDim2.new(1, -offsetRight, 0, 14)
        descLbl.Position         = UDim2.new(0, 0, 0, 26)
        descLbl.BackgroundTransparency = 1
        descLbl.Text             = desc
        descLbl.TextColor3       = theme.TextSecondary
        descLbl.TextSize         = 11
        descLbl.Font             = Enum.Font.Gotham
        descLbl.TextXAlignment   = Enum.TextXAlignment.Left
        descLbl.TextTruncate     = Enum.TextTruncate.AtEnd
        descLbl.Parent           = parent
    end
end

local Elements = {}

-- ─── BUTTON ───────────────────────────────────────────────────────────────────
function Elements.Button(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Button"
    local desc     = cfg.Desc     or ""
    local callback = cfg.Callback or function() end

    local f = baseFrame(theme)
    padding(f, 0, 0, 12, 12)

    titleDesc(f, theme, title, desc, 36)

    local arrow = Instance.new("TextLabel")
    arrow.Size               = UDim2.new(0, 24, 1, 0)
    arrow.Position           = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text               = "›"
    arrow.TextColor3         = theme.Accent
    arrow.TextSize           = 18
    arrow.Font               = Enum.Font.GothamBold
    arrow.TextXAlignment     = Enum.TextXAlignment.Center
    arrow.Parent             = f

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.ZIndex               = 2
    btn.Parent               = f

    btn.MouseEnter:Connect(function()
        tween(f, { BackgroundColor3 = theme.ElementHover })
    end)
    btn.MouseLeave:Connect(function()
        tween(f, { BackgroundColor3 = theme.Element })
    end)
    btn.MouseButton1Down:Connect(function()
        tween(f, { BackgroundColor3 = theme.AccentDark })
    end)
    btn.MouseButton1Up:Connect(function()
        tween(f, { BackgroundColor3 = theme.ElementHover })
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
    local theme    = tab._theme
    local title    = cfg.Title    or "Toggle"
    local desc     = cfg.Desc     or ""
    local value    = cfg.Value    ~= nil and cfg.Value or false
    local callback = cfg.Callback or function() end

    local f = baseFrame(theme)
    padding(f, 0, 0, 12, 12)

    titleDesc(f, theme, title, desc, 52)

    -- Track
    local track = Instance.new("Frame")
    track.Size             = UDim2.new(0, 36, 0, 20)
    track.Position         = UDim2.new(1, -46, 0.5, -10)
    track.BackgroundColor3 = value and theme.Accent or theme.ElementStroke
    track.BorderSizePixel  = 0
    corner(track, UDim.new(1, 0))
    track.Parent = f

    -- Thumb
    local thumb = Instance.new("Frame")
    thumb.Size             = UDim2.new(0, 14, 0, 14)
    thumb.Position         = value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel  = 0
    corner(thumb, UDim.new(1, 0))
    thumb.Parent = track

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.ZIndex               = 2
    btn.Parent               = f

    btn.MouseEnter:Connect(function()
        tween(f, { BackgroundColor3 = theme.ElementHover })
    end)
    btn.MouseLeave:Connect(function()
        tween(f, { BackgroundColor3 = theme.Element })
    end)

    btn.MouseButton1Click:Connect(function()
        value = not value
        tween(track, { BackgroundColor3 = value and theme.Accent or theme.ElementStroke })
        tween(thumb, { Position = value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
        pcall(callback, value)
    end)

    local obj = {}
    function obj:Set(v)
        value = v
        tween(track, { BackgroundColor3 = value and theme.Accent or theme.ElementStroke })
        tween(thumb, { Position = value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
        pcall(callback, value)
    end
    function obj:Get() return value end

    tab:_addElement(f)
    return obj
end

-- ─── INPUT ────────────────────────────────────────────────────────────────────
function Elements.Input(tab, cfg)
    cfg = cfg or {}
    local theme       = tab._theme
    local title       = cfg.Title       or "Input"
    local desc        = cfg.Desc        or ""
    local placeholder = cfg.Placeholder or "Type here..."
    local callback    = cfg.Callback    or function() end

    local f = baseFrame(theme, 70)
    padding(f, 0, 0, 12, 12)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size            = UDim2.new(1, 0, 0, 16)
    titleLbl.Position        = UDim2.new(0, 0, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text            = title
    titleLbl.TextColor3      = theme.TextPrimary
    titleLbl.TextSize        = 13
    titleLbl.Font            = Enum.Font.GothamMedium
    titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
    titleLbl.Parent          = f

    -- Input box
    local box = Instance.new("Frame")
    box.Size             = UDim2.new(1, 0, 0, 28)
    box.Position         = UDim2.new(0, 0, 0, 30)
    box.BackgroundColor3 = theme.Background
    box.BorderSizePixel  = 0
    corner(box, UDim.new(0, 5))
    stroke(box, theme.ElementStroke, 1)
    box.Parent = f

    local input = Instance.new("TextBox")
    input.Size               = UDim2.new(1, -12, 1, 0)
    input.Position           = UDim2.new(0, 6, 0, 0)
    input.BackgroundTransparency = 1
    input.Text               = ""
    input.PlaceholderText    = placeholder
    input.TextColor3         = theme.TextPrimary
    input.PlaceholderColor3  = theme.TextDisabled
    input.TextSize           = 12
    input.Font               = Enum.Font.Gotham
    input.TextXAlignment     = Enum.TextXAlignment.Left
    input.ClearTextOnFocus   = false
    input.Parent             = box

    input.Focused:Connect(function()
        tween(box, { BackgroundColor3 = theme.ElementHover })
        stroke(box, theme.Accent, 1)
    end)
    input.FocusLost:Connect(function(enter)
        tween(box, { BackgroundColor3 = theme.Background })
        stroke(box, theme.ElementStroke, 1)
        if enter then pcall(callback, input.Text) end
    end)
    input:GetPropertyChangedSignal("Text"):Connect(function()
        pcall(callback, input.Text)
    end)

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return input.Text end
    function obj:Set(v) input.Text = v end
    return obj
end

-- ─── SLIDER ───────────────────────────────────────────────────────────────────
function Elements.Slider(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Slider"
    local desc     = cfg.Desc     or ""
    local min      = cfg.Min      or 0
    local max      = cfg.Max      or 100
    local value    = cfg.Value    or min
    local suffix   = cfg.Suffix   or ""
    local callback = cfg.Callback or function() end

    local f = baseFrame(theme, 60)
    padding(f, 0, 0, 12, 12)

    local valLbl = Instance.new("TextLabel")
    valLbl.Size              = UDim2.new(0, 50, 0, 16)
    valLbl.Position          = UDim2.new(1, -54, 0, 8)
    valLbl.BackgroundTransparency = 1
    valLbl.Text              = tostring(value) .. suffix
    valLbl.TextColor3        = theme.Accent
    valLbl.TextSize          = 12
    valLbl.Font              = Enum.Font.GothamBold
    valLbl.TextXAlignment    = Enum.TextXAlignment.Right
    valLbl.Parent            = f

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size            = UDim2.new(1, -60, 0, 16)
    titleLbl.Position        = UDim2.new(0, 0, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text            = title
    titleLbl.TextColor3      = theme.TextPrimary
    titleLbl.TextSize        = 13
    titleLbl.Font            = Enum.Font.GothamMedium
    titleLbl.TextXAlignment  = Enum.TextXAlignment.Left
    titleLbl.Parent          = f

    -- Track bg
    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1, 0, 0, 6)
    track.Position         = UDim2.new(0, 0, 0, 36)
    track.BackgroundColor3 = theme.ElementStroke
    track.BorderSizePixel  = 0
    corner(track, UDim.new(1, 0))
    track.Parent = f

    -- Fill
    local fill = Instance.new("Frame")
    fill.Size              = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3  = theme.Accent
    fill.BorderSizePixel   = 0
    corner(fill, UDim.new(1, 0))
    fill.Parent = track

    -- Thumb
    local thumbSize = 14
    local thumb = Instance.new("Frame")
    thumb.Size             = UDim2.new(0, thumbSize, 0, thumbSize)
    thumb.AnchorPoint      = Vector2.new(0.5, 0.5)
    thumb.Position         = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel  = 0
    corner(thumb, UDim.new(1, 0))
    thumb.ZIndex           = 3
    thumb.Parent           = track

    local dragging = false

    local function updateSlider(inputX)
        local trackAbs = track.AbsolutePosition.X
        local trackW   = track.AbsoluteSize.X
        local rel      = math.clamp((inputX - trackAbs) / trackW, 0, 1)
        value = math.floor(min + rel * (max - min) + 0.5)
        local pct = (value - min) / (max - min)
        tween(fill,  { Size = UDim2.new(pct, 0, 1, 0) }, 0.05)
        tween(thumb, { Position = UDim2.new(pct, 0, 0.5, 0) }, 0.05)
        valLbl.Text = tostring(value) .. suffix
        pcall(callback, value)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return value end
    function obj:Set(v)
        value = math.clamp(v, min, max)
        local pct = (value - min) / (max - min)
        tween(fill,  { Size = UDim2.new(pct, 0, 1, 0) })
        tween(thumb, { Position = UDim2.new(pct, 0, 0.5, 0) })
        valLbl.Text = tostring(value) .. suffix
    end
    return obj
end

-- ─── DROPDOWN ─────────────────────────────────────────────────────────────────
function Elements.Dropdown(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Dropdown"
    local desc     = cfg.Desc     or ""
    local values   = cfg.Values   or {}
    local value    = cfg.Value    or (values[1] or "")
    local callback = cfg.Callback or function() end

    local open = false

    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, ELEMENT_H)
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel  = 0
    f.ClipsDescendants = false
    corner(f)
    stroke(f, theme.ElementStroke, 1)

    padding(f, 0, 0, 12, 12)

    titleDesc(f, theme, title, desc, 110)

    -- Selected display
    local selBox = Instance.new("Frame")
    selBox.Size             = UDim2.new(0, 100, 0, 26)
    selBox.Position         = UDim2.new(1, -108, 0.5, -13)
    selBox.BackgroundColor3 = theme.Background
    selBox.BorderSizePixel  = 0
    corner(selBox, UDim.new(0, 5))
    stroke(selBox, theme.ElementStroke, 1)
    selBox.Parent = f

    local selLbl = Instance.new("TextLabel")
    selLbl.Size              = UDim2.new(1, -24, 1, 0)
    selLbl.Position          = UDim2.new(0, 8, 0, 0)
    selLbl.BackgroundTransparency = 1
    selLbl.Text              = value
    selLbl.TextColor3        = theme.TextPrimary
    selLbl.TextSize          = 12
    selLbl.Font              = Enum.Font.Gotham
    selLbl.TextXAlignment    = Enum.TextXAlignment.Left
    selLbl.TextTruncate      = Enum.TextTruncate.AtEnd
    selLbl.Parent            = selBox

    local chevron = Instance.new("TextLabel")
    chevron.Size             = UDim2.new(0, 18, 1, 0)
    chevron.Position         = UDim2.new(1, -20, 0, 0)
    chevron.BackgroundTransparency = 1
    chevron.Text             = "v"
    chevron.TextColor3       = theme.TextSecondary
    chevron.TextSize         = 10
    chevron.Font             = Enum.Font.GothamBold
    chevron.TextXAlignment   = Enum.TextXAlignment.Center
    chevron.Parent           = selBox

    -- Dropdown list
    local list = Instance.new("Frame")
    list.Name              = "DropList"
    list.Size              = UDim2.new(0, 100, 0, 0)
    list.Position          = UDim2.new(1, -108, 0, ELEMENT_H + 2)
    list.BackgroundColor3  = theme.Element
    list.BorderSizePixel   = 0
    list.ClipsDescendants  = true
    list.ZIndex            = 10
    corner(list)
    stroke(list, theme.ElementStroke, 1)
    list.Parent = f

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent  = list
    padding(list, 4, 4, 4, 4)

    local function buildList()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, v in ipairs(values) do
            local item = Instance.new("TextButton")
            item.Size              = UDim2.new(1, 0, 0, 26)
            item.BackgroundColor3  = v == value and theme.ElementHover or theme.Element
            item.Text              = v
            item.TextColor3        = v == value and theme.Accent or theme.TextPrimary
            item.TextSize          = 12
            item.Font              = Enum.Font.Gotham
            item.TextXAlignment    = Enum.TextXAlignment.Left
            item.BorderSizePixel   = 0
            item.AutoButtonColor   = false
            item.ZIndex            = 11
            corner(item, UDim.new(0, 4))
            padding(item, 0, 0, 8, 8)
            item.Parent = list

            item.MouseEnter:Connect(function()
                tween(item, { BackgroundColor3 = theme.ElementHover }, 0.08)
            end)
            item.MouseLeave:Connect(function()
                tween(item, { BackgroundColor3 = v == value and theme.ElementHover or theme.Element }, 0.08)
            end)
            item.MouseButton1Click:Connect(function()
                value   = v
                selLbl.Text = v
                open = false
                tween(list, { Size = UDim2.new(0, 100, 0, 0) })
                tween(chevron, { Rotation = 0 })
                buildList()
                pcall(callback, value)
            end)
        end
    end

    buildList()

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.new(1, 0, 0, ELEMENT_H)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.ZIndex               = 2
    btn.Parent               = f

    btn.MouseButton1Click:Connect(function()
        open = not open
        local itemCount = #values
        local listH     = itemCount * 28 + 8
        tween(list, { Size = UDim2.new(0, 100, 0, open and listH or 0) })
        tween(chevron, { Rotation = open and 180 or 0 })
    end)

    btn.MouseEnter:Connect(function()
        tween(f, { BackgroundColor3 = theme.ElementHover })
    end)
    btn.MouseLeave:Connect(function()
        tween(f, { BackgroundColor3 = theme.Element })
    end)

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return value end
    function obj:Set(v)
        value = v
        selLbl.Text = v
        buildList()
    end
    function obj:Refresh(newValues)
        values = newValues
        buildList()
    end
    return obj
end

-- ─── PARAGRAPH ────────────────────────────────────────────────────────────────
function Elements.Paragraph(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local title = cfg.Title or ""
    local desc  = cfg.Desc  or ""

    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize    = Enum.AutomaticSize.Y
    f.BackgroundColor3 = theme.Element
    f.BorderSizePixel  = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 10, 10, 12, 12)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent  = f

    if title ~= "" then
        local t = Instance.new("TextLabel")
        t.Size               = UDim2.new(1, 0, 0, 16)
        t.AutomaticSize      = Enum.AutomaticSize.Y
        t.BackgroundTransparency = 1
        t.Text               = title
        t.TextColor3         = theme.TextPrimary
        t.TextSize           = 13
        t.Font               = Enum.Font.GothamBold
        t.TextXAlignment     = Enum.TextXAlignment.Left
        t.TextWrapped        = true
        t.Parent             = f
    end

    if desc ~= "" then
        local d = Instance.new("TextLabel")
        d.Size               = UDim2.new(1, 0, 0, 0)
        d.AutomaticSize      = Enum.AutomaticSize.Y
        d.BackgroundTransparency = 1
        d.Text               = desc
        d.TextColor3         = theme.TextSecondary
        d.TextSize           = 12
        d.Font               = Enum.Font.Gotham
        d.TextXAlignment     = Enum.TextXAlignment.Left
        d.TextWrapped        = true
        d.Parent             = f
    end

    tab:_addElement(f)
    return f
end

-- ─── DIVIDER ──────────────────────────────────────────────────────────────────
function Elements.Divider(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local label = cfg.Label or ""

    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, 18)
    f.BackgroundTransparency = 1
    f.BorderSizePixel  = 0

    local line = Instance.new("Frame")
    line.Size            = UDim2.new(1, 0, 0, 1)
    line.Position        = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = theme.ElementStroke
    line.BorderSizePixel = 0
    line.Parent          = f

    if label ~= "" then
        local lbl = Instance.new("TextLabel")
        lbl.Size             = UDim2.new(0, 0, 1, 0)
        lbl.AutomaticSize    = Enum.AutomaticSize.X
        lbl.AnchorPoint      = Vector2.new(0.5, 0)
        lbl.Position         = UDim2.new(0.5, 0, 0, 0)
        lbl.BackgroundColor3 = theme.Background
        lbl.Text             = "  " .. label .. "  "
        lbl.TextColor3       = theme.TextDisabled
        lbl.TextSize         = 11
        lbl.Font             = Enum.Font.Gotham
        lbl.BorderSizePixel  = 0
        lbl.Parent           = f
    end

    tab:_addElement(f)
    return f
end

-- ─── SPACE ────────────────────────────────────────────────────────────────────
function Elements.Space(tab, cfg)
    cfg = cfg or {}
    local h = cfg.Height or 8

    local f = Instance.new("Frame")
    f.Size                  = UDim2.new(1, 0, 0, h)
    f.BackgroundTransparency = 1
    f.BorderSizePixel       = 0

    tab:_addElement(f)
    return f
end

-- Injecte tous les éléments dans un Tab
function Elements.inject(Tab)
    function Tab:Button(cfg)   return Elements.Button(self, cfg)   end
    function Tab:Toggle(cfg)   return Elements.Toggle(self, cfg)   end
    function Tab:Input(cfg)    return Elements.Input(self, cfg)    end
    function Tab:Slider(cfg)   return Elements.Slider(self, cfg)   end
    function Tab:Dropdown(cfg) return Elements.Dropdown(self, cfg) end
    function Tab:Paragraph(cfg) return Elements.Paragraph(self, cfg) end
    function Tab:Divider(cfg)  return Elements.Divider(self, cfg)  end
    function Tab:Space(cfg)    return Elements.Space(self, cfg)    end
end

return Elements
