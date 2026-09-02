import os
import random
import time


interval = 150
os.system("swww-daemon")
current_waybar = "/home/jack/.config/waybar/waybar-switcher/current.sh"
with os.popen("ls ~/wallpapers/static_unsorted_wallpapers/") as f:
        wall_static = f.read()
static = wall_static.split("\n")

def live_grep():
    with os.popen("ls ~/wallpapers/VideoWallpapers/") as f:
        wall_live = f.read()
    return wall_live.split("\n")

live = live_grep()

def static_slidshow():
    wall = random.choice(static)
    os.system(f"cp '/home/jack/wallpapers/static_unsorted_wallpapers/{wall}' /home/jack/.config/hypr/hyprlock/wall; bash {current_waybar} & swww img '/home/jack/wallpapers/static_unsorted_wallpapers/{wall}' --transition-type random & matugen image '/home/jack/wallpapers/static_unsorted_wallpapers/{wall}'")
    os.system(f"echo {wall} > ~/.scripts/wallname.txt")
    static.remove(wall)
    time.sleep(interval)

def live_slidshow():
    if not live:
        live_grep()
    livewall = random.choice(live)
    os.system(f"pkill mpvpaper; prime-run mpvpaper -o '--no-audio --loop --hwdec=nvdec --cache=no --demuxer-max-bytes=32M --demuxer-max-back-bytes=16M --vd-lavc-threads=2 --vf=fps=60 --vo=gpu-next --load-scripts=no' eDP-1 ~/wallpapers/VideoWallpapers/{livewall} & bash {current-waybar} & echo {livewall} > ~/.scripts/wallname.txt;")
    time.sleep(interval)
    os.system("pkill mpvpaper")
    live.remove(livewall)

while True:
    c = random.choice([1,2])
    if c == 1:
        static_slidshow()
    elif c == 2:
        live_slidshow()
