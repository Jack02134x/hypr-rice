import os
import random
import time

os.system("swww-daemon")

with os.popen("ls ~/wallpapers/static_unsorted_wallpapers/") as f:
    data = f.read()

files = data.split("\n")

while files:
    wall = random.choice(files)
    os.system(
        f"cp '/home/jack/wallpapers/static_unsorted_wallpapers/{wall}' /home/jack/.config/hypr/hyprlock/wall; echo {wall} > /home/jack/.scripts/wallname.txt; swww img '/home/jack/wallpapers/static_unsorted_wallpapers/{wall}' --transition-type any & matugen image '/home/jack/wallpapers/static_unsorted_wallpapers/{wall}' & "
    )
    files.remove(wall)
    time.sleep(150)
