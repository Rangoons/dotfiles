# Lazy load nvm for faster shell startup
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() {
  unset -f node
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  node "$@"
}
npm() {
  unset -f npm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npm "$@"
}
npx() {
  unset -f npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  npx "$@"
}
# history setup
HISTFILE=$HOME/.zhistory
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
alias ls="ls  -A -F -G"
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
  eval "$(oh-my-posh init zsh --config ~/rosepine.omp.json)"
fi
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# bun completions
# [ -s "/Users/brendan.mcdonald/.bun/_bun" ] && source "/Users/brendan.mcdonald/.bun/_bun"
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator 
export PATH=$PATH:$ANDROID_HOME/platform-tools
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
BREW_PREFIX="/opt/homebrew"
export LIBRARY_PATH="$BREW_PREFIX/lib:$LIBRARY_PATH"
export C_INCLUDE_PATH="$BREW_PREFIX/include:$C_INCLUDE_PATH"
# Teleport
alias klogin="tsh logout; tsh login --proxy=prizepicks.teleport.sh --auth=jc"
alias klogout="tsh logout"
alias kdev="tsh kube login dev01-gcpdev-us-east4"
alias kstage="tsh kube login staging01-gcpstg-us-east4"
alias kterm="kubectl exec --stdin --tty prizepicks-rails-utility-0 -n rails-api -c prizepicks-rails-utility -- /bin/bash"
alias pp:nuke:packages="find packages -path 'packages/eslint-plugin-custom-rules' -prune -o -type d -name dist -exec rm -rf {} + && find packages -type d -name node_modules -exec rm -rf {} +"
# opencode
export PATH=/Users/brendan.mcdonald/.opencode/bin:$PATH

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
