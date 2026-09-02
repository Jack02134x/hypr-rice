# Quickshell launcher

Run the launcher from this directory with:

```sh
qs -p /home/jack/.config/quickshell
```

The launcher starts hidden but remains active. Type to search, use the arrow keys to select an entry, press Enter to launch it, and press Escape to close it. Selecting an application with Enter or a click also closes the launcher.

The search field also supports these modes:

- `$ command`: run a shell command when Enter is pressed.
- `# search terms`: search Google in Firefox when Enter is pressed. A hostname or URL such as `#example.com` or `#https://example.net/path` opens directly instead.
- `c expression`: calculate using parentheses, `+`, `-`, `*`, `/`, `%`, and `^`. Results update as you type and follow normal operator precedence.
- `w name`: browse and filter images from `/home/jack/wallpapers/ilike/`. Use Up/Down to select a preview and Enter to apply it, or click a preview. Applying it uses a random `awww` transition, runs `matugen`, writes its filename without an extension to `/home/jack/.scripts/wallname.txt`, and copies it to `/home/jack/wallpapers/wall`.

Wallpaper previews are read directly from the folder on each use. The launcher creates no image cache.

It exposes an IPC target named `launcher`, which makes it easy to connect to a compositor keybind:

```sh
qs ipc call launcher toggle
```

Other available commands are `open` and `close`:

```sh
qs ipc call launcher open
qs ipc call launcher close
```

To toggle it with the Super key, add this to your Hyprland configuration and reload Hyprland:

```ini
bind = SUPER, SUPER_L, exec, qs ipc call launcher toggle
```

If you already use Super as a modifier, `SUPER + Space` is usually less likely to conflict:

```ini
bind = SUPER, SPACE, exec, qs ipc call launcher toggle
```

Custom commands can be added to the `launchSelected()` path in `shell.qml` as the launcher grows beyond applications.
