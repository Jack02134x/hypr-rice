-- ~/.config/hypr/hyprconfigs/autostart.lua
-- All commands that should run once when Hyprland starts

hl.on("hyprland.start", function ()     -- Environment variables (equivalent to export)
    hl.exec_cmd("export QT_QPA_PLATFORMTHEME=qt5ct")
    hl.exec_cmd("export QT_QPA_PLATFORMTHEME=qt6ct")   -- only qt6ct is needed; qt5ct is redundant

    -- Cursor
    hl.exec_cmd("hyprctl setcursor 'miku-cursor-linux' 32")
    
    -- Bar / panel
    hl.exec_cmd("~/.config/waybar/waybar-switcher/current.sh")
    
    -- daemon
    -- hl.exec_cmd("skwd-daemon")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("eww-daemon")
    hl.exec_cmd("quickshell")

    -- Applets
    hl.exec_cmd("nm-applet")

    -- Notifications
    hl.exec_cmd("swaync")

    -- Applications
    hl.exec_cmd("Telegram -startintray")
    hl.exec_cmd("vesktop --start-minimized && hyprctl dispatch minimize active")
    hl.exec_cmd("fdm --minimized")
    hl.exec_cmd("heroic")
    hl.exec_cmd("steam -silent")
    hl.exec_cmd("kdeconnectd")
    hl.exec_cmd("/usr/lib/hyprpolkitagent/hyprpolkitagent")
    hl.exec_cmd('chromium --app=https://web.whatsapp.com')
    
    -- Idle manager (auto lock)
    hl.exec_cmd("hypridle")

    -- Other
    hl.exec_cmd("mouse_invert")
    hl.exec_cmd("wl-paste --watch cliphist store")
end)