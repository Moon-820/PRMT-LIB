local Elements = {}
Elements.__index = Elements

-- ═══════════════════════════════════════════════════════════════════
--  SERVICES
-- ═══════════════════════════════════════════════════════════════════
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

-- ═══════════════════════════════════════════════════════════════════
--  HELPERS INTERNES
-- ═══════════════════════════════════════════════════════════════════
local ANIM_FAST = 0.10
local ANIM_MED  = 0.16
local CORNER_EL = UDim.new(0, 7)
local CORNER_SM = UDim.new(0, 5)
local CORNER_XS = UDim.new(0, 3)

local function tw(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or ANIM_MED, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER_EL
    c.Parent = p
    return c
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color           = col or Color3.fromRGB(40, 40, 40)
    s.Thickness       = th or 1
    s.LineJoinMode    = Enum.LineJoinMode.Round
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent          = p
    return s
end

local function pad(p, t, b, l, r)
    local u = Instance.new("UIPadding")
    u.PaddingTop    = UDim.new(0, t or 6)
    u.PaddingBottom = UDim.new(0, b or 6)
    u.PaddingLeft   = UDim.new(0, l or 10)
    u.PaddingRight  = UDim.new(0, r or 10)
    u.Parent = p
    return u
end

local function mkFrame(parent, bg, size, pos)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = bg or Color3.fromRGB(20, 20, 20)
    f.Size             = size or UDim2.fromScale(1, 1)
    f.Position         = pos or UDim2.new(0, 0, 0, 0)
    f.BorderSizePixel  = 0
    f.Parent           = parent
    return f
end

local function mkLbl(parent, text, col, sz, font, xa)
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

-- ═══════════════════════════════════════════════════════════════════
--  EXTEND — injecte tous les éléments avancés dans un Tab
-- ═══════════════════════════════════════════════════════════════════
function Elements:Extend(Tab)
    local theme = Tab._theme
    local page  = Tab._page
    local gui   = Tab._gui

    if not theme or not page then
        warn("[TryxLib/Elements] Tab invalide — avez-vous bien passé un Tab créé par TryxLib:CreateWindow()?")
        return
    end

    -- ─── GRAPH (mini sparkline) ───────────────────────────────────────
    function Tab:Graph(cfg)
        cfg = cfg or {}
        local data     = cfg.Data   or {}
        local maxPts   = cfg.Points or 60
        local color    = cfg.Color  or theme.Accent
        local h        = 88
        local title    = cfg.Title  or "Graph"

        local f = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel  = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 10, 10, 14, 14)

        local titleLbl = mkLbl(f, title, theme.TextSecondary, 10, Enum.Font.GothamBold)
        titleLbl.Size     = UDim2.new(1, -40, 0, 13)
        titleLbl.Position = UDim2.new(0, 0, 0, 0)

        local valLbl = mkLbl(f, "", color, 18, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
        valLbl.Size     = UDim2.new(0, 60, 0, 18)
        valLbl.Position = UDim2.new(1, -60, 0, 0)

        local canvas = mkFrame(f, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 1, -18))
        canvas.Position           = UDim2.new(0, 0, 0, 18)
        canvas.BackgroundTransparency = 1
        canvas.ClipsDescendants   = true

        local bars  = {}
        local barW  = 1 / maxPts

        for i = 1, maxPts do
            local bar = mkFrame(canvas, color, UDim2.new(barW, -1, 0, 0))
            bar.Position          = UDim2.new((i - 1) * barW, 0, 1, 0)
            bar.AnchorPoint       = Vector2.new(0, 1)
            bar.BackgroundTransparency = 0.6
            bars[i] = bar
        end

        local pts = {}
        for _, v in ipairs(data) do
            table.insert(pts, v)
        end

        local function redraw()
            local mn  = math.huge
            local mx  = -math.huge
            for _, v in ipairs(pts) do
                if v < mn then mn = v end
                if v > mx then mx = v end
            end
            if mx == mn then mx = mn + 1 end

            local filled = math.min(#pts, maxPts)
            local offset = math.max(0, #pts - maxPts)
            local range  = mx - mn

            for i = 1, maxPts do
                local src = pts[offset + i]
                if src then
                    local pct = (src - mn) / range
                    tw(bars[i], { Size = UDim2.new(barW, -1, pct, 0) }, 0.08)
                    bars[i].BackgroundTransparency = 0.55 - pct * 0.3
                else
                    bars[i].Size = UDim2.new(barW, -1, 0, 0)
                end
            end

            if #pts > 0 then
                local last = pts[#pts]
                valLbl.Text = cfg.Suffix
                    and (tostring(math.round(last)) .. cfg.Suffix)
                    or tostring(math.round(last))
            end
        end

        redraw()
        f.Parent = page

        local obj = { _frame = f }

        function obj:Push(v)
            table.insert(pts, v)
            if #pts > maxPts * 2 then
                for _ = 1, maxPts do table.remove(pts, 1) end
            end
            redraw()
        end

        function obj:SetData(d)
            pts = {}
            for _, v in ipairs(d) do table.insert(pts, v) end
            redraw()
        end

        if cfg.AutoUpdate then
            task.spawn(function()
                while f.Parent do
                    task.wait(cfg.Interval or 0.5)
                    if cfg.Getter then
                        local ok, v = pcall(cfg.Getter)
                        if ok then obj:Push(v) end
                    end
                end
            end)
        end

        return obj
    end

    -- ─── PROGRESS BAR ────────────────────────────────────────────────
    function Tab:ProgressBar(cfg)
        cfg = cfg or {}
        local value    = math.clamp(cfg.Value or 0, 0, 100)
        local suffix   = cfg.Suffix or "%"
        local showVal  = cfg.ShowValue ~= false
        local color    = cfg.Color or theme.Accent

        local h = 52
        local f = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 10, 10, 14, 14)

        local titleLbl = mkLbl(f, cfg.Title or "", theme.TextPrimary, 12, Enum.Font.GothamMedium)
        titleLbl.Size     = UDim2.new(1, -60, 0, 15)
        titleLbl.Position = UDim2.new(0, 0, 0, 0)

        local valLbl = nil
        if showVal then
            valLbl = mkLbl(f, tostring(value) .. suffix, color, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
            valLbl.Size     = UDim2.new(0, 54, 0, 15)
            valLbl.Position = UDim2.new(1, -54, 0, 0)
        end

        local track = mkFrame(f, theme.ElementStroke2, UDim2.new(1, 0, 0, 6))
        track.Position = UDim2.new(0, 0, 0, 22)
        corner(track, UDim.new(1, 0))

        local fill = mkFrame(track, color, UDim2.new(value / 100, 0, 1, 0))
        fill.BackgroundTransparency = 0.1
        corner(fill, UDim.new(1, 0))

        f.Parent = page

        local obj = { _frame = f }
        function obj:Set(v)
            value = math.clamp(v, 0, 100)
            tw(fill, { Size = UDim2.new(value / 100, 0, 1, 0) }, 0.25)
            if valLbl then valLbl.Text = tostring(math.round(value)) .. suffix end
        end
        function obj:Get() return value end
        return obj
    end

    -- ─── TABLE ───────────────────────────────────────────────────────
    function Tab:Table(cfg)
        cfg = cfg or {}
        local headers  = cfg.Headers or {}
        local rows     = cfg.Rows    or {}
        local rowH     = 28
        local headH    = 28
        local maxRows  = cfg.MaxRows or 5
        local h        = headH + math.min(#rows, maxRows) * rowH + 20
        if cfg.Title then h += 22 end

        local f = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 10, 10, 10, 10)

        local yOff = 0
        if cfg.Title then
            local tl = mkLbl(f, cfg.Title, theme.TextPrimary, 12, Enum.Font.GothamBold)
            tl.Size     = UDim2.new(1, 0, 0, 15)
            tl.Position = UDim2.new(0, 0, 0, 0)
            yOff = 20
        end

        -- Header row
        local headRow = mkFrame(f, theme.Element, UDim2.new(1, 0, 0, headH))
        headRow.Position           = UDim2.new(0, 0, 0, yOff)
        headRow.BackgroundTransparency = 0.4
        corner(headRow, CORNER_XS)

        local colW = 1 / math.max(#headers, 1)
        for i, hdr in ipairs(headers) do
            local cl = mkLbl(headRow, hdr, theme.Accent, 10, Enum.Font.GothamBold)
            cl.Size     = UDim2.new(colW, -4, 1, 0)
            cl.Position = UDim2.new((i - 1) * colW, 4, 0, 0)
        end

        -- Rows scroll frame
        local scrollH = math.min(#rows, maxRows) * rowH
        local scroll  = Instance.new("ScrollingFrame")
        scroll.Size                   = UDim2.new(1, 0, 0, scrollH)
        scroll.Position               = UDim2.new(0, 0, 0, yOff + headH + 2)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel        = 0
        scroll.ScrollBarThickness     = 3
        scroll.ScrollBarImageColor3   = theme.ScrollBar
        scroll.CanvasSize             = UDim2.new(0, 0, 0, #rows * rowH)
        scroll.ScrollingDirection     = Enum.ScrollingDirection.Y
        scroll.ElasticBehavior        = Enum.ElasticBehavior.Never
        scroll.Parent = f

        local lay = Instance.new("UIListLayout")
        lay.Padding   = UDim.new(0, 0)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Parent    = scroll

        local rowFrames = {}
        for ri, row in ipairs(rows) do
            local rframe = mkFrame(scroll, ri % 2 == 0 and theme.Element or theme.CardBg, UDim2.new(1, 0, 0, rowH))
            rframe.BackgroundTransparency = ri % 2 == 0 and 0.6 or 0.85

            for ci, cell in ipairs(row) do
                local cl = mkLbl(rframe, tostring(cell), theme.TextPrimary, 11, Enum.Font.Gotham)
                cl.Size     = UDim2.new(colW, -4, 1, 0)
                cl.Position = UDim2.new((ci - 1) * colW, 4, 0, 0)
                cl.TextTruncate = Enum.TextTruncate.AtEnd
            end

            if cfg.OnRowClick then
                local rb = mkBtn(rframe)
                rb.MouseEnter:Connect(function()
                    tw(rframe, { BackgroundTransparency = 0.5 })
                end)
                rb.MouseLeave:Connect(function()
                    tw(rframe, { BackgroundTransparency = ri % 2 == 0 and 0.6 or 0.85 })
                end)
                rb.MouseButton1Click:Connect(function()
                    task.spawn(function() pcall(cfg.OnRowClick, ri, row) end)
                end)
            end

            table.insert(rowFrames, rframe)
        end

        f.Parent = page
        local obj = { _frame = f }

        function obj:UpdateRow(index, newRow)
            local rframe = rowFrames[index]
            if not rframe then return end
            for i, child in ipairs(rframe:GetChildren()) do
                if child:IsA("TextLabel") then child:Destroy() end
            end
            for ci, cell in ipairs(newRow) do
                local cl = mkLbl(rframe, tostring(cell), theme.TextPrimary, 11, Enum.Font.Gotham)
                cl.Size     = UDim2.new(colW, -4, 1, 0)
                cl.Position = UDim2.new((ci - 1) * colW, 4, 0, 0)
                cl.TextTruncate = Enum.TextTruncate.AtEnd
            end
        end

        return obj
    end

    -- ─── STAT GRID ───────────────────────────────────────────────────
    function Tab:StatGrid(cfg)
        cfg = cfg or {}
        local items = cfg.Items or {}
        local cols  = cfg.Cols  or 3
        local itemH = 56
        local rows  = math.ceil(#items / cols)
        local h     = rows * itemH + (rows - 1) * 6 + (cfg.Title and 22 or 0) + 4

        local f = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 10, 10, 10, 10)

        local yOff = 0
        if cfg.Title then
            local tl = mkLbl(f, cfg.Title, theme.TextPrimary, 12, Enum.Font.GothamBold)
            tl.Size     = UDim2.new(1, 0, 0, 15)
            tl.Position = UDim2.new(0, 0, 0, 0)
            yOff = 20
        end

        local colW = (1 - (cols - 1) * 0.01) / cols
        local valLabels = {}

        for i, item in ipairs(items) do
            local row = math.floor((i - 1) / cols)
            local col = (i - 1) % cols

            local card = mkFrame(f, theme.CardBg, UDim2.new(colW, -2, 0, itemH))
            card.Position = UDim2.new(col * (colW + 0.01), 0, 0, yOff + row * (itemH + 6))
            card.BackgroundTransparency = 0.3
            corner(card, CORNER_SM)
            pad(card, 8, 8, 10, 10)

            local color = item.Color or theme.Accent

            local valLbl2 = mkLbl(card, tostring(item.Value or "—"), color, 16, Enum.Font.GothamBold)
            valLbl2.Size     = UDim2.new(1, 0, 0, 20)
            valLbl2.Position = UDim2.new(0, 0, 0, 0)

            local nameLbl = mkLbl(card, item.Name or "Stat", theme.TextSecondary, 10, Enum.Font.Gotham)
            nameLbl.Size     = UDim2.new(1, 0, 0, 13)
            nameLbl.Position = UDim2.new(0, 0, 0, 22)
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

            valLabels[item.Name or i] = valLbl2

            if item.Trend then
                local up    = item.Trend > 0
                local col2  = up and theme.Success or theme.Danger
                local tIcon = up and "▲" or "▼"
                local tl2   = mkLbl(card, tIcon .. " " .. math.abs(item.Trend) .. "%", col2, 9, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
                tl2.Size     = UDim2.new(1, 0, 0, 12)
                tl2.Position = UDim2.new(0, 0, 1, -14)
            end
        end

        f.Parent = page
        local obj = { _frame = f }
        function obj:SetValue(name, v)
            local lbl2 = valLabels[name]
            if lbl2 then lbl2.Text = tostring(v) end
        end
        return obj
    end

    -- ─── RADIO GROUP ─────────────────────────────────────────────────
    function Tab:RadioGroup(cfg)
        cfg = cfg or {}
        local options  = cfg.Options or {}
        local value    = cfg.Value   or (options[1] or "")
        local disabled = cfg.Disabled or false
        local perRow   = cfg.PerRow  or 2
        local cols     = math.min(perRow, #options)
        local rows     = math.ceil(#options / cols)
        local itemH    = 32
        local h        = (cfg.Title and 22 or 0) + rows * itemH + (rows - 1) * 4 + 20

        local f = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 10, 10, 14, 14)

        local yOff = 0
        if cfg.Title then
            local tl = mkLbl(f, cfg.Title, theme.TextPrimary, 12, Enum.Font.GothamMedium)
            tl.Size     = UDim2.new(1, 0, 0, 15)
            tl.Position = UDim2.new(0, 0, 0, 0)
            yOff = 20
        end

        local colW   = (1 - (cols - 1) * 0.02) / cols
        local circles = {}

        local function setActive(opt)
            value = opt
            for k, c in pairs(circles) do
                local active = (k == opt)
                tw(c.outer, { BorderColor3 = active and theme.Accent or theme.ElementStroke })
                tw(c.inner, { BackgroundColor3 = active and theme.Accent or theme.ElementStroke })
                tw(c.inner, { Size = active and UDim2.new(0, 8, 0, 8) or UDim2.new(0, 4, 0, 4) })
                tw(c.lbl,   { TextColor3 = active and theme.TextPrimary or theme.TextSecondary })
            end
            task.spawn(function() pcall(cfg.Callback or function() end, value) end)
        end

        for i, opt in ipairs(options) do
            local row  = math.floor((i - 1) / cols)
            local col  = (i - 1) % cols
            local active = (opt == value)

            local item = mkFrame(f, Color3.fromRGB(0, 0, 0), UDim2.new(colW, -4, 0, itemH))
            item.Position           = UDim2.new(col * (colW + 0.02), 0, 0, yOff + row * (itemH + 4))
            item.BackgroundTransparency = 1

            local outerCircle = mkFrame(item, theme.ElementStroke, UDim2.new(0, 18, 0, 18))
            outerCircle.Position = UDim2.new(0, 0, 0.5, -9)
            corner(outerCircle, UDim.new(1, 0))
            stroke(outerCircle, active and theme.Accent or theme.ElementStroke, 1.5)

            local innerDot = mkFrame(outerCircle, active and theme.Accent or theme.ElementStroke,
                active and UDim2.new(0, 8, 0, 8) or UDim2.new(0, 4, 0, 4))
            innerDot.AnchorPoint = Vector2.new(0.5, 0.5)
            innerDot.Position    = UDim2.new(0.5, 0, 0.5, 0)
            corner(innerDot, UDim.new(1, 0))

            local optLbl = mkLbl(item, tostring(opt), active and theme.TextPrimary or theme.TextSecondary, 12, Enum.Font.Gotham)
            optLbl.Size     = UDim2.new(1, -26, 1, 0)
            optLbl.Position = UDim2.new(0, 24, 0, 0)
            optLbl.TextTruncate = Enum.TextTruncate.AtEnd

            circles[opt] = { outer = outerCircle, inner = innerDot, lbl = optLbl }

            local ib = mkBtn(item)
            ib.MouseButton1Click:Connect(function()
                if disabled then return end
                setActive(opt)
            end)
            ib.MouseEnter:Connect(function()
                if disabled then return end
                tw(optLbl, { TextColor3 = theme.TextPrimary })
            end)
            ib.MouseLeave:Connect(function()
                if disabled then return end
                if value ~= opt then
                    tw(optLbl, { TextColor3 = theme.TextSecondary })
                end
            end)
        end

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:Get()   return value end
        function obj:Set(v)  setActive(v) end
        return obj
    end

    -- ─── SEARCH BOX ──────────────────────────────────────────────────
    function Tab:SearchBox(cfg)
        cfg = cfg or {}
        local items    = cfg.Items    or {}
        local maxShow  = cfg.MaxShow  or 5
        local disabled = cfg.Disabled or false
        local filtered = {}

        local f = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, 46))
        f.BorderSizePixel  = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 10, 10, 14, 14)

        local iconLbl = mkLbl(f, "🔍", theme.TextSecondary, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        iconLbl.Size     = UDim2.new(0, 18, 0, 18)
        iconLbl.Position = UDim2.new(0, 0, 0.5, -9)

        local box = Instance.new("TextBox")
        box.Size              = UDim2.new(1, -26, 0, 26)
        box.Position          = UDim2.new(0, 24, 0.5, -13)
        box.BackgroundTransparency = 1
        box.Text              = ""
        box.PlaceholderText   = cfg.Placeholder or "Rechercher..."
        box.TextColor3        = theme.TextPrimary
        box.PlaceholderColor3 = theme.TextDisabled
        box.TextSize          = 12
        box.Font              = Enum.Font.Gotham
        box.TextXAlignment    = Enum.TextXAlignment.Left
        box.ClearTextOnFocus  = false
        box.Editable          = not disabled
        box.Parent            = f

        -- Dropdown de résultats
        local resultsList = nil

        local function closeResults()
            if resultsList then
                local r = resultsList
                resultsList = nil
                tw(r, { BackgroundTransparency = 1 }, ANIM_FAST)
                task.delay(ANIM_FAST + 0.02, function() pcall(function() r:Destroy() end) end)
            end
        end

        local function showResults(query)
            closeResults()
            filtered = {}
            for _, item in ipairs(items) do
                if query == "" or tostring(item):lower():find(query:lower(), 1, true) then
                    table.insert(filtered, item)
                end
            end

            if #filtered == 0 then return end

            local sg = gui
            if not sg then return end

            RunService.Heartbeat:Wait()

            local abs  = f.AbsolutePosition
            local absS = f.AbsoluteSize
            local vp   = workspace.CurrentCamera.ViewportSize
            local itemH   = 26
            local count   = math.min(#filtered, maxShow)
            local listH   = count * itemH + 8

            local openBelow = (abs.Y + absS.Y + listH + 4) < vp.Y
            local listY     = openBelow and (abs.Y + absS.Y + 4) or (abs.Y - listH - 4)
            local listX     = math.clamp(abs.X, 4, vp.X - absS.X - 4)

            resultsList = Instance.new("Frame")
            resultsList.Size              = UDim2.new(0, absS.X, 0, listH)
            resultsList.Position          = UDim2.new(0, listX, 0, listY)
            resultsList.BackgroundColor3  = theme.OverlayBg or theme.Element
            resultsList.BackgroundTransparency = 1
            resultsList.BorderSizePixel   = 0
            resultsList.ZIndex            = 999
            resultsList.ClipsDescendants  = true
            corner(resultsList, CORNER_SM)
            stroke(resultsList, theme.OverlayStroke or theme.ElementStroke, 1)
            resultsList.Parent = sg

            tw(resultsList, { BackgroundTransparency = 0 }, ANIM_FAST)

            local lay = Instance.new("UIListLayout")
            lay.SortOrder = Enum.SortOrder.LayoutOrder
            lay.Parent    = resultsList
            pad(resultsList, 4, 4, 0, 0)

            for _, item in ipairs(filtered) do
                local ri = mkFrame(resultsList, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, itemH))
                ri.BackgroundTransparency = 1
                ri.ZIndex = 1000

                local rl = mkLbl(ri, tostring(item), theme.TextPrimary, 12, Enum.Font.Gotham)
                rl.Size     = UDim2.new(1, -12, 1, 0)
                rl.Position = UDim2.new(0, 6, 0, 0)
                rl.ZIndex   = 1001
                rl.TextTruncate = Enum.TextTruncate.AtEnd

                local rb = mkBtn(ri, UDim2.fromScale(1, 1), nil, 1002)
                rb.MouseEnter:Connect(function()
                    tw(ri, { BackgroundTransparency = 0 })
                    ri.BackgroundColor3 = theme.ElementHover
                end)
                rb.MouseLeave:Connect(function()
                    tw(ri, { BackgroundTransparency = 1 })
                end)
                rb.MouseButton1Click:Connect(function()
                    box.Text = tostring(item)
                    closeResults()
                    task.spawn(function() pcall(cfg.Callback or function() end, item) end)
                end)
            end
        end

        box:GetPropertyChangedSignal("Text"):Connect(function()
            showResults(box.Text)
        end)
        box.FocusLost:Connect(function()
            task.delay(0.18, closeResults)
        end)

        if disabled then f.BackgroundTransparency = 0.4 end
        f.Parent = page

        local obj = { _frame = f }
        function obj:SetItems(i) items = i end
        function obj:Get()       return box.Text end
        function obj:Set(v)      box.Text = v end
        return obj
    end

    -- ─── TABS (sous-tabs dans un Tab) ─────────────────────────────────
    function Tab:SubTabs(cfg)
        cfg = cfg or {}
        local tabs    = cfg.Tabs or {}
        local tabH    = 32
        local wrapH   = tabH + 8

        local wrapper = mkFrame(page, Color3.fromRGB(0, 0, 0), UDim2.new(1, 0, 0, wrapH))
        wrapper.BackgroundTransparency = 1

        local nav = mkFrame(wrapper, theme.Sidebar, UDim2.new(1, 0, 0, tabH))
        nav.Position = UDim2.new(0, 0, 0, 0)
        corner(nav, UDim.new(0, 7))
        stroke(nav, theme.ElementStroke, 1)

        local navLay = Instance.new("UIListLayout")
        navLay.FillDirection     = Enum.FillDirection.Horizontal
        navLay.VerticalAlignment = Enum.VerticalAlignment.Center
        navLay.Padding           = UDim.new(0, 2)
        navLay.Parent            = nav
        pad(nav, 3, 3, 4, 4)

        local content  = {}
        local navBtns  = {}
        local active   = nil

        for i, t in ipairs(tabs) do
            local nb = mkFrame(nav, Color3.fromRGB(0, 0, 0), UDim2.new(0, 0, 1, 0))
            nb.AutomaticSize          = Enum.AutomaticSize.X
            nb.BackgroundTransparency = i == 1 and 0 or 1
            if i == 1 then nb.BackgroundColor3 = theme.TabActive end
            corner(nb, UDim.new(0, 5))
            pad(nb, 0, 0, 10, 10)

            local nl = mkLbl(nb, t.Title or "Tab", i == 1 and theme.TextPrimary or theme.TextSecondary, 11, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
            nl.Size = UDim2.new(0, 0, 1, 0)
            nl.AutomaticSize = Enum.AutomaticSize.X

            local cp = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, 0))
            cp.AutomaticSize          = Enum.AutomaticSize.Y
            cp.BackgroundTransparency = 1
            cp.Visible                = (i == 1)
            pad(cp, 4, 4, 0, 0)

            local cpl = Instance.new("UIListLayout")
            cpl.Padding   = UDim.new(0, 5)
            cpl.SortOrder = Enum.SortOrder.LayoutOrder
            cpl.Parent    = cp

            content[i]  = cp
            navBtns[i]  = { btn = nb, lbl = nl }

            if i == 1 then active = i end

            local nbb = mkBtn(nb)
            nbb.MouseButton1Click:Connect(function()
                if active == i then return end
                -- Désactiver l'ancien
                content[active].Visible = false
                tw(navBtns[active].btn, { BackgroundTransparency = 1 })
                tw(navBtns[active].lbl, { TextColor3 = theme.TextSecondary })
                -- Activer le nouveau
                active = i
                content[i].Visible = true
                tw(nb, { BackgroundTransparency = 0 })
                nb.BackgroundColor3 = theme.TabActive
                tw(nl, { TextColor3 = theme.TextPrimary })
            end)

            cp.Parent = page
        end

        wrapper.Parent = page

        -- Retourne un objet SubTab qui permet d'injecter des éléments
        -- dans chaque contenu de tab
        local subObj = { _frame = wrapper }
        for i, _ in ipairs(tabs) do
            subObj[i] = {
                _frame = content[i],
                _theme = theme,
                _gui   = gui,
                _page  = content[i],
            }
            injectElements and injectElements(subObj[i], theme, content[i])
        end
        return subObj
    end

    -- ─── SWITCH ROW ──────────────────────────────────────────────────
    -- Une rangée de switches pour modifier plusieurs options à la fois
    function Tab:SwitchRow(cfg)
        cfg = cfg or {}
        local switches = cfg.Switches or {}
        local cols     = cfg.Cols     or 2
        local switchH  = 40
        local rows     = math.ceil(#switches / cols)
        local h        = (cfg.Title and 22 or 0) + rows * switchH + (rows - 1) * 4 + 20

        local f = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 10, 10, 14, 14)

        local yOff = 0
        if cfg.Title then
            local tl = mkLbl(f, cfg.Title, theme.TextPrimary, 12, Enum.Font.GothamMedium)
            tl.Size     = UDim2.new(1, 0, 0, 15)
            tl.Position = UDim2.new(0, 0, 0, 0)
            yOff = 20
        end

        local colW = (1 - (cols - 1) * 0.02) / cols
        local objs = {}

        for i, sw in ipairs(switches) do
            local row = math.floor((i - 1) / cols)
            local col = (i - 1) % cols
            local value = sw.Value ~= nil and sw.Value or false

            local item = mkFrame(f, theme.CardBg, UDim2.new(colW, -2, 0, switchH - 4))
            item.Position           = UDim2.new(col * (colW + 0.02), 0, 0, yOff + row * (switchH + 4))
            item.BackgroundTransparency = 0.5
            corner(item, CORNER_SM)
            pad(item, 0, 0, 10, 10)

            local nl = mkLbl(item, sw.Title or "Option", theme.TextPrimary, 11, Enum.Font.GothamMedium)
            nl.Size     = UDim2.new(1, -46, 1, 0)
            nl.Position = UDim2.new(0, 0, 0, 0)
            nl.TextTruncate = Enum.TextTruncate.AtEnd

            local track = mkFrame(item, value and theme.Accent or theme.ElementStroke, UDim2.new(0, 32, 0, 16))
            track.Position = UDim2.new(1, -34, 0.5, -8)
            corner(track, UDim.new(1, 0))

            local thumb = mkFrame(track, Color3.fromRGB(255, 255, 255), UDim2.new(0, 12, 0, 12))
            thumb.AnchorPoint = Vector2.new(0, 0.5)
            thumb.Position    = value and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            corner(thumb, UDim.new(1, 0))

            local function update(v)
                tw(track, { BackgroundColor3 = v and theme.Accent or theme.ElementStroke })
                tw(thumb, { Position = v and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) })
            end

            local ib = mkBtn(item)
            ib.MouseButton1Click:Connect(function()
                value = not value
                update(value)
                task.spawn(function() pcall(sw.Callback or function() end, value) end)
            end)

            objs[sw.Title or i] = {
                Get = function() return value end,
                Set = function(self, v)
                    value = v
                    update(v)
                end,
            }
        end

        f.Parent = page
        local obj = { _frame = f, Switches = objs }
        return obj
    end

    -- ─── RICH TEXT BLOCK ─────────────────────────────────────────────
    function Tab:RichText(cfg)
        cfg = cfg or {}
        local content = cfg.Content or ""
        local align   = cfg.Align and Enum.TextXAlignment[cfg.Align] or Enum.TextXAlignment.Left

        local f = mkFrame(page, cfg.Background and theme.CardBg or Color3.fromRGB(0, 0, 0),
            UDim2.new(1, 0, 0, 0))
        f.BackgroundTransparency = cfg.Background and 0.4 or 1
        f.AutomaticSize          = Enum.AutomaticSize.Y
        if cfg.Background then
            corner(f, CORNER_EL)
            stroke(f, theme.CardStroke, 1)
            pad(f, 10, 10, 14, 14)
        end

        local l = Instance.new("TextLabel")
        l.Text                   = content
        l.TextColor3             = cfg.Color or theme.TextSecondary
        l.TextSize               = cfg.Size or 12
        l.Font                   = cfg.Font and Enum.Font[cfg.Font] or Enum.Font.Gotham
        l.BackgroundTransparency = 1
        l.TextXAlignment         = align
        l.TextYAlignment         = Enum.TextYAlignment.Top
        l.TextWrapped            = true
        l.RichText               = true
        l.Size                   = UDim2.new(1, 0, 0, 0)
        l.AutomaticSize          = Enum.AutomaticSize.Y
        l.Parent                 = f

        f.Parent = page
        local obj = { _frame = f }
        function obj:Set(text) l.Text = text end
        function obj:Get()     return l.Text end
        function obj:SetColor(c) l.TextColor3 = c end
        return obj
    end

    -- ─── COUNTDOWN ───────────────────────────────────────────────────
    function Tab:Countdown(cfg)
        cfg = cfg or {}
        local seconds  = cfg.Seconds  or 60
        local running  = cfg.AutoStart ~= false
        local elapsed  = 0
        local color    = cfg.Color     or theme.Accent

        local f = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, 64))
        f.BorderSizePixel = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        pad(f, 10, 10, 14, 14)

        local tl = mkLbl(f, cfg.Title or "Countdown", theme.TextSecondary, 10, Enum.Font.GothamBold)
        tl.Size     = UDim2.new(1, 0, 0, 13)
        tl.Position = UDim2.new(0, 0, 0, 0)

        local timeLbl = mkLbl(f, "00:00", color, 22, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        timeLbl.Size     = UDim2.new(0.5, 0, 0, 26)
        timeLbl.Position = UDim2.new(0.25, 0, 0, 18)

        local track = mkFrame(f, theme.ElementStroke2, UDim2.new(1, 0, 0, 4))
        track.Position = UDim2.new(0, 0, 1, -6)
        corner(track, UDim.new(1, 0))

        local fill = mkFrame(track, color, UDim2.new(1, 0, 1, 0))
        fill.BackgroundTransparency = 0.2
        corner(fill, UDim.new(1, 0))

        local function fmt(s)
            local m = math.floor(s / 60)
            return string.format("%02d:%02d", m, s % 60)
        end

        local function update()
            local rem = math.max(0, seconds - elapsed)
            timeLbl.Text = fmt(rem)
            tw(fill, { Size = UDim2.new(rem / seconds, 0, 1, 0) }, 0.5, Enum.EasingStyle.Linear)
            if rem <= 0 then
                running = false
                task.spawn(function() pcall(cfg.OnFinish or function() end) end)
            end
        end

        update()

        local tickConn
        if running then
            tickConn = RunService.Heartbeat:Connect(function(dt)
                if not running then return end
                elapsed += dt
                update()
            end)
        end

        f.Parent = page
        local obj = { _frame = f }
        function obj:Start()
            running = true
            if not tickConn then
                tickConn = RunService.Heartbeat:Connect(function(dt)
                    if not running then return end
                    elapsed += dt
                    update()
                end)
            end
        end
        function obj:Pause()  running = false end
        function obj:Reset()
            elapsed = 0
            running = false
            update()
        end
        function obj:SetSeconds(s)
            seconds = s
            elapsed = 0
            update()
        end
        return obj
    end

    -- ─── NOTIFICATION INLINE (info box) ──────────────────────────────
    function Tab:InfoBox(cfg)
        cfg = cfg or {}
        local ntype  = cfg.Type or "info"
        local types  = {
            success = { col = theme.Success, bg = theme.SuccessDark, icon = "✓" },
            error   = { col = theme.Danger,  bg = theme.DangerDark,  icon = "✕" },
            warn    = { col = theme.Warning, bg = theme.WarningDark, icon = "!" },
            info    = { col = theme.Info,    bg = theme.InfoDark,    icon = "i" },
        }
        local td    = types[ntype] or types.info
        local color = cfg.Color or td.col

        local f = mkFrame(page, color, UDim2.new(1, 0, 0, 0))
        f.AutomaticSize          = Enum.AutomaticSize.Y
        f.BackgroundTransparency = 0.88
        corner(f, CORNER_SM)
        stroke(f, color, 1)
        pad(f, 10, 10, 14, 14)

        -- Barre latérale
        local bar = mkFrame(f, color, UDim2.new(0, 3, 1, 0))
        bar.Position          = UDim2.new(0, -14, 0, 0)
        bar.AnchorPoint       = Vector2.new(0, 0)
        bar.BackgroundTransparency = 0.2
        corner(bar, UDim.new(0, 2))

        -- Icône
        local iconBg = mkFrame(f, color, UDim2.new(0, 18, 0, 18))
        iconBg.Position           = UDim2.new(0, 0, 0, 0)
        iconBg.BackgroundTransparency = 0.7
        corner(iconBg, UDim.new(1, 0))
        local ic = mkLbl(iconBg, td.icon, color, 10, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
        ic.Size = UDim2.fromScale(1, 1)

        if cfg.Title and cfg.Title ~= "" then
            local tl = mkLbl(f, cfg.Title, color, 12, Enum.Font.GothamBold)
            tl.Size     = UDim2.new(1, -24, 0, 15)
            tl.Position = UDim2.new(0, 24, 0, 0)
            tl.TextTruncate = Enum.TextTruncate.AtEnd
        end

        if cfg.Desc and cfg.Desc ~= "" then
            local dl = Instance.new("TextLabel")
            dl.Text              = cfg.Desc
            dl.TextColor3        = color
            dl.TextSize          = 11
            dl.Font              = Enum.Font.Gotham
            dl.BackgroundTransparency = 1
            dl.TextXAlignment    = Enum.TextXAlignment.Left
            dl.TextYAlignment    = Enum.TextYAlignment.Top
            dl.TextWrapped       = true
            dl.Size              = UDim2.new(1, -24, 0, 0)
            dl.AutomaticSize     = Enum.AutomaticSize.Y
            dl.Position          = UDim2.new(0, 24, 0, cfg.Title and 16 or 0)
            dl.Parent            = f
        end

        f.Parent = page
        local obj = { _frame = f }
        function obj:SetTitle(t) end
        function obj:SetDesc(d) end
        return obj
    end

    -- ─── IMAGE VIEWER ────────────────────────────────────────────────
    function Tab:ImageViewer(cfg)
        cfg = cfg or {}
        local imgId = cfg.Image or "rbxassetid://0"
        local h     = cfg.Height or 120

        local f = mkFrame(page, theme.Element, UDim2.new(1, 0, 0, h))
        f.BorderSizePixel  = 0
        corner(f, CORNER_EL)
        stroke(f, theme.ElementStroke, 1)
        f.ClipsDescendants = true

        local img = Instance.new("ImageLabel")
        img.Size      = UDim2.fromScale(1, 1)
        img.Position  = UDim2.new(0, 0, 0, 0)
        img.BackgroundColor3 = theme.CardBg
        img.Image     = imgId
        img.ScaleType = Enum.ScaleType.Crop
        img.Parent    = f

        local overlay = mkFrame(f, Color3.fromRGB(0, 0, 0), UDim2.fromScale(1, 1))
        overlay.BackgroundTransparency = 0.7

        if cfg.Caption and cfg.Caption ~= "" then
            local cap = mkLbl(overlay, cfg.Caption, theme.TextPrimary, 11, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
            cap.Size     = UDim2.new(1, 0, 0, 16)
            cap.Position = UDim2.new(0, 0, 1, -20)
            cap.TextTruncate = Enum.TextTruncate.AtEnd
        end

        f.Parent = page
        local obj = { _frame = f }
        function obj:SetImage(id) img.Image = id end
        function obj:SetCaption(c) end
        return obj
    end

end -- Elements:Extend

-- ═══════════════════════════════════════════════════════════════════
--  EXPOSE
-- ═══════════════════════════════════════════════════════════════════
return Elements

