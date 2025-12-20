if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
    random choice "Hello!" "Hi" "Konnichiwas" "Howdy"
end

alias ls='ls'
alias grep='grep --color=auto'
alias pyon="source ~/pyenv/bin/activate.fish; python"
alias pipon="source ~/pyenv/bin/activate.fish; pip"
alias h="hyprland"
alias pw="startplasma-wayland"
alias px="startx"
alias ..="cd .."
alias q="exit"
#alias cava="foot -e cava"
#alias cmatrix="foot -e cmatrix"


export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

fastfetch
