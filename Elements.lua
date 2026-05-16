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
    return f
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

