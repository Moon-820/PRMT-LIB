local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ELEMENT_H = 44
local CORNER_R  = UDim.new(0, 7)
local ANIM      = 0.14

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or ANIM, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER_R
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

local function padding(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 6)
    u.PaddingBottom = UDim.new(0, b or 6)
    u.PaddingLeft   = UDim.new(0, l or 12)
    u.PaddingRight  = UDim.new(0, r or 12)
    u.Parent = p
end

local function baseFrame(theme, h, cfg)
    cfg = cfg or {}
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, h or ELEMENT_H)
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel  = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    return f
end

local function titleDesc(parent, theme, title, desc, offsetRight)
    offsetRight = offsetRight or 0
    local hasDesc = desc and desc ~= ""

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size             = UDim2.new(1, -offsetRight, 0, 16)
    titleLbl.Position         = UDim2.new(0, 0, 0, hasDesc and 8 or 14)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text             = title or ""
    titleLbl.TextColor3       = theme.TextPrimary
    titleLbl.TextSize         = 13
    titleLbl.Font             = Enum.Font.GothamMedium
    titleLbl.TextXAlignment   = Enum.TextXAlignment.Left
    titleLbl.Parent           = parent

    if hasDesc then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size              = UDim2.new(1, -offsetRight, 0, 14)
        descLbl.Position          = UDim2.new(0, 0, 0, 26)
        descLbl.BackgroundTransparency = 1
        descLbl.Text              = desc
        descLbl.TextColor3        = theme.TextSecondary
        descLbl.TextSize          = 11
        descLbl.Font              = Enum.Font.Gotham
        descLbl.TextXAlignment    = Enum.TextXAlignment.Left
        descLbl.TextTruncate      = Enum.TextTruncate.AtEnd
        descLbl.Parent            = parent
    end

    return titleLbl
end

local function getScreenGui(frame)
    local p = frame
    while p do
        if p:IsA("ScreenGui") then return p end
        p = p.Parent
    end
    return nil
end

local Elements = {}

-- ─── BUTTON ───────────────────────────────────────────────────────────────────
function Elements.Button(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Button"
    local desc     = cfg.Desc     or ""
    local callback = cfg.Callback or function() end
    local style    = cfg.Style    or "Default"

    local bgColor
    if style == "Filled" then
        bgColor = cfg.Color or theme.Accent
    elseif style == "Danger" then
        bgColor = cfg.Color or theme.Danger
    elseif style == "Ghost" then
        bgColor = cfg.Color or theme.Element
    else
        bgColor = cfg.Color or theme.Element
    end

    local f = baseFrame(theme, ELEMENT_H, { Color = bgColor, Transparency = cfg.Transparency or 0 })
    padding(f, 0, 0, 12, 12)

    titleDesc(f, theme, title, desc, 36)

    local arrow = Instance.new("TextLabel")
    arrow.Size               = UDim2.new(0, 24, 1, 0)
    arrow.Position           = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text               = "›"
    arrow.TextColor3         = style == "Filled" and theme.Background or (style == "Danger" and Color3.fromRGB(255,255,255) or theme.Accent)
    arrow.TextSize           = 18
    arrow.Font               = Enum.Font.GothamBold
    arrow.TextXAlignment     = Enum.TextXAlignment.Center
    arrow.Parent             = f

    if style == "Ghost" then
        local existingStroke = f:FindFirstChildWhichIsA("UIStroke")
        if existingStroke then existingStroke:Destroy() end
        stroke(f, theme.Accent, 1)
    end

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.ZIndex               = 2
    btn.Parent               = f

    local hoverColor = style == "Filled" and theme.AccentDark or (style == "Danger" and Color3.fromRGB(160, 40, 40) or theme.ElementHover)

    btn.MouseEnter:Connect(function() tween(f, { BackgroundColor3 = hoverColor }) end)
    btn.MouseLeave:Connect(function() tween(f, { BackgroundColor3 = bgColor }) end)
    btn.MouseButton1Down:Connect(function() tween(f, { BackgroundColor3 = theme.AccentDark }) end)
    btn.MouseButton1Up:Connect(function() tween(f, { BackgroundColor3 = hoverColor }) end)
    btn.MouseButton1Click:Connect(function() pcall(callback) end)

    tab:_addElement(f)
    return f
end

-- ─── TOGGLE ───────────────────────────────────────────────────────────────────
function Elements.Toggle(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Toggle"
    local desc     = cfg.Desc     or ""
    local value    = cfg.Value ~= nil and cfg.Value or false
    local callback = cfg.Callback or function() end
    local toggleType = cfg.Type  or "Default"

    local f = baseFrame(theme, ELEMENT_H, { Color = cfg.Color, Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 52)

    local indicator

    if toggleType == "Checkbox" then
        local box = Instance.new("Frame")
        box.Size             = UDim2.new(0, 20, 0, 20)
        box.Position         = UDim2.new(1, -30, 0.5, -10)
        box.BackgroundColor3 = value and theme.Accent or theme.Background
        box.BorderSizePixel  = 0
        corner(box, UDim.new(0, 4))
        stroke(box, value and theme.Accent or theme.ElementStroke, 1.5)
        box.Parent = f

        local checkLbl = Instance.new("TextLabel")
        checkLbl.Size               = UDim2.fromScale(1, 1)
        checkLbl.BackgroundTransparency = 1
        checkLbl.Text               = value and "✓" or ""
        checkLbl.TextColor3         = theme.Background
        checkLbl.TextSize           = 13
        checkLbl.Font               = Enum.Font.GothamBold
        checkLbl.TextXAlignment     = Enum.TextXAlignment.Center
        checkLbl.Parent             = box

        indicator = {
            set = function(v)
                tween(box, { BackgroundColor3 = v and theme.Accent or theme.Background })
                local s = box:FindFirstChildWhichIsA("UIStroke")
                if s then tween(s, { Color = v and theme.Accent or theme.ElementStroke }) end
                checkLbl.Text = v and "✓" or ""
            end
        }
    else
        local track = Instance.new("Frame")
        track.Size             = UDim2.new(0, 36, 0, 20)
        track.Position         = UDim2.new(1, -46, 0.5, -10)
        track.BackgroundColor3 = value and theme.Accent or theme.ElementStroke
        track.BorderSizePixel  = 0
        corner(track, UDim.new(1, 0))
        track.Parent = f

        local thumb = Instance.new("Frame")
        thumb.Size             = UDim2.new(0, 14, 0, 14)
        thumb.Position         = value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        thumb.BorderSizePixel  = 0
        corner(thumb, UDim.new(1, 0))
        thumb.ZIndex           = 3
        thumb.Parent           = track

        indicator = {
            set = function(v)
                tween(track, { BackgroundColor3 = v and theme.Accent or theme.ElementStroke })
                tween(thumb, { Position = v and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
            end
        }
    end

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.ZIndex               = 2
    btn.Parent               = f

    btn.MouseEnter:Connect(function() tween(f, { BackgroundColor3 = theme.ElementHover }) end)
    btn.MouseLeave:Connect(function() tween(f, { BackgroundColor3 = cfg.Color or theme.Element }) end)
    btn.MouseButton1Click:Connect(function()
        value = not value
        indicator.set(value)
        pcall(callback, value)
    end)

    local obj = {}
    function obj:Set(v)
        value = v
        indicator.set(value)
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
    local multiline   = cfg.Multiline   or false
    local height      = multiline and 90 or 70

    local f = baseFrame(theme, height, { Color = cfg.Color, Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size             = UDim2.new(1, 0, 0, 16)
    titleLbl.Position         = UDim2.new(0, 0, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text             = title
    titleLbl.TextColor3       = theme.TextPrimary
    titleLbl.TextSize         = 13
    titleLbl.Font             = Enum.Font.GothamMedium
    titleLbl.TextXAlignment   = Enum.TextXAlignment.Left
    titleLbl.Parent           = f

    local boxH = multiline and 56 or 28

    local box = Instance.new("Frame")
    box.Size             = UDim2.new(1, 0, 0, boxH)
    box.Position         = UDim2.new(0, 0, 0, 30)
    box.BackgroundColor3 = theme.Background
    box.BorderSizePixel  = 0
    corner(box, UDim.new(0, 5))
    stroke(box, theme.ElementStroke, 1)
    box.Parent = f

    local input = Instance.new("TextBox")
    input.Size               = UDim2.new(1, -12, 1, multiline and -8 or 0)
    input.Position           = UDim2.new(0, 6, 0, multiline and 4 or 0)
    input.BackgroundTransparency = 1
    input.Text               = cfg.Default or ""
    input.PlaceholderText    = placeholder
    input.TextColor3         = theme.TextPrimary
    input.PlaceholderColor3  = theme.TextDisabled
    input.TextSize           = 12
    input.Font               = Enum.Font.Gotham
    input.TextXAlignment     = Enum.TextXAlignment.Left
    input.ClearTextOnFocus   = false
    input.MultiLine          = multiline
    input.TextWrapped        = multiline
    input.Parent             = box

    input.Focused:Connect(function()
        tween(box, { BackgroundColor3 = theme.ElementHover })
        local s = box:FindFirstChildWhichIsA("UIStroke")
        if s then tween(s, { Color = theme.Accent }) end
    end)
    input.FocusLost:Connect(function(enter)
        tween(box, { BackgroundColor3 = theme.Background })
        local s = box:FindFirstChildWhichIsA("UIStroke")
        if s then tween(s, { Color = theme.ElementStroke }) end
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
    local theme      = tab._theme
    local title      = cfg.Title    or "Slider"
    local desc       = cfg.Desc     or ""
    local min        = cfg.Min      or 0
    local max        = cfg.Max      or 100
    local value      = cfg.Value    or min
    local suffix     = cfg.Suffix   or ""
    local callback   = cfg.Callback or function() end
    local useInput   = cfg.Input    == true
    local step       = cfg.Step     or 1

    local frameH = useInput and 68 or 58
    local f = baseFrame(theme, frameH, { Color = cfg.Color, Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)

    local rightOffset = useInput and 64 or 54

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size             = UDim2.new(1, -rightOffset, 0, 16)
    titleLbl.Position         = UDim2.new(0, 0, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text             = title
    titleLbl.TextColor3       = theme.TextPrimary
    titleLbl.TextSize         = 13
    titleLbl.Font             = Enum.Font.GothamMedium
    titleLbl.TextXAlignment   = Enum.TextXAlignment.Left
    titleLbl.Parent           = f

    local valDisplay
    local inputBox

    if useInput then
        local inputFrame = Instance.new("Frame")
        inputFrame.Size             = UDim2.new(0, 52, 0, 22)
        inputFrame.Position         = UDim2.new(1, -56, 0, 4)
        inputFrame.BackgroundColor3 = theme.Background
        inputFrame.BorderSizePixel  = 0
        corner(inputFrame, UDim.new(0, 4))
        stroke(inputFrame, theme.ElementStroke, 1)
        inputFrame.Parent = f

        inputBox = Instance.new("TextBox")
        inputBox.Size               = UDim2.new(1, -8, 1, 0)
        inputBox.Position           = UDim2.new(0, 4, 0, 0)
        inputBox.BackgroundTransparency = 1
        inputBox.Text               = tostring(value)
        inputBox.TextColor3         = theme.Accent
        inputBox.TextSize           = 12
        inputBox.Font               = Enum.Font.GothamBold
        inputBox.TextXAlignment     = Enum.TextXAlignment.Center
        inputBox.ClearTextOnFocus   = false
        inputBox.ZIndex             = 4
        inputBox.Parent             = inputFrame

        valDisplay = inputBox
    else
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
        valDisplay = valLbl
    end

    local trackY = useInput and 36 or 36

    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1, 0, 0, 6)
    track.Position         = UDim2.new(0, 0, 0, trackY)
    track.BackgroundColor3 = theme.ElementStroke
    track.BorderSizePixel  = 0
    corner(track, UDim.new(1, 0))
    track.Parent = f

    local fill = Instance.new("Frame")
    fill.Size              = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3  = cfg.AccentColor or theme.Accent
    fill.BorderSizePixel   = 0
    corner(fill, UDim.new(1, 0))
    fill.Parent = track

    local thumb = Instance.new("Frame")
    thumb.Size             = UDim2.new(0, 14, 0, 14)
    thumb.AnchorPoint      = Vector2.new(0.5, 0.5)
    thumb.Position         = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel  = 0
    corner(thumb, UDim.new(1, 0))
    thumb.ZIndex           = 3
    thumb.Parent           = track

    local dragging = false

    local function snapValue(v)
        return math.floor(v / step + 0.5) * step
    end

    local function updateSlider(inputX)
        local trackAbs = track.AbsolutePosition.X
        local trackW   = track.AbsoluteSize.X
        local rel      = math.clamp((inputX - trackAbs) / trackW, 0, 1)
        value = snapValue(min + rel * (max - min))
        value = math.clamp(value, min, max)
        local pct = (value - min) / (max - min)
        tween(fill,  { Size = UDim2.new(pct, 0, 1, 0) }, 0.05)
        tween(thumb, { Position = UDim2.new(pct, 0, 0.5, 0) }, 0.05)
        if useInput then
            inputBox.Text = tostring(value)
        else
            valDisplay.Text = tostring(value) .. suffix
        end
        pcall(callback, value)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    if useInput then
        inputBox.FocusLost:Connect(function()
            local parsed = tonumber(inputBox.Text)
            if parsed then
                value = math.clamp(snapValue(parsed), min, max)
                local pct = (value - min) / (max - min)
                tween(fill,  { Size = UDim2.new(pct, 0, 1, 0) })
                tween(thumb, { Position = UDim2.new(pct, 0, 0.5, 0) })
                inputBox.Text = tostring(value)
                pcall(callback, value)
            else
                inputBox.Text = tostring(value)
            end
        end)
        inputBox:GetPropertyChangedSignal("Text"):Connect(function()
            local parsed = tonumber(inputBox.Text)
            if parsed then
                local clamped = math.clamp(snapValue(parsed), min, max)
                local pct = (clamped - min) / (max - min)
                tween(fill,  { Size = UDim2.new(pct, 0, 1, 0) }, 0.05)
                tween(thumb, { Position = UDim2.new(pct, 0, 0.5, 0) }, 0.05)
            end
        end)
    end

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return value end
    function obj:Set(v)
        value = math.clamp(snapValue(v), min, max)
        local pct = (value - min) / (max - min)
        tween(fill,  { Size = UDim2.new(pct, 0, 1, 0) })
        tween(thumb, { Position = UDim2.new(pct, 0, 0.5, 0) })
        if useInput then
            inputBox.Text = tostring(value)
        else
            valDisplay.Text = tostring(value) .. suffix
        end
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
    local multi    = cfg.Multi    == true

    local open = false
    local selected = multi and {} or value

    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, ELEMENT_H)
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel  = 0
    f.ClipsDescendants = false
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 0, 0, 12, 12)

    titleDesc(f, theme, title, desc, 110)

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
    selLbl.Text              = multi and "Select..." or value
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
    chevron.Text             = "▾"
    chevron.TextColor3       = theme.TextSecondary
    chevron.TextSize         = 10
    chevron.Font             = Enum.Font.GothamBold
    chevron.TextXAlignment   = Enum.TextXAlignment.Center
    chevron.Parent           = selBox

    local function getDisplayText()
        if multi then
            local count = 0
            for _ in pairs(selected) do count = count + 1 end
            return count == 0 and "Select..." or count .. " selected"
        end
        return selected
    end

    local list
    local listConnection

    local function closeList()
        if not list then return end
        open = false
        tween(list, { Size = UDim2.new(0, 110, 0, 0) }, 0.12)
        tween(chevron, { Rotation = 0 })
        task.delay(0.15, function()
            if list then
                list:Destroy()
                list = nil
            end
        end)
        if listConnection then
            listConnection:Disconnect()
            listConnection = nil
        end
    end

    local function buildList()
        if list then list:Destroy() list = nil end

        local screenGui = getScreenGui(f)
        if not screenGui then return end

        list = Instance.new("Frame")
        list.Name              = "DropList"
        list.Size              = UDim2.new(0, 110, 0, 0)
        list.BackgroundColor3  = theme.Element
        list.BorderSizePixel   = 0
        list.ClipsDescendants  = true
        list.ZIndex            = 100
        corner(list)
        stroke(list, theme.ElementStroke, 1)
        list.Parent = screenGui

        local innerPad = Instance.new("UIPadding")
        innerPad.PaddingTop    = UDim.new(0, 4)
        innerPad.PaddingBottom = UDim.new(0, 4)
        innerPad.PaddingLeft   = UDim.new(0, 4)
        innerPad.PaddingRight  = UDim.new(0, 4)
        innerPad.Parent = list

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 2)
        listLayout.Parent  = list

        local function positionList()
            local absPos  = selBox.AbsolutePosition
            local absSize = selBox.AbsoluteSize
            list.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
        end

        positionList()

        local itemCount = #values
        local listH     = itemCount * 28 + 8

        for _, v in ipairs(values) do
            local isSelected = multi and selected[v] or (v == selected)
            local item = Instance.new("TextButton")
            item.Size              = UDim2.new(1, 0, 0, 26)
            item.BackgroundColor3  = isSelected and theme.ElementHover or theme.Element
            item.Text              = (multi and isSelected and "✓  " or "") .. v
            item.TextColor3        = isSelected and theme.Accent or theme.TextPrimary
            item.TextSize          = 12
            item.Font              = Enum.Font.Gotham
            item.TextXAlignment    = Enum.TextXAlignment.Left
            item.BorderSizePixel   = 0
            item.AutoButtonColor   = false
            item.ZIndex            = 101
            corner(item, UDim.new(0, 4))

            local itemPad = Instance.new("UIPadding")
            itemPad.PaddingLeft  = UDim.new(0, 8)
            itemPad.PaddingRight = UDim.new(0, 8)
            itemPad.Parent = item

            item.Parent = list

            item.MouseEnter:Connect(function()
                tween(item, { BackgroundColor3 = theme.ElementHover }, 0.08)
            end)
            item.MouseLeave:Connect(function()
                local sel = multi and selected[v] or (v == selected)
                tween(item, { BackgroundColor3 = sel and theme.ElementHover or theme.Element }, 0.08)
            end)
            item.MouseButton1Click:Connect(function()
                if multi then
                    selected[v] = not selected[v] or nil
                    selLbl.Text = getDisplayText()
                    local arr = {}
                    for k in pairs(selected) do table.insert(arr, k) end
                    pcall(callback, arr)
                    closeList()
                    if open then buildList() end
                else
                    selected = v
                    selLbl.Text = v
                    closeList()
                    pcall(callback, selected)
                end
            end)
        end

        tween(list, { Size = UDim2.new(0, 110, 0, listH) }, 0.12)

        listConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                task.wait()
                local mPos = UserInputService:GetMouseLocation()
                local lPos = list.AbsolutePosition
                local lSize = list.AbsoluteSize
                if mPos.X < lPos.X or mPos.X > lPos.X + lSize.X or mPos.Y < lPos.Y or mPos.Y > lPos.Y + lSize.Y then
                    closeList()
                    open = false
                    tween(chevron, { Rotation = 0 })
                end
            end
        end)
    end

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.new(1, 0, 0, ELEMENT_H)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.ZIndex               = 2
    btn.Parent               = f

    btn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            buildList()
            tween(chevron, { Rotation = 180 })
        else
            closeList()
        end
    end)

    btn.MouseEnter:Connect(function() tween(f, { BackgroundColor3 = theme.ElementHover }) end)
    btn.MouseLeave:Connect(function() tween(f, { BackgroundColor3 = cfg.Color or theme.Element }) end)

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return selected end
    function obj:Set(v)
        if multi then
            selected = v
            selLbl.Text = getDisplayText()
        else
            selected = v
            selLbl.Text = v
        end
    end
    function obj:Refresh(newValues)
        values = newValues
        if open then
            closeList()
            open = false
        end
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
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel  = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 10, 10, 12, 12)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent  = f

    if title ~= "" then
        local t = Instance.new("TextLabel")
        t.Size               = UDim2.new(1, 0, 0, 0)
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
    f.Size                  = UDim2.new(1, 0, 0, 18)
    f.BackgroundTransparency = 1
    f.BorderSizePixel       = 0

    local line = Instance.new("Frame")
    line.Size             = UDim2.new(1, 0, 0, 1)
    line.Position         = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = cfg.Color or theme.ElementStroke
    line.BorderSizePixel  = 0
    line.Parent           = f

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
    local f = Instance.new("Frame")
    f.Size                  = UDim2.new(1, 0, 0, cfg.Height or 8)
    f.BackgroundTransparency = 1
    f.BorderSizePixel       = 0
    tab:_addElement(f)
    return f
end

-- ─── SECTION ──────────────────────────────────────────────────────────────────
function Elements.Section(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local title = cfg.Title or "Section"

    local f = Instance.new("Frame")
    f.Size                  = UDim2.new(1, 0, 0, 24)
    f.BackgroundTransparency = 1
    f.BorderSizePixel       = 0

    local bar = Instance.new("Frame")
    bar.Size             = UDim2.new(0, 3, 0.7, 0)
    bar.Position         = UDim2.new(0, 0, 0.15, 0)
    bar.BackgroundColor3 = cfg.Color or theme.Accent
    bar.BorderSizePixel  = 0
    corner(bar, UDim.new(1, 0))
    bar.Parent = f

    local lbl = Instance.new("TextLabel")
    lbl.Size              = UDim2.new(1, -14, 1, 0)
    lbl.Position          = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text              = title:upper()
    lbl.TextColor3        = theme.TextDisabled
    lbl.TextSize          = 10
    lbl.Font              = Enum.Font.GothamBold
    lbl.TextXAlignment    = Enum.TextXAlignment.Left
    lbl.LetterSpacing     = 1
    lbl.Parent            = f

    tab:_addElement(f)
    return f
end

-- ─── BADGE ────────────────────────────────────────────────────────────────────
function Elements.Badge(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme
    local title = cfg.Title or "Label"
    local text  = cfg.Text  or "NEW"
    local color = cfg.Color or theme.Accent

    local f = baseFrame(theme, ELEMENT_H, { Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, cfg.Desc or "", 60)

    local badge = Instance.new("Frame")
    badge.Size             = UDim2.new(0, 0, 0, 20)
    badge.AutomaticSize    = Enum.AutomaticSize.X
    badge.Position         = UDim2.new(1, -8, 0.5, -10)
    badge.AnchorPoint      = Vector2.new(1, 0)
    badge.BackgroundColor3 = color
    badge.BackgroundTransparency = 0.8
    badge.BorderSizePixel  = 0
    corner(badge, UDim.new(1, 0))

    local badgePad = Instance.new("UIPadding")
    badgePad.PaddingLeft  = UDim.new(0, 8)
    badgePad.PaddingRight = UDim.new(0, 8)
    badgePad.Parent = badge

    local badgeLbl = Instance.new("TextLabel")
    badgeLbl.Size               = UDim2.new(0, 0, 1, 0)
    badgeLbl.AutomaticSize      = Enum.AutomaticSize.X
    badgeLbl.BackgroundTransparency = 1
    badgeLbl.Text               = text
    badgeLbl.TextColor3         = color
    badgeLbl.TextSize           = 10
    badgeLbl.Font               = Enum.Font.GothamBold
    badgeLbl.TextXAlignment     = Enum.TextXAlignment.Center
    badgeLbl.Parent             = badge

    badge.Parent = f

    tab:_addElement(f)
    local obj = {}
    function obj:SetText(t) badgeLbl.Text = t end
    function obj:SetColor(c)
        badge.BackgroundColor3 = c
        badgeLbl.TextColor3 = c
    end
    return obj
end

-- ─── ALERT ────────────────────────────────────────────────────────────────────
function Elements.Alert(tab, cfg)
    cfg = cfg or {}
    local theme   = tab._theme
    local alertType = cfg.Type or "Info"
    local title   = cfg.Title or alertType
    local desc    = cfg.Desc  or ""

    local colorMap = {
        Info    = theme.Accent,
        Success = theme.Success,
        Warning = theme.Warning,
        Danger  = theme.Danger,
    }
    local iconMap = {
        Info    = "ℹ",
        Success = "✓",
        Warning = "⚠",
        Danger  = "✕",
    }

    local accentColor = colorMap[alertType] or theme.Accent
    local icon        = iconMap[alertType]  or "ℹ"

    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize    = Enum.AutomaticSize.Y
    f.BackgroundColor3 = theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel  = 0
    corner(f)

    local accentStroke = Instance.new("UIStroke")
    accentStroke.Color     = accentColor
    accentStroke.Thickness = 1
    accentStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    accentStroke.Parent    = f

    local leftBar = Instance.new("Frame")
    leftBar.Size             = UDim2.new(0, 3, 1, 0)
    leftBar.BackgroundColor3 = accentColor
    leftBar.BorderSizePixel  = 0
    corner(leftBar, UDim.new(0, 2))
    leftBar.Parent = f

    padding(f, 10, 10, 18, 12)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 3)
    layout.Parent  = f

    local titleRow = Instance.new("Frame")
    titleRow.Size               = UDim2.new(1, 0, 0, 16)
    titleRow.BackgroundTransparency = 1
    titleRow.Parent             = f

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size               = UDim2.new(0, 16, 1, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text               = icon
    iconLbl.TextColor3         = accentColor
    iconLbl.TextSize           = 13
    iconLbl.Font               = Enum.Font.GothamBold
    iconLbl.Parent             = titleRow

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size              = UDim2.new(1, -20, 1, 0)
    titleLbl.Position          = UDim2.new(0, 20, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text              = title
    titleLbl.TextColor3        = theme.TextPrimary
    titleLbl.TextSize          = 13
    titleLbl.Font              = Enum.Font.GothamBold
    titleLbl.TextXAlignment    = Enum.TextXAlignment.Left
    titleLbl.Parent            = titleRow

    if desc ~= "" then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size               = UDim2.new(1, 0, 0, 0)
        descLbl.AutomaticSize      = Enum.AutomaticSize.Y
        descLbl.BackgroundTransparency = 1
        descLbl.Text               = desc
        descLbl.TextColor3         = theme.TextSecondary
        descLbl.TextSize           = 11
        descLbl.Font               = Enum.Font.Gotham
        descLbl.TextXAlignment     = Enum.TextXAlignment.Left
        descLbl.TextWrapped        = true
        descLbl.Parent             = f
    end

    tab:_addElement(f)
    return f
end

-- ─── KEYBIND ──────────────────────────────────────────────────────────────────
function Elements.Keybind(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Keybind"
    local desc     = cfg.Desc     or ""
    local default  = cfg.Default  or Enum.KeyCode.Unknown
    local callback = cfg.Callback or function() end

    local key      = default
    local listening = false

    local f = baseFrame(theme, ELEMENT_H, { Color = cfg.Color, Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 80)

    local keyFrame = Instance.new("Frame")
    keyFrame.Size             = UDim2.new(0, 70, 0, 24)
    keyFrame.Position         = UDim2.new(1, -78, 0.5, -12)
    keyFrame.BackgroundColor3 = theme.Background
    keyFrame.BorderSizePixel  = 0
    corner(keyFrame, UDim.new(0, 5))
    stroke(keyFrame, theme.ElementStroke, 1)
    keyFrame.Parent = f

    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size               = UDim2.fromScale(1, 1)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text               = key == Enum.KeyCode.Unknown and "None" or key.Name
    keyLbl.TextColor3         = theme.Accent
    keyLbl.TextSize           = 12
    keyLbl.Font               = Enum.Font.GothamBold
    keyLbl.TextXAlignment     = Enum.TextXAlignment.Center
    keyLbl.Parent             = keyFrame

    local btn = Instance.new("TextButton")
    btn.Size                 = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text                 = ""
    btn.ZIndex               = 2
    btn.Parent               = f

    btn.MouseEnter:Connect(function() tween(f, { BackgroundColor3 = theme.ElementHover }) end)
    btn.MouseLeave:Connect(function() tween(f, { BackgroundColor3 = cfg.Color or theme.Element }) end)

    btn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyLbl.Text      = "..."
        keyLbl.TextColor3 = theme.TextSecondary
        tween(keyFrame, { BackgroundColor3 = theme.ElementHover })
        local s = keyFrame:FindFirstChildWhichIsA("UIStroke")
        if s then tween(s, { Color = theme.Accent }) end
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not listening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            key = input.KeyCode
            listening = false
            keyLbl.Text      = key.Name
            keyLbl.TextColor3 = theme.Accent
            tween(keyFrame, { BackgroundColor3 = theme.Background })
            local s = keyFrame:FindFirstChildWhichIsA("UIStroke")
            if s then tween(s, { Color = theme.ElementStroke }) end
            pcall(callback, key)
        end
    end)

    local obj = {}
    function obj:Get() return key end
    function obj:Set(k)
        key = k
        keyLbl.Text = k == Enum.KeyCode.Unknown and "None" or k.Name
    end
    tab:_addElement(f)
    return obj
end

-- ─── KEYBIND BUTTON ───────────────────────────────────────────────────────────
function Elements.KeybindButton(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "KeybindButton"
    local desc     = cfg.Desc     or ""
    local default  = cfg.Default  or Enum.KeyCode.Unknown
    local onPress  = cfg.OnPress  or function() end
    local onBind   = cfg.OnBind   or function() end

    local key       = default
    local listening = false

    local f = baseFrame(theme, ELEMENT_H, { Color = cfg.Color, Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 120)

    local keyFrame = Instance.new("Frame")
    keyFrame.Size             = UDim2.new(0, 58, 0, 24)
    keyFrame.Position         = UDim2.new(1, -66, 0.5, -12)
    keyFrame.BackgroundColor3 = theme.Background
    keyFrame.BorderSizePixel  = 0
    corner(keyFrame, UDim.new(0, 5))
    stroke(keyFrame, theme.ElementStroke, 1)
    keyFrame.Parent = f

    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size               = UDim2.fromScale(1, 1)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Text               = key == Enum.KeyCode.Unknown and "None" or key.Name
    keyLbl.TextColor3         = theme.Accent
    keyLbl.TextSize           = 11
    keyLbl.Font               = Enum.Font.GothamBold
    keyLbl.TextXAlignment     = Enum.TextXAlignment.Center
    keyLbl.Parent             = keyFrame

    local mainBtn = Instance.new("TextButton")
    mainBtn.Size             = UDim2.new(1, -70, 1, 0)
    mainBtn.BackgroundTransparency = 1
    mainBtn.Text             = ""
    mainBtn.ZIndex           = 2
    mainBtn.Parent           = f

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size             = UDim2.new(0, 64, 1, 0)
    bindBtn.Position         = UDim2.new(1, -64, 0, 0)
    bindBtn.BackgroundTransparency = 1
    bindBtn.Text             = ""
    bindBtn.ZIndex           = 2
    bindBtn.Parent           = f

    mainBtn.MouseEnter:Connect(function() tween(f, { BackgroundColor3 = theme.ElementHover }) end)
    mainBtn.MouseLeave:Connect(function() tween(f, { BackgroundColor3 = cfg.Color or theme.Element }) end)
    mainBtn.MouseButton1Down:Connect(function() tween(f, { BackgroundColor3 = theme.AccentDark }) end)
    mainBtn.MouseButton1Up:Connect(function() tween(f, { BackgroundColor3 = theme.ElementHover }) end)
    mainBtn.MouseButton1Click:Connect(function() pcall(onPress) end)

    bindBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyLbl.Text = "..."
        keyLbl.TextColor3 = theme.TextSecondary
        tween(keyFrame, { BackgroundColor3 = theme.ElementHover })
        local s = keyFrame:FindFirstChildWhichIsA("UIStroke")
        if s then tween(s, { Color = theme.Accent }) end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if not listening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            key = input.KeyCode
            listening = false
            keyLbl.Text = key.Name
            keyLbl.TextColor3 = theme.Accent
            tween(keyFrame, { BackgroundColor3 = theme.Background })
            local s = keyFrame:FindFirstChildWhichIsA("UIStroke")
            if s then tween(s, { Color = theme.ElementStroke }) end
            pcall(onBind, key)
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then
            pcall(onPress)
        end
    end)

    local obj = {}
    function obj:GetKey() return key end
    function obj:SetKey(k)
        key = k
        keyLbl.Text = k == Enum.KeyCode.Unknown and "None" or k.Name
    end
    tab:_addElement(f)
    return obj
end

-- ─── PROFILE FRAME ────────────────────────────────────────────────────────────
function Elements.ProfileFrame(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local name     = cfg.Name     or "Player"
    local subtitle = cfg.Subtitle or ""
    local userId   = cfg.UserId   or 0
    local badges   = cfg.Badges   or {}
    local onAction = cfg.OnAction or nil
    local actionText = cfg.ActionText or "Action"

    local frameH = 68
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, frameH)
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel  = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size             = UDim2.new(0, 46, 0, 46)
    avatarFrame.Position         = UDim2.new(0, 10, 0.5, -23)
    avatarFrame.BackgroundColor3 = theme.ElementStroke
    avatarFrame.BorderSizePixel  = 0
    corner(avatarFrame, UDim.new(1, 0))
    avatarFrame.Parent = f

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size               = UDim2.fromScale(1, 1)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Image              = userId > 0 and ("https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png") or ""
    avatarImg.ScaleType          = Enum.ScaleType.Crop
    corner(avatarImg, UDim.new(1, 0))
    avatarImg.Parent = avatarFrame

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size              = UDim2.new(1, -80 - (onAction and 90 or 0), 0, 16)
    nameLbl.Position          = UDim2.new(0, 64, 0, subtitle ~= "" and 12 or 26)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text              = name
    nameLbl.TextColor3        = theme.TextPrimary
    nameLbl.TextSize          = 14
    nameLbl.Font              = Enum.Font.GothamBold
    nameLbl.TextXAlignment    = Enum.TextXAlignment.Left
    nameLbl.TextTruncate      = Enum.TextTruncate.AtEnd
    nameLbl.Parent            = f

    if subtitle ~= "" then
        local subLbl = Instance.new("TextLabel")
        subLbl.Size              = UDim2.new(1, -80 - (onAction and 90 or 0), 0, 14)
        subLbl.Position          = UDim2.new(0, 64, 0, 30)
        subLbl.BackgroundTransparency = 1
        subLbl.Text              = subtitle
        subLbl.TextColor3        = theme.TextSecondary
        subLbl.TextSize          = 11
        subLbl.Font              = Enum.Font.Gotham
        subLbl.TextXAlignment    = Enum.TextXAlignment.Left
        subLbl.TextTruncate      = Enum.TextTruncate.AtEnd
        subLbl.Parent            = f
    end

    if #badges > 0 then
        local badgeRow = Instance.new("Frame")
        badgeRow.Size               = UDim2.new(0, 0, 0, 16)
        badgeRow.Position           = UDim2.new(0, 64, 1, -20)
        badgeRow.AutomaticSize      = Enum.AutomaticSize.X
        badgeRow.BackgroundTransparency = 1
        badgeRow.Parent = f

        local badgeLayout = Instance.new("UIListLayout")
        badgeLayout.FillDirection = Enum.FillDirection.Horizontal
        badgeLayout.Padding       = UDim.new(0, 4)
        badgeLayout.Parent        = badgeRow

        for _, b in ipairs(badges) do
            local bFrame = Instance.new("Frame")
            bFrame.Size             = UDim2.new(0, 0, 1, 0)
            bFrame.AutomaticSize    = Enum.AutomaticSize.X
            bFrame.BackgroundColor3 = b.Color or theme.Accent
            bFrame.BackgroundTransparency = 0.8
            bFrame.BorderSizePixel  = 0
            corner(bFrame, UDim.new(1, 0))

            local bp = Instance.new("UIPadding")
            bp.PaddingLeft  = UDim.new(0, 5)
            bp.PaddingRight = UDim.new(0, 5)
            bp.Parent = bFrame

            local bLbl = Instance.new("TextLabel")
            bLbl.Size               = UDim2.new(0, 0, 1, 0)
            bLbl.AutomaticSize      = Enum.AutomaticSize.X
            bLbl.BackgroundTransparency = 1
            bLbl.Text               = b.Text or "?"
            bLbl.TextColor3         = b.Color or theme.Accent
            bLbl.TextSize           = 9
            bLbl.Font               = Enum.Font.GothamBold
            bLbl.Parent             = bFrame

            bFrame.Parent = badgeRow
        end
    end

    if onAction then
        local actionBtn = Instance.new("TextButton")
        actionBtn.Size             = UDim2.new(0, 80, 0, 26)
        actionBtn.Position         = UDim2.new(1, -90, 0.5, -13)
        actionBtn.BackgroundColor3 = theme.Accent
        actionBtn.Text             = actionText
        actionBtn.TextColor3       = theme.Background
        actionBtn.TextSize         = 11
        actionBtn.Font             = Enum.Font.GothamBold
        actionBtn.BorderSizePixel  = 0
        actionBtn.AutoButtonColor  = false
        actionBtn.ZIndex           = 2
        corner(actionBtn, UDim.new(0, 6))
        actionBtn.Parent = f

        actionBtn.MouseEnter:Connect(function() tween(actionBtn, { BackgroundColor3 = theme.AccentDark }) end)
        actionBtn.MouseLeave:Connect(function() tween(actionBtn, { BackgroundColor3 = theme.Accent }) end)
        actionBtn.MouseButton1Click:Connect(function() pcall(onAction) end)
    end

    tab:_addElement(f)

    local obj = {}
    function obj:SetName(n) nameLbl.Text = n end
    function obj:SetAvatar(id)
        avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. id .. "&width=150&height=150&format=png"
    end
    return obj
end

-- ─── CARD ─────────────────────────────────────────────────────────────────────
function Elements.Card(tab, cfg)
    cfg = cfg or {}
    local theme   = tab._theme
    local title   = cfg.Title   or "Card"
    local desc    = cfg.Desc    or ""
    local icon    = cfg.Icon    or ""
    local onClick = cfg.OnClick or nil

    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, 0)
    f.AutomaticSize    = Enum.AutomaticSize.Y
    f.BackgroundColor3 = cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel  = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 14, 14, 14, 14)

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent  = f

    if icon ~= "" then
        local iconLbl = Instance.new("TextLabel")
        iconLbl.Size               = UDim2.new(1, 0, 0, 22)
        iconLbl.BackgroundTransparency = 1
        iconLbl.Text               = icon
        iconLbl.TextColor3         = theme.Accent
        iconLbl.TextSize           = 18
        iconLbl.Font               = Enum.Font.GothamBold
        iconLbl.TextXAlignment     = Enum.TextXAlignment.Left
        iconLbl.Parent             = f
    end

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size               = UDim2.new(1, 0, 0, 0)
    titleLbl.AutomaticSize      = Enum.AutomaticSize.Y
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text               = title
    titleLbl.TextColor3         = theme.TextPrimary
    titleLbl.TextSize           = 14
    titleLbl.Font               = Enum.Font.GothamBold
    titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
    titleLbl.TextWrapped        = true
    titleLbl.Parent             = f

    if desc ~= "" then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size               = UDim2.new(1, 0, 0, 0)
        descLbl.AutomaticSize      = Enum.AutomaticSize.Y
        descLbl.BackgroundTransparency = 1
        descLbl.Text               = desc
        descLbl.TextColor3         = theme.TextSecondary
        descLbl.TextSize           = 12
        descLbl.Font               = Enum.Font.Gotham
        descLbl.TextXAlignment     = Enum.TextXAlignment.Left
        descLbl.TextWrapped        = true
        descLbl.Parent             = f
    end

    if onClick then
        local clickBtn = Instance.new("TextButton")
        clickBtn.Size                 = UDim2.fromScale(1, 1)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text                 = ""
        clickBtn.ZIndex               = 2
        clickBtn.Parent               = f

        clickBtn.MouseEnter:Connect(function() tween(f, { BackgroundColor3 = theme.ElementHover }) end)
        clickBtn.MouseLeave:Connect(function() tween(f, { BackgroundColor3 = cfg.Color or theme.Element }) end)
        clickBtn.MouseButton1Click:Connect(function() pcall(onClick) end)
    end

    tab:_addElement(f)
    return f
end

-- ─── COLOR PICKER ─────────────────────────────────────────────────────────────
function Elements.ColorPicker(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Color"
    local desc     = cfg.Desc     or ""
    local default  = cfg.Default  or Color3.fromRGB(220, 180, 60)
    local callback = cfg.Callback or function() end

    local color = default
    local open  = false

    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, ELEMENT_H)
    f.BackgroundColor3 = cfg.Color and cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel  = 0
    f.ClipsDescendants = false
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    padding(f, 0, 0, 12, 12)

    titleDesc(f, theme, title, desc, 46)

    local swatch = Instance.new("Frame")
    swatch.Size             = UDim2.new(0, 28, 0, 20)
    swatch.Position         = UDim2.new(1, -36, 0.5, -10)
    swatch.BackgroundColor3 = color
    swatch.BorderSizePixel  = 0
    corner(swatch, UDim.new(0, 5))
    stroke(swatch, theme.ElementStroke, 1)
    swatch.Parent = f

    local picker
    local hue, sat, val_ = Color3.toHSV(color)

    local function closeColorPicker()
        if not picker then return end
        open = false
        picker:Destroy()
        picker = nil
    end

    local function buildPicker()
        if picker then picker:Destroy() picker = nil end

        local screenGui = getScreenGui(f)
        if not screenGui then return end

        picker = Instance.new("Frame")
        picker.Size             = UDim2.new(0, 200, 0, 220)
        picker.BackgroundColor3 = theme.Element
        picker.BorderSizePixel  = 0
        picker.ZIndex           = 100
        corner(picker)
        stroke(picker, theme.ElementStroke, 1)
        picker.Parent = screenGui

        local absPos  = swatch.AbsolutePosition
        local absSize = swatch.AbsoluteSize
        picker.Position = UDim2.new(0, absPos.X - 160, 0, absPos.Y + absSize.Y + 6)

        local pickerPad = Instance.new("UIPadding")
        pickerPad.PaddingTop    = UDim.new(0, 10)
        pickerPad.PaddingBottom = UDim.new(0, 10)
        pickerPad.PaddingLeft   = UDim.new(0, 10)
        pickerPad.PaddingRight  = UDim.new(0, 10)
        pickerPad.Parent = picker

        local pickerLayout = Instance.new("UIListLayout")
        pickerLayout.Padding = UDim.new(0, 8)
        pickerLayout.Parent  = picker

        local function makeSliderRow(labelText, defaultVal, barColor, onChanged)
            local row = Instance.new("Frame")
            row.Size             = UDim2.new(1, 0, 0, 28)
            row.BackgroundTransparency = 1
            row.ZIndex           = 101
            row.Parent           = picker

            local lbl = Instance.new("TextLabel")
            lbl.Size             = UDim2.new(0, 20, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text             = labelText
            lbl.TextColor3       = theme.TextSecondary
            lbl.TextSize         = 10
            lbl.Font             = Enum.Font.GothamBold
            lbl.ZIndex           = 101
            lbl.Parent           = row

            local sTrack = Instance.new("Frame")
            sTrack.Size             = UDim2.new(1, -60, 0, 6)
            sTrack.Position         = UDim2.new(0, 24, 0.5, -3)
            sTrack.BackgroundColor3 = theme.ElementStroke
            sTrack.BorderSizePixel  = 0
            sTrack.ZIndex           = 101
            corner(sTrack, UDim.new(1, 0))
            sTrack.Parent = row

            local sFill = Instance.new("Frame")
            sFill.Size             = UDim2.new(defaultVal, 0, 1, 0)
            sFill.BackgroundColor3 = barColor
            sFill.BorderSizePixel  = 0
            sFill.ZIndex           = 102
            corner(sFill, UDim.new(1, 0))
            sFill.Parent = sTrack

            local sThumb = Instance.new("Frame")
            sThumb.Size             = UDim2.new(0, 12, 0, 12)
            sThumb.AnchorPoint      = Vector2.new(0.5, 0.5)
            sThumb.Position         = UDim2.new(defaultVal, 0, 0.5, 0)
            sThumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
            sThumb.BorderSizePixel  = 0
            sThumb.ZIndex           = 103
            corner(sThumb, UDim.new(1, 0))
            sThumb.Parent = sTrack

            local valLbl2 = Instance.new("TextLabel")
            valLbl2.Size             = UDim2.new(0, 30, 1, 0)
            valLbl2.Position         = UDim2.new(1, -30, 0, 0)
            valLbl2.BackgroundTransparency = 1
            valLbl2.Text             = tostring(math.floor(defaultVal * 255))
            valLbl2.TextColor3       = theme.TextSecondary
            valLbl2.TextSize         = 10
            valLbl2.Font             = Enum.Font.Gotham
            valLbl2.TextXAlignment   = Enum.TextXAlignment.Right
            valLbl2.ZIndex           = 101
            valLbl2.Parent           = row

            local sDrag = false
            sTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sDrag = true
                    local rel = math.clamp((input.Position.X - sTrack.AbsolutePosition.X) / sTrack.AbsoluteSize.X, 0, 1)
                    tween(sFill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.05)
                    tween(sThumb, { Position = UDim2.new(rel, 0, 0.5, 0) }, 0.05)
                    valLbl2.Text = tostring(math.floor(rel * 255))
                    onChanged(rel)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - sTrack.AbsolutePosition.X) / sTrack.AbsoluteSize.X, 0, 1)
                    tween(sFill, { Size = UDim2.new(rel, 0, 1, 0) }, 0.05)
                    tween(sThumb, { Position = UDim2.new(rel, 0, 0.5, 0) }, 0.05)
                    valLbl2.Text = tostring(math.floor(rel * 255))
                    onChanged(rel)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sDrag = false end
            end)
        end

        local function applyColor()
            color = Color3.fromHSV(hue, sat, val_)
            swatch.BackgroundColor3 = color
            pcall(callback, color)
        end

        makeSliderRow("H", hue, theme.Accent, function(v) hue = v applyColor() end)
        makeSliderRow("S", sat, theme.Accent, function(v) sat = v applyColor() end)
        makeSliderRow("V", val_, theme.Accent, function(v) val_ = v applyColor() end)

        local hexRow = Instance.new("Frame")
        hexRow.Size             = UDim2.new(1, 0, 0, 30)
        hexRow.BackgroundTransparency = 1
        hexRow.ZIndex           = 101
        hexRow.Parent           = picker

        local hexLabel = Instance.new("TextLabel")
        hexLabel.Size             = UDim2.new(0, 22, 1, 0)
        hexLabel.BackgroundTransparency = 1
        hexLabel.Text             = "#"
        hexLabel.TextColor3       = theme.TextSecondary
        hexLabel.TextSize         = 12
        hexLabel.Font             = Enum.Font.GothamBold
        hexLabel.ZIndex           = 101
        hexLabel.Parent           = hexRow

        local hexBox = Instance.new("Frame")
        hexBox.Size             = UDim2.new(1, -22, 0, 26)
        hexBox.Position         = UDim2.new(0, 22, 0.5, -13)
        hexBox.BackgroundColor3 = theme.Background
        hexBox.BorderSizePixel  = 0
        hexBox.ZIndex           = 101
        corner(hexBox, UDim.new(0, 4))
        stroke(hexBox, theme.ElementStroke, 1)
        hexBox.Parent = hexRow

        local function colorToHex(c)
            return string.format("%02X%02X%02X", math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255))
        end

        local hexInput = Instance.new("TextBox")
        hexInput.Size               = UDim2.new(1, -8, 1, 0)
        hexInput.Position           = UDim2.new(0, 4, 0, 0)
        hexInput.BackgroundTransparency = 1
        hexInput.Text               = colorToHex(color)
        hexInput.TextColor3         = theme.TextPrimary
        hexInput.TextSize           = 12
        hexInput.Font               = Enum.Font.GothamMedium
        hexInput.ClearTextOnFocus   = false
        hexInput.ZIndex             = 102
        hexInput.Parent             = hexBox

        hexInput.FocusLost:Connect(function()
            local hex = hexInput.Text:gsub("#", ""):upper()
            if #hex == 6 then
                local r = tonumber(hex:sub(1,2), 16)
                local g = tonumber(hex:sub(3,4), 16)
                local b = tonumber(hex:sub(5,6), 16)
                if r and g and b then
                    color = Color3.fromRGB(r, g, b)
                    hue, sat, val_ = Color3.toHSV(color)
                    swatch.BackgroundColor3 = color
                    pcall(callback, color)
                end
            end
            hexInput.Text = colorToHex(color)
        end)

        local closePickerBtn = Instance.new("TextButton")
        closePickerBtn.Size             = UDim2.new(1, 0, 0, 28)
        closePickerBtn.BackgroundColor3 = theme.Background
        closePickerBtn.Text             = "Apply"
        closePickerBtn.TextColor3       = theme.TextPrimary
        closePickerBtn.TextSize         = 12
        closePickerBtn.Font             = Enum.Font.GothamBold
        closePickerBtn.BorderSizePixel  = 0
        closePickerBtn.AutoButtonColor  = false
        closePickerBtn.ZIndex           = 101
        corner(closePickerBtn, UDim.new(0, 5))
        closePickerBtn.Parent = picker

        closePickerBtn.MouseButton1Click:Connect(function()
            closeColorPicker()
        end)
    end

    local swatchBtn = Instance.new("TextButton")
    swatchBtn.Size                 = UDim2.new(0, 28, 0, 20)
    swatchBtn.Position             = UDim2.new(1, -36, 0.5, -10)
    swatchBtn.BackgroundTransparency = 1
    swatchBtn.Text                 = ""
    swatchBtn.ZIndex               = 2
    swatchBtn.Parent               = f

    swatchBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            buildPicker()
        else
            closeColorPicker()
        end
    end)

    local bgBtn = Instance.new("TextButton")
    bgBtn.Size                 = UDim2.new(1, -44, 1, 0)
    bgBtn.BackgroundTransparency = 1
    bgBtn.Text                 = ""
    bgBtn.ZIndex               = 2
    bgBtn.Parent               = f
    bgBtn.MouseEnter:Connect(function() tween(f, { BackgroundColor3 = theme.ElementHover }) end)
    bgBtn.MouseLeave:Connect(function() tween(f, { BackgroundColor3 = cfg.Color and cfg.Color or theme.Element }) end)

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return color end
    function obj:Set(c)
        color = c
        hue, sat, val_ = Color3.toHSV(c)
        swatch.BackgroundColor3 = c
    end
    return obj
end

-- ─── INJECT ───────────────────────────────────────────────────────────────────
function Elements.inject(Tab)
    function Tab:Button(cfg)        return Elements.Button(self, cfg)        end
    function Tab:Toggle(cfg)        return Elements.Toggle(self, cfg)        end
    function Tab:Input(cfg)         return Elements.Input(self, cfg)         end
    function Tab:Slider(cfg)        return Elements.Slider(self, cfg)        end
    function Tab:Dropdown(cfg)      return Elements.Dropdown(self, cfg)      end
    function Tab:Paragraph(cfg)     return Elements.Paragraph(self, cfg)     end
    function Tab:Divider(cfg)       return Elements.Divider(self, cfg)       end
    function Tab:Space(cfg)         return Elements.Space(self, cfg)         end
    function Tab:Section(cfg)       return Elements.Section(self, cfg)       end
    function Tab:Badge(cfg)         return Elements.Badge(self, cfg)         end
    function Tab:Alert(cfg)         return Elements.Alert(self, cfg)         end
    function Tab:Keybind(cfg)       return Elements.Keybind(self, cfg)       end
    function Tab:KeybindButton(cfg) return Elements.KeybindButton(self, cfg) end
    function Tab:ProfileFrame(cfg)  return Elements.ProfileFrame(self, cfg)  end
    function Tab:Card(cfg)          return Elements.Card(self, cfg)          end
    function Tab:ColorPicker(cfg)   return Elements.ColorPicker(self, cfg)   end
end

return Elements
