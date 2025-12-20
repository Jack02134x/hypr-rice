import os
import random

script_dir = os.path.dirname(os.path.abspath(__file__))
music_dir = os.path.join(script_dir, "music")

if not os.path.exists(music_dir):
    exit(1)

with os.popen(f'ls "{music_dir}"') as pipe:
    data = pipe.read()

result = data.splitlines()  
total = len(result)

if total == 0:
    exit(1)

e = list(range(total))
try:        
    while e:
        k = random.choice(e)
        file_path = os.path.join(music_dir, result[k])
        os.system(f"mpv --no-video '{file_path}'")
        e.remove(k)
except:
    print("An unexpected error occurred")
