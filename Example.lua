-- TryxLib | Example.lua
-- Exemple d'utilisation complète
-- Version test pouvant comporter des bugs

local Tryx = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moon-820/PRMT-LIB/refs/heads/main/main.lua"))()

local Window = Tryx:CreateWindow({
    Title    = "TryxHub",
    Icon     = "Star",
})

-- ── Tab Principal ──────────────────────────────────────
local Main = Window:Tab({ Title = "Main", Icon = "⚡" })

Main:Button({
    Title    = "Test Button",
    Desc     = "Click me to trigger an action",
    Callback = function()
        Window:Notify({ Title = "Button", Desc = "Clicked!", Type = "success", Duration = 3 })
    end,
})

Main:Toggle({
    Title    = "Auto Farm",
    Desc     = "Enables automatic farming",
    Value    = false,
    Callback = function(state)
        Window:Notify({ Title = "Auto Farm", Desc = state and "Enabled" or "Disabled", Type = state and "success" or "warn", Duration = 3 })
    end,
})

Main:Slider({
    Title    = "Walk Speed",
    Desc     = "Adjust player speed",
    Min      = 16,
    Max      = 200,
    Value    = 16,
    Suffix   = " sp",
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

Main:Input({
    Title       = "Custom Value",
    Desc        = "Enter any value",
    Placeholder = "Type here...",
    Callback    = function(v)
        print("Input:", v)
    end,
})

Main:Dropdown({
    Title    = "Select Mode",
    Desc     = "Choose a game mode",
    Values   = { "Mode A", "Mode B", "Mode C" },
    Value    = "Mode A",
    Callback = function(v)
        print("Selected:", v)
    end,
})

Main:Divider({ Label = "Info" })

Main:Paragraph({
    Title = "TryxHub v1.0",
    Desc  = "Powered by TryxLib — Premium UI Library",
})

Main:Space()

-- ── Tab Premium ────────────────────────────────────────
local Prm = Window:Tab({ Title = "Premium", Icon = "★" })

Prm:Paragraph({
    Title = "Premium Features",
    Desc  = "Unlock all features for 2€ — Contact us on Discord.",
})

-- ── Notifications test ─────────────────────────────────
Window:Notify({ Title = "TryxHub", Desc = "Loaded successfully!", Type = "success", Duration = 4 })
