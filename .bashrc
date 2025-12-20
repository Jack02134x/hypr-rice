#
# ~/.bashrc
#

fish

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias python="source ~/pyenv/bin/activate && python"
alias pip="source ~/pyenv/bin/activate && pip"
alias h="hyprland"
alias pw="startplasma-wayland"
alias px="startx"
alias ..="cd .."
alias q="exit"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

PS1='[\u@\h \W]\$ '

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/applications:$PATH"
