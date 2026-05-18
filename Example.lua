local Tryx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moon-820/PRMT-LIB/refs/heads/main/main.lua"))()

local Window = Tryx:CreateWindow({
    Title      = "TryxHub",
    Subtitle   = "v2.0 · Showcase",
    Icon       = "⚡",
    Theme      = Tryx.Themes.Default,
    ToggleKey  = Enum.KeyCode.RightAlt,
    Size       = Vector2.new(500, 650),
})

local Main = Window:Tab({ Title = "Main", Icon = "⚡" })

Main:ProfileFrame({
    UserId   = game.Players.LocalPlayer.UserId,
    Username = game.Players.LocalPlayer.Name,
    Desc     = "@" .. game.Players.LocalPlayer.Name,
    Role     = "User",
    Badges   = {
        { Text = "MEMBER", Color = Color3.fromRGB(90, 160, 255) },
        { Text = "BETA",   Color = Color3.fromRGB(180, 80, 255) },
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
    Title        = "Custom Color Button",
    Desc         = "Custom background using Color =",
    Color        = Color3.fromRGB(14, 22, 36),
    Callback     = function()
        Window:Notify({ Title = "Button", Desc = "Custom color clicked!", Type = "info", Duration = 3 })
    end,
})

Main:Button({
    Title        = "Danger Button",
    Desc         = "Red color · destructive action",
    Color        = Color3.fromRGB(32, 10, 10),
    Callback     = function()
        Window:Notify({ Title = "Danger", Desc = "Action executed!", Type = "error", Duration = 3 })
    end,
})

Main:Button({
    Title        = "Disabled Button",
    Desc         = "Not clickable — Disabled = true",
    Disabled     = true,
    Callback     = function() end,
})

Main:Button({
    Title        = "Transparent Button",
    Desc         = "Transparency = 0.4",
    Transparency = 0.4,
    Callback     = function()
        Window:Notify({ Title = "Ghost", Desc = "Semi-transparent!", Type = "info", Duration = 2 })
    end,
})

Main:Section({ Title = "Toggles" })

Main:Toggle({
    Title    = "Auto Farm",
    Desc     = "Switch style — Default",
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
        Window:Notify({ Title = "God Mode", Desc = state and "ON" or "OFF", Type = state and "success" or "warn", Duration = 2 })
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
    Desc     = "Character speed",
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
    Desc     = "Input = true · manual input enabled",
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
    Title    = "FOV",
    Desc     = "Field of view — Input + Color",
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
        print("Value:", v)
    end,
})

Main:Input({
    Title       = "Custom Seed",
    Desc        = "Colored background — Color =",
    Placeholder = "ex: 123456",
    Color       = Color3.fromRGB(14, 14, 26),
    Callback    = function(v)
        print("Seed:", v)
    end,
})

Main:Input({
    Title       = "Script Executor",
    Desc        = "MultiLine = true · long input",
    Placeholder = "print('Hello World')",
    MultiLine   = true,
    Callback    = function(v)
        print("Script:", v)
    end,
})

Main:Input({
    Title       = "Read Only",
    Desc        = "Disabled = true",
    Value       = "Not editable",
    Disabled    = true,
    Callback    = function() end,
})

Main:Section({ Title = "Dropdowns" })

Main:Dropdown({
    Title    = "Game Mode",
    Desc     = "Classic selector",
    Values   = { "Solo", "Duo", "Squad", "Custom" },
    Value    = "Solo",
    Callback = function(v)
        Window:Notify({ Title = "Mode", Desc = "Selected: " .. v, Type = "info", Duration = 2 })
    end,
})

Main:Dropdown({
    Title    = "Active Auras",
    Desc     = "Multi = true · multiple choices",
    Values   = { "Flame", "Ice", "Thunder", "Shadow", "Holy" },
    Multi    = true,
    Callback = function(selected)
        print("Auras:", table.concat(selected, ", "))
    end,
})

Main:Dropdown({
    Title    = "Skin",
    Desc     = "Custom color",
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
    Desc     = "Press to change the key",
    Key      = Enum.KeyCode.X,
    Callback = function(key)
        Window:Notify({ Title = "ESP Keybind", Desc = "Key: " .. key.Name, Type = "info", Duration = 2 })
    end,
    OnPress  = function()
        print("ESP toggled by keybind")
    end,
})

Main:KeybindButton({
    Title      = "Teleport Home",
    Desc       = "Click Run or press the key",
    Key        = Enum.KeyCode.T,
    ButtonText = "Run",
    Callback   = function()
        Window:Notify({ Title = "Teleport", Desc = "Teleport completed", Type = "success", Duration = 2 })
    end,
})

Main:Section({ Title = "Color Pickers" })

Main:ColorPicker({
    Title    = "ESP Color",
    Desc     = "Choose ESP color",
    Value    = Color3.fromRGB(255, 80, 80),
    Callback = function(color)
        print("ESP Color:", color)
    end,
})

Main:ColorPicker({
    Title    = "Aura Color",
    Desc     = "Color picker + custom background",
    Value    = Color3.fromRGB(80, 120, 255),
    Color    = Color3.fromRGB(10, 10, 22),
    Callback = function(color)
        print("Aura Color:", color)
    end,
})

Main:Section({ Title = "Text & Layout" })

Main:Paragraph({
    Title = "About",
    Desc  = "TryxHub is powered by TryxLib v2.0, a premium interface developed by Moon820. All features are available in this example.",
})

Main:Paragraph({
    Title     = "Important Note",
    Desc      = "Using these features in public servers may result in a ban. Use carefully.",
    AccentBar = Color3.fromRGB(218, 158, 38),
})

Main:Paragraph({
    Title     = "Status : Active",
    Desc      = "All modules loaded successfully.",
    AccentBar = Color3.fromRGB(58, 188, 98),
})

Main:Label({
    Text  = "• Latest update: v2.0",
    Color = Color3.fromRGB(90, 90, 110),
    Size  = 11,
})

Main:Label({
    Text  = "• Developed by Moon820",
    Color = Color3.fromRGB(218, 175, 55),
    Size  = 11,
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

Cards:Card({
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
    Icon       = "🔥",
    Value      = 7,
    ValueColor = Color3.fromRGB(218, 100, 40),
    Callback   = function()
        Window:Notify({ Title = "Streak", Desc = "Details loaded", Type = "info", Duration = 2 })
    end,
})

Cards:Card({
    Title       = "Premium",
    Desc        = "Account status",
    Icon        = "★",
    Value       = "Active",
    ValueColor  = Color3.fromRGB(218, 175, 55),
    Color       = Color3.fromRGB(28, 22, 8),
    AccentColor = Color3.fromRGB(218, 175, 55),
    Height      = 82,
})

Cards:Section({ Title = "Card Rows — Multi Columns" })

local row = Cards:CardRow({
    { Title = "Kills",  Value = 0,    Sub = "Session",  ValueColor = Color3.fromRGB(218, 175, 55) },
    { Title = "Deaths", Value = 0,    Sub = "Session",  ValueColor = Color3.fromRGB(210, 58, 58)  },
    { Title = "K/D",    Value = "∞",  Sub = "Ratio",    ValueColor = Color3.fromRGB(58, 188, 98)  },
})

Cards:CardRow({
    { Title = "Ping",   Value = "-- ms", Sub = "Network",  ValueColor = Color3.fromRGB(90, 160, 255) },
    { Title = "FPS",    Value = "60",    Sub = "Render",   ValueColor = Color3.fromRGB(58, 188, 98)  },
})

Cards:Space({ Height = 4 })

task.spawn(function()
    while task.wait(1) do
        local fps = math.floor(1 / RunService.Heartbeat:Wait())
        row[1]:SetValue(math.random(0, 50))
        row[2]:SetValue(math.random(0, 20))
        pcall(function()
            Cards:CardRow({})
        end)
    end
end)

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
        { Text = "ADMIN",  Color = Color3.fromRGB(210, 58, 58)   },
        { Text = "OWNER",  Color = Color3.fromRGB(218, 175, 55)  },
        { Text = "DEV",    Color = Color3.fromRGB(138, 108, 255) },
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
    Desc     = "Reduce spacing — Checkbox",
    Type     = "Checkbox",
    Value    = false,
    Callback = function(v) print("Compact:", v) end,
})

Settings:Slider({
    Title    = "UI Scale",
    Desc     = "Global menu size",
    Min      = 60,
    Max      = 130,
    Value    = 100,
    Suffix   = "%",
    Input    = true,
    Callback = function(v) print("Scale:", v) end,
})

Settings:ColorPicker({
    Title    = "Accent Color",
    Desc     = "Change the library accent color",
    Value    = Color3.fromRGB(218, 175, 55),
    Callback = function(color)
        print("New accent:", color)
    end,
})

Settings:Divider({ Label = "Theme" })

Settings:Dropdown({
    Title    = "Interface Theme",
    Desc     = "Change the global appearance",
    Values   = { "Default", "Dark", "Midnight" },
    Value    = "Default",
    Callback = function(v)
        Window:SetTheme(v)
        Window:Notify({ Title = "Theme", Desc = "Applied: " .. v, Type = "info", Duration = 2 })
    end,
})

Settings:Divider({ Label = "Shortcuts" })

Settings:Keybind({
    Title    = "Toggle GUI",
    Desc     = "Open / close the interface",
    Key      = Enum.KeyCode.RightAlt,
    Callback = function(key) print("Toggle key:", key.Name) end,
})

Settings:KeybindButton({
    Title      = "Panic Key",
    Desc       = "Instantly close the GUI",
    Key        = Enum.KeyCode.End,
    ButtonText = "Run",
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
        Window:Notify({ Title = "Error", Desc = "An error occurred.", Type = "error", Duration = 4 })
    end,
})

Settings:Button({
    Title    = "Warning Notification",
    Color    = Color3.fromRGB(28, 22, 8),
    Callback = function()
        Window:Notify({ Title = "Warning", Desc = "Proceed carefully.", Type = "warn", Duration = 4 })
    end,
})

Settings:Button({
    Title    = "Info Notification",
    Color    = Color3.fromRGB(10, 16, 28),
    Callback = function()
        Window:Notify({ Title = "Info", Desc = "TryxLib v2.0 — everything works.", Type = "info", Duration = 4 })
    end,
})

Settings:Divider({ Label = "Danger Zone" })

Settings:Button({
    Title    = "Reset Settings",
    Desc     = "Reset all saved options",
    Color    = Color3.fromRGB(28, 8, 8),
    Callback = function()
        Window:Notify({ Title = "Reset", Desc = "Settings reset", Type = "warn", Duration = 3 })
    end,
})

Window:Notify({
    Title    = "TryxHub",
    Desc     = "Loaded successfully · Example.lua",
    Type     = "success",
    Duration = 5,
})
