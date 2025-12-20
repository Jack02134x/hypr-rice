i="$1"

is_number() {
  local input="$1"
  if [[ "$input" =~ ^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$ ]]; then
    return 0 # True (it's a number)
  else
    return 1 # False (it's not a number)
  fi
}
if is_number "$i"; then
    pactl set-sink-volume @DEFAULT_SINK@ "$i"%
else
    pactl set-sink-mute @DEFAULT_SINK@ toggle

fi
