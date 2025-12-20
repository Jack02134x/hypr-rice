import os

the_file = "Yt-playlist.txt"

if not os.path.exists(the_file):
    with open(the_file, 'w') as f:
        pass

def reading():
    with open(the_file, 'r') as f:
        content = f.read()
        return content if content else "Your playlist is empty!"

def saving(fetched_link):
    with open(the_file, 'a') as f:
        f.write(fetched_link + "\n")
    print("Link added to your downloaded playlist.")

def streaming():
    print("Streaming is now independent of the playlist.")
    usr_link = input("Enter the YouTube link to stream: ").strip()
    if usr_link:
        os.system(f"yt-dlp -f bestaudio -o - '{usr_link}' | mpv --no-video -")
    else:
        print("No link provided. Returning to menu.")

def downloading():
    usr_link = input("Enter the YouTube link to download: ").strip()
    if usr_link:
        os.system(f"yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 -o 'music/%(title)s.%(ext)s' '{usr_link}'")
        saving(usr_link)
        print("Download complete and link added to the playlist.")
    else:
        print("No link provided. Returning to menu.")

def playing_playlist():
    with os.popen('ls music') as pipe:
        data = pipe.read()
    music = data.splitlines()
    for i in music:
        os.system(f"mpv --no-video 'music/{i}' ")

def main():
    while True:
        try:
            choice = int(input("""
This small program allows you to stream or download YouTube music using YouTube links.
Choose an option:
1. Play audio (stream without saving)
2. Download audio (and save to playlist)
3. View your downloaded playlist
4. Play your entire playlist
5. Exit
Enter your choice: """))

            if choice == 1:
                streaming()
            elif choice == 2:
                downloading()
            elif choice == 3:
                print(f"\nYour downloaded playlist:\n{reading()}\n")
            elif choice == 4:
                playing_playlist()
            elif choice == 5:
                print("Exiting program. Goodbye!")
                break
            else:
                print("Invalid choice. Please try again.")
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 4.")

if __name__ == "__main__":
    main()
