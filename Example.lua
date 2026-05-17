local Tryx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moon-820/PRMT-LIB/refs/heads/main/main.lua"))()

local Window = Tryx:CreateWindow({
    Title    = "TryxHub",
    Icon     = "⚡",
    Subtitle = "v2.0",
})

local Main = Window:Tab({ Title = "Main", Icon = "⚡" })

Main:ProfileFrame({
    Name     = "@...",
    Subtitle = "f",
    UserId   = 0,
})

Main:Divider({ Label = "Actions" })

Main:Button({
    Title    = "Test Button",
    Desc     = "Click me to trigger an action",
    Callback = function()
        Window:Notify({ Title = "Button", Desc = "Clicked!", Type = "success", Duration = 3 })
    end,
})

Main:Button({
    Title        = "Danger Button",
    Desc         = "Action risquée",
    Color        = Color3.fromRGB(30, 10, 10),
    Transparency = 0,
    Callback     = function()
        Window:Notify({ Title = "Danger", Desc = "Action exécutée", Type = "error", Duration = 3 })
    end,
})

Main:Divider({ Label = "Toggles" })

Main:Toggle({
    Title    = "Auto Farm",
    Desc     = "Enables automatic farming",
    Value    = false,
    Callback = function(state)
        Window:Notify({ Title = "Auto Farm", Desc = state and "Enabled" or "Disabled", Type = state and "success" or "warn", Duration = 3 })
    end,
})

Main:Toggle({
    Title    = "God Mode",
    Desc     = "Invincibilité (checkbox style)",
    Type     = "Checkbox",
    Value    = true,
    Color    = Color3.fromRGB(12, 22, 12),
    Callback = function(state)
        Window:Notify({ Title = "God Mode", Desc = state and "ON" or "OFF", Type = state and "success" or "warn", Duration = 2 })
    end,
})

Main:Toggle({
    Title        = "ESP Players",
    Desc         = "Voir les joueurs à travers les murs",
    Type         = "Checkbox",
    Value        = false,
    Transparency = 0,
    Callback     = function(state)
        print("ESP:", state)
    end,
})

Main:Divider({ Label = "Sliders" })

Main:Slider({
    Title    = "Walk Speed",
    Desc     = "Adjust player speed",
    Min      = 16,
    Max      = 200,
    Value    = 16,
    Suffix   = " sp",
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end,
})

Main:Slider({
    Title    = "Jump Power",
    Desc     = "Hauteur de saut — Input activé",
    Min      = 50,
    Max      = 500,
    Value    = 50,
    Suffix   = " jp",
    Input    = true,
    Color    = Color3.fromRGB(18, 18, 26),
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpPower = v
        end
    end,
})

Main:Slider({
    Title    = "FOV",
    Min      = 70,
    Max      = 120,
    Value    = 70,
    Suffix   = "°",
    Input    = true,
    Callback = function(v)
        workspace.CurrentCamera.FieldOfView = v
    end,
})

Main:Divider({ Label = "Input" })

Main:Input({
    Title       = "Custom Value",
    Desc        = "Enter any value",
    Placeholder = "Type here...",
    Callback    = function(v)
        print("Input:", v)
    end,
})

Main:Input({
    Title       = "Target Player",
    Placeholder = "Nom du joueur...",
    Color       = Color3.fromRGB(14, 14, 22),
    Callback    = function(v)
        print("Target:", v)
    end,
})

Main:Divider({ Label = "Dropdown" })

Main:Dropdown({
    Title    = "Select Mode",
    Desc     = "Choose a game mode",
    Values   = { "Mode A", "Mode B", "Mode C", "Mode D" },
    Value    = "Mode A",
    Callback = function(v)
        Window:Notify({ Title = "Mode", Desc = "Sélectionné : " .. v, Type = "info", Duration = 2 })
    end,
})

Main:Dropdown({
    Title    = "Aura Type",
    Values   = { "Aucune", "Flame", "Ice", "Thunder", "Shadow" },
    Value    = "Aucune",
    Color    = Color3.fromRGB(20, 14, 20),
    Callback = function(v)
        print("Aura:", v)
    end,
})

Main:Divider({ Label = "Keybinds" })

Main:Keybind({
    Title    = "Toggle GUI",
    Desc     = "Ouvre/Ferme l'interface",
    Key      = Enum.KeyCode.RightShift,
    Callback = function(key)
        print("Keybind GUI:", key.Name)
    end,
})

Main:KeybindButton({
    Title    = "Teleport Waypoint",
    Desc     = "TP au waypoint · Bouton ou touche",
    Key      = Enum.KeyCode.T,
    Callback = function(key)
        Window:Notify({ Title = "Teleport", Desc = "Waypoint activé", Type = "info", Duration = 2 })
    end,
})

Main:Divider({ Label = "Info" })

Main:Paragraph({
    Title = "TryxHub v2.0",
    Desc  = "Powered by TryxLib — Premium UI Library",
})

Main:Space({ Height = 4 })

local Prm = Window:Tab({ Title = "Premium", Icon = "★" })

Prm:Card({
    Title = "Premium",
    Desc  = "Accès à toutes les fonctionnalités exclusives.",
    Icon  = "★",
    Color = Color3.fromRGB(28, 22, 8),
})

Prm:Space()

Prm:ProfileFrame({
    Name     = "Moon820",
    Subtitle = "Développeur · TryxLib",
    UserId   = 0,
})

Prm:Space()

Prm:Toggle({
    Title    = "Infinite Stamina",
    Desc     = "Premium only",
    Type     = "Checkbox",
    Value    = false,
    Color    = Color3.fromRGB(28, 22, 8),
    Callback = function(state)
        Window:Notify({ Title = "Stamina", Desc = state and "Activée" or "Désactivée", Type = state and "success" or "warn", Duration = 2 })
    end,
})

Prm:Slider({
    Title    = "Damage Multiplier",
    Desc     = "Premium · Multiplicateur de dégâts",
    Min      = 1,
    Max      = 10,
    Value    = 1,
    Suffix   = "x",
    Input    = true,
    Color    = Color3.fromRGB(28, 22, 8),
    Callback = function(v)
        print("DMG x" .. v)
    end,
})

Prm:Dropdown({
    Title    = "Unlock Skin",
    Desc     = "Skins exclusifs premium",
    Values   = { "Default", "Gold", "Obsidian", "Neon", "Shadow" },
    Value    = "Default",
    Color    = Color3.fromRGB(28, 22, 8),
    Callback = function(v)
        print("Skin:", v)
    end,
})

Prm:Divider({ Label = "Accès" })

Prm:Paragraph({
    Title = "Comment obtenir le Premium ?",
    Desc  = "Rejoins notre Discord et contacte un admin pour débloquer l'accès Premium pour 2€.",
})

Prm:Button({
    Title    = "Rejoindre le Discord",
    Desc     = "discord.gg/tryxhub",
    Color    = Color3.fromRGB(20, 20, 32),
    Callback = function()
        Window:Notify({ Title = "Discord", Desc = "Lien copié dans le presse-papier", Type = "info", Duration = 3 })
    end,
})

local Settings = Window:Tab({ Title = "Settings", Icon = "⚙" })

Settings:Divider({ Label = "Interface" })

Settings:Toggle({
    Title    = "Notifications",
    Desc     = "Afficher les notifications",
    Value    = true,
    Callback = function(state)
        print("Notifs:", state)
    end,
})

Settings:Toggle({
    Title    = "Topmost Window",
    Desc     = "Toujours au premier plan",
    Type     = "Checkbox",
    Value    = false,
    Callback = function(state)
        print("Topmost:", state)
    end,
})

Settings:Slider({
    Title    = "UI Transparency",
    Desc     = "Opacité du menu",
    Min      = 0,
    Max      = 80,
    Value    = 0,
    Suffix   = "%",
    Input    = true,
    Callback = function(v)
        print("Transparency:", v)
    end,
})

Settings:Divider({ Label = "Keybinds" })

Settings:Keybind({
    Title    = "Hide/Show GUI",
    Desc     = "Raccourci clavier principal",
    Key      = Enum.KeyCode.RightShift,
    Callback = function(key)
        print("Toggle GUI:", key.Name)
    end,
})

Settings:KeybindButton({
    Title    = "Panic Key",
    Desc     = "Ferme immédiatement le GUI",
    Key      = Enum.KeyCode.End,
    Callback = function()
        Window:Destroy()
    end,
})

Settings:Divider({ Label = "Infos" })

Settings:Card({
    Title = "TryxLib",
    Desc  = "Version 2.0 — Build stable\nDéveloppé par Moon820",
    Icon  = "⚡",
})

Settings:Space()

Settings:Button({
    Title    = "Reset Settings",
    Desc     = "Réinitialise toutes les options",
    Color    = Color3.fromRGB(28, 10, 10),
    Callback = function()
        Window:Notify({ Title = "Reset", Desc = "Paramètres réinitialisés", Type = "warn", Duration = 3 })
    end,
})

Window:Notify({ Title = "TryxHub", Desc = "Loaded successfully!", Type = "success", Duration = 4 })
