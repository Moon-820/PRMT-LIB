local TryxLib = {}
TryxLib.__index = TryxLib

local cloneref = cloneref or clonereference or function(x) return x end
local Players          = cloneref(game:GetService("Players"))
local TweenService     = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService       = cloneref(game:GetService("RunService"))
local HttpService      = cloneref(game:GetService("HttpService"))
local CoreGui          = cloneref(game:GetService("CoreGui"))

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

local Creator = {}
Creator.Font   = "rbxassetid://12187365364"
Creator.Theme  = nil
Creator.Objects = {}
Creator.Signals = {}

Creator.Shapes = {
    Square               = "rbxassetid://82909646051652",
    ["Square-Outline"]   = "rbxassetid://72946211851948",
    Squircle             = "rbxassetid://80999662900595",
    SquircleOutline      = "rbxassetid://117788349049947",
    ["Squircle-Outline"] = "rbxassetid://117817408534198",
    SquircleOutline2     = "rbxassetid://117817408534198",
    ["Shadow-sm"]        = "rbxassetid://84825982946844",
    ["Squircle-TL-TR"]   = "rbxassetid://73569156276236",
    ["Squircle-BL-BR"]   = "rbxassetid://93853842912264",
    ["Glass-0.7"]        = "rbxassetid://79047752995006",
    ["Glass-1"]          = "rbxassetid://97324581055162",
    ["Glass-1.4"]        = "rbxassetid://95071123641270",
}

Creator.DefaultProperties = {
    Frame = {
        BorderSizePixel  = 0,
        BackgroundColor3 = Color3.new(1,1,1),
    },
    TextLabel = {
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel  = 0,
        Text             = "",
        RichText         = true,
        TextColor3       = Color3.new(1,1,1),
        TextSize         = 14,
    },
    TextButton = {
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel  = 0,
        Text             = "",
        AutoButtonColor  = false,
        TextColor3       = Color3.new(1,1,1),
        TextSize         = 14,
    },
    TextBox = {
        BackgroundColor3 = Color3.new(1,1,1),
        BorderColor3     = Color3.new(0,0,0),
        ClearTextOnFocus = false,
        Text             = "",
        TextColor3       = Color3.new(0,0,0),
        TextSize         = 14,
    },
    ImageLabel = {
        BackgroundTransparency = 1,
        BackgroundColor3       = Color3.new(1,1,1),
        BorderSizePixel        = 0,
    },
    ImageButton = {
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
    },
    ScrollingFrame = {
        ScrollBarImageTransparency = 1,
        BorderSizePixel            = 0,
    },
    UIListLayout = {
        SortOrder = "LayoutOrder",
    },
    CanvasGroup = {
        BorderSizePixel  = 0,
        BackgroundColor3 = Color3.new(1,1,1),
    },
    ScreenGui = {
        ResetOnSpawn   = false,
        ZIndexBehavior = "Sibling",
    },
}

Creator.ThemeFallbacks = {
    Primary                       = "Accent",
    Hover                         = "Text",
    Dialog                        = "Accent",
    WindowBackground              = "Background",
    WindowShadow                  = "Black",
    White                         = Color3.new(1,1,1),
    Black                         = Color3.new(0,0,0),
    ElementBackground             = "Text",
    ElementBackgroundTransparency = 0.93,
    ElementTitle                  = "Text",
    ElementDesc                   = "Text",
    ElementIcon                   = "Icon",
    PopupBackground               = "Background",
    PopupTitle                    = "Text",
    PopupContent                  = "Text",
    Toggle                        = "Button",
    Slider                        = "Primary",
    SliderThumb                   = "White",
    SliderIcon                    = "Icon",
    Checkbox                      = "Primary",
    CheckboxIcon                  = "White",
    CheckboxBorder                = "White",
    CheckboxBorderTransparency    = 0.75,
    TabBackground                 = "Hover",
    TabText                       = "Text",
    TabIcon                       = "Icon",
    TabIconTransparency           = 0.4,
    TabIconTransparencyActive     = 0.1,
    TabTextTransparency           = 0.3,
    TabTextTransparencyActive     = 0,
    SectionIcon                   = "Icon",
    SectionBox                    = "White",
    SectionBoxTransparency        = 0.95,
    SectionBoxBorder              = "White",
    SectionBoxBorderTransparency  = 0.75,
    NotificationTitle             = "Text",
    NotificationTitleTransparency = 0,
    NotificationContent           = "Text",
    NotificationContentTransparency = 0.4,
    NotificationDuration          = "White",
    NotificationDurationTransparency = 0.95,
    NotificationBorder            = "White",
    NotificationBorderTransparency = 0.75,
    LabelBackground               = "White",
    LabelBackgroundTransparency   = 0.95,
}

function Creator.GetThemeValue(key)
    if not Creator.Theme then return nil end
    local val = Creator.Theme[key]
    if val == nil then
        val = Creator.ThemeFallbacks[key]
    end
    if val == nil then return nil end
    if typeof(val) == "string" then
        if val:sub(1,1) == "#" then
            return Color3.fromHex(val)
        else
            return Creator.GetThemeValue(val)
        end
    end
    return val
end

function Creator.ApplyTheme(obj, tags)
    for prop, key in pairs(tags) do
        local val = Creator.GetThemeValue(key)
        if val ~= nil then
            pcall(function() obj[prop] = val end)
        end
    end
end

function Creator.SetTheme(theme)
    Creator.Theme = theme
    local dead = {}
    for obj, tags in pairs(Creator.Objects) do
        if obj and obj.Parent ~= nil then
            Creator.ApplyTheme(obj, tags)
        else
            table.insert(dead, obj)
        end
    end
    for _, obj in ipairs(dead) do
        Creator.Objects[obj] = nil
    end
end

function Creator.RegisterThemeTag(obj, tags)
    Creator.Objects[obj] = tags
    if Creator.Theme then
        Creator.ApplyTheme(obj, tags)
    end
    obj.Destroying:Connect(function()
        Creator.Objects[obj] = nil
    end)
end

function Creator.Tween(obj, t, props, style, dir)
    local info = TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    return TweenService:Create(obj, info, props)
end

function Creator.New(className, props, children)
    local defaults = Creator.DefaultProperties[className] or {}
    local ok, obj = pcall(Instance.new, className)
    if not ok then return nil end
    for k, v in pairs(defaults) do
        pcall(function() obj[k] = v end)
    end
    local themeTag, parent = nil, nil
    for k, v in pairs(props) do
        if k == "ThemeTag" then
            themeTag = v
        elseif k == "Parent" then
            parent = v
        else
            pcall(function() obj[k] = v end)
        end
    end
    if themeTag then
        Creator.RegisterThemeTag(obj, themeTag)
    end
    if children then
        for _, child in ipairs(children) do
            if child and typeof(child) == "Instance" then
                child.Parent = obj
            end
        end
    end
    if parent then obj.Parent = parent end
    return obj
end

function Creator.NewRoundFrame(shape, props, children, isButton)
    local className  = isButton and "ImageButton" or "ImageLabel"
    local shapeAsset = Creator.Shapes[shape] or Creator.Shapes.Squircle
    local merged     = {}
    for k, v in pairs(props) do merged[k] = v end
    merged.Image               = merged.Image or shapeAsset
    merged.ScaleType           = Enum.ScaleType.Slice
    merged.SliceCenter         = Rect.new(49, 49, 450, 450)
    if merged.BackgroundTransparency == nil then
        merged.BackgroundTransparency = 1
    end
    local frame = Creator.New(className, merged)
    if children then
        for _, child in ipairs(children) do
            if child and typeof(child) == "Instance" then
                child.Parent = frame
            end
        end
    end
    return frame
end

function Creator.AddSignal(signal, fn)
    local conn = signal:Connect(fn)
    table.insert(Creator.Signals, conn)
    return conn
end

function Creator.DisconnectAll()
    for _, conn in ipairs(Creator.Signals) do
        pcall(function() conn:Disconnect() end)
    end
    Creator.Signals = {}
end

local Icons = nil
pcall(function()
    local url = "https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"
    local src  = game.HttpGetAsync and game:HttpGetAsync(url) or HttpService:GetAsync(url)
    Icons = loadstring(src)()
    Icons.SetIconsType("lucide")
end)

function Creator.Icon(name)
    if not Icons then return nil, nil end
    local ok, result = pcall(function() return Icons.Icon(name) end)
    if not ok or not result then return nil, nil end
    return result[1], result[2]
end

function Creator.MakeIcon(name, size, parent, themeKey)
    local img, data = Creator.Icon(name)
    if not img then return nil end
    return Creator.New("ImageLabel", {
        Image            = img,
        ImageRectOffset  = data and data.ImageRectPosition or Vector2.zero,
        ImageRectSize    = data and data.ImageRectSize    or Vector2.zero,
        Size             = UDim2.new(0, size or 16, 0, size or 16),
        BackgroundTransparency = 1,
        Parent           = parent,
        ThemeTag         = themeKey and { ImageColor3 = themeKey } or nil,
    })
end

local Themes = {}

Themes.Dark = {
    Name                         = "Dark",
    Accent                       = Color3.fromHex("#18181b"),
    Dialog                       = Color3.fromHex("#161616"),
    Outline                      = Color3.fromHex("#FFFFFF"),
    Text                         = Color3.fromHex("#FFFFFF"),
    Placeholder                  = Color3.fromHex("#7a7a7a"),
    Background                   = Color3.fromHex("#101010"),
    Button                       = Color3.fromHex("#52525b"),
    Icon                         = Color3.fromHex("#a1a1aa"),
    Toggle                       = Color3.fromHex("#33C759"),
    Slider                       = Color3.fromHex("#0091FF"),
    Checkbox                     = Color3.fromHex("#0091FF"),
    Primary                      = Color3.fromHex("#0091FF"),
    SliderIcon                   = Color3.fromHex("#908F95"),
    LabelBackground              = Color3.fromHex("#000000"),
    LabelBackgroundTransparency  = 0.83,
    ElementBackground            = Color3.fromHex("#2A2A2C"),
    ElementBackgroundTransparency= 0,
}

Themes.Light = {
    Name                         = "Light",
    Accent                       = Color3.fromHex("#FFFFFF"),
    Dialog                       = Color3.fromHex("#f4f4f5"),
    Outline                      = Color3.fromHex("#ffffff"),
    Text                         = Color3.fromHex("#000000"),
    Placeholder                  = Color3.fromHex("#555555"),
    Background                   = Color3.fromHex("#e9e9e9"),
    Button                       = Color3.fromHex("#18181b"),
    Icon                         = Color3.fromHex("#52525b"),
    Toggle                       = Color3.fromHex("#33C759"),
    Slider                       = Color3.fromHex("#0091FF"),
    Checkbox                     = Color3.fromHex("#0091FF"),
    Primary                      = Color3.fromHex("#0091FF"),
    ElementBackground            = Color3.fromHex("#EEEEEE"),
    ElementBackgroundTransparency= 0,
    LabelBackground              = Color3.fromHex("#ffffff"),
    LabelBackgroundTransparency  = 0,
}

Themes.Rose = {
    Name                         = "Rose",
    Accent                       = Color3.fromHex("#be185d"),
    Dialog                       = Color3.fromHex("#4c0519"),
    Text                         = Color3.fromHex("#fdf2f8"),
    Placeholder                  = Color3.fromHex("#d67aa6"),
    Background                   = Color3.fromHex("#1f0308"),
    Button                       = Color3.fromHex("#e95f74"),
    Icon                         = Color3.fromHex("#fb7185"),
    Toggle                       = Color3.fromHex("#fb7185"),
    Slider                       = Color3.fromHex("#fb7185"),
    Checkbox                     = Color3.fromHex("#fb7185"),
    Primary                      = Color3.fromHex("#fb7185"),
    ElementBackground            = Color3.fromHex("#381E23"),
    ElementBackgroundTransparency= 0,
}

Themes.Plant = {
    Name                         = "Plant",
    Accent                       = Color3.fromHex("#166534"),
    Dialog                       = Color3.fromHex("#052e16"),
    Text                         = Color3.fromHex("#f0fdf4"),
    Placeholder                  = Color3.fromHex("#4fbf7a"),
    Background                   = Color3.fromHex("#0a1b0f"),
    Button                       = Color3.fromHex("#16a34a"),
    Icon                         = Color3.fromHex("#4ade80"),
    Toggle                       = Color3.fromHex("#4ade80"),
    Slider                       = Color3.fromHex("#4ade80"),
    Checkbox                     = Color3.fromHex("#4ade80"),
    Primary                      = Color3.fromHex("#4ade80"),
    ElementBackground            = Color3.fromHex("#28342A"),
    ElementBackgroundTransparency= 0,
}

Themes.Red = {
    Name                         = "Red",
    Accent                       = Color3.fromHex("#991b1b"),
    Dialog                       = Color3.fromHex("#450a0a"),
    Text                         = Color3.fromHex("#fef2f2"),
    Placeholder                  = Color3.fromHex("#d95353"),
    Background                   = Color3.fromHex("#1c0606"),
    Button                       = Color3.fromHex("#dc2626"),
    Icon                         = Color3.fromHex("#ef4444"),
    Toggle                       = Color3.fromHex("#ef4444"),
    Slider                       = Color3.fromHex("#ef4444"),
    Checkbox                     = Color3.fromHex("#ef4444"),
    Primary                      = Color3.fromHex("#ef4444"),
    ElementBackground            = Color3.fromHex("#322221"),
    ElementBackgroundTransparency= 0,
}

Themes.Indigo = {
    Name                         = "Indigo",
    Accent                       = Color3.fromHex("#3730a3"),
    Dialog                       = Color3.fromHex("#1e1b4b"),
    Text                         = Color3.fromHex("#f1f5f9"),
    Placeholder                  = Color3.fromHex("#7078d9"),
    Background                   = Color3.fromHex("#0f0a2e"),
    Button                       = Color3.fromHex("#4f46e5"),
    Icon                         = Color3.fromHex("#6366f1"),
    Toggle                       = Color3.fromHex("#6366f1"),
    Slider                       = Color3.fromHex("#6366f1"),
    Checkbox                     = Color3.fromHex("#6366f1"),
    Primary                      = Color3.fromHex("#6366f1"),
    ElementBackground            = Color3.fromHex("#282543"),
    ElementBackgroundTransparency= 0,
}

Themes.Sky = {
    Name                         = "Sky",
    Accent                       = Color3.fromHex("#0284c7"),
    Dialog                       = Color3.fromHex("#0c4a6e"),
    Text                         = Color3.fromHex("#f0f9ff"),
    Placeholder                  = Color3.fromHex("#7dd3fc"),
    Background                   = Color3.fromHex("#051a2e"),
    Button                       = Color3.fromHex("#0ea5e9"),
    Icon                         = Color3.fromHex("#38bdf8"),
    Toggle                       = Color3.fromHex("#38bdf8"),
    Slider                       = Color3.fromHex("#38bdf8"),
    Checkbox                     = Color3.fromHex("#38bdf8"),
    Primary                      = Color3.fromHex("#38bdf8"),
    ElementBackground            = Color3.fromHex("#0f2d42"),
    ElementBackgroundTransparency= 0,
}

Themes.Default = {
    Name                         = "Default",
    Accent                       = Color3.fromHex("#18180e"),
    Dialog                       = Color3.fromHex("#12110a"),
    Text                         = Color3.fromHex("#f5f0e8"),
    Placeholder                  = Color3.fromHex("#9a8f75"),
    Background                   = Color3.fromHex("#0d0c07"),
    Button                       = Color3.fromHex("#4a3f20"),
    Icon                         = Color3.fromHex("#c9a84c"),
    Toggle                       = Color3.fromHex("#daa732"),
    Slider                       = Color3.fromHex("#daa732"),
    Checkbox                     = Color3.fromHex("#daa732"),
    Primary                      = Color3.fromHex("#daa732"),
    ElementBackground            = Color3.fromHex("#1e1b10"),
    ElementBackgroundTransparency= 0,
}

Themes.Midnight = {
    Name                         = "Midnight",
    Accent                       = Color3.fromHex("#1e1b2e"),
    Dialog                       = Color3.fromHex("#13111e"),
    Text                         = Color3.fromHex("#ede8ff"),
    Placeholder                  = Color3.fromHex("#7a6fa8"),
    Background                   = Color3.fromHex("#0e0c18"),
    Button                       = Color3.fromHex("#4a3f80"),
    Icon                         = Color3.fromHex("#9b8aff"),
    Toggle                       = Color3.fromHex("#8a6cff"),
    Slider                       = Color3.fromHex("#8a6cff"),
    Checkbox                     = Color3.fromHex("#8a6cff"),
    Primary                      = Color3.fromHex("#8a6cff"),
    ElementBackground            = Color3.fromHex("#1c1928"),
    ElementBackgroundTransparency= 0,
}

Themes.Slate = {
    Name                         = "Slate",
    Accent                       = Color3.fromHex("#1e293b"),
    Dialog                       = Color3.fromHex("#0f172a"),
    Text                         = Color3.fromHex("#f1f5f9"),
    Placeholder                  = Color3.fromHex("#64748b"),
    Background                   = Color3.fromHex("#0b1120"),
    Button                       = Color3.fromHex("#334155"),
    Icon                         = Color3.fromHex("#94a3b8"),
    Toggle                       = Color3.fromHex("#60a5fa"),
    Slider                       = Color3.fromHex("#60a5fa"),
    Checkbox                     = Color3.fromHex("#60a5fa"),
    Primary                      = Color3.fromHex("#60a5fa"),
    ElementBackground            = Color3.fromHex("#1a2535"),
    ElementBackgroundTransparency= 0,
}

TryxLib.Themes = Themes

local NotifyGui
do
    local ok
    ok, NotifyGui = pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name          = "TryxLib_Notifications"
        g.ResetOnSpawn  = false
        g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        g.IgnoreGuiInset = true
        if pcall(function() return gethui() end) and gethui then
            g.Parent = gethui()
        else
            g.Parent = CoreGui
        end
        return g
    end)
    if not ok then
        NotifyGui = Instance.new("ScreenGui")
        NotifyGui.Name   = "TryxLib_Notifications"
        NotifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

local NotifyHolder = Creator.New("Frame", {
    AnchorPoint         = Vector2.new(1, 1),
    Position            = UDim2.new(1, -16, 1, -16),
    Size                = UDim2.new(0, 300, 1, -32),
    BackgroundTransparency = 1,
    Parent              = NotifyGui,
}, {
    Creator.New("UIListLayout", {
        VerticalAlignment   = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding             = UDim.new(0, 8),
        SortOrder           = Enum.SortOrder.LayoutOrder,
    }),
})

local NotifyColors = {
    success = Color3.fromHex("#3cb371"),
    error   = Color3.fromHex("#e53935"),
    warn    = Color3.fromHex("#f57c00"),
    info    = Color3.fromHex("#039be5"),
}

function TryxLib:Notify(cfg)
    local title    = cfg.Title    or "Notification"
    local desc     = cfg.Desc     or ""
    local nType    = cfg.Type     or "info"
    local duration = cfg.Duration or 4
    local color    = NotifyColors[nType] or NotifyColors.info

    local wrap = Creator.New("Frame", {
        BackgroundTransparency = 1,
        Size  = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = NotifyHolder,
    })

    local main = Creator.NewRoundFrame("Squircle", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ImageTransparency = 0.06,
        ThemeTag = { ImageColor3 = "Accent" },
        Position = UDim2.new(2, 0, 0, 0),
    })

    Creator.NewRoundFrame("Glass-1", {
        Size     = UDim2.new(1, 0, 1, 0),
        ThemeTag = { ImageColor3 = "NotificationBorder", ImageTransparency = "NotificationBorderTransparency" },
        Parent   = main,
    })

    local accent = Creator.New("Frame", {
        Size             = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = color,
        Parent           = main,
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
    })

    local txtFrame = Creator.New("Frame", {
        Size              = UDim2.new(1, -14, 0, 0),
        AutomaticSize     = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Position          = UDim2.new(0, 14, 0, 0),
        Parent            = main,
    }, {
        Creator.New("UIPadding", {
            PaddingTop    = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingRight  = UDim.new(0, 10),
        }),
        Creator.New("UIListLayout", {
            Padding = UDim.new(0, 3),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
    })

    Creator.New("TextLabel", {
        Size          = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Text          = title,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize      = 15,
        FontFace      = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        BackgroundTransparency = 1,
        TextWrapped   = true,
        Parent        = txtFrame,
        ThemeTag      = { TextColor3 = "NotificationTitle" },
    })

    if desc ~= "" then
        Creator.New("TextLabel", {
            Size          = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text          = desc,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize      = 13,
            FontFace      = Font.new(Creator.Font, Enum.FontWeight.Medium),
            BackgroundTransparency = 1,
            TextWrapped   = true,
            Parent        = txtFrame,
            ThemeTag      = { TextColor3 = "NotificationContent", TextTransparency = "NotificationContentTransparency" },
        })
    end

    local durationBar = Creator.NewRoundFrame("Squircle", {
        Size             = UDim2.new(1, 0, 0, 2),
        ImageColor3      = color,
        ImageTransparency = 0,
        Parent           = main,
        Position         = UDim2.new(0, 0, 1, -2),
    })

    main.Parent = wrap

    task.spawn(function()
        task.wait()
        local h = main.AbsoluteSize.Y
        Creator.Tween(wrap, 0.4, { Size = UDim2.new(1, 0, 0, h) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Creator.Tween(main, 0.4, { Position = UDim2.new(0, 0, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        Creator.Tween(durationBar, duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut):Play()
        task.wait(duration)
        Creator.Tween(main, 0.4, { Position = UDim2.new(2, 0, 0, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        task.wait(0.4)
        wrap:Destroy()
    end)
end

local ELEMENT_H    = 46
local ANIM         = 0.15
local ANIM_FAST    = 0.09
local CORNER_R     = UDim.new(0, 8)
local CORNER_SM    = UDim.new(0, 6)
local SIDEBAR_W    = 180
local POPUP_Z      = 9999

local function mkCorner(r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or CORNER_R
    return c
end

local function mkPad(t, b, l, r)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    return p
end

local function mkStroke(thickness, color, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness    = thickness or 1
    s.Color        = color or Color3.new(1,1,1)
    s.Transparency = transparency ~= nil and transparency or 0.85
    return s
end

local function makeElement(parent, theme, cfg)
    local bg = cfg.Color or Creator.GetThemeValue("ElementBackground")
    local bgT = cfg.Transparency ~= nil and cfg.Transparency or (Creator.GetThemeValue("ElementBackgroundTransparency") or 0)

    local frame = Creator.New("Frame", {
        Size             = UDim2.new(1, 0, 0, ELEMENT_H),
        BackgroundColor3 = bg or Color3.fromHex("#1e1b10"),
        BackgroundTransparency = bgT,
        Parent           = parent,
    }, {
        mkCorner(CORNER_R),
    })

    if not cfg.Color then
        Creator.RegisterThemeTag(frame, {
            BackgroundColor3       = "ElementBackground",
            BackgroundTransparency = "ElementBackgroundTransparency",
        })
    end

    local titleLbl = Creator.New("TextLabel", {
        Size           = UDim2.new(1, -120, 1, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text           = cfg.Title or "",
        TextSize       = 14,
        FontFace       = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        Parent         = frame,
        ThemeTag       = { TextColor3 = "ElementTitle" },
    }, {
        mkPad(0, 0, 12, 0),
    })

    if cfg.Desc and cfg.Desc ~= "" then
        frame.Size = UDim2.new(1, 0, 0, ELEMENT_H + 16)
        local inner = Creator.New("Frame", {
            Size  = UDim2.new(1, -120, 1, 0),
            BackgroundTransparency = 1,
            Parent = frame,
        }, {
            mkPad(0, 0, 12, 0),
            Creator.New("UIListLayout", {
                Padding   = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
        })
        titleLbl.Parent = nil
        titleLbl.Size   = UDim2.new(1, 0, 0, 0)
        titleLbl.AutomaticSize = Enum.AutomaticSize.Y
        titleLbl.Parent = inner
        Creator.New("TextLabel", {
            Size           = UDim2.new(1, 0, 0, 0),
            AutomaticSize  = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text           = cfg.Desc,
            TextSize       = 12,
            FontFace       = Font.new(Creator.Font, Enum.FontWeight.Regular),
            TextTransparency = 0.4,
            TextWrapped    = true,
            Parent         = inner,
            ThemeTag       = { TextColor3 = "ElementDesc" },
        })
        frame.AutomaticSize = Enum.AutomaticSize.Y
    end

    if cfg.Disabled then
        frame.BackgroundTransparency = (bgT or 0) + 0.3
        titleLbl.TextTransparency   = 0.5
    end

    return frame, titleLbl
end

function TryxLib.new(cfg)
    cfg = cfg or {}
    local win = {
        Title   = cfg.Title  or "TryxLib",
        Theme   = cfg.Theme  or Themes.Default,
        Key     = cfg.Key    or Enum.KeyCode.RightShift,
        Visible = true,
        Tabs    = {},
        _tab    = nil,
    }

    Creator.SetTheme(win.Theme)

    local GUIParent
    pcall(function()
        if gethui then
            GUIParent = gethui()
        end
    end)
    if not GUIParent then
        pcall(function() GUIParent = CoreGui end)
    end
    if not GUIParent then
        GUIParent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local screenGui = Creator.New("ScreenGui", {
        Name             = "TryxLib",
        IgnoreGuiInset   = true,
        ResetOnSpawn     = false,
        ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
        DisplayOrder     = 999,
        Parent           = GUIParent,
    })

    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(screenGui) end
        if protect_gui then protect_gui(screenGui) end
    end)

    local windowFrame = Creator.NewRoundFrame("Squircle", {
        Size             = UDim2.new(0, 640, 0, 440),
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new(0.5, 0, 0.5, 0),
        ImageTransparency = 0,
        ThemeTag         = { ImageColor3 = "Background" },
        Parent           = screenGui,
    })

    Creator.NewRoundFrame("Glass-1", {
        Size     = UDim2.new(1, 0, 1, 0),
        ThemeTag = { ImageColor3 = "Outline", ImageTransparency = "CheckboxBorderTransparency" },
        Parent   = windowFrame,
    })

    local shadow = Creator.New("ImageLabel", {
        Image            = "rbxassetid://5554236805",
        AnchorPoint      = Vector2.new(0.5, 0.5),
        Position         = UDim2.new(0.5, 0, 0.5, 0),
        Size             = UDim2.new(1, 60, 1, 60),
        BackgroundTransparency = 1,
        ImageColor3      = Color3.new(0, 0, 0),
        ImageTransparency = 0.6,
        ZIndex           = 0,
        Parent           = windowFrame,
    })

    local topbar = Creator.NewRoundFrame("Squircle-TL-TR", {
        Size             = UDim2.new(1, 0, 0, 46),
        ImageTransparency = 0,
        ThemeTag         = { ImageColor3 = "Accent" },
        Parent           = windowFrame,
    })

    Creator.New("TextLabel", {
        Size           = UDim2.new(1, -100, 1, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text           = win.Title,
        TextSize       = 16,
        FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
        Parent         = topbar,
        ThemeTag       = { TextColor3 = "Text" },
    }, {
        mkPad(0, 0, 16, 0),
    })

    local closeBtn = Creator.NewRoundFrame("Squircle", {
        Size             = UDim2.new(0, 28, 0, 28),
        AnchorPoint      = Vector2.new(1, 0.5),
        Position         = UDim2.new(1, -10, 0.5, 0),
        ImageTransparency = 0.85,
        ThemeTag         = { ImageColor3 = "Text" },
        Parent           = topbar,
        Active           = true,
    }, nil, true)

    Creator.New("TextLabel", {
        Size           = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text           = "×",
        TextSize       = 18,
        FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
        ThemeTag       = { TextColor3 = "Text" },
        Parent         = closeBtn,
    })

    local mainArea = Creator.New("Frame", {
        Size             = UDim2.new(1, 0, 1, -46),
        Position         = UDim2.new(0, 0, 0, 46),
        BackgroundTransparency = 1,
        Parent           = windowFrame,
    })

    local sidebar = Creator.NewRoundFrame("Squircle-BL-BR", {
        Size             = UDim2.new(0, SIDEBAR_W, 1, 0),
        ImageTransparency = 0.02,
        ThemeTag         = { ImageColor3 = "Accent" },
        Parent           = mainArea,
    })

    local tabList = Creator.New("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent           = sidebar,
    }, {
        Creator.New("UIListLayout", {
            Padding         = UDim.new(0, 4),
            SortOrder       = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        }),
        mkPad(8, 8, 8, 8),
    })

    local activeIndicator = Creator.NewRoundFrame("Squircle", {
        Size             = UDim2.new(1, -16, 0, ELEMENT_H),
        AnchorPoint      = Vector2.new(0, 0),
        Position         = UDim2.new(0, 8, 0, 8),
        ImageTransparency = 0.85,
        ThemeTag         = { ImageColor3 = "Primary" },
        Parent           = sidebar,
    })

    local contentArea = Creator.New("Frame", {
        Size             = UDim2.new(1, -SIDEBAR_W, 1, 0),
        Position         = UDim2.new(0, SIDEBAR_W, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent           = mainArea,
    })

    local popupContainer = Creator.New("Frame", {
        Size             = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex           = POPUP_Z,
        Parent           = screenGui,
    })

    do
        local dragging, dragStart, startPos = false, nil, nil
        Creator.AddSignal(topbar.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging  = true
                dragStart = input.Position
                startPos  = windowFrame.Position
            end
        end)
        Creator.AddSignal(UserInputService.InputChanged, function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                windowFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
        Creator.AddSignal(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end

    Creator.AddSignal(closeBtn.MouseButton1Click, function()
        Creator.Tween(windowFrame, 0.3, { Size = UDim2.new(0, windowFrame.AbsoluteSize.X, 0, 0), ImageTransparency = 1 }, Enum.EasingStyle.Quint):Play()
        task.wait(0.3)
        windowFrame.Visible = false
        win.Visible = false
    end)

    Creator.AddSignal(UserInputService.InputBegan, function(input, gp)
        if not gp and input.KeyCode == win.Key then
            win.Visible = not win.Visible
            windowFrame.Visible = win.Visible
            if win.Visible then
                Creator.Tween(windowFrame, 0.3, { Size = UDim2.new(0, 640, 0, 440) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            end
        end
    end)

    local function selectTab(tab)
        if win._tab == tab then return end
        if win._tab then
            win._tab._container.Visible = false
            Creator.Tween(win._tab._btn, ANIM, { ImageTransparency = 1 }, Enum.EasingStyle.Quart):Play()
            Creator.Tween(win._tab._btnText, ANIM, { TextTransparency = 0.3 }):Play()
        end
        win._tab = tab
        tab._container.Visible = true
        local btnPos = tab._btn.AbsolutePosition
        local sidePos = sidebar.AbsolutePosition
        Creator.Tween(activeIndicator, ANIM, {
            Position = UDim2.new(0, 8, 0, btnPos.Y - sidePos.Y),
            Size     = UDim2.new(1, -16, 0, tab._btn.AbsoluteSize.Y),
        }, Enum.EasingStyle.Quint):Play()
        Creator.Tween(tab._btn, ANIM, { ImageTransparency = 0 }, Enum.EasingStyle.Quart):Play()
        Creator.Tween(tab._btnText, ANIM, { TextTransparency = 0 }):Play()
    end

    local winObj = { _win = win, _screenGui = screenGui, _windowFrame = windowFrame, _selectTab = selectTab, _contentArea = contentArea, _tabList = tabList, _activeIndicator = activeIndicator, _popupContainer = popupContainer }
    winObj.__index = winObj

    function winObj:Tab(tabCfg)
        tabCfg = tabCfg or {}
        local tab = {
            _elements  = {},
            _container = nil,
            _btn       = nil,
            _btnText   = nil,
        }

        local isFirst = #win.Tabs == 0
        table.insert(win.Tabs, tab)

        local btn = Creator.NewRoundFrame("Squircle", {
            Size             = UDim2.new(1, 0, 0, ELEMENT_H),
            ImageTransparency = 1,
            ThemeTag         = { ImageColor3 = "Primary" },
            Parent           = tabList,
            Active           = true,
        }, nil, true)

        local btnInner = Creator.New("Frame", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Parent           = btn,
        }, {
            Creator.New("UIListLayout", {
                FillDirection       = Enum.FillDirection.Horizontal,
                VerticalAlignment   = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding             = UDim.new(0, 8),
            }),
            mkPad(0, 0, 12, 8),
        })

        if tabCfg.Icon then
            Creator.New("TextLabel", {
                Size           = UDim2.new(0, 18, 0, 18),
                BackgroundTransparency = 1,
                Text           = tabCfg.Icon,
                TextSize       = 16,
                Parent         = btnInner,
                ThemeTag       = { TextColor3 = "TabIcon" },
            })
        end

        local btnText = Creator.New("TextLabel", {
            Size           = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text           = tabCfg.Title or "Tab",
            TextSize       = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace       = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
            TextTransparency = 0.3,
            Parent         = btnInner,
            ThemeTag       = { TextColor3 = "TabText" },
        })

        tab._btn     = btn
        tab._btnText = btnText

        local container = Creator.New("ScrollingFrame", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness   = 3,
            ScrollBarImageColor3 = Color3.fromHex("#ffffff"),
            ScrollBarImageTransparency = 0.7,
            CanvasSize       = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible          = false,
            Parent           = contentArea,
        }, {
            Creator.New("UIListLayout", {
                Padding   = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),
            mkPad(10, 10, 10, 14),
        })

        tab._container = container

        Creator.AddSignal(btn.MouseButton1Click, function()
            selectTab(tab)
        end)

        Creator.AddSignal(btn.MouseEnter, function()
            if win._tab ~= tab then
                Creator.Tween(btn, ANIM, { ImageTransparency = 0.88 }, Enum.EasingStyle.Quart):Play()
            end
        end)
        Creator.AddSignal(btn.MouseLeave, function()
            if win._tab ~= tab then
                Creator.Tween(btn, ANIM, { ImageTransparency = 1 }, Enum.EasingStyle.Quart):Play()
            end
        end)

        if isFirst then
            task.wait()
            selectTab(tab)
        end

        local tabObj = {}
        tabObj.__index = tabObj
        tabObj._tab = tab
        tabObj._win = winObj

        function tabObj:Button(c)
            local frame, _ = makeElement(container, win.Theme, c)
            frame.Size = UDim2.new(1, 0, 0, ELEMENT_H)

            local arrow = Creator.New("TextLabel", {
                Size           = UDim2.new(0, 30, 1, 0),
                AnchorPoint    = Vector2.new(1, 0.5),
                Position       = UDim2.new(1, -8, 0.5, 0),
                BackgroundTransparency = 1,
                Text           = "›",
                TextSize       = 22,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
                TextXAlignment = Enum.TextXAlignment.Right,
                ThemeTag       = { TextColor3 = "Primary" },
                Parent         = frame,
            })

            if c.Color then
                Creator.New("UIStroke", {
                    Thickness    = 1,
                    Color        = c.Color,
                    Transparency = 0.7,
                    Parent       = frame,
                })
            end

            if not c.Disabled then
                Creator.AddSignal(frame.InputBegan, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        Creator.Tween(frame, ANIM_FAST, { BackgroundTransparency = (c.Transparency or (Creator.GetThemeValue("ElementBackgroundTransparency") or 0)) + 0.15 }):Play()
                    end
                end)
                Creator.AddSignal(frame.InputEnded, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        Creator.Tween(frame, ANIM_FAST, { BackgroundTransparency = c.Transparency or (Creator.GetThemeValue("ElementBackgroundTransparency") or 0) }):Play()
                        task.spawn(function()
                            if c.Callback then pcall(c.Callback) end
                        end)
                    end
                end)
            end

            local el = {}
            function el:SetDisabled(v)
                c.Disabled = v
            end
            return el
        end

        function tabObj:Toggle(c)
            local frame, _ = makeElement(container, win.Theme, c)
            local value = c.Value or false

            local isCheckbox = (c.Type == "Checkbox")

            local toggleW = isCheckbox and 26 or 46
            local toggleH = 26

            local toggleBase = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, toggleW, 0, toggleH),
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -12, 0.5, 0),
                ImageTransparency = 0.82,
                ThemeTag         = { ImageColor3 = "Text" },
                Parent           = frame,
            })

            local toggleFill = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(1, 0, 1, 0),
                ImageTransparency = value and 0 or 1,
                ThemeTag         = { ImageColor3 = "Toggle" },
                Parent           = toggleBase,
            })

            local toggleKnob
            if not isCheckbox then
                toggleKnob = Creator.NewRoundFrame("Squircle", {
                    Size      = UDim2.new(0, 20, 0, 20),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position  = UDim2.new(0, value and (toggleW - 24) or 3, 0.5, 0),
                    ThemeTag  = { ImageColor3 = "SliderThumb" },
                    Parent    = toggleBase,
                })
            else
                local checkIcon = Creator.New("TextLabel", {
                    Size           = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text           = "✓",
                    TextSize       = 15,
                    FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
                    TextTransparency = value and 0 or 1,
                    ThemeTag       = { TextColor3 = "CheckboxIcon" },
                    Parent         = toggleBase,
                })
                toggleKnob = checkIcon
            end

            local function setToggle(v, doCallback)
                value = v
                if isCheckbox then
                    Creator.Tween(toggleFill,  ANIM, { ImageTransparency = v and 0 or 1 }):Play()
                    Creator.Tween(toggleKnob,  ANIM, { TextTransparency  = v and 0 or 1 }):Play()
                else
                    Creator.Tween(toggleFill,  ANIM, { ImageTransparency = v and 0 or 1 }):Play()
                    Creator.Tween(toggleKnob,  ANIM, {
                        Position = UDim2.new(0, v and (toggleW - 24) or 3, 0.5, 0),
                    }):Play()
                end
                if doCallback and c.Callback then
                    task.spawn(function() pcall(c.Callback, v) end)
                end
            end

            if not c.Disabled then
                Creator.AddSignal(toggleBase.MouseButton1Click, function()
                    setToggle(not value, true)
                end)
                Creator.AddSignal(frame.InputBegan, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        setToggle(not value, true)
                    end
                end)
            end

            local el = {}
            function el:Set(v)
                setToggle(v, false)
            end
            function el:Get()
                return value
            end
            return el
        end

        function tabObj:Slider(c)
            local frame, _ = makeElement(container, win.Theme, c)
            frame.Size = UDim2.new(1, 0, 0, c.Desc and (ELEMENT_H + 16) or ELEMENT_H)
            frame.AutomaticSize = Enum.AutomaticSize.None

            local minV   = c.Min   or 0
            local maxV   = c.Max   or 100
            local step   = c.Step  or 1
            local suffix = c.Suffix or ""
            local value  = math.clamp(c.Value or minV, minV, maxV)
            local isFloat = step % 1 ~= 0

            local function fmtVal(v)
                if isFloat then
                    return string.format("%.2f", v) .. suffix
                end
                return tostring(math.floor(v + 0.5)) .. suffix
            end

            local function snap(v)
                if isFloat then
                    return math.floor(v / step + 0.5) * step
                end
                return math.floor(v / step + 0.5) * step
            end

            local delta = (value - minV) / (maxV - minV)

            local SLIDER_W = 130

            local trackBg = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, SLIDER_W, 0, 4),
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -12, 0.5, 0),
                ImageTransparency = 0.88,
                ThemeTag         = { ImageColor3 = "Text" },
                Parent           = frame,
            })

            local trackFill = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(delta, 0, 1, 0),
                ImageTransparency = 0.1,
                ThemeTag         = { ImageColor3 = "Slider" },
                Parent           = trackBg,
            })

            local thumb = Creator.NewRoundFrame("Squircle", {
                Size      = UDim2.new(0, 14, 0, 14),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position  = UDim2.new(delta, 0, 0.5, 0),
                ThemeTag  = { ImageColor3 = "SliderThumb" },
                Parent    = trackBg,
            })

            local valLbl
            if c.Input then
                valLbl = Creator.New("TextBox", {
                    Size           = UDim2.new(0, 38, 0, 22),
                    AnchorPoint    = Vector2.new(1, 0.5),
                    Position       = UDim2.new(0, -8, 0.5, 0),
                    BackgroundTransparency = 0.85,
                    Text           = fmtVal(value),
                    TextSize       = 13,
                    FontFace       = Font.new(Creator.Font, Enum.FontWeight.Medium),
                    ClearTextOnFocus = false,
                    ThemeTag       = { TextColor3 = "Text", BackgroundColor3 = "ElementBackground" },
                    Parent         = trackBg,
                }, {
                    mkCorner(UDim.new(0, 4)),
                })
            else
                valLbl = Creator.New("TextLabel", {
                    Size           = UDim2.new(0, 42, 0, 22),
                    AnchorPoint    = Vector2.new(1, 0.5),
                    Position       = UDim2.new(0, -8, 0.5, 0),
                    BackgroundTransparency = 1,
                    Text           = fmtVal(value),
                    TextSize       = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    FontFace       = Font.new(Creator.Font, Enum.FontWeight.Medium),
                    ThemeTag       = { TextColor3 = "Text" },
                    Parent         = trackBg,
                })
            end

            local function setSlider(v, doCallback)
                v     = snap(math.clamp(v, minV, maxV))
                value = v
                local d = (v - minV) / (maxV - minV)
                Creator.Tween(trackFill, ANIM_FAST, { Size = UDim2.new(d, 0, 1, 0) }):Play()
                Creator.Tween(thumb,     ANIM_FAST, { Position = UDim2.new(d, 0, 0.5, 0) }):Play()
                valLbl.Text = fmtVal(v)
                if doCallback and c.Callback then
                    task.spawn(function() pcall(c.Callback, v) end)
                end
            end

            if not c.Disabled then
                local holding = false
                Creator.AddSignal(trackBg.InputBegan, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        holding = true
                        task.spawn(function()
                            while holding do
                                local absX = trackBg.AbsolutePosition.X
                                local absW = trackBg.AbsoluteSize.X
                                local mx   = math.clamp(Mouse.X, absX, absX + absW)
                                local d    = (mx - absX) / absW
                                setSlider(minV + d * (maxV - minV), true)
                                RunService.Heartbeat:Wait()
                            end
                        end)
                    end
                end)
                Creator.AddSignal(UserInputService.InputEnded, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        holding = false
                    end
                end)

                if c.Input then
                    Creator.AddSignal(valLbl.FocusLost, function(enter)
                        if enter then
                            local n = tonumber(valLbl.Text:match("%-?%d+%.?%d*"))
                            if n then setSlider(n, true) end
                        end
                    end)
                end
            end

            local el = {}
            function el:Set(v)
                setSlider(v, false)
            end
            function el:Get()
                return value
            end
            return el
        end

        function tabObj:Input(c)
            local frame, _ = makeElement(container, win.Theme, c)
            local isML = c.MultiLine

            if isML then
                frame.Size = UDim2.new(1, 0, 0, ELEMENT_H + 70)
                frame.AutomaticSize = Enum.AutomaticSize.None
            end

            local inputWrap = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, 140, 0, 30),
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -12, 0.5, 0),
                ImageTransparency = 0.88,
                ThemeTag         = { ImageColor3 = "Text" },
                Parent           = frame,
            }, {
                mkStroke(1, Color3.new(1,1,1), 0.88),
            })

            if isML then
                inputWrap.Size      = UDim2.new(1, -24, 0, 70)
                inputWrap.AnchorPoint = Vector2.new(0.5, 1)
                inputWrap.Position  = UDim2.new(0.5, 0, 1, -10)
            end

            local textBox = Creator.New("TextBox", {
                Size              = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text              = c.Default or "",
                PlaceholderText   = c.Placeholder or "...",
                TextSize          = 13,
                FontFace          = Font.new(Creator.Font, Enum.FontWeight.Regular),
                ClearTextOnFocus  = false,
                TextXAlignment    = Enum.TextXAlignment.Left,
                TextYAlignment    = isML and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
                MultiLine         = isML or false,
                TextWrapped       = isML or false,
                ThemeTag          = { TextColor3 = "Text", PlaceholderColor3 = "Placeholder" },
                TextEditable      = not c.Disabled,
                Interactable      = not c.Disabled,
                Parent            = inputWrap,
            }, {
                mkPad(4, 4, 8, 8),
            })

            if c.Disabled then
                inputWrap.ImageTransparency = 0.94
            end

            Creator.AddSignal(textBox.FocusLost, function(enter)
                if enter or true then
                    if c.Callback then
                        task.spawn(function() pcall(c.Callback, textBox.Text) end)
                    end
                end
            end)

            local el = {}
            function el:Set(v)
                textBox.Text = v or ""
            end
            function el:Get()
                return textBox.Text
            end
            return el
        end

        function tabObj:NumberInput(c)
            local frame, _ = makeElement(container, win.Theme, c)
            local minV  = c.Min  or 0
            local maxV  = c.Max  or 100
            local step  = c.Step or 1
            local value = math.clamp(c.Value or minV, minV, maxV)

            local wrap = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, 120, 0, 30),
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -12, 0.5, 0),
                ImageTransparency = 0.88,
                ThemeTag         = { ImageColor3 = "Text" },
                Parent           = frame,
            })

            local function mkBtn(text, side)
                local b = Creator.NewRoundFrame("Squircle", {
                    Size             = UDim2.new(0, 30, 1, 0),
                    AnchorPoint      = side == "L" and Vector2.new(0,0.5) or Vector2.new(1,0.5),
                    Position         = side == "L" and UDim2.new(0,0,0.5,0) or UDim2.new(1,0,0.5,0),
                    ImageTransparency = 0.78,
                    ThemeTag         = { ImageColor3 = "Button" },
                    Parent           = wrap,
                }, nil, true)
                Creator.New("TextLabel", {
                    Size  = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    Text  = text,
                    TextSize = 16,
                    FontFace = Font.new(Creator.Font, Enum.FontWeight.Bold),
                    ThemeTag = { TextColor3 = "Text" },
                    Parent = b,
                })
                return b
            end

            local minusBtn = mkBtn("−", "L")
            local plusBtn  = mkBtn("+", "R")

            local numBox = Creator.New("TextBox", {
                Size              = UDim2.new(1, -60, 1, 0),
                AnchorPoint       = Vector2.new(0.5, 0.5),
                Position          = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                Text              = tostring(value),
                TextSize          = 14,
                FontFace          = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                ClearTextOnFocus  = false,
                TextEditable      = not c.Disabled,
                Interactable      = not c.Disabled,
                ThemeTag          = { TextColor3 = "Text" },
                Parent            = wrap,
            })

            local function setNum(v, doCallback)
                v     = math.clamp(v, minV, maxV)
                value = v
                numBox.Text = tostring(v)
                if doCallback and c.Callback then
                    task.spawn(function() pcall(c.Callback, v) end)
                end
            end

            if not c.Disabled then
                Creator.AddSignal(minusBtn.MouseButton1Click, function()
                    setNum(value - step, true)
                end)
                Creator.AddSignal(plusBtn.MouseButton1Click, function()
                    setNum(value + step, true)
                end)
                Creator.AddSignal(numBox.FocusLost, function(enter)
                    if enter then
                        local n = tonumber(numBox.Text)
                        if n then setNum(n, true) else numBox.Text = tostring(value) end
                    end
                end)
            end

            local el = {}
            function el:Set(v)
                setNum(v, false)
            end
            function el:Get()
                return value
            end
            return el
        end

        function tabObj:ProgressBar(c)
            local frame, _ = makeElement(container, win.Theme, c)
            local value    = math.clamp(c.Value or 0, 0, 1)
            local barColor = c.BarColor or Creator.GetThemeValue("Primary") or Color3.fromHex("#daa732")

            local trackBg = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, 180, 0, 6),
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -12, 0.5, 0),
                ImageTransparency = 0.88,
                ThemeTag         = { ImageColor3 = "Text" },
                Parent           = frame,
            })

            local fill = Creator.NewRoundFrame("Squircle", {
                Size         = UDim2.new(value, 0, 1, 0),
                ImageColor3  = barColor,
                ImageTransparency = 0,
                Parent       = trackBg,
            })

            local pctLbl
            if c.ShowPercent then
                pctLbl = Creator.New("TextLabel", {
                    Size           = UDim2.new(0, 38, 0, 20),
                    AnchorPoint    = Vector2.new(1, 0.5),
                    Position       = UDim2.new(0, -8, 0.5, 0),
                    BackgroundTransparency = 1,
                    Text           = math.floor(value * 100) .. "%",
                    TextSize       = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    FontFace       = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                    ThemeTag       = { TextColor3 = "Text" },
                    Parent         = trackBg,
                })
                trackBg.Size = UDim2.new(0, 180, 0, 6)
                trackBg.Position = UDim2.new(1, -56, 0.5, 0)
            end

            local el = {}
            function el:Set(v)
                v = math.clamp(v, 0, 1)
                value = v
                Creator.Tween(fill, ANIM, { Size = UDim2.new(v, 0, 1, 0) }):Play()
                if pctLbl then
                    pctLbl.Text = math.floor(v * 100) .. "%"
                end
            end
            function el:Get()
                return value
            end
            return el
        end

        function tabObj:Dropdown(c)
            local frame, _ = makeElement(container, win.Theme, c)
            frame.ClipsDescendants = false

            local isMulti  = c.Multi  or false
            local values   = c.Values or {}
            local selected = {}

            if isMulti then
                selected = {}
            else
                if c.Value then
                    selected[c.Value] = true
                end
            end

            local function getDisplayText()
                if isMulti then
                    local keys = {}
                    for k in pairs(selected) do table.insert(keys, k) end
                    if #keys == 0 then return "None" end
                    if #keys == 1 then return keys[1] end
                    return keys[1] .. " +" .. (#keys - 1)
                else
                    for k in pairs(selected) do return k end
                    return "Select..."
                end
            end

            local ddBtn = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, 140, 0, 30),
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -12, 0.5, 0),
                ImageTransparency = 0.88,
                ThemeTag         = { ImageColor3 = "Text" },
                Parent           = frame,
            }, nil, true)

            local ddText = Creator.New("TextLabel", {
                Size           = UDim2.new(1, -28, 1, 0),
                BackgroundTransparency = 1,
                Text           = getDisplayText(),
                TextSize       = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.Medium),
                TextTruncate   = Enum.TextTruncate.AtEnd,
                ThemeTag       = { TextColor3 = "Text" },
                Parent         = ddBtn,
            }, {
                mkPad(0, 0, 10, 0),
            })

            Creator.New("TextLabel", {
                Size           = UDim2.new(0, 20, 1, 0),
                AnchorPoint    = Vector2.new(1, 0.5),
                Position       = UDim2.new(1, -4, 0.5, 0),
                BackgroundTransparency = 1,
                Text           = "⌄",
                TextSize       = 14,
                ThemeTag       = { TextColor3 = "Icon" },
                Parent         = ddBtn,
            })

            local popupFrame
            local open = false

            local function closePopup()
                if popupFrame then
                    Creator.Tween(popupFrame, ANIM, { Size = UDim2.new(0, popupFrame.Size.X.Offset, 0, 0) }):Play()
                    task.wait(ANIM)
                    pcall(function() popupFrame:Destroy() end)
                    popupFrame = nil
                end
                open = false
            end

            local function openPopup()
                if open then closePopup() return end
                open = true

                local absPos  = ddBtn.AbsolutePosition
                local absSize = ddBtn.AbsoluteSize
                local sgAbsPos = screenGui.AbsolutePosition

                popupFrame = Creator.NewRoundFrame("Squircle", {
                    Size             = UDim2.new(0, absSize.X, 0, 0),
                    Position         = UDim2.new(0, absPos.X - sgAbsPos.X, 0, absPos.Y - sgAbsPos.Y + absSize.Y + 4),
                    ImageTransparency = 0,
                    ThemeTag         = { ImageColor3 = "Dialog" },
                    ZIndex           = POPUP_Z,
                    ClipsDescendants = true,
                    Parent           = popupContainer,
                })

                Creator.NewRoundFrame("Glass-1", {
                    Size     = UDim2.new(1, 0, 1, 0),
                    ThemeTag = { ImageColor3 = "Outline", ImageTransparency = "CheckboxBorderTransparency" },
                    ZIndex   = POPUP_Z + 1,
                    Parent   = popupFrame,
                })

                local list = Creator.New("Frame", {
                    Size             = UDim2.new(1, 0, 0, 0),
                    AutomaticSize    = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    ZIndex           = POPUP_Z + 2,
                    Parent           = popupFrame,
                }, {
                    Creator.New("UIListLayout", {
                        Padding   = UDim.new(0, 2),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                    }),
                    mkPad(6, 6, 6, 6),
                })

                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if not popupFrame or not popupFrame.Parent then
                        conn:Disconnect()
                        return
                    end
                    local newAbsPos  = ddBtn.AbsolutePosition
                    local newSgPos   = screenGui.AbsolutePosition
                    popupFrame.Position = UDim2.new(0, newAbsPos.X - newSgPos.X, 0, newAbsPos.Y - newSgPos.Y + ddBtn.AbsoluteSize.Y + 4)
                end)

                for _, v in ipairs(values) do
                    local isSelected = selected[v] or false
                    local item = Creator.NewRoundFrame("Squircle", {
                        Size             = UDim2.new(1, 0, 0, 30),
                        ImageTransparency = isSelected and 0.8 or 1,
                        ThemeTag         = { ImageColor3 = "Primary" },
                        ZIndex           = POPUP_Z + 3,
                        Parent           = list,
                    }, nil, true)

                    Creator.New("TextLabel", {
                        Size           = UDim2.new(1, -8, 1, 0),
                        BackgroundTransparency = 1,
                        Text           = v,
                        TextSize       = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        FontFace       = Font.new(Creator.Font, Enum.FontWeight.Medium),
                        ZIndex         = POPUP_Z + 4,
                        ThemeTag       = { TextColor3 = "Text" },
                        Parent         = item,
                    }, {
                        mkPad(0, 0, 10, 0),
                    })

                    if isSelected then
                        Creator.New("TextLabel", {
                            Size           = UDim2.new(0, 20, 1, 0),
                            AnchorPoint    = Vector2.new(1, 0.5),
                            Position       = UDim2.new(1, -4, 0.5, 0),
                            BackgroundTransparency = 1,
                            Text           = "✓",
                            TextSize       = 12,
                            ZIndex         = POPUP_Z + 4,
                            ThemeTag       = { TextColor3 = "Primary" },
                            Parent         = item,
                        })
                    end

                    Creator.AddSignal(item.MouseButton1Click, function()
                        if isMulti then
                            selected[v] = not selected[v] or nil
                        else
                            selected = { [v] = true }
                        end
                        ddText.Text = getDisplayText()
                        if c.Callback then
                            task.spawn(function()
                                if isMulti then
                                    pcall(c.Callback, selected)
                                else
                                    pcall(c.Callback, v)
                                end
                            end)
                        end
                        closePopup()
                    end)

                    Creator.AddSignal(item.MouseEnter, function()
                        Creator.Tween(item, ANIM_FAST, { ImageTransparency = 0.85 }):Play()
                    end)
                    Creator.AddSignal(item.MouseLeave, function()
                        Creator.Tween(item, ANIM_FAST, { ImageTransparency = selected[v] and 0.8 or 1 }):Play()
                    end)
                end

                task.wait()
                local targetH = math.min(list.AbsoluteSize.Y, 200)
                Creator.Tween(popupFrame, ANIM, { Size = UDim2.new(0, absSize.X, 0, targetH) }):Play()
            end

            Creator.AddSignal(ddBtn.MouseButton1Click, function()
                openPopup()
            end)

            local el = {}
            function el:Set(v)
                selected = { [v] = true }
                ddText.Text = getDisplayText()
            end
            function el:Get()
                return selected
            end
            return el
        end

        function tabObj:Keybind(c)
            local frame, _ = makeElement(container, win.Theme, c)
            local key     = c.Key     or Enum.KeyCode.F
            local picking = false

            local function keyName(k)
                if typeof(k) == "EnumItem" then return k.Name end
                return tostring(k)
            end

            local kBtn = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, 80, 0, 28),
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -12, 0.5, 0),
                ImageTransparency = 0.82,
                ThemeTag         = { ImageColor3 = "Text" },
                Parent           = frame,
            }, nil, true)

            local kLbl = Creator.New("TextLabel", {
                Size           = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text           = keyName(key),
                TextSize       = 13,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                ThemeTag       = { TextColor3 = "Text" },
                Parent         = kBtn,
            })

            if not c.Disabled then
                Creator.AddSignal(kBtn.MouseButton1Click, function()
                    picking = true
                    kLbl.Text = "..."
                    Creator.Tween(kBtn, ANIM, { ImageTransparency = 0.6 }):Play()
                end)

                Creator.AddSignal(UserInputService.InputBegan, function(inp, gp)
                    if not gp and picking then
                        if inp.UserInputType == Enum.UserInputType.Keyboard then
                            if inp.KeyCode ~= Enum.KeyCode.Escape then
                                key = inp.KeyCode
                                kLbl.Text = keyName(key)
                                if c.Callback then
                                    task.spawn(function() pcall(c.Callback, key) end)
                                end
                            else
                                kLbl.Text = keyName(key)
                            end
                            picking = false
                            Creator.Tween(kBtn, ANIM, { ImageTransparency = 0.82 }):Play()
                        end
                    elseif not gp and not picking then
                        if inp.KeyCode == key and c.OnPress then
                            task.spawn(function() pcall(c.OnPress) end)
                        end
                    end
                end)
            end

            local el = {}
            function el:Set(k)
                key   = k
                kLbl.Text = keyName(k)
            end
            function el:Get()
                return key
            end
            return el
        end

        function tabObj:KeybindButton(c)
            local frame, _ = makeElement(container, win.Theme, c)
            local key      = c.Key or Enum.KeyCode.F

            local function keyName(k)
                if typeof(k) == "EnumItem" then return k.Name end
                return tostring(k)
            end

            local btnWrap = Creator.New("Frame", {
                Size             = UDim2.new(0, 130, 0, 30),
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -12, 0.5, 0),
                BackgroundTransparency = 1,
                Parent           = frame,
            }, {
                Creator.New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding       = UDim.new(0, 6),
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                }),
            })

            local kLbl = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, 60, 0, 28),
                ImageTransparency = 0.88,
                ThemeTag         = { ImageColor3 = "Text" },
                Parent           = btnWrap,
            })

            Creator.New("TextLabel", {
                Size           = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Text           = keyName(key),
                TextSize       = 12,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                ThemeTag       = { TextColor3 = "Text" },
                TextTransparency = 0.3,
                Parent         = kLbl,
            })

            local runBtn = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, 62, 0, 28),
                ImageTransparency = 0.78,
                ThemeTag         = { ImageColor3 = "Primary" },
                Parent           = btnWrap,
            }, nil, true)

            Creator.New("TextLabel", {
                Size  = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Text  = c.ButtonText or "Run",
                TextSize = 13,
                FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                ThemeTag = { TextColor3 = "Text" },
                Parent = runBtn,
            })

            local function doRun()
                if c.Callback then task.spawn(function() pcall(c.Callback) end) end
            end

            Creator.AddSignal(runBtn.MouseButton1Click, doRun)
            Creator.AddSignal(UserInputService.InputBegan, function(inp, gp)
                if not gp and inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == key then
                    doRun()
                end
            end)

            local el = {}
            function el:Set(k)
                key = k
            end
            return el
        end

        function tabObj:ColorPicker(c)
            local frame, _ = makeElement(container, win.Theme, c)
            local color    = c.Value or Color3.fromRGB(255, 255, 255)
            local hue, sat, vib = Color3.toHSV(color)

            local preview = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, 28, 0, 28),
                AnchorPoint      = Vector2.new(1, 0.5),
                Position         = UDim2.new(1, -12, 0.5, 0),
                ImageColor3      = color,
                Parent           = frame,
            }, nil, true)

            local popupFrame
            local open = false

            local function closeCP()
                if popupFrame then
                    Creator.Tween(popupFrame, ANIM, { ImageTransparency = 1 }):Play()
                    task.wait(ANIM)
                    pcall(function() popupFrame:Destroy() end)
                    popupFrame = nil
                end
                open = false
            end

            local function mkHex()
                return string.format("#%02X%02X%02X",
                    math.floor(Color3.fromHSV(hue, sat, vib).R * 255),
                    math.floor(Color3.fromHSV(hue, sat, vib).G * 255),
                    math.floor(Color3.fromHSV(hue, sat, vib).B * 255))
            end

            local function openCP()
                if open then closeCP() return end
                open = true

                local absPos  = preview.AbsolutePosition
                local sgAbsPos = screenGui.AbsolutePosition

                popupFrame = Creator.NewRoundFrame("Squircle", {
                    Size             = UDim2.new(0, 240, 0, 260),
                    Position         = UDim2.new(0, absPos.X - sgAbsPos.X - 212, 0, absPos.Y - sgAbsPos.Y - 268),
                    ImageTransparency = 0.04,
                    ThemeTag         = { ImageColor3 = "Dialog" },
                    ZIndex           = POPUP_Z,
                    ClipsDescendants = false,
                    Parent           = popupContainer,
                })

                Creator.NewRoundFrame("Glass-1", {
                    Size     = UDim2.new(1, 0, 1, 0),
                    ThemeTag = { ImageColor3 = "Outline", ImageTransparency = "CheckboxBorderTransparency" },
                    ZIndex   = POPUP_Z + 1,
                    Parent   = popupFrame,
                })

                local conn
                conn = RunService.Heartbeat:Connect(function()
                    if not popupFrame or not popupFrame.Parent then
                        conn:Disconnect()
                        return
                    end
                    local newAbs = preview.AbsolutePosition
                    local newSg  = screenGui.AbsolutePosition
                    popupFrame.Position = UDim2.new(0, newAbs.X - newSg.X - 212, 0, newAbs.Y - newSg.Y - 268)
                end)

                local sv = Creator.New("Frame", {
                    Size             = UDim2.new(0, 180, 0, 160),
                    Position         = UDim2.new(0, 10, 0, 10),
                    BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
                    ZIndex           = POPUP_Z + 2,
                    Parent           = popupFrame,
                }, {
                    mkCorner(UDim.new(0, 6)),
                    Creator.New("Frame", {
                        Size             = UDim2.new(1, 0, 1, 0),
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        ZIndex           = POPUP_Z + 2,
                    }, {
                        mkCorner(UDim.new(0, 6)),
                        Creator.New("UIGradient", {
                            Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)),
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0),
                                NumberSequenceKeypoint.new(1, 1),
                            }),
                        }),
                    }),
                    Creator.New("Frame", {
                        Size             = UDim2.new(1, 0, 1, 0),
                        BackgroundColor3 = Color3.new(0, 0, 0),
                        ZIndex           = POPUP_Z + 2,
                    }, {
                        mkCorner(UDim.new(0, 6)),
                        Creator.New("UIGradient", {
                            Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0)),
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 1),
                                NumberSequenceKeypoint.new(1, 0),
                            }),
                            Rotation = 90,
                        }),
                    }),
                })

                local svCursor = Creator.New("Frame", {
                    Size             = UDim2.new(0, 10, 0, 10),
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    Position         = UDim2.new(sat, 0, 1 - vib, 0),
                    BackgroundColor3 = Color3.fromHSV(hue, sat, vib),
                    ZIndex           = POPUP_Z + 3,
                    Parent           = sv,
                }, {
                    mkCorner(UDim.new(1, 0)),
                    mkStroke(2, Color3.new(1,1,1), 0),
                })

                local hueSlider = Creator.New("Frame", {
                    Size             = UDim2.new(0, 18, 0, 160),
                    Position         = UDim2.new(0, 198, 0, 10),
                    BackgroundColor3 = Color3.new(1,1,1),
                    ZIndex           = POPUP_Z + 2,
                    Parent           = popupFrame,
                }, {
                    mkCorner(UDim.new(0, 4)),
                    Creator.New("UIGradient", {
                        Rotation = 270,
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,   1, 1)),
                            ColorSequenceKeypoint.new(1/6,  Color3.fromHSV(1/6, 1, 1)),
                            ColorSequenceKeypoint.new(2/6,  Color3.fromHSV(2/6, 1, 1)),
                            ColorSequenceKeypoint.new(3/6,  Color3.fromHSV(3/6, 1, 1)),
                            ColorSequenceKeypoint.new(4/6,  Color3.fromHSV(4/6, 1, 1)),
                            ColorSequenceKeypoint.new(5/6,  Color3.fromHSV(5/6, 1, 1)),
                            ColorSequenceKeypoint.new(1,    Color3.fromHSV(0,   1, 1)),
                        }),
                    }),
                })

                local hueCursor = Creator.New("Frame", {
                    Size             = UDim2.new(1, 4, 0, 6),
                    AnchorPoint      = Vector2.new(0.5, 0.5),
                    Position         = UDim2.new(0.5, 0, hue, 0),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    ZIndex           = POPUP_Z + 3,
                    Parent           = hueSlider,
                }, {
                    mkCorner(UDim.new(0, 3)),
                    mkStroke(1, Color3.new(0,0,0), 0.6),
                })

                local hexBox = Creator.New("TextBox", {
                    Size             = UDim2.new(0, 120, 0, 26),
                    Position         = UDim2.new(0, 10, 0, 180),
                    BackgroundTransparency = 0.9,
                    Text             = mkHex(),
                    TextSize         = 13,
                    FontFace         = Font.new(Creator.Font, Enum.FontWeight.Medium),
                    ClearTextOnFocus = false,
                    ZIndex           = POPUP_Z + 2,
                    ThemeTag         = { TextColor3 = "Text", BackgroundColor3 = "ElementBackground" },
                    Parent           = popupFrame,
                }, {
                    mkCorner(UDim.new(0, 4)),
                })

                local applyBtn = Creator.NewRoundFrame("Squircle", {
                    Size             = UDim2.new(0, 80, 0, 26),
                    Position         = UDim2.new(0, 138, 0, 180),
                    ImageTransparency = 0.7,
                    ThemeTag         = { ImageColor3 = "Primary" },
                    ZIndex           = POPUP_Z + 2,
                    Parent           = popupFrame,
                }, nil, true)

                Creator.New("TextLabel", {
                    Size           = UDim2.new(1,0,1,0),
                    BackgroundTransparency = 1,
                    Text           = "Apply",
                    TextSize       = 13,
                    FontFace       = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                    ThemeTag       = { TextColor3 = "Text" },
                    ZIndex         = POPUP_Z + 3,
                    Parent         = applyBtn,
                })

                local function updateVisuals()
                    sv.BackgroundColor3   = Color3.fromHSV(hue, 1, 1)
                    svCursor.Position     = UDim2.new(sat, 0, 1 - vib, 0)
                    svCursor.BackgroundColor3 = Color3.fromHSV(hue, sat, vib)
                    hueCursor.Position    = UDim2.new(0.5, 0, hue, 0)
                    hexBox.Text           = mkHex()
                    preview.ImageColor3   = Color3.fromHSV(hue, sat, vib)
                end

                Creator.AddSignal(sv.InputBegan, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        task.spawn(function()
                            while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                local absX = sv.AbsolutePosition.X
                                local absY = sv.AbsolutePosition.Y
                                local absW = sv.AbsoluteSize.X
                                local absH = sv.AbsoluteSize.Y
                                sat = math.clamp((Mouse.X - absX) / absW, 0, 1)
                                vib = math.clamp(1 - (Mouse.Y - absY) / absH, 0, 1)
                                updateVisuals()
                                RunService.Heartbeat:Wait()
                            end
                        end)
                    end
                end)

                Creator.AddSignal(hueSlider.InputBegan, function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        task.spawn(function()
                            while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                local absY = hueSlider.AbsolutePosition.Y
                                local absH = hueSlider.AbsoluteSize.Y
                                hue = math.clamp((Mouse.Y - absY) / absH, 0, 1)
                                updateVisuals()
                                RunService.Heartbeat:Wait()
                            end
                        end)
                    end
                end)

                Creator.AddSignal(hexBox.FocusLost, function(enter)
                    if enter then
                        local hex = hexBox.Text:gsub("#", "")
                        local ok, col = pcall(Color3.fromHex, hex)
                        if ok and typeof(col) == "Color3" then
                            hue, sat, vib = Color3.toHSV(col)
                            updateVisuals()
                        end
                    end
                end)

                Creator.AddSignal(applyBtn.MouseButton1Click, function()
                    color = Color3.fromHSV(hue, sat, vib)
                    preview.ImageColor3 = color
                    if c.Callback then
                        task.spawn(function() pcall(c.Callback, color) end)
                    end
                    closeCP()
                end)
            end

            Creator.AddSignal(preview.MouseButton1Click, function()
                openCP()
            end)

            local el = {}
            function el:Set(col)
                color = col
                hue, sat, vib = Color3.toHSV(col)
                preview.ImageColor3 = col
            end
            function el:Get()
                return color
            end
            return el
        end

        function tabObj:Section(c)
            local lbl = Creator.New("TextLabel", {
                Size           = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text           = (c.Title or "Section"):upper(),
                TextSize       = 11,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
                TextTransparency = 0.4,
                ThemeTag       = { TextColor3 = "Text" },
                Parent         = container,
            }, {
                mkPad(0, 0, 4, 0),
            })
            return lbl
        end

        function tabObj:Divider(c)
            local wrap = Creator.New("Frame", {
                Size             = UDim2.new(1, 0, 0, 16),
                BackgroundTransparency = 1,
                Parent           = container,
            })

            local line = Creator.New("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundColor3 = c and c.Color or Color3.new(1,1,1),
                BackgroundTransparency = 0.88,
                Parent           = wrap,
            })

            if c and c.Label and c.Label ~= "" then
                line.Size = UDim2.new(1, -80, 0, 1)
                Creator.New("TextLabel", {
                    Size           = UDim2.new(0, 72, 1, 0),
                    AnchorPoint    = Vector2.new(1, 0.5),
                    Position       = UDim2.new(0, 0, 0.5, 0),
                    BackgroundTransparency = 1,
                    Text           = c.Label,
                    TextSize       = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTransparency = 0.5,
                    ThemeTag       = { TextColor3 = "Text" },
                    Parent         = wrap,
                })
            end

            return wrap
        end

        function tabObj:Space(c)
            return Creator.New("Frame", {
                Size             = UDim2.new(1, 0, 0, c and c.Height or 8),
                BackgroundTransparency = 1,
                Parent           = container,
            })
        end

        function tabObj:Label(c)
            return Creator.New("TextLabel", {
                Size           = UDim2.new(1, 0, 0, 0),
                AutomaticSize  = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text           = "• " .. (c.Title or ""),
                TextSize       = 13,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.Regular),
                TextColor3     = c.Color or Creator.GetThemeValue("Text") or Color3.new(1,1,1),
                TextWrapped    = true,
                Parent         = container,
            }, {
                mkPad(0, 0, 8, 0),
            })
        end

        function tabObj:Paragraph(c)
            local wrap = Creator.New("Frame", {
                Size          = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent        = container,
            }, {
                Creator.New("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),
            })

            Creator.New("TextLabel", {
                Size           = UDim2.new(1, 0, 0, 0),
                AutomaticSize  = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text           = c.Title or "",
                TextSize       = 14,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
                ThemeTag       = { TextColor3 = "Text" },
                TextWrapped    = true,
                Parent         = wrap,
            })

            Creator.New("TextLabel", {
                Size           = UDim2.new(1, 0, 0, 0),
                AutomaticSize  = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text           = c.Desc or "",
                TextSize       = 13,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.Regular),
                TextTransparency = 0.3,
                ThemeTag       = { TextColor3 = "Text" },
                TextWrapped    = true,
                Parent         = wrap,
            })

            return wrap
        end

        function tabObj:Badge(badges)
            local wrap = Creator.New("Frame", {
                Size          = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1,
                Parent        = container,
            }, {
                Creator.New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding       = UDim.new(0, 6),
                    SortOrder     = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),
            })

            for _, b in ipairs(badges) do
                local bg = Creator.NewRoundFrame("Squircle", {
                    Size             = UDim2.new(0, 0, 0, 22),
                    AutomaticSize    = Enum.AutomaticSize.X,
                    ImageColor3      = b.Color or Creator.GetThemeValue("Primary"),
                    ImageTransparency = 0.75,
                    Parent           = wrap,
                }, {
                    Creator.New("TextLabel", {
                        Size           = UDim2.new(0, 0, 1, 0),
                        AutomaticSize  = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Text           = b.Text or "",
                        TextSize       = 10,
                        FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
                        TextColor3     = b.Color or Creator.GetThemeValue("Primary") or Color3.new(1,1,1),
                        Parent         = nil,
                    }, {
                        mkPad(0, 0, 8, 8),
                    }),
                })

                local inner = bg:FindFirstChildOfClass("TextLabel")
                if not inner then
                    inner = Creator.New("TextLabel", {
                        Size          = UDim2.new(0, 0, 1, 0),
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Text          = b.Text or "",
                        TextSize      = 10,
                        FontFace      = Font.new(Creator.Font, Enum.FontWeight.Bold),
                        TextColor3    = b.Color or Creator.GetThemeValue("Primary") or Color3.new(1,1,1),
                        Parent        = bg,
                    }, {
                        mkPad(0, 0, 8, 8),
                    })
                end
            end

            return wrap
        end

        function tabObj:ProfileFrame(c)
            local frame = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(1, 0, 0, 80),
                ImageTransparency = 0,
                BackgroundColor3 = c.Color,
                ThemeTag         = c.Color and nil or { ImageColor3 = "ElementBackground" },
                ImageColor3      = c.Color or Creator.GetThemeValue("ElementBackground"),
                Parent           = container,
            })

            local avatar = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(0, 52, 0, 52),
                AnchorPoint      = Vector2.new(0, 0.5),
                Position         = UDim2.new(0, 14, 0.5, 0),
                ImageTransparency = 0.8,
                ThemeTag         = { ImageColor3 = "Text" },
                Parent           = frame,
            })

            local avatarImg = Creator.New("ImageLabel", {
                Size             = UDim2.new(1, -4, 1, -4),
                AnchorPoint      = Vector2.new(0.5, 0.5),
                Position         = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 1,
                Image            = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. (c.UserId or 0) .. "&width=150&height=150&format=png",
                Parent           = avatar,
            }, {
                mkCorner(UDim.new(1, 0)),
            })

            local infoFrame = Creator.New("Frame", {
                Size             = UDim2.new(1, -80, 1, 0),
                Position         = UDim2.new(0, 74, 0, 0),
                BackgroundTransparency = 1,
                Parent           = frame,
            }, {
                Creator.New("UIListLayout", {
                    Padding         = UDim.new(0, 3),
                    SortOrder       = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),
            })

            Creator.New("TextLabel", {
                Size           = UDim2.new(1, 0, 0, 0),
                AutomaticSize  = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text           = c.Username or "Player",
                TextSize       = 15,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
                ThemeTag       = { TextColor3 = "Text" },
                Parent         = infoFrame,
            })

            if c.Desc then
                Creator.New("TextLabel", {
                    Size           = UDim2.new(1, 0, 0, 0),
                    AutomaticSize  = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text           = c.Desc,
                    TextSize       = 12,
                    FontFace       = Font.new(Creator.Font, Enum.FontWeight.Regular),
                    TextTransparency = 0.4,
                    ThemeTag       = { TextColor3 = "Text" },
                    Parent         = infoFrame,
                })
            end

            if c.Badges and #c.Badges > 0 then
                local badgeRow = Creator.New("Frame", {
                    Size          = UDim2.new(1, 0, 0, 18),
                    BackgroundTransparency = 1,
                    Parent        = infoFrame,
                }, {
                    Creator.New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding       = UDim.new(0, 4),
                        SortOrder     = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                    }),
                })

                for _, b in ipairs(c.Badges) do
                    Creator.NewRoundFrame("Squircle", {
                        Size             = UDim2.new(0, 0, 0, 16),
                        AutomaticSize    = Enum.AutomaticSize.X,
                        ImageColor3      = b.Color or Color3.fromHex("#daa732"),
                        ImageTransparency = 0.78,
                        Parent           = badgeRow,
                    }, {
                        Creator.New("TextLabel", {
                            Size          = UDim2.new(0, 0, 1, 0),
                            AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundTransparency = 1,
                            Text          = b.Text or "",
                            TextSize      = 9,
                            FontFace      = Font.new(Creator.Font, Enum.FontWeight.Bold),
                            TextColor3    = b.Color or Color3.fromHex("#daa732"),
                            Parent        = nil,
                        }, {
                            mkPad(0, 0, 6, 6),
                        }),
                    })
                end
            end

            if c.Role then
                Creator.NewRoundFrame("Squircle", {
                    Size             = UDim2.new(0, 0, 0, 22),
                    AutomaticSize    = Enum.AutomaticSize.X,
                    AnchorPoint      = Vector2.new(1, 0.5),
                    Position         = UDim2.new(1, -12, 0.5, 0),
                    ImageTransparency = 0.8,
                    ThemeTag         = { ImageColor3 = "Primary" },
                    Parent           = frame,
                }, {
                    Creator.New("TextLabel", {
                        Size          = UDim2.new(0, 0, 1, 0),
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Text          = c.Role,
                        TextSize      = 11,
                        FontFace      = Font.new(Creator.Font, Enum.FontWeight.Bold),
                        ThemeTag      = { TextColor3 = "Primary" },
                        Parent        = nil,
                    }, {
                        mkPad(0, 0, 8, 8),
                    }),
                })
            end

            return frame
        end

        function tabObj:Card(c)
            local frame = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(1, 0, 0, c.Height or 80),
                ImageTransparency = 0,
                ImageColor3      = c.Color or Creator.GetThemeValue("ElementBackground"),
                ThemeTag         = c.Color and nil or { ImageColor3 = "ElementBackground" },
                Parent           = container,
                Active           = c.Callback and true or nil,
            }, nil, c.Callback ~= nil)

            if c.AccentColor then
                Creator.New("Frame", {
                    Size             = UDim2.new(0, 3, 0.7, 0),
                    AnchorPoint      = Vector2.new(0, 0.5),
                    Position         = UDim2.new(0, 0, 0.5, 0),
                    BackgroundColor3 = c.AccentColor,
                    Parent           = frame,
                }, {
                    mkCorner(UDim.new(1, 0)),
                })
            end

            local infoFrame = Creator.New("Frame", {
                Size             = UDim2.new(1, -20, 1, 0),
                Position         = UDim2.new(0, c.AccentColor and 10 or 14, 0, 0),
                BackgroundTransparency = 1,
                Parent           = frame,
            }, {
                Creator.New("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),
            })

            if c.Icon then
                Creator.New("TextLabel", {
                    Size  = UDim2.new(0, 28, 0, 28),
                    BackgroundTransparency = 1,
                    Text  = c.Icon,
                    TextSize = 18,
                    ThemeTag = { TextColor3 = "Text" },
                    Parent = infoFrame,
                })
            end

            Creator.New("TextLabel", {
                Size           = UDim2.new(1, 0, 0, 0),
                AutomaticSize  = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text           = c.Title or "",
                TextSize       = 13,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                ThemeTag       = { TextColor3 = "Text" },
                Parent         = infoFrame,
            })

            if c.Desc then
                Creator.New("TextLabel", {
                    Size          = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text          = c.Desc,
                    TextSize      = 11,
                    FontFace      = Font.new(Creator.Font, Enum.FontWeight.Regular),
                    TextTransparency = 0.4,
                    ThemeTag      = { TextColor3 = "Text" },
                    Parent        = infoFrame,
                })
            end

            local valueLbl = Creator.New("TextLabel", {
                Size           = UDim2.new(0, 80, 1, 0),
                AnchorPoint    = Vector2.new(1, 0.5),
                Position       = UDim2.new(1, -14, 0.5, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Text           = tostring(c.Value or ""),
                TextSize       = 22,
                FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
                TextColor3     = c.ValueColor or Creator.GetThemeValue("Primary") or Color3.fromHex("#daa732"),
                Parent         = frame,
            })

            if c.Callback then
                Creator.AddSignal(frame.MouseButton1Click, function()
                    task.spawn(function() pcall(c.Callback) end)
                end)
            end

            local el = {}
            function el:SetValue(v)
                valueLbl.Text = tostring(v)
            end
            function el:Get()
                return valueLbl.Text
            end
            return el
        end

        function tabObj:CardRow(cards)
            local wrap = Creator.New("Frame", {
                Size          = UDim2.new(1, 0, 0, 70),
                BackgroundTransparency = 1,
                Parent        = container,
            }, {
                Creator.New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding       = UDim.new(0, 6),
                    SortOrder     = Enum.SortOrder.LayoutOrder,
                }),
            })

            local els = {}
            local cardW = math.floor((1 / #cards) * 100)

            for i, cd in ipairs(cards) do
                local cardFrame = Creator.NewRoundFrame("Squircle", {
                    Size             = UDim2.new(cardW / 100, i < #cards and -4 or 0, 1, 0),
                    ImageTransparency = 0,
                    ThemeTag         = { ImageColor3 = "ElementBackground" },
                    Parent           = wrap,
                })

                local inner = Creator.New("Frame", {
                    Size             = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Parent           = cardFrame,
                }, {
                    Creator.New("UIListLayout", {
                        Padding = UDim.new(0, 2),
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    }),
                })

                local valLbl = Creator.New("TextLabel", {
                    Size           = UDim2.new(1, 0, 0, 0),
                    AutomaticSize  = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Text           = tostring(cd.Value or "0"),
                    TextSize       = 18,
                    FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
                    TextColor3     = cd.ValueColor or Creator.GetThemeValue("Primary") or Color3.fromHex("#daa732"),
                    Parent         = inner,
                })

                Creator.New("TextLabel", {
                    Size          = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Text          = cd.Title or "",
                    TextSize      = 12,
                    FontFace      = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
                    ThemeTag      = { TextColor3 = "Text" },
                    Parent        = inner,
                })

                if cd.Sub then
                    Creator.New("TextLabel", {
                        Size          = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        Text          = cd.Sub,
                        TextSize      = 10,
                        FontFace      = Font.new(Creator.Font, Enum.FontWeight.Regular),
                        TextTransparency = 0.5,
                        ThemeTag      = { TextColor3 = "Text" },
                        Parent        = inner,
                    })
                end

                local el = {}
                function el:SetValue(v)
                    valLbl.Text = tostring(v)
                end
                table.insert(els, el)
            end

            return els
        end

        function tabObj:Table(c)
            local headers = c.Headers or {}
            local rows    = c.Rows    or {}
            local colW    = math.floor(100 / math.max(#headers, 1))

            local wrap = Creator.NewRoundFrame("Squircle", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                ImageTransparency = 0,
                ThemeTag         = { ImageColor3 = "ElementBackground" },
                Parent           = container,
            })

            local headerRow = Creator.New("Frame", {
                Size             = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Parent           = wrap,
            }, {
                Creator.New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder     = Enum.SortOrder.LayoutOrder,
                }),
            })

            for i, h in ipairs(headers) do
                Creator.New("TextLabel", {
                    Size           = UDim2.new(colW / 100, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text           = h,
                    TextSize       = 12,
                    FontFace       = Font.new(Creator.Font, Enum.FontWeight.Bold),
                    TextTransparency = 0.3,
                    ThemeTag       = { TextColor3 = "Text" },
                    Parent         = headerRow,
                }, {
                    mkPad(0, 0, 12, 0),
                })
            end

            Creator.New("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                BackgroundTransparency = 0.85,
                BackgroundColor3 = Color3.new(1, 1, 1),
                Position         = UDim2.new(0, 0, 0, 32),
                Parent           = wrap,
            })

            local rowsFrame = Creator.New("Frame", {
                Size          = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Position      = UDim2.new(0, 0, 0, 33),
                Parent        = wrap,
            }, {
                Creator.New("UIListLayout", {
                    Padding   = UDim.new(0, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),
            })

            for ri, row in ipairs(rows) do
                local rowFrame = Creator.New("Frame", {
                    Size             = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = ri % 2 == 0 and 0.97 or 1,
                    Parent           = rowsFrame,
                }, {
                    Creator.New("UIListLayout", {
                        FillDirection = Enum.FillDirection.Horizontal,
                        SortOrder     = Enum.SortOrder.LayoutOrder,
                    }),
                })

                for ci, cell in ipairs(row) do
                    Creator.New("TextLabel", {
                        Size           = UDim2.new(colW / 100, 0, 1, 0),
                        BackgroundTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Text           = tostring(cell),
                        TextSize       = 12,
                        FontFace       = Font.new(Creator.Font, Enum.FontWeight.Medium),
                        ThemeTag       = { TextColor3 = "Text" },
                        Parent         = rowFrame,
                    }, {
                        mkPad(0, 0, 12, 0),
                    })
                end
            end

            return wrap
        end

        return setmetatable(tabObj, tabObj)
    end

    function winObj:SetTheme(theme)
        win.Theme = theme
        Creator.SetTheme(theme)
    end

    function winObj:Notify(cfg)
        TryxLib.Notify(TryxLib, cfg)
    end

    function winObj:Destroy()
        Creator.DisconnectAll()
        pcall(function() screenGui:Destroy() end)
        pcall(function() NotifyGui:Destroy() end)
    end

    return setmetatable(winObj, winObj)
end

return TryxLib
