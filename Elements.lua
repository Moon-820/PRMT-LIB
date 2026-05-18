local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local ELEMENT_H  = 46
local CORNER_R   = UDim.new(0, 7)
local CORNER_SM  = UDim.new(0, 5)
local ANIM       = 0.14
local ANIM_FAST  = 0.09
local OVERLAY_Z  = 9999

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
    s.Color           = col
    s.Thickness       = th or 1
    s.LineJoinMode    = Enum.LineJoinMode.Round
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent          = p
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

local function lbl(parent, text, col, sz, font, xa)
    local l = Instance.new("TextLabel")
    l.Text                   = text or ""
    l.TextColor3             = col or Color3.fromRGB(240, 240, 240)
    l.TextSize               = sz or 13
    l.Font                   = font or Enum.Font.GothamMedium
    l.BackgroundTransparency = 1
    l.TextXAlignment         = xa or Enum.TextXAlignment.Left
    l.TextYAlignment         = Enum.TextYAlignment.Center
    l.TextTruncate           = Enum.TextTruncate.AtEnd
    l.Parent                 = parent
    return l
end

local function mkBtn(parent, size, pos, zi)
    local b = Instance.new("TextButton")
    b.Size                   = size or UDim2.fromScale(1, 1)
    b.Position               = pos or UDim2.new(0, 0, 0, 0)
    b.BackgroundTransparency = 1
    b.Text                   = ""
    b.BorderSizePixel        = 0
    b.AutoButtonColor        = false
    b.ZIndex                 = zi or 2
    b.Parent                 = parent
    return b
end

local function mkFrame(parent, bg, size, pos, zi)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or Color3.fromRGB(20, 20, 20)
    f.Size             = size or UDim2.fromScale(1, 1)
    f.Position         = pos or UDim2.new(0, 0, 0, 0)
    f.BorderSizePixel  = 0
    if zi then f.ZIndex = zi end
    f.Parent = parent
    return f
end

local function getScreenGui(instance)
    local p = instance
    while p do
        if p:IsA("ScreenGui") then return p end
        p = p.Parent
    end
    return nil
end

local function positionPopup(popup, anchor, ox, oy)
    ox = ox or 0
    oy = oy or 4
    local vp   = workspace.CurrentCamera.ViewportSize
    local abs  = anchor.AbsolutePosition
    local asiz = anchor.AbsoluteSize
    local psiz = popup.AbsoluteSize

    local x = abs.X + ox
    local y = abs.Y + asiz.Y + oy

    if y + psiz.Y > vp.Y - 8 then y = abs.Y - psiz.Y - oy end
    if x + psiz.X > vp.X - 8 then x = vp.X - psiz.X - 8 end
    if x < 6 then x = 6 end
    if y < 6 then y = 6 end

    popup.Position = UDim2.new(0, x, 0, y)
end

local function baseFrame(theme, h, cfg)
    cfg = cfg or {}
    local f = Instance.new("Frame")
    f.Size               = UDim2.new(1, 0, 0, h or ELEMENT_H)
    f.BackgroundColor3   = cfg.Color or theme.Element
    f.BackgroundTransparency = cfg.Transparency or 0
    f.BorderSizePixel    = 0
    f.ClipsDescendants   = true
    corner(f)
    stroke(f, theme.ElementStroke, 1)
    return f
end

local function titleDesc(parent, theme, title, desc, offsetRight)
    offsetRight = offsetRight or 0
    local hasDesc = desc and desc ~= ""

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size                   = UDim2.new(1, -offsetRight, 0, 16)
    titleLbl.Position               = UDim2.new(0, 0, 0, hasDesc and 8 or 15)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text                   = title or ""
    titleLbl.TextColor3             = theme.TextPrimary
    titleLbl.TextSize               = 13
    titleLbl.Font                   = Enum.Font.GothamMedium
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.TextTruncate           = Enum.TextTruncate.AtEnd
    titleLbl.Parent                 = parent

    if hasDesc then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size                   = UDim2.new(1, -offsetRight, 0, 14)
        descLbl.Position               = UDim2.new(0, 0, 0, 26)
        descLbl.BackgroundTransparency = 1
        descLbl.Text                   = desc
        descLbl.TextColor3             = theme.TextSecondary
        descLbl.TextSize               = 11
        descLbl.Font                   = Enum.Font.Gotham
        descLbl.TextXAlignment         = Enum.TextXAlignment.Left
        descLbl.TextTruncate           = Enum.TextTruncate.AtEnd
        descLbl.Parent                 = parent
    end

    return titleLbl
end

local Elements = {}

function Elements.Button(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Button"
    local desc     = cfg.Desc     or ""
    local callback = cfg.Callback or function() end
    local style    = cfg.Style    or "Default"
    local disabled = cfg.Disabled or false

    local bgColor
    if style == "Filled" then
        bgColor = cfg.Color or theme.Accent
    elseif style == "Danger" then
        bgColor = cfg.Color or theme.Danger
    elseif style == "Ghost" then
        bgColor = cfg.Color or theme.Element
    elseif style == "Success" then
        bgColor = cfg.Color or theme.Success
    else
        bgColor = cfg.Color or theme.Element
    end

    local f = baseFrame(theme, ELEMENT_H, { Color = bgColor, Transparency = cfg.Transparency or 0 })
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 36)

    local arrow = lbl(f, "›", style == "Filled" and Color3.fromRGB(10,10,10) or theme.Accent, 18, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    arrow.Size         = UDim2.new(0, 22, 1, 0)
    arrow.Position     = UDim2.new(1, -26, 0, 0)
    arrow.TextTruncate = Enum.TextTruncate.None

    if style == "Ghost" then
        local s = f:FindFirstChildWhichIsA("UIStroke")
        if s then s:Destroy() end
        stroke(f, theme.Accent, 1.2)
    end

    local hoverColor
    if style == "Filled" then hoverColor = theme.AccentDark
    elseif style == "Danger" then hoverColor = theme.DangerDark
    elseif style == "Success" then hoverColor = theme.SuccessDark
    else hoverColor = theme.ElementHover end

    local b = mkBtn(f)
    b.MouseEnter:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = hoverColor })
    end)
    b.MouseLeave:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = bgColor })
    end)
    b.MouseButton1Down:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = style == "Filled" and theme.AccentDark or theme.ElementActive })
    end)
    b.MouseButton1Up:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = hoverColor })
    end)
    b.MouseButton1Click:Connect(function()
        if disabled then return end
        task.spawn(function() pcall(callback) end)
    end)

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = { _frame = f }
    function obj:SetDisabled(v)
        disabled = v
        tween(f, { BackgroundTransparency = v and 0.4 or 0 })
    end
    function obj:Trigger()
        task.spawn(function() pcall(callback) end)
    end
    return obj
end

function Elements.Toggle(tab, cfg)
    cfg = cfg or {}
    local theme      = tab._theme
    local title      = cfg.Title    or "Toggle"
    local desc       = cfg.Desc     or ""
    local value      = cfg.Value ~= nil and cfg.Value or false
    local callback   = cfg.Callback or function() end
    local toggleType = cfg.Type     or "Default"
    local disabled   = cfg.Disabled or false

    local f = baseFrame(theme, ELEMENT_H, { Color = cfg.Color, Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 52)

    local indicator

    if toggleType == "Checkbox" then
        local box = mkFrame(f, value and theme.Accent or theme.InputBg, UDim2.new(0, 20, 0, 20))
        box.Position = UDim2.new(1, -24, 0.5, -10)
        corner(box, UDim.new(0, 5))
        local bs = stroke(box, value and theme.Accent or theme.ElementStroke, 1.5)

        local chk = lbl(box, "✓", Color3.fromRGB(255, 255, 255), 12, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        chk.Size             = UDim2.fromScale(1, 1)
        chk.TextTransparency = value and 0 or 1
        chk.TextTruncate     = Enum.TextTruncate.None

        indicator = {
            set = function(v)
                tween(box, { BackgroundColor3 = v and theme.Accent or theme.InputBg })
                tween(chk, { TextTransparency = v and 0 or 1 })
                bs.Color = v and theme.Accent or theme.ElementStroke
            end
        }
    else
        local track = mkFrame(f, value and theme.Accent or theme.ElementStroke, UDim2.new(0, 38, 0, 20))
        track.Position = UDim2.new(1, -42, 0.5, -10)
        corner(track, UDim.new(1, 0))

        local thumb = mkFrame(track, Color3.fromRGB(255, 255, 255), UDim2.new(0, 14, 0, 14))
        thumb.AnchorPoint = Vector2.new(0, 0.5)
        thumb.Position    = value and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        corner(thumb, UDim.new(1, 0))

        indicator = {
            set = function(v)
                tween(track, { BackgroundColor3 = v and theme.Accent or theme.ElementStroke })
                tween(thumb, { Position = v and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) })
            end
        }
    end

    local b = mkBtn(f)
    b.MouseEnter:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = theme.ElementHover })
    end)
    b.MouseLeave:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = cfg.Color or theme.Element })
    end)
    b.MouseButton1Click:Connect(function()
        if disabled then return end
        value = not value
        indicator.set(value)
        task.spawn(function() pcall(callback, value) end)
    end)

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = {}
    function obj:Set(v)
        value = v
        indicator.set(v)
        task.spawn(function() pcall(callback, v) end)
    end
    function obj:Get() return value end
    function obj:SetDisabled(v) disabled = v; tween(f, { BackgroundTransparency = v and 0.4 or 0 }) end
    return obj
end

function Elements.Input(tab, cfg)
    cfg = cfg or {}
    local theme       = tab._theme
    local title       = cfg.Title       or "Input"
    local desc        = cfg.Desc        or ""
    local placeholder = cfg.Placeholder or ""
    local callback    = cfg.Callback    or function() end
    local multiline   = cfg.Multiline   or false
    local disabled    = cfg.Disabled    or false
    local boxH        = multiline and 52 or 28
    local height      = 40 + boxH + (desc ~= "" and 16 or 0)

    local f = baseFrame(theme, height, { Color = cfg.Color, Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)

    local titleLbl = lbl(f, title, theme.TextPrimary, 13, Enum.Font.GothamMedium)
    titleLbl.Size     = UDim2.new(1, 0, 0, 16)
    titleLbl.Position = UDim2.new(0, 0, 0, 8)

    if desc ~= "" then
        local descLbl = lbl(f, desc, theme.TextSecondary, 11, Enum.Font.Gotham)
        descLbl.Size     = UDim2.new(1, 0, 0, 14)
        descLbl.Position = UDim2.new(0, 0, 0, 26)
    end

    local yOff = desc ~= "" and 46 or 30

    local box = mkFrame(f, theme.InputBg, UDim2.new(1, 0, 0, boxH))
    box.Position = UDim2.new(0, 0, 0, yOff)
    corner(box, CORNER_SM)
    local boxS = stroke(box, theme.ElementStroke, 1)

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
    input.TextYAlignment     = multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    input.ClearTextOnFocus   = false
    input.MultiLine          = multiline
    input.TextWrapped        = multiline
    input.Parent             = box

    if disabled then input.TextEditable = false end

    input.Focused:Connect(function()
        tween(box, { BackgroundColor3 = theme.ElementHover })
        tween(boxS, { Color = theme.Accent })
    end)
    input.FocusLost:Connect(function(enter)
        tween(box, { BackgroundColor3 = theme.InputBg })
        tween(boxS, { Color = theme.ElementStroke })
        if enter then task.spawn(function() pcall(callback, input.Text) end) end
    end)
    if cfg.LiveCallback then
        input:GetPropertyChangedSignal("Text"):Connect(function()
            task.spawn(function() pcall(cfg.LiveCallback, input.Text) end)
        end)
    end

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return input.Text end
    function obj:Set(v) input.Text = v end
    function obj:Clear() input.Text = "" end
    function obj:SetDisabled(v)
        disabled = v
        input.TextEditable = not v
        tween(f, { BackgroundTransparency = v and 0.4 or 0 })
    end
    return obj
end

function Elements.Slider(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Slider"
    local desc     = cfg.Desc     or ""
    local min      = cfg.Min      or 0
    local max      = cfg.Max      or 100
    local value    = math.clamp(cfg.Value or min, min, max)
    local suffix   = cfg.Suffix   or ""
    local callback = cfg.Callback or function() end
    local step     = cfg.Step     or 1
    local useInput = cfg.Input    == true
    local disabled = cfg.Disabled or false

    local frameH = 60 + (desc ~= "" and 16 or 0)
    local f = baseFrame(theme, frameH, { Color = cfg.Color, Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)

    local rightOff = useInput and 62 or 54
    titleDesc(f, theme, title, desc, rightOff)

    local valDisplay
    if useInput then
        local inputFrame = mkFrame(f, theme.InputBg, UDim2.new(0, 50, 0, 22))
        inputFrame.Position = UDim2.new(1, -52, 0, 6)
        corner(inputFrame, UDim.new(0, 4))
        stroke(inputFrame, theme.ElementStroke, 1)

        local ib = Instance.new("TextBox")
        ib.Size               = UDim2.new(1, -8, 1, 0)
        ib.Position           = UDim2.new(0, 4, 0, 0)
        ib.BackgroundTransparency = 1
        ib.Text               = tostring(value)
        ib.TextColor3         = theme.Accent
        ib.TextSize           = 12
        ib.Font               = Enum.Font.GothamBold
        ib.TextXAlignment     = Enum.TextXAlignment.Center
        ib.ClearTextOnFocus   = false
        ib.ZIndex             = 4
        ib.Parent             = inputFrame
        valDisplay            = ib
    else
        local vl = lbl(f, tostring(value) .. suffix, theme.Accent, 12, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        vl.Size         = UDim2.new(0, 48, 0, 16)
        vl.Position     = UDim2.new(1, -50, 0, 8)
        vl.TextTruncate = Enum.TextTruncate.None
        valDisplay      = vl
    end

    local trackY = desc ~= "" and 52 or 38

    local track = mkFrame(f, theme.ElementStroke2 or theme.ElementStroke, UDim2.new(1, 0, 0, 6))
    track.Position = UDim2.new(0, 0, 0, trackY)
    corner(track, UDim.new(1, 0))

    local fill = mkFrame(track, cfg.AccentColor or theme.Accent, UDim2.new((value - min) / math.max(max - min, 0.001), 0, 1, 0))
    corner(fill, UDim.new(1, 0))

    local thumb = mkFrame(track, Color3.fromRGB(255, 255, 255), UDim2.new(0, 14, 0, 14))
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.Position    = UDim2.new((value - min) / math.max(max - min, 0.001), 0, 0.5, 0)
    corner(thumb, UDim.new(1, 0))
    stroke(thumb, cfg.AccentColor or theme.Accent, 1.5)
    thumb.ZIndex = 3

    local dragging = false

    local function snapValue(v)
        if step <= 0 then return v end
        return math.floor(v / step + 0.5) * step
    end

    local function applyValue(v)
        value = math.clamp(snapValue(v), min, max)
        local pct = (max - min == 0) and 0 or (value - min) / (max - min)
        fill.Size      = UDim2.new(pct, 0, 1, 0)
        thumb.Position = UDim2.new(pct, 0, 0.5, 0)
        if useInput then
            valDisplay.Text = tostring(value)
        else
            valDisplay.Text = tostring(value) .. suffix
        end
        task.spawn(function() pcall(callback, value) end)
    end

    local function inputXToValue(inputX)
        local abs = track.AbsolutePosition.X
        local w   = track.AbsoluteSize.X
        if w == 0 then return value end
        local rel = math.clamp((inputX - abs) / w, 0, 1)
        return min + rel * (max - min)
    end

    track.InputBegan:Connect(function(i)
        if disabled then return end
        local isMouse = i.UserInputType == Enum.UserInputType.MouseButton1
        local isTouch = i.UserInputType == Enum.UserInputType.Touch
        if isMouse or isTouch then
            dragging = true
            applyValue(inputXToValue(i.Position.X))
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        local isMouse = i.UserInputType == Enum.UserInputType.MouseMovement
        local isTouch = i.UserInputType == Enum.UserInputType.Touch
        if isMouse or isTouch then applyValue(inputXToValue(i.Position.X)) end
    end)

    UserInputService.InputEnded:Connect(function(i)
        local isMouse = i.UserInputType == Enum.UserInputType.MouseButton1
        local isTouch = i.UserInputType == Enum.UserInputType.Touch
        if isMouse or isTouch then dragging = false end
    end)

    if useInput then
        valDisplay.FocusLost:Connect(function()
            local parsed = tonumber(valDisplay.Text)
            if parsed then applyValue(parsed) else valDisplay.Text = tostring(value) end
        end)
    end

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return value end
    function obj:Set(v) applyValue(v) end
    function obj:SetDisabled(v)
        disabled = v
        tween(f, { BackgroundTransparency = v and 0.4 or 0 })
    end
    return obj
end

function Elements.Dropdown(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Dropdown"
    local desc     = cfg.Desc     or ""
    local values   = cfg.Values   or {}
    local value    = cfg.Value    or (values[1] or "")
    local callback = cfg.Callback or function() end
    local multi    = cfg.Multi    == true
    local disabled = cfg.Disabled or false
    local open     = false
    local selected = multi and {} or value
    local list     = nil
    local listConn = nil

    local f = baseFrame(theme, ELEMENT_H, { Color = cfg.Color, Transparency = cfg.Transparency })
    f.ClipsDescendants = true
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 114)

    local selBox = mkFrame(f, theme.InputBg, UDim2.new(0, 102, 0, 26))
    selBox.Position = UDim2.new(1, -104, 0.5, -13)
    corner(selBox, CORNER_SM)
    stroke(selBox, theme.ElementStroke, 1)

    local function getDisplayText()
        if multi then
            local count = 0
            for _ in pairs(selected) do count += 1 end
            return count == 0 and "Select..." or count .. " selected"
        end
        return tostring(selected)
    end

    local selLbl = lbl(selBox, getDisplayText(), theme.TextPrimary, 11, Enum.Font.Gotham)
    selLbl.Size     = UDim2.new(1, -22, 1, 0)
    selLbl.Position = UDim2.new(0, 7, 0, 0)

    local chevron = lbl(selBox, "▾", theme.TextSecondary, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    chevron.Size     = UDim2.new(0, 16, 1, 0)
    chevron.Position = UDim2.new(1, -18, 0, 0)
    chevron.TextTruncate = Enum.TextTruncate.None

    local function closeList()
        if not list then return end
        open = false
        tween(chevron, { Rotation = 0 }, ANIM_FAST)
        local captured = list
        tween(captured, { BackgroundTransparency = 1 }, ANIM_FAST)
        task.delay(ANIM_FAST + 0.02, function()
            if captured and captured.Parent then captured:Destroy() end
        end)
        list = nil
        if listConn then listConn:Disconnect(); listConn = nil end
    end

    local function buildList()
        closeList()
        local sg = getScreenGui(f)
        if not sg then return end

        local itemH   = 28
        local maxShow = math.min(#values, 7)
        local listH   = maxShow * itemH + 8

        list = mkFrame(sg, theme.Element, UDim2.new(0, 104, 0, 0))
        list.ZIndex           = OVERLAY_Z
        list.ClipsDescendants = true
        list.BackgroundTransparency = 0

        corner(list, CORNER_SM)
        stroke(list, theme.ElementStroke, 1)

        local shadow = Instance.new("ImageLabel")
        shadow.Size               = UDim2.new(1, 30, 1, 30)
        shadow.Position           = UDim2.new(0, -15, 0, -15)
        shadow.BackgroundTransparency = 1
        shadow.Image              = "rbxassetid://6014261993"
        shadow.ImageColor3        = Color3.fromRGB(0, 0, 0)
        shadow.ImageTransparency  = 0.5
        shadow.ScaleType          = Enum.ScaleType.Slice
        shadow.SliceCenter        = Rect.new(49, 49, 450, 450)
        shadow.ZIndex             = 0
        shadow.Parent             = list

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size                    = UDim2.fromScale(1, 1)
        scroll.BackgroundTransparency  = 1
        scroll.BorderSizePixel         = 0
        scroll.CanvasSize              = UDim2.new(0, 0, 0, #values * itemH + 8)
        scroll.ScrollBarThickness      = 3
        scroll.ScrollBarImageColor3    = theme.ScrollBar
        scroll.ScrollingDirection      = Enum.ScrollingDirection.Y
        scroll.ElasticBehavior         = Enum.ElasticBehavior.Never
        scroll.Parent                  = list

        local lay = Instance.new("UIListLayout")
        lay.Padding   = UDim.new(0, 0)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Parent    = scroll

        local sPad = Instance.new("UIPadding")
        sPad.PaddingTop    = UDim.new(0, 4)
        sPad.PaddingBottom = UDim.new(0, 4)
        sPad.PaddingLeft   = UDim.new(0, 4)
        sPad.PaddingRight  = UDim.new(0, 4)
        sPad.Parent        = scroll

        for _, v in ipairs(values) do
            local isSelected = multi and selected[v] or (selected == v)

            local item = mkFrame(scroll, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, itemH))
            item.BackgroundTransparency = 1

            local itemBg = mkFrame(item, isSelected and theme.ElementActive or Color3.fromRGB(0, 0, 0), UDim2.fromScale(1, 1))
            itemBg.BackgroundTransparency = isSelected and 0 or 1
            corner(itemBg, UDim.new(0, 4))

            local il = lbl(item, tostring(v), isSelected and theme.Accent or theme.TextPrimary, 11, Enum.Font.Gotham)
            il.Size     = UDim2.new(1, -8, 1, 0)
            il.Position = UDim2.new(0, 8, 0, 0)
            il.ZIndex   = OVERLAY_Z + 1

            local ib = mkBtn(item, UDim2.fromScale(1, 1), nil, OVERLAY_Z + 2)
            ib.MouseEnter:Connect(function()
                tween(itemBg, { BackgroundColor3 = theme.ElementHover, BackgroundTransparency = 0 })
                tween(il, { TextColor3 = theme.TextPrimary })
            end)
            ib.MouseLeave:Connect(function()
                if (multi and selected[v]) or (not multi and selected == v) then
                    tween(itemBg, { BackgroundColor3 = theme.ElementActive, BackgroundTransparency = 0 })
                    tween(il, { TextColor3 = theme.Accent })
                else
                    tween(itemBg, { BackgroundTransparency = 1 })
                    tween(il, { TextColor3 = theme.TextPrimary })
                end
            end)
            ib.MouseButton1Click:Connect(function()
                if multi then
                    selected[v] = not selected[v] and true or nil
                else
                    selected = v
                end
                selLbl.Text = getDisplayText()
                task.spawn(function() pcall(callback, selected) end)
                if not multi then closeList() end
            end)
        end

        positionPopup(list, selBox, 0, 4)
        tween(list, { Size = UDim2.new(0, 104, 0, listH) }, ANIM_FAST)
        tween(chevron, { Rotation = 180 }, ANIM_FAST)

        listConn = UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                local mx, my = i.Position.X, i.Position.Y
                if not list then return end
                local lp = list.AbsolutePosition
                local ls = list.AbsoluteSize
                if mx >= lp.X and mx <= lp.X + ls.X and my >= lp.Y and my <= lp.Y + ls.Y then return end
                local fp = f.AbsolutePosition
                local fs = f.AbsoluteSize
                if mx >= fp.X and mx <= fp.X + fs.X and my >= fp.Y and my <= fp.Y + fs.Y then return end
                closeList()
            end
        end)
    end

    local b = mkBtn(f)
    b.MouseEnter:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = theme.ElementHover })
    end)
    b.MouseLeave:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = cfg.Color or theme.Element })
    end)
    b.MouseButton1Click:Connect(function()
        if disabled then return end
        open = not open
        if open then buildList() else closeList() end
    end)

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return selected end
    function obj:Set(v)
        selected = v
        selLbl.Text = getDisplayText()
    end
    function obj:SetValues(v)
        values = v
        if not multi then selected = v[1] or "" end
        selLbl.Text = getDisplayText()
    end
    function obj:Close() closeList() end
    function obj:SetDisabled(v) disabled = v; tween(f, { BackgroundTransparency = v and 0.4 or 0 }) end
    return obj
end

function Elements.ColorPicker(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Color"
    local desc     = cfg.Desc     or ""
    local color    = cfg.Default  or Color3.fromRGB(220, 180, 60)
    local callback = cfg.Callback or function() end
    local disabled = cfg.Disabled or false
    local open     = false
    local panel    = nil
    local panelConn = nil

    local f = baseFrame(theme, ELEMENT_H, { Color = cfg.Color, Transparency = cfg.Transparency })
    f.ClipsDescendants = true
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 50)

    local swatch = mkFrame(f, color, UDim2.new(0, 28, 0, 20))
    swatch.Position = UDim2.new(1, -30, 0.5, -10)
    corner(swatch, CORNER_SM)
    stroke(swatch, theme.ElementStroke, 1)

    local rgb = { math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255) }

    local function toHex(r, g, b)
        return string.format("%02X%02X%02X", r, g, b)
    end

    local function updateColor()
        color = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
        tween(swatch, { BackgroundColor3 = color })
        task.spawn(function() pcall(callback, color) end)
    end

    local function closePanel()
        if not panel then return end
        open = false
        local cap = panel
        tween(cap, { BackgroundTransparency = 1 }, ANIM_FAST)
        task.delay(ANIM_FAST + 0.02, function()
            if cap and cap.Parent then cap:Destroy() end
        end)
        panel = nil
        if panelConn then panelConn:Disconnect(); panelConn = nil end
    end

    local function buildPanel()
        closePanel()
        local sg = getScreenGui(f)
        if not sg then return end

        panel = mkFrame(sg, theme.Element, UDim2.new(0, 214, 0, 0))
        panel.ZIndex = OVERLAY_Z
        panel.BackgroundTransparency = 0
        corner(panel)
        stroke(panel, theme.ElementStroke, 1)

        local pShadow = Instance.new("ImageLabel")
        pShadow.Size               = UDim2.new(1, 30, 1, 30)
        pShadow.Position           = UDim2.new(0, -15, 0, -15)
        pShadow.BackgroundTransparency = 1
        pShadow.Image              = "rbxassetid://6014261993"
        pShadow.ImageColor3        = Color3.fromRGB(0, 0, 0)
        pShadow.ImageTransparency  = 0.5
        pShadow.ScaleType          = Enum.ScaleType.Slice
        pShadow.SliceCenter        = Rect.new(49, 49, 450, 450)
        pShadow.ZIndex             = 0
        pShadow.Parent             = panel

        local pPad = Instance.new("UIPadding")
        pPad.PaddingTop    = UDim.new(0, 10)
        pPad.PaddingBottom = UDim.new(0, 10)
        pPad.PaddingLeft   = UDim.new(0, 12)
        pPad.PaddingRight  = UDim.new(0, 12)
        pPad.Parent        = panel

        local pLay = Instance.new("UIListLayout")
        pLay.Padding  = UDim.new(0, 8)
        pLay.SortOrder = Enum.SortOrder.LayoutOrder
        pLay.Parent   = panel

        local hexRow = mkFrame(panel, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 26))
        hexRow.BackgroundTransparency = 1
        hexRow.ZIndex                 = OVERLAY_Z + 1
        hexRow.LayoutOrder            = 0

        local hexLabel = lbl(hexRow, "HEX", theme.TextSecondary, 9, Enum.Font.GothamBold)
        hexLabel.Size  = UDim2.new(0, 28, 1, 0)
        hexLabel.ZIndex = OVERLAY_Z + 1

        local hexFrame = mkFrame(hexRow, theme.InputBg, UDim2.new(1, -32, 1, 0))
        hexFrame.Position = UDim2.new(0, 32, 0, 0)
        corner(hexFrame, UDim.new(0, 4))
        stroke(hexFrame, theme.ElementStroke, 1)
        hexFrame.ZIndex = OVERLAY_Z + 1

        local hexBox = Instance.new("TextBox")
        hexBox.Size               = UDim2.new(1, -8, 1, 0)
        hexBox.Position           = UDim2.new(0, 4, 0, 0)
        hexBox.BackgroundTransparency = 1
        hexBox.Text               = toHex(rgb[1], rgb[2], rgb[3])
        hexBox.TextColor3         = theme.TextPrimary
        hexBox.TextSize           = 11
        hexBox.Font               = Enum.Font.Gotham
        hexBox.TextXAlignment     = Enum.TextXAlignment.Left
        hexBox.ClearTextOnFocus   = false
        hexBox.ZIndex             = OVERLAY_Z + 2
        hexBox.Parent             = hexFrame

        hexBox.FocusLost:Connect(function()
            local hex = hexBox.Text:gsub("[^%x]", ""):sub(1, 6)
            if #hex == 6 then
                rgb[1] = tonumber(hex:sub(1, 2), 16) or 0
                rgb[2] = tonumber(hex:sub(3, 4), 16) or 0
                rgb[3] = tonumber(hex:sub(5, 6), 16) or 0
                updateColor()
            end
            hexBox.Text = toHex(rgb[1], rgb[2], rgb[3])
        end)

        local channels = {
            { name = "R", idx = 1, col = Color3.fromRGB(220, 60, 60) },
            { name = "G", idx = 2, col = Color3.fromRGB(60, 200, 80) },
            { name = "B", idx = 3, col = Color3.fromRGB(60, 120, 220) },
        }

        for ordIdx, ch in ipairs(channels) do
            local row = mkFrame(panel, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 26))
            row.BackgroundTransparency = 1
            row.ZIndex                 = OVERLAY_Z + 1
            row.LayoutOrder            = ordIdx

            local cl = lbl(row, ch.name, theme.TextSecondary, 9, Enum.Font.GothamBold)
            cl.Size         = UDim2.new(0, 14, 1, 0)
            cl.ZIndex       = OVERLAY_Z + 1
            cl.TextTruncate = Enum.TextTruncate.None

            local tr = mkFrame(row, theme.ElementStroke2 or theme.ElementStroke, UDim2.new(1, -56, 0, 6))
            tr.Position = UDim2.new(0, 18, 0.5, -3)
            tr.ZIndex   = OVERLAY_Z + 1
            corner(tr, UDim.new(1, 0))

            local fi = mkFrame(tr, ch.col, UDim2.new(rgb[ch.idx] / 255, 0, 1, 0))
            fi.BackgroundTransparency = 0.2
            fi.ZIndex                 = OVERLAY_Z + 2
            corner(fi, UDim.new(1, 0))

            local th2 = mkFrame(tr, Color3.fromRGB(255, 255, 255), UDim2.new(0, 12, 0, 12))
            th2.AnchorPoint = Vector2.new(0.5, 0.5)
            th2.Position    = UDim2.new(rgb[ch.idx] / 255, 0, 0.5, 0)
            th2.ZIndex      = OVERLAY_Z + 3
            corner(th2, UDim.new(1, 0))
            stroke(th2, ch.col, 1.5)

            local vi = Instance.new("TextBox")
            vi.Size               = UDim2.new(0, 30, 0, 18)
            vi.Position           = UDim2.new(1, -30, 0.5, -9)
            vi.BackgroundColor3   = theme.InputBg
            vi.Text               = tostring(rgb[ch.idx])
            vi.TextColor3         = theme.TextPrimary
            vi.TextSize           = 10
            vi.Font               = Enum.Font.GothamBold
            vi.TextXAlignment     = Enum.TextXAlignment.Center
            vi.ClearTextOnFocus   = false
            vi.BorderSizePixel    = 0
            vi.ZIndex             = OVERLAY_Z + 4
            corner(vi, UDim.new(0, 3))
            vi.Parent = row

            local drag2 = false

            local function applySlider(inputX)
                local abs = tr.AbsolutePosition.X
                local w   = tr.AbsoluteSize.X
                if w == 0 then return end
                local r2  = math.clamp((inputX - abs) / w, 0, 1)
                rgb[ch.idx] = math.floor(r2 * 255)
                vi.Text     = tostring(rgb[ch.idx])
                fi.Size     = UDim2.new(r2, 0, 1, 0)
                th2.Position = UDim2.new(r2, 0, 0.5, 0)
                updateColor()
                hexBox.Text = toHex(rgb[1], rgb[2], rgb[3])
            end

            tr.InputBegan:Connect(function(i)
                local isMouse = i.UserInputType == Enum.UserInputType.MouseButton1
                local isTouch = i.UserInputType == Enum.UserInputType.Touch
                if isMouse or isTouch then
                    drag2 = true
                    applySlider(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if not drag2 then return end
                local isMouse = i.UserInputType == Enum.UserInputType.MouseMovement
                local isTouch = i.UserInputType == Enum.UserInputType.Touch
                if isMouse or isTouch then applySlider(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                local isMouse = i.UserInputType == Enum.UserInputType.MouseButton1
                local isTouch = i.UserInputType == Enum.UserInputType.Touch
                if isMouse or isTouch then drag2 = false end
            end)

            vi.FocusLost:Connect(function()
                local v2 = math.clamp(tonumber(vi.Text) or rgb[ch.idx], 0, 255)
                rgb[ch.idx] = math.floor(v2)
                vi.Text      = tostring(rgb[ch.idx])
                fi.Size      = UDim2.new(rgb[ch.idx] / 255, 0, 1, 0)
                th2.Position = UDim2.new(rgb[ch.idx] / 255, 0, 0.5, 0)
                updateColor()
                hexBox.Text = toHex(rgb[1], rgb[2], rgb[3])
            end)
        end

        local targetH = 26 + 8 + 3 * (26 + 8) + 20
        panel.Size = UDim2.new(0, 214, 0, 0)
        positionPopup(panel, swatch, -182, 6)
        tween(panel, { Size = UDim2.new(0, 214, 0, targetH) }, ANIM_FAST)

        panelConn = UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                local mx, my = i.Position.X, i.Position.Y
                if not panel then return end
                local pp = panel.AbsolutePosition
                local ps = panel.AbsoluteSize
                if mx >= pp.X and mx <= pp.X + ps.X and my >= pp.Y and my <= pp.Y + ps.Y then return end
                local fp = f.AbsolutePosition
                local fs = f.AbsoluteSize
                if mx >= fp.X and mx <= fp.X + fs.X and my >= fp.Y and my <= fp.Y + fs.Y then return end
                closePanel()
            end
        end)
    end

    local b = mkBtn(f)
    b.MouseEnter:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = theme.ElementHover })
    end)
    b.MouseLeave:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = cfg.Color or theme.Element })
    end)
    b.MouseButton1Click:Connect(function()
        if disabled then return end
        open = not open
        if open then buildPanel() else closePanel() end
    end)

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return color end
    function obj:Set(col)
        color = col
        rgb[1] = math.floor(col.R * 255)
        rgb[2] = math.floor(col.G * 255)
        rgb[3] = math.floor(col.B * 255)
        swatch.BackgroundColor3 = col
    end
    function obj:SetDisabled(v) disabled = v; tween(f, { BackgroundTransparency = v and 0.4 or 0 }) end
    return obj
end

function Elements.Keybind(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Keybind"
    local desc     = cfg.Desc     or ""
    local default  = cfg.Default  or Enum.KeyCode.Unknown
    local callback = cfg.Callback or function() end
    local disabled = cfg.Disabled or false
    local key      = default
    local listening = false

    local f = baseFrame(theme, ELEMENT_H, { Color = cfg.Color, Transparency = cfg.Transparency })
    f.ClipsDescendants = true
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 80)

    local keyFrame = mkFrame(f, theme.InputBg, UDim2.new(0, 70, 0, 24))
    keyFrame.Position = UDim2.new(1, -72, 0.5, -12)
    corner(keyFrame, CORNER_SM)
    local kfS = stroke(keyFrame, theme.ElementStroke, 1)

    local keyLbl = lbl(keyFrame, key == Enum.KeyCode.Unknown and "NONE" or key.Name:upper(), theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    keyLbl.Size        = UDim2.fromScale(1, 1)
    keyLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local b = mkBtn(f)
    b.MouseEnter:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = theme.ElementHover })
    end)
    b.MouseLeave:Connect(function()
        if disabled then return end
        tween(f, { BackgroundColor3 = cfg.Color or theme.Element })
    end)
    b.MouseButton1Click:Connect(function()
        if disabled or listening then return end
        listening        = true
        keyLbl.Text      = "..."
        keyLbl.TextColor3 = theme.TextSecondary
        tween(keyFrame, { BackgroundColor3 = theme.ElementActive })
        tween(kfS, { Color = theme.Accent })
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                listening        = false
                keyLbl.Text      = key == Enum.KeyCode.Unknown and "NONE" or key.Name:upper()
                keyLbl.TextColor3 = theme.Accent
                tween(keyFrame, { BackgroundColor3 = theme.InputBg })
                tween(kfS, { Color = theme.ElementStroke })
                conn:Disconnect()
                task.spawn(function() pcall(callback, key) end)
            end
        end)
    end)

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return key end
    function obj:Set(k)
        key = k
        keyLbl.Text = k == Enum.KeyCode.Unknown and "NONE" or k.Name:upper()
    end
    function obj:SetDisabled(v) disabled = v; tween(f, { BackgroundTransparency = v and 0.4 or 0 }) end
    return obj
end

function Elements.KeybindButton(tab, cfg)
    cfg = cfg or {}
    local theme      = tab._theme
    local title      = cfg.Title    or "KeybindButton"
    local desc       = cfg.Desc     or ""
    local default    = cfg.Default  or Enum.KeyCode.Unknown
    local onPress    = cfg.OnPress  or function() end
    local onBind     = cfg.OnBind   or function() end
    local disabled   = cfg.Disabled or false
    local key        = default
    local listening  = false

    local f = baseFrame(theme, ELEMENT_H, { Color = cfg.Color, Transparency = cfg.Transparency })
    f.ClipsDescendants = true
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 124)

    local keyFrame = mkFrame(f, theme.InputBg, UDim2.new(0, 56, 0, 24))
    keyFrame.Position = UDim2.new(1, -118, 0.5, -12)
    corner(keyFrame, CORNER_SM)
    stroke(keyFrame, theme.ElementStroke, 1)

    local keyLbl = lbl(keyFrame, key == Enum.KeyCode.Unknown and "NONE" or key.Name:upper(), theme.Accent, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    keyLbl.Size        = UDim2.fromScale(1, 1)
    keyLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local execBox = mkFrame(f, theme.Accent, UDim2.new(0, 54, 0, 26))
    execBox.Position = UDim2.new(1, -56, 0.5, -13)
    corner(execBox, CORNER_SM)

    local execL = lbl(execBox, cfg.ButtonText or "Run", Color3.fromRGB(10, 10, 10), 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    execL.Size        = UDim2.fromScale(1, 1)
    execL.TextTruncate = Enum.TextTruncate.None

    local mainBtn = mkBtn(f, UDim2.new(1, -180, 1, 0))
    mainBtn.MouseEnter:Connect(function() if not disabled then tween(f, { BackgroundColor3 = theme.ElementHover }) end end)
    mainBtn.MouseLeave:Connect(function() if not disabled then tween(f, { BackgroundColor3 = cfg.Color or theme.Element }) end end)

    local eb = mkBtn(execBox, UDim2.fromScale(1, 1), nil, 3)
    eb.MouseButton1Click:Connect(function()
        if disabled then return end
        task.spawn(function() pcall(onPress) end)
    end)
    eb.MouseEnter:Connect(function() tween(execBox, { BackgroundColor3 = theme.AccentLight }) end)
    eb.MouseLeave:Connect(function() tween(execBox, { BackgroundColor3 = theme.Accent }) end)

    local kb = mkBtn(keyFrame, UDim2.fromScale(1, 1), nil, 3)
    kb.MouseButton1Click:Connect(function()
        if disabled or listening then return end
        listening        = true
        keyLbl.Text      = "..."
        keyLbl.TextColor3 = theme.TextSecondary
        local conn
        conn = UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.UserInputType == Enum.UserInputType.Keyboard then
                key              = i.KeyCode
                listening        = false
                keyLbl.Text      = key.Name:upper()
                keyLbl.TextColor3 = theme.Accent
                conn:Disconnect()
                task.spawn(function() pcall(onBind, key) end)
            end
        end)
    end)

    UserInputService.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == key and not disabled then
            task.spawn(function() pcall(onPress) end)
        end
    end)

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = {}
    function obj:GetKey() return key end
    function obj:SetKey(k)
        key = k
        keyLbl.Text = k == Enum.KeyCode.Unknown and "NONE" or k.Name:upper()
    end
    function obj:SetDisabled(v) disabled = v; tween(f, { BackgroundTransparency = v and 0.4 or 0 }) end
    return obj
end

function Elements.ProfileFrame(tab, cfg)
    cfg = cfg or {}
    local theme      = tab._theme
    local name       = cfg.Name      or "Player"
    local subtitle   = cfg.Subtitle  or ""
    local userId     = cfg.UserId    or 0
    local badges     = cfg.Badges    or {}
    local onAction   = cfg.OnAction  or nil
    local actionText = cfg.ActionText or "Action"
    local disabled   = cfg.Disabled  or false

    local frameH = subtitle ~= "" and 72 or 58
    if #badges > 0 then frameH = frameH + 18 end

    local f = mkFrame(nil, cfg.Color or theme.Element, UDim2.new(1, 0, 0, frameH))
    f.BorderSizePixel = 0
    corner(f)
    stroke(f, theme.ElementStroke, 1)

    local avatarFrame = mkFrame(f, theme.ElementStroke, UDim2.new(0, 46, 0, 46))
    avatarFrame.Position = UDim2.new(0, 10, 0.5, -23)
    corner(avatarFrame, UDim.new(1, 0))

    if userId > 0 then
        local avatarImg = Instance.new("ImageLabel")
        avatarImg.Size               = UDim2.fromScale(1, 1)
        avatarImg.BackgroundTransparency = 1
        avatarImg.Image              = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
        avatarImg.ScaleType          = Enum.ScaleType.Crop
        corner(avatarImg, UDim.new(1, 0))
        avatarImg.Parent = avatarFrame
    end

    local nameYOff = subtitle ~= "" and (frameH / 2 - 18) or (frameH / 2 - 8)

    local nameLbl = lbl(f, name, theme.TextPrimary, 13, Enum.Font.GothamBold)
    nameLbl.Size         = UDim2.new(1, -80 - (onAction and 92 or 0), 0, 16)
    nameLbl.Position     = UDim2.new(0, 64, 0, nameYOff)
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

    if subtitle ~= "" then
        local subLbl = lbl(f, subtitle, theme.TextSecondary, 11, Enum.Font.Gotham)
        subLbl.Size         = UDim2.new(1, -80 - (onAction and 92 or 0), 0, 14)
        subLbl.Position     = UDim2.new(0, 64, 0, nameYOff + 18)
        subLbl.TextTruncate = Enum.TextTruncate.AtEnd
    end

    if #badges > 0 then
        local badgeRow = mkFrame(f, Color3.fromRGB(0, 0, 0), UDim2.new(0, 0, 0, 16))
        badgeRow.AutomaticSize         = Enum.AutomaticSize.X
        badgeRow.Position              = UDim2.new(0, 64, 1, -20)
        badgeRow.BackgroundTransparency = 1

        local blay = Instance.new("UIListLayout")
        blay.FillDirection = Enum.FillDirection.Horizontal
        blay.Padding       = UDim.new(0, 4)
        blay.Parent        = badgeRow

        for _, bd in ipairs(badges) do
            local bFrame = mkFrame(badgeRow, bd.Color or theme.Accent, UDim2.new(0, 0, 1, 0))
            bFrame.AutomaticSize          = Enum.AutomaticSize.X
            bFrame.BackgroundTransparency = 0.8
            corner(bFrame, UDim.new(1, 0))
            local bPad = Instance.new("UIPadding")
            bPad.PaddingLeft  = UDim.new(0, 5)
            bPad.PaddingRight = UDim.new(0, 5)
            bPad.Parent = bFrame
            local bLbl = lbl(bFrame, bd.Text or "?", bd.Color or theme.Accent, 9, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            bLbl.Size          = UDim2.new(0, 0, 1, 0)
            bLbl.AutomaticSize = Enum.AutomaticSize.X
            bLbl.TextTruncate  = Enum.TextTruncate.None
        end
    end

    if onAction then
        local actionBtn = Instance.new("TextButton")
        actionBtn.Size             = UDim2.new(0, 80, 0, 26)
        actionBtn.Position         = UDim2.new(1, -88, 0.5, -13)
        actionBtn.BackgroundColor3 = theme.Accent
        actionBtn.Text             = actionText
        actionBtn.TextColor3       = theme.Background
        actionBtn.TextSize         = 11
        actionBtn.Font             = Enum.Font.GothamBold
        actionBtn.BorderSizePixel  = 0
        actionBtn.AutoButtonColor  = false
        actionBtn.ZIndex           = 2
        corner(actionBtn, CORNER_SM)
        actionBtn.Parent = f

        actionBtn.MouseEnter:Connect(function() tween(actionBtn, { BackgroundColor3 = theme.AccentDark }) end)
        actionBtn.MouseLeave:Connect(function() tween(actionBtn, { BackgroundColor3 = theme.Accent }) end)
        actionBtn.MouseButton1Click:Connect(function()
            if disabled then return end
            task.spawn(function() pcall(onAction) end)
        end)
    end

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = {}
    function obj:SetName(n) nameLbl.Text = n end
    function obj:SetAvatar(id)
        local av = avatarFrame:FindFirstChildWhichIsA("ImageLabel")
        if av then av.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. id .. "&width=150&height=150&format=png" end
    end
    function obj:SetDisabled(v) disabled = v; tween(f, { BackgroundTransparency = v and 0.4 or 0 }) end
    return obj
end

function Elements.Card(tab, cfg)
    cfg = cfg or {}
    local theme   = tab._theme
    local title   = cfg.Title   or "Card"
    local desc    = cfg.Desc    or ""
    local icon    = cfg.Icon    or ""
    local onClick = cfg.OnClick or nil

    local f = mkFrame(nil, cfg.Color or theme.Element, UDim2.new(1, 0, 0, 0))
    f.AutomaticSize          = Enum.AutomaticSize.Y
    f.BorderSizePixel        = 0
    f.ClipsDescendants       = false
    corner(f)
    stroke(f, theme.ElementStroke, 1)

    local inner = mkFrame(f, Color3.fromRGB(0, 0, 0), UDim2.fromScale(1, 1))
    inner.BackgroundTransparency = 1
    inner.AutomaticSize          = Enum.AutomaticSize.Y

    local iPad = Instance.new("UIPadding")
    iPad.PaddingTop    = UDim.new(0, 12)
    iPad.PaddingBottom = UDim.new(0, 12)
    iPad.PaddingLeft   = UDim.new(0, 14)
    iPad.PaddingRight  = UDim.new(0, 14)
    iPad.Parent        = inner

    local iLay = Instance.new("UIListLayout")
    iLay.Padding  = UDim.new(0, 6)
    iLay.SortOrder = Enum.SortOrder.LayoutOrder
    iLay.Parent   = inner

    if icon ~= "" then
        local iconLbl = lbl(inner, icon, theme.Accent, 18, Enum.Font.GothamBold)
        iconLbl.Size          = UDim2.new(1, 0, 0, 22)
        iconLbl.AutomaticSize = Enum.AutomaticSize.None
        iconLbl.TextTruncate  = Enum.TextTruncate.None
    end

    local titleLbl = lbl(inner, title, theme.TextPrimary, 13, Enum.Font.GothamBold)
    titleLbl.Size          = UDim2.new(1, 0, 0, 0)
    titleLbl.AutomaticSize = Enum.AutomaticSize.Y
    titleLbl.TextWrapped   = true
    titleLbl.TextTruncate  = Enum.TextTruncate.None
    titleLbl.TextYAlignment = Enum.TextYAlignment.Top

    if desc ~= "" then
        local descLbl = lbl(inner, desc, theme.TextSecondary, 12, Enum.Font.Gotham)
        descLbl.Size          = UDim2.new(1, 0, 0, 0)
        descLbl.AutomaticSize = Enum.AutomaticSize.Y
        descLbl.TextWrapped   = true
        descLbl.TextTruncate  = Enum.TextTruncate.None
        descLbl.TextYAlignment = Enum.TextYAlignment.Top
    end

    if onClick then
        local clickBtn = mkBtn(f, UDim2.fromScale(1, 1))
        clickBtn.MouseEnter:Connect(function() tween(f, { BackgroundColor3 = theme.ElementHover }) end)
        clickBtn.MouseLeave:Connect(function() tween(f, { BackgroundColor3 = cfg.Color or theme.Element }) end)
        clickBtn.MouseButton1Click:Connect(function()
            task.spawn(function() pcall(onClick) end)
        end)
    end

    tab:_addElement(f)
    return f
end

function Elements.Section(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme

    local wrapper = mkFrame(nil, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 24))
    wrapper.BackgroundTransparency = 1

    local tl = lbl(wrapper, (cfg.Title or ""):upper(), theme.TextDisabled, 10, Enum.Font.GothamBold)
    tl.Size         = UDim2.new(1, 0, 1, 0)
    tl.TextTruncate = Enum.TextTruncate.None

    tab:_addElement(wrapper)
    return wrapper
end

function Elements.Divider(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme

    local f = mkFrame(nil, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 20))
    f.BackgroundTransparency = 1

    local line = mkFrame(f, cfg.Color or theme.ElementStroke, UDim2.new(1, 0, 0, 1))
    line.AnchorPoint = Vector2.new(0, 0.5)
    line.Position    = UDim2.new(0, 0, 0.5, 0)

    if cfg.Label and cfg.Label ~= "" then
        local bg = mkFrame(f, theme.Background, UDim2.new(0, 0, 1, 0))
        bg.AutomaticSize   = Enum.AutomaticSize.X
        bg.AnchorPoint     = Vector2.new(0.5, 0)
        bg.Position        = UDim2.new(0.5, 0, 0, 0)
        bg.BorderSizePixel = 0
        local ll = lbl(bg, "  " .. cfg.Label .. "  ", theme.TextDisabled, 11, Enum.Font.Gotham, Enum.TextXAlignment.Center)
        ll.Size         = UDim2.new(1, 0, 1, 0)
        ll.TextTruncate = Enum.TextTruncate.None
    end

    tab:_addElement(f)
    return f
end

function Elements.Paragraph(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme

    local outer = mkFrame(nil, cfg.Color or theme.CardBg, UDim2.new(1, 0, 0, 0))
    outer.AutomaticSize = Enum.AutomaticSize.Y
    corner(outer)
    stroke(outer, theme.CardStroke or theme.ElementStroke, 1)

    local inner = mkFrame(outer, Color3.fromRGB(0, 0, 0), UDim2.fromScale(1, 1))
    inner.BackgroundTransparency = 1
    inner.AutomaticSize          = Enum.AutomaticSize.Y

    local iPad = Instance.new("UIPadding")
    iPad.PaddingTop    = UDim.new(0, 10)
    iPad.PaddingBottom = UDim.new(0, 10)
    iPad.PaddingLeft   = UDim.new(0, 14)
    iPad.PaddingRight  = UDim.new(0, 14)
    iPad.Parent        = inner

    local iLay = Instance.new("UIListLayout")
    iLay.Padding  = UDim.new(0, 5)
    iLay.SortOrder = Enum.SortOrder.LayoutOrder
    iLay.Parent   = inner

    if cfg.Title and cfg.Title ~= "" then
        local tl = lbl(inner, cfg.Title, theme.TextPrimary, 13, Enum.Font.GothamBold)
        tl.Size           = UDim2.new(1, 0, 0, 0)
        tl.AutomaticSize  = Enum.AutomaticSize.Y
        tl.TextWrapped    = true
        tl.TextTruncate   = Enum.TextTruncate.None
        tl.TextYAlignment = Enum.TextYAlignment.Top
    end

    if cfg.Desc and cfg.Desc ~= "" then
        local dl = lbl(inner, cfg.Desc, theme.TextSecondary, 12, Enum.Font.Gotham)
        dl.Size           = UDim2.new(1, 0, 0, 0)
        dl.AutomaticSize  = Enum.AutomaticSize.Y
        dl.TextWrapped    = true
        dl.TextTruncate   = Enum.TextTruncate.None
        dl.TextYAlignment = Enum.TextYAlignment.Top
    end

    tab:_addElement(outer)
    return outer
end

function Elements.Label(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme

    local wrapper = mkFrame(nil, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, 0))
    wrapper.BackgroundTransparency = 1
    wrapper.AutomaticSize          = Enum.AutomaticSize.Y

    local tl = lbl(wrapper, cfg.Title or "", cfg.Color or theme.TextPrimary, cfg.TextSize or 13, cfg.Font or Enum.Font.GothamMedium)
    tl.Size           = UDim2.new(1, 0, 0, 0)
    tl.AutomaticSize  = Enum.AutomaticSize.Y
    tl.TextWrapped    = true
    tl.TextTruncate   = Enum.TextTruncate.None
    tl.TextXAlignment = cfg.Align or Enum.TextXAlignment.Left
    tl.TextYAlignment = Enum.TextYAlignment.Top

    tab:_addElement(wrapper)

    local obj = {}
    function obj:Set(t) tl.Text = t end
    function obj:SetColor(c) tl.TextColor3 = c end
    return obj
end

function Elements.Space(tab, cfg)
    cfg = cfg or {}
    local theme = tab._theme

    local f = mkFrame(nil, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, cfg.Height or 8))
    f.BackgroundTransparency = 1
    tab:_addElement(f)
    return f
end

function Elements.ProgressBar(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Progress"
    local desc     = cfg.Desc     or ""
    local value    = math.clamp(cfg.Value or 0, 0, 1)
    local showPct  = cfg.ShowPercent ~= false
    local barColor = cfg.BarColor  or theme.Accent

    local frameH = 52 + (desc ~= "" and 16 or 0)
    local f = baseFrame(theme, frameH, { Color = cfg.Color, Transparency = cfg.Transparency })
    padding(f, 0, 0, 12, 12)

    local tl = lbl(f, title, theme.TextPrimary, 13, Enum.Font.GothamMedium)
    tl.Size     = UDim2.new(1, showPct and -44 or 0, 0, 16)
    tl.Position = UDim2.new(0, 0, 0, 8)

    local pctLbl = nil
    if showPct then
        pctLbl = lbl(f, math.floor(value * 100) .. "%", theme.Accent, 12, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        pctLbl.Size         = UDim2.new(0, 40, 0, 16)
        pctLbl.Position     = UDim2.new(1, -42, 0, 8)
        pctLbl.TextTruncate = Enum.TextTruncate.None
    end

    local trackY = desc ~= "" and 50 or 34
    local track = mkFrame(f, theme.ElementStroke2 or theme.ElementStroke, UDim2.new(1, 0, 0, 8))
    track.Position = UDim2.new(0, 0, 0, trackY)
    corner(track, UDim.new(1, 0))

    local fill = mkFrame(track, barColor, UDim2.new(value, 0, 1, 0))
    corner(fill, UDim.new(1, 0))

    tab:_addElement(f)

    local obj = {}
    function obj:Set(v)
        value = math.clamp(v, 0, 1)
        tween(fill, { Size = UDim2.new(value, 0, 1, 0) })
        if pctLbl then pctLbl.Text = math.floor(value * 100) .. "%" end
    end
    function obj:Get() return value end
    return obj
end

function Elements.NumberInput(tab, cfg)
    cfg = cfg or {}
    local theme    = tab._theme
    local title    = cfg.Title    or "Number"
    local desc     = cfg.Desc     or ""
    local min      = cfg.Min      or 0
    local max      = cfg.Max      or math.huge
    local step     = cfg.Step     or 1
    local value    = math.clamp(cfg.Value or min, min, max)
    local callback = cfg.Callback or function() end
    local disabled = cfg.Disabled or false

    local f = baseFrame(theme, ELEMENT_H, { Color = cfg.Color, Transparency = cfg.Transparency })
    f.ClipsDescendants = true
    padding(f, 0, 0, 12, 12)
    titleDesc(f, theme, title, desc, 90)

    local controlBox = mkFrame(f, theme.InputBg, UDim2.new(0, 80, 0, 26))
    controlBox.Position = UDim2.new(1, -82, 0.5, -13)
    corner(controlBox, CORNER_SM)
    stroke(controlBox, theme.ElementStroke, 1)

    local minusBtn = mkFrame(controlBox, theme.ElementHover, UDim2.new(0, 26, 1, 0))
    corner(minusBtn, UDim.new(0, 4))
    local minusL = lbl(minusBtn, "–", theme.TextPrimary, 14, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    minusL.Size        = UDim2.fromScale(1, 1)
    minusL.TextTruncate = Enum.TextTruncate.None

    local numBox = Instance.new("TextBox")
    numBox.Size               = UDim2.new(1, -52, 1, 0)
    numBox.Position           = UDim2.new(0, 26, 0, 0)
    numBox.BackgroundTransparency = 1
    numBox.Text               = tostring(value)
    numBox.TextColor3         = theme.Accent
    numBox.TextSize           = 12
    numBox.Font               = Enum.Font.GothamBold
    numBox.TextXAlignment     = Enum.TextXAlignment.Center
    numBox.ClearTextOnFocus   = false
    numBox.ZIndex             = 3
    numBox.Parent             = controlBox

    local plusBtn = mkFrame(controlBox, theme.ElementHover, UDim2.new(0, 26, 1, 0))
    plusBtn.Position = UDim2.new(1, -26, 0, 0)
    corner(plusBtn, UDim.new(0, 4))
    local plusL = lbl(plusBtn, "+", theme.TextPrimary, 14, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
    plusL.Size        = UDim2.fromScale(1, 1)
    plusL.TextTruncate = Enum.TextTruncate.None

    local function applyValue(v)
        value = math.clamp(v, min, max)
        numBox.Text = tostring(value)
        task.spawn(function() pcall(callback, value) end)
    end

    local mb = mkBtn(minusBtn, UDim2.fromScale(1, 1), nil, 4)
    mb.MouseButton1Click:Connect(function()
        if disabled then return end
        applyValue(value - step)
    end)
    mb.MouseEnter:Connect(function() tween(minusBtn, { BackgroundColor3 = theme.ElementActive }) end)
    mb.MouseLeave:Connect(function() tween(minusBtn, { BackgroundColor3 = theme.ElementHover }) end)

    local pb = mkBtn(plusBtn, UDim2.fromScale(1, 1), nil, 4)
    pb.MouseButton1Click:Connect(function()
        if disabled then return end
        applyValue(value + step)
    end)
    pb.MouseEnter:Connect(function() tween(plusBtn, { BackgroundColor3 = theme.ElementActive }) end)
    pb.MouseLeave:Connect(function() tween(plusBtn, { BackgroundColor3 = theme.ElementHover }) end)

    numBox.FocusLost:Connect(function()
        local parsed = tonumber(numBox.Text)
        if parsed then applyValue(parsed) else numBox.Text = tostring(value) end
    end)

    if disabled then f.BackgroundTransparency = 0.4 end

    tab:_addElement(f)

    local obj = {}
    function obj:Get() return value end
    function obj:Set(v) applyValue(v) end
    function obj:SetDisabled(v) disabled = v; tween(f, { BackgroundTransparency = v and 0.4 or 0 }) end
    return obj
end

return Elements
