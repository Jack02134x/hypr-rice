status=$(playerctl status 2>/dev/null)

case "$status" in
    Playing) icon="" ;;
    Paused)  icon="" ;;
    *) exit 0 ;;
esac

title=$(playerctl metadata --format '{{ xesam:title }}' 2>/dev/null)
[ -z "$title" ] && exit 0

max=40
if [ ${#title} -gt $max ]; then
    title="${title:0:$((max-1))}…"
fi

printf "%s %s\n" "$icon" "$title"
