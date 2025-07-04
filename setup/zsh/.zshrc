# sourcing exegol custom .rc source file
source /opt/.exegol_shells_rc

# Check if running in interactive mode
if [[ -o interactive ]]; then
  # ZSH setup
  export ZSH="/root/.oh-my-zsh"
  ZSH_THEME="gentoo"
  export NVM_LAZY_LOAD=true
  export NVM_COMPLETION=true

  # fzf
  export FZF_BASE=/opt/tools/fzf
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  plugins=(zsh-syntax-highlighting zsh-completions zsh-autosuggestions tmux fzf zsh-z zsh-nvm starship)

  # oh-my-zsh
  source $ZSH/oh-my-zsh.sh

  TIME_="%{$fg[white]%}[%{$fg[red]%}%D{%b %d, %Y - %T (%Z)}%{$fg[white]%}]%{$reset_color%}"

# Updated prompt using starship for environment variables
  update_prompt() {
    PROMPT="$LOGGING$TIME_$(starship prompt)%{$FX[bold]$FG[013]%} $EXEGOL_HOSTNAME %{$fg_bold[blue]%}%(!.%1~.%c) $(prompt_char)%{$reset_color%} "
  }

  add-zsh-hook precmd update_prompt

  # Color correction for zsh-syntax-highlighting
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#626262'
  ZSH_HIGHLIGHT_STYLES[comment]='fg=#888888'
else
  # Non-interactive mode - minimal setup
  ZSH_DISABLE_COMPFIX=true
  # NVM
  [ -f /root/.nvm/nvm.sh ] && source /root/.nvm/nvm.sh
fi

# Common settings regardless of interactive status
# asdf
export PATH="$PATH:${ASDF_DATA_DIR:-$HOME/.asdf}/shims"

# Golang asdf plugin
source ~/.asdf/plugins/golang/set-env.zsh
export GOPATH=$(go env GOPATH)

# asdf completions
# append completions to fpath
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# zsh history config
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export HISTTIMEFORMAT="[%F %T] "
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS

# TERM to prevent tmux not working with autosuggestion
export TERM=xterm-256color

# At the end, loads user-defined zshrc post-routines if the file exists otherwise creates a default file if my-resources is enabled in the container
if [ -f /opt/my-resources/setup/zsh/zshrc ]
then
  source /opt/my-resources/setup/zsh/zshrc
else
  [ -d /opt/my-resources/setup/zsh ] || mkdir -p /opt/my-resources/setup/zsh
  cp /.exegol/skel/zsh/zshrc /opt/my-resources/setup/zsh/zshrc
fi

# Enable gf autocompletion
compdef _gf gf

function _gf {
    _arguments "1: :($(gf -list))"
}

# genusernames function
source /opt/tools/genusernames/genusernames.function
