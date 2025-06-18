#
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"
# ---- Eza (better ls) -----
alias ls="eza --color=always --icons=always"
# ---- Mise version manager -----
eval "$(~/.local/bin/mise activate)"
function update_theme_mode() {
  if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
    export THEME_MODE="dark"
  else
    export THEME_MODE="light"
  fi
}

precmd_functions+=(update_theme_mode)
# --- Oh My Posh ---
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config /Users/brendanmcdonald/rosepine.omp.json)"
fi

# bun completions
[ -s "/Users/brendanmcdonald/.bun/_bun" ] && source "/Users/brendanmcdonald/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ----- thefuck alias -----
eval $(thefuck --alias)
eval $(thefuck --alias fk)
# ----- Bat (better cat) -----
export BAT_THEME=Dracula
# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}
# ---- FZF theme ----
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#f8f8f2,fg+:#f8f8f2,bg:#282a36,bg+:#44475a
  --color=hl:#bd93f9,hl+:#bd93f9,info:#ffb86c,marker:#ff79c6
  --color=prompt:#50fa7b,spinner:#ffb86c,pointer:#ff79c6,header:#6272a4
  --color=border:#262626,label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="fzf" --border-label-pos="0" --preview-window="border-rounded"
  --prompt="> " --marker=">" --pointer="👉" --separator="─"
  --scrollbar="│"'
  eval "$(fzf --zsh)"
  source ~/fzf-git.sh/fzf-git.sh
  ## ascii
# echo "    .__________________________."
# echo "    | .___________________. |==|"
# echo "    | | ................. | |  |"
# echo "    | | ::::Apple ][::::: | |  |"
# echo "    | | ::::::::::::::::: | |  |"
# echo "    | | ::::::::::::::::: | |  |"
# echo "    | | ::::::::::::::::: | |  |"
# echo "    | | ::::::::::::::::: | |  |"
# echo "    | | ::::::::::::::::: | | ,|"
# echo "    | !___________________! |(c|"
# echo "    !_______________________!__!"
# echo "   /                            \\"
# echo "  /  [][][][][][][][][][][][][]  \\"
# echo " /  [][][][][][][][][][][][][][]  \\"
# echo "(  [][][][][____________][][][][]  )"
# echo " \\ ------------------------------ /"
# echo "  \\______________________________/"

# pnpm
export PNPM_HOME="/Users/brendanmcdonald/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
