local code = game:HttpGet("https://raw.githubusercontent.com/Moon-820/PRMT-LIB/refs/heads/main/main.lua")
local func, err = loadstring(code)

if not func then
    error("Erreur dans main.lua :\n" .. tostring(err))
end

local Tryx = func()

local Window = TryxLib.new({
    Title  = "TryxHub",
    Theme  = TryxLib.Themes.Default,
    Key    = Enum.KeyCode.RightAlt,
})

local Main = Window:Tab({ Title = "Main", Icon = "⚡" })

Main:ProfileFrame({
    UserId   = game.Players.LocalPlayer.UserId,
    Username = game.Players.LocalPlayer.Name,
    Desc     = "@" .. game.Players.LocalPlayer.Name,
    Role     = "User",
    Badges   = {
        { Text = "MEMBER", Color = Color3.fromRGB(90, 160, 255)  },
        { Text = "BETA",   Color = Color3.fromRGB(180, 80, 255)  },
    },
})

Main:Space({ Height = 4 })

Main:Section({ Title = "Buttons" })

Main:Button({
    Title    = "Default Button",
    Desc     = "Default style with accent arrow",
    Callback = function()
        Window:Notify({ Title = "Button", Desc = "Default clicked!", Type = "success", Duration = 3 })
    end,
})

Main:Button({
    Title    = "Custom Color Button",
    Desc     = "Custom background using Color =",
    Color    = Color3.fromRGB(14, 22, 36),
    Callback = function()
        Window:Notify({ Title = "Button", Desc = "Custom color clicked!", Type = "info", Duration = 3 })
    end,
})

Main:Button({
    Title    = "Danger Button",
    Desc     = "Red tinted · destructive action",
    Color    = Color3.fromRGB(32, 10, 10),
    Callback = function()
        Window:Notify({ Title = "Danger", Desc = "Action executed!", Type = "error", Duration = 3 })
    end,
})

Main:Button({
    Title    = "Disabled Button",
    Desc     = "Not clickable — Disabled = true",
    Disabled = true,
    Callback = function() end,
})

Main:Button({
    Title        = "Transparent Button",
    Desc         = "Semi-transparent · Transparency = 0.4",
    Transparency = 0.4,
    Callback     = function()
        Window:Notify({ Title = "Ghost", Desc = "Semi-transparent clicked!", Type = "info", Duration = 2 })
    end,
})

Main:Section({ Title = "Toggles" })

Main:Toggle({
    Title    = "Auto Farm",
    Desc     = "Switch style — default",
    Value    = false,
    Callback = function(state)
        Window:Notify({
            Title    = "Auto Farm",
            Desc     = state and "Enabled" or "Disabled",
            Type     = state and "success" or "warn",
            Duration = 2,
        })
    end,
})

Main:Toggle({
    Title    = "God Mode",
    Desc     = "Checkbox style — Type = Checkbox",
    Type     = "Checkbox",
    Value    = false,
    Callback = function(state)
        Window:Notify({
            Title    = "God Mode",
            Desc     = state and "ON" or "OFF",
            Type     = state and "success" or "warn",
            Duration = 2,
        })
    end,
})

Main:Toggle({
    Title        = "ESP Players",
    Desc         = "Checkbox · custom background",
    Type         = "Checkbox",
    Value        = false,
    Color        = Color3.fromRGB(10, 22, 14),
    Transparency = 0,
    Callback     = function(state)
        print("ESP:", state)
    end,
})

Main:Toggle({
    Title    = "Feature Locked",
    Desc     = "Disabled = true · non interactive",
    Disabled = true,
    Value    = true,
    Callback = function() end,
})

Main:Section({ Title = "Sliders" })

Main:Slider({
    Title    = "Walk Speed",
    Desc     = "Character movement speed",
    Min      = 16,
    Max      = 500,
    Value    = 16,
    Suffix   = " sp",
    Step     = 1,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end,
})

Main:Slider({
    Title    = "Jump Power",
    Desc     = "Input = true · manual value input",
    Min      = 50,
    Max      = 1000,
    Value    = 50,
    Suffix   = " jp",
    Input    = true,
    Step     = 5,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = v
        end
    end,
})

Main:Slider({
    Title    = "Field of View",
    Desc     = "Camera FOV — Input + custom color",
    Min      = 70,
    Max      = 120,
    Value    = 70,
    Suffix   = "°",
    Input    = true,
    Step     = 1,
    Color    = Color3.fromRGB(14, 14, 26),
    Callback = function(v)
        workspace.CurrentCamera.FieldOfView = v
    end,
})

Main:Slider({
    Title    = "Locked Slider",
    Desc     = "Disabled = true",
    Min      = 0,
    Max      = 100,
    Value    = 40,
    Disabled = true,
    Callback = function() end,
})

Main:Section({ Title = "Inputs" })

Main:Input({
    Title       = "Username",
    Desc        = "Enter a player name",
    Placeholder = "ex: Builderman",
    Callback    = function(v)
        print("Username:", v)
    end,
})

Main:Input({
    Title       = "Custom Seed",
    Desc        = "Blue tinted background — Color =",
    Placeholder = "ex: 123456",
    Color       = Color3.fromRGB(14, 14, 26),
    Callback    = function(v)
        print("Seed:", v)
    end,
})

Main:Input({
    Title       = "Script Executor",
    Desc        = "MultiLine = true · multi-line input",
    Placeholder = "print('Hello World')",
    MultiLine   = true,
    Callback    = function(v)
        print("Script:", v)
    end,
})

Main:Input({
    Title    = "Read Only",
    Desc     = "Disabled = true",
    Default  = "Not editable",
    Disabled = true,
    Callback = function() end,
})

Main:Section({ Title = "Number Inputs" })

Main:NumberInput({
    Title    = "Max Players",
    Desc     = "+/– buttons with manual input",
    Min      = 1,
    Max      = 100,
    Step     = 1,
    Value    = 10,
    Callback = function(v)
        print("Max players:", v)
    end,
})

Main:NumberInput({
    Title    = "Coin Amount",
    Desc     = "Step = 50",
    Min      = 0,
    Max      = 100000,
    Step     = 50,
    Value    = 500,
    Callback = function(v)
        print("Coins:", v)
    end,
})

Main:Section({ Title = "Progress Bars" })

local progressBar = Main:ProgressBar({
    Title      = "Loading Progress",
    Desc       = "Live update — use :Set(0..1)",
    Value      = 0,
    BarColor   = Color3.fromRGB(218, 175, 55),
    ShowPercent = true,
})

local filling = true
task.spawn(function()
    local v = 0
    while task.wait(0.04) do
        if filling then
            v = math.min(1, v + 0.008)
            if v >= 1 then filling = false end
        else
            v = math.max(0, v - 0.012)
            if v <= 0 then filling = true end
        end
        progressBar:Set(v)
    end
end)

Main:ProgressBar({
    Title      = "Server Health",
    Desc       = "Static — Value = 0.72",
    Value      = 0.72,
    BarColor   = Color3.fromRGB(58, 188, 98),
    ShowPercent = true,
})

Main:ProgressBar({
    Title      = "Cooldown",
    Desc       = "Danger bar — BarColor = red",
    Value      = 0.25,
    BarColor   = Color3.fromRGB(210, 58, 58),
    ShowPercent = true,
})

Main:Section({ Title = "Dropdowns" })

Main:Dropdown({
    Title    = "Game Mode",
    Desc     = "Classic single-select",
    Values   = { "Solo", "Duo", "Squad", "Custom" },
    Value    = "Solo",
    Callback = function(v)
        Window:Notify({ Title = "Mode", Desc = "Selected: " .. v, Type = "info", Duration = 2 })
    end,
})

Main:Dropdown({
    Title    = "Active Auras",
    Desc     = "Multi = true · multiple selection",
    Values   = { "Flame", "Ice", "Thunder", "Shadow", "Holy" },
    Multi    = true,
    Callback = function(selected)
        local list = {}
        for k in pairs(selected) do table.insert(list, k) end
        print("Auras:", table.concat(list, ", "))
    end,
})

Main:Dropdown({
    Title    = "Skin",
    Desc     = "Custom color background",
    Values   = { "Default", "Gold", "Obsidian", "Neon" },
    Value    = "Default",
    Color    = Color3.fromRGB(22, 16, 6),
    Callback = function(v)
        print("Skin:", v)
    end,
})

Main:Section({ Title = "Keybinds" })

Main:Keybind({
    Title    = "Toggle ESP",
    Desc     = "Click to rebind · press key in game",
    Key      = Enum.KeyCode.X,
    Callback = function(key)
        Window:Notify({ Title = "ESP Keybind", Desc = "Key set: " .. key.Name, Type = "info", Duration = 2 })
    end,
    OnPress  = function()
        print("ESP toggled by keybind")
    end,
})

Main:Keybind({
    Title    = "Noclip",
    Desc     = "Separate keybind",
    Key      = Enum.KeyCode.N,
    Callback = function(key)
        print("Noclip key:", key.Name)
    end,
    OnPress  = function()
        Window:Notify({ Title = "Noclip", Desc = "Toggled!", Type = "warn", Duration = 2 })
    end,
})

Main:KeybindButton({
    Title      = "Teleport Home",
    Desc       = "Click Run or press the key",
    Key        = Enum.KeyCode.T,
    ButtonText = "Run",
    Callback   = function()
        Window:Notify({ Title = "Teleport", Desc = "Teleport executed!", Type = "success", Duration = 2 })
    end,
})

Main:Section({ Title = "Color Pickers" })

Main:ColorPicker({
    Title    = "ESP Color",
    Desc     = "Choose highlight color",
    Value    = Color3.fromRGB(255, 80, 80),
    Callback = function(color)
        print("ESP Color:", color)
    end,
})

Main:ColorPicker({
    Title    = "Aura Color",
    Desc     = "Custom blue background",
    Value    = Color3.fromRGB(80, 120, 255),
    Color    = Color3.fromRGB(10, 10, 22),
    Callback = function(color)
        print("Aura Color:", color)
    end,
})

Main:Section({ Title = "Text & Layout" })

Main:Paragraph({
    Title = "About TryxHub",
    Desc  = "TryxHub is powered by TryxLib, a professional Roblox UI library. All features shown in this example are fully functional and compatible with the current library version.",
})

Main:Paragraph({
    Title = "Status : Active",
    Desc  = "All modules loaded successfully. No errors detected.",
})

Main:Label({
    Title = "• Latest update: v2.0",
    Color = Color3.fromRGB(90, 90, 110),
})

Main:Label({
    Title = "• Developed by Moon820",
    Color = Color3.fromRGB(218, 175, 55),
})

Main:Divider({ Label = "Separator" })

Main:Divider({ Color = Color3.fromRGB(218, 175, 55) })

Main:Badge({
    { Text = "PREMIUM", Color = Color3.fromRGB(218, 175, 55) },
    { Text = "ADMIN",   Color = Color3.fromRGB(210, 58, 58)  },
    { Text = "BETA",    Color = Color3.fromRGB(138, 108, 255)},
})

Main:Space({ Height = 6 })

local Cards = Window:Tab({ Title = "Cards", Icon = "◈" })

Cards:Section({ Title = "Simple Cards" })

local killCard = Cards:Card({
    Title      = "Kills",
    Desc       = "Current session",
    Icon       = "⚔",
    Value      = 0,
    ValueColor = Color3.fromRGB(218, 175, 55),
    Height     = 82,
})

Cards:Card({
    Title      = "Streak",
    Desc       = "Your best streak",
    Icon       = "★",
    Value      = 7,
    ValueColor = Color3.fromRGB(218, 100, 40),
    Height     = 82,
    Callback   = function()
        Window:Notify({ Title = "Streak", Desc = "Details loaded", Type = "info", Duration = 2 })
    end,
})

Cards:Card({
    Title       = "Premium",
    Desc        = "Account status",
    Icon        = "◆",
    Value       = "Active",
    ValueColor  = Color3.fromRGB(218, 175, 55),
    Color       = Color3.fromRGB(28, 22, 8),
    AccentColor = Color3.fromRGB(218, 175, 55),
    Height      = 82,
})

Cards:Section({ Title = "Card Rows — Multi Columns" })

local rowCards = Cards:CardRow({
    { Title = "Kills",  Value = 0,   Sub = "Session", ValueColor = Color3.fromRGB(218, 175, 55) },
    { Title = "Deaths", Value = 0,   Sub = "Session", ValueColor = Color3.fromRGB(210, 58, 58)  },
    { Title = "K/D",    Value = "∞", Sub = "Ratio",   ValueColor = Color3.fromRGB(58, 188, 98)  },
})

Cards:CardRow({
    { Title = "Ping",   Value = "-- ms", Sub = "Network", ValueColor = Color3.fromRGB(90, 160, 255) },
    { Title = "FPS",    Value = "60",    Sub = "Render",  ValueColor = Color3.fromRGB(58, 188, 98)  },
    { Title = "Memory", Value = "-- MB", Sub = "Usage",   ValueColor = Color3.fromRGB(218, 158, 38) },
})

task.spawn(function()
    local kills, deaths = 0, 0
    while task.wait(2) do
        kills  = kills  + math.random(0, 3)
        deaths = deaths + math.random(0, 1)
        local kd = deaths == 0 and "∞" or tostring(math.floor((kills / deaths) * 10) / 10)
        rowCards[1]:SetValue(kills)
        rowCards[2]:SetValue(deaths)
        rowCards[3]:SetValue(kd)
        killCard:SetValue(kills)
    end
end)

Cards:Space({ Height = 4 })

Cards:Section({ Title = "ProfileFrame Variants" })

Cards:ProfileFrame({
    UserId   = game.Players.LocalPlayer.UserId,
    Username = game.Players.LocalPlayer.Name,
    Desc     = "Local player",
    Role     = "User",
    Badges   = {
        { Text = "MEMBER", Color = Color3.fromRGB(90, 160, 255) },
    },
})

Cards:ProfileFrame({
    UserId   = 0,
    Username = "Moon820",
    Desc     = "Developer · TryxLib",
    Role     = "DEV",
    Color    = Color3.fromRGB(16, 12, 24),
    Badges   = {
        { Text = "ADMIN", Color = Color3.fromRGB(210, 58, 58)   },
        { Text = "OWNER", Color = Color3.fromRGB(218, 175, 55)  },
        { Text = "DEV",   Color = Color3.fromRGB(138, 108, 255) },
    },
})

Cards:Section({ Title = "Data Table" })

Cards:Table({
    Headers = { "Player", "Score", "Rank", "Status" },
    Rows    = {
        { "Moon820",    "9,840", "#1",  "Online"  },
        { "Builderman", "7,210", "#2",  "Online"  },
        { "Roblox",     "5,500", "#3",  "AFK"     },
        { "Guest_1337", "3,120", "#4",  "Offline" },
        { "xX_Pro_Xx",  "1,080", "#5",  "Online"  },
    },
})

local Settings = Window:Tab({ Title = "Settings", Icon = "⚙" })

Settings:Section({ Title = "Interface" })

Settings:Toggle({
    Title    = "Notifications",
    Desc     = "Enable notification popups",
    Value    = true,
    Callback = function(v) print("Notifications:", v) end,
})

Settings:Toggle({
    Title    = "Compact Mode",
    Desc     = "Reduce element spacing — Checkbox",
    Type     = "Checkbox",
    Value    = false,
    Callback = function(v) print("Compact:", v) end,
})

Settings:Slider({
    Title    = "UI Scale",
    Desc     = "Global interface size",
    Min      = 60,
    Max      = 130,
    Value    = 100,
    Suffix   = "%",
    Input    = true,
    Callback = function(v) print("Scale:", v) end,
})

Settings:ColorPicker({
    Title    = "Accent Override",
    Desc     = "Preview a custom accent color",
    Value    = Color3.fromRGB(218, 175, 55),
    Callback = function(color)
        print("Accent:", color)
    end,
})

Settings:Divider({ Label = "Theme" })

Settings:Dropdown({
    Title    = "Interface Theme",
    Desc     = "Change the global appearance",
    Values   = { "Default", "Dark", "Midnight", "Slate" },
    Value    = "Default",
    Callback = function(v)
        local themeMap = {
            Default  = TryxLib.Themes.Default,
            Dark     = TryxLib.Themes.Dark,
            Midnight = TryxLib.Themes.Midnight,
            Slate    = TryxLib.Themes.Slate,
        }
        if themeMap[v] then
            Window:SetTheme(themeMap[v])
        end
        Window:Notify({ Title = "Theme", Desc = "Applied: " .. v, Type = "info", Duration = 2 })
    end,
})

Settings:Divider({ Label = "Shortcuts" })

Settings:Keybind({
    Title    = "Toggle GUI",
    Desc     = "Open / close the interface",
    Key      = Enum.KeyCode.RightAlt,
    Callback = function(key)
        print("Toggle key changed:", key.Name)
    end,
})

Settings:KeybindButton({
    Title      = "Panic Key",
    Desc       = "Instantly close and destroy the GUI",
    Key        = Enum.KeyCode.End,
    ButtonText = "Close",
    Callback   = function()
        Window:Destroy()
    end,
})

Settings:Divider({ Label = "Test Notifications" })

Settings:Button({
    Title    = "Success Notification",
    Callback = function()
        Window:Notify({ Title = "Success", Desc = "Action completed successfully!", Type = "success", Duration = 4 })
    end,
})

Settings:Button({
    Title    = "Error Notification",
    Color    = Color3.fromRGB(28, 10, 10),
    Callback = function()
        Window:Notify({ Title = "Error", Desc = "An unexpected error occurred.", Type = "error", Duration = 4 })
    end,
})

Settings:Button({
    Title    = "Warning Notification",
    Color    = Color3.fromRGB(28, 22, 8),
    Callback = function()
        Window:Notify({ Title = "Warning", Desc = "Proceed with caution.", Type = "warn", Duration = 4 })
    end,
})

Settings:Button({
    Title    = "Info Notification",
    Color    = Color3.fromRGB(10, 16, 28),
    Callback = function()
        Window:Notify({ Title = "Info", Desc = "TryxLib v2.0 — everything is working.", Type = "info", Duration = 4 })
    end,
})

Settings:Divider({ Label = "Danger Zone" })

Settings:Button({
    Title    = "Reset Settings",
    Desc     = "Revert all options to default",
    Color    = Color3.fromRGB(28, 8, 8),
    Callback = function()
        Window:Notify({ Title = "Reset", Desc = "Settings have been reset.", Type = "warn", Duration = 3 })
    end,
})

Window:Notify({
    Title    = "TryxHub",
    Desc     = "Loaded successfully!",
    Type     = "success",
    Duration = 5,
})
