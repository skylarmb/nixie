. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

# profile shell startup time
if [[ -n "$DEBUG_ZPROF" ]]; then
  zmodload zsh/zprof
fi
zmodload zsh/parameter
autoload -U add-zsh-hook

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"
ZSH_THEME="af-magic-ansi"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# export POWERLEVEL9K_INSTANT_PROMPT=quiet
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---------------- SHELL ----------------

# use vim navigation
set -o vi
setopt +o nomatch

# increase the number of files a terminal session can have open
ulimit -n 16384

# dont prompt when rming glob patterns
setopt rmstarsilent

# zsh options
ZSH_DISABLE_COMPFIX="true"
# use hyphen-insensitive completion. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="false"
# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# Performance optimzations
# DISABLE_UPDATE_PROMPT="true"

# compinit, runs once a day
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;
# easily rename filenames to kebab-case
autoload -Uz zmv
autoload -Uz edit-command-line
bindkey "^X^E" edit-command-line

# Word movement bindings for Alt+Left/Right and Ctrl+b/f
# These match the wezterm key bindings which send ESC+b and ESC+f
bindkey '\eb' backward-word
bindkey '\ef' forward-word

# Word deletion bindings for Alt+Backspace and Alt+d
# These match the wezterm key bindings which send ESC+DEL and ESC+d
bindkey '\e\x7f' backward-delete-word
bindkey '\ed' delete-word
zstyle ':completion:*' completer _expand_alias _complete _ignored
export ZSH_EXPAND_ALL_DISABLE="word,alias"
bindkey "^X^X" expand-all

# ---------------- USER CONFIG ----------------

## Private
# .private should define:
# - $WORKSPACE
# - $GITHUB_TOKEN
# - $GITHUB_EMAIL
# - $TMUX_DEFAULT_PATH
# - $DOCKER_CERT_PATH, $DOCKER_HOST, $DOCKER_TLS_VERIFY, etc
if [ -d "$HOME/.private" ]; then
  source "$HOME/.private/.zshrc"
fi

# ---------------- ENV ----------------
fpath=($fpath "$HOME/.zfunctions")

# shell
export GPG_TTY=$(tty)
export PERIOD="1"
export EDITOR='nvim'
export LESS='--RAW-CONTROL-CHARS'
export THEME="$(tmux show-environment -g THEME 2>/dev/null | sed 's/THEME=//g')"
if command -v lesspipe.sh &>/dev/null; then
  export LESSOPEN='|~/.lessfilter %s'
fi
# if command -v bat &>/dev/null; then
export BAT_THEME="base16"
#   export PAGER="$BAT_CMD"
#   export MANPAGER="$BAT_CMD"
# fi

# PATH
export ANDROID_HOME="~/Library/Android/sdk"
export GIT_EDITOR="$EDITOR"
export GO111MODULE=on
export GOPATH="$HOME/go";
export GOBIN="$GOPATH/bin";
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
export MANPATH="/usr/local/man:$MANPATH"
export PATH="$HOME/.local/share/npm/bin:$PATH"
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$PATH:$GOBIN";
export PATH="$PATH:/Applications/Sublime Text.app/Contents/SharedSupport/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/dotfiles/bin"
export PATH="$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin"
# export DOCKER_HOST="unix:///run/user/1000/podman/podman-machine-default-api.sock"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# brew
# eval "$(/opt/homebrew/bin/brew shellenv)"

# pyenv
export SYSTEM_PYTHON="/usr/bin/python3"
export PATH="$HOME/.pyenv/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# config
export BAT_PAGER="less -F -x4"
export PYTHONWARNINGS="ignore"
export FZF_ALT_C_COMMAND="fd --ignore-file .gitignore -t d"
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
export FZF_CTRL_R_OPTS="--reverse --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_DEFAULT_COMMAND='rg -l --follow --color=never --hidden ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export BAT_PREVIEW_COMMAND="bat --color=always --paging=never --line-range :200 {}"
export FZF_DEFAULT_OPTS="--ansi --no-mouse --inline-info --border"
export TMUX_FZF_OPTIONS="-p -w 75% -h 75% -m"
export TMUX_FZF_WINDOW_FORMAT="[#{window_name}] #{pane_current_command}"
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins"
# export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export DEFAULT_USER=$USER
export DOTFILES_DIR="$HOME/nixie/dotfiles"
export WORKSPACE="$HOME/workspace"
# ---------------- ALIAS ----------------

# alias v='nv'
alias v='nvim'
alias vi='v' # dont open mega-broken vi/vim
alias vim='v' # dont open mega-broken vi/vim
alias vo='FZF_DEFAULT_COMMAND="git ls-files | sort -nr" fzf_edit_file'
alias b='git checkout -b'
alias voo='fzf_edit_file'
alias vc='fzf_edit_grep'
alias q='exit'
alias qq='q'
alias qa='q'
alias :q='q'
alias :qa='q'
alias :h='nvim_help'
alias :man='f(){ nvim "+:Man $* | only" };f'
alias tt="nvim +'execute \"ToDoTxtTasksToggle\" | wincmd o'"
alias tn="nvim +'execute \"ToDoTxtTasksToggle\" | wincmd o | execute \"ToDoTxtTasksCapture\"'"
alias workspace="cd $WORKSPACE"
alias dotfiles="cd $DOTFILES_DIR"
alias vimc="cd $DOTFILES_DIR/.config/nvim && nvim . && cd -"
alias vimcd="cd $DOTFILES_DIR/.config/nvim && $EDITOR ."
alias cdd='cd_dirname'
alias zc="$EDITOR $DOTFILES_DIR/.zshrc && exec zsh"
alias gitc="$EDITOR $DOTFILES_DIR/.config/git/config"
alias zcp="$EDITOR $HOME/.private/.zshrc && exec zsh"
alias alc="$EDITOR $DOTFILES_DIR/.config/alacritty/alacritty.toml"
alias wtc="$EDITOR $DOTFILES_DIR/.wezterm.lua"
alias tc="$EDITOR $DOTFILES_DIR/.config/tmux/tmux.conf"
alias tcc="$EDITOR $DOTFILES_DIR/.config/tmux/colorscheme.conf"
alias hc="cd $HOME/nixie && nvim ./home.nix"
alias hs='home-manager switch --flake "$HOME/nixie#$USER@$(uname -s | tr A-Z a-z)"'
alias nrs='sudo nixos-rebuild switch --flake "$HOME/nixie#nixos"'
alias zu='exec zsh'
alias dka='docker kill $(docker ps -q)'
alias vimwipe='rm -rf $HOME/.vim/tmp/swap; mkdir -p $HOME/.vim/tmp/swap'
alias g='git'
alias cc='git rev-parse HEAD | pbcopy'
alias ccwd='pwd | pbcopy'
alias unwip='git reset --soft HEAD~'
alias vm='cd $(git rev-parse --show-toplevel) && nvim `git --no-pager diff --name-only --diff-filter=U`'
alias todo='gg "todo before"'
alias installglobals='npm install -g prettier diff-so-fancy neovim npm-why serve serverless nodemon markdown-toc ts-node lebab'
alias scr='v $WORKSPACE/scratchpad/scratch.tsx'
alias tm='tmux a -t main || tmux new -s main'

# Use function instead of alias to detect if output is a TTY
cat() {
  if [[ -t 1 ]]; then
    # stdout is a terminal - use fancy styles
    bat --style=plain,header,grid "$@"
  else
    # stdout is redirected/piped - use plain output
    bat --style=plain "$@"
  fi
}
alias ccat='command cat'
# alias ag='ag --path-to-ignore ~/.ignore'
alias notes='cd ~/notes'
alias aa='cp ~/notes/all_around.template.md ~/notes/candidates/new.md && v ~/notes/candidates/new.md'
alias todo='v ~/notes/life.todo.md'
alias fgf='fg %$(jobs | fzf | grep -Eo "[0-9]{1,}" | head -1)'
alias p='pnpm'
alias pi='pnpm install'
alias plr='git checkout origin/master **/pnpm-lock.yaml && pnpm install'
alias prs='gh pr status'
alias w='~/.tmux/plugins/tmux-fzf/scripts/window.sh switch'
alias ta='tmux new-session -A -s main -t main'
alias psg='ps aux | grep'
# switch between light and dark themes
# alias tl="export THEME=light; tmux set-environment THEME 'light'; tmux source-file ~/.tmux.conf; alacritty-themes Atelierdune.light;"
# alias td="export THEME=dark; tmux set-environment THEME 'dark'; tmux source-file ~/.tmux.conf; alacritty-themes Atelierdune.dark;"
# alias tm="tmux select-layout main-horizontal; tmux resize-pane -y80% -t 1;"
# alias python="$(pyenv which python3)"
# alias pip="$(pyenv which pip3)"
# alias brewfast='HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew'
alias nd="nix develop -c $SHELL"
alias pr='poetry run'
alias dr='docker run -it --rm'
alias dive="docker run -ti --rm  -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/joschi/dive"
alias ch='claude --model haiku'
alias cs='claude --model sonnet'
alias gs='git switch -'
alias cursor='cursor-agent'

# ---------------- PLUGINS ----------------
#
# if [[ -n "$DEBUG_ANTIGEN" ]]; then
#   cat $ANTIGEN_LOG
# fi
# If there is cache available
if [[ -f ${ADOTDIR:-$HOME/.antigen}/.cache/.zcache-payload ]]; then
    # Load bundles statically
    source ${ADOTDIR:-$HOME/.antigen}/.cache/.zcache-payload
    # You will need to call compinit
    autoload -Uz compinit
    compinit -d ${HOME}/.zcompdump
else
    # If there is no cache available, load normally and create cache
    source $HOME/antigen.zsh
    antigen init $HOME/.antigenrc
fi

bindkey '^Xh' _complete_help
# bindkey '\t' autosuggest-accept

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions'   format '[%d]'
zstyle ':completion:*'                list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*'                menu no
zstyle ':fzf-tab:complete:cd:*'       fzf-preview 'eza --all -1 --color=always $realpath'
zstyle ':fzf-tab:complete:eza:*'      fzf-preview 'eza --all -1 --color=always $realpath'
zstyle ':fzf-tab:*'                   fzf-flags --bind=enter:accept --min-height=20 --height=20 --border
zstyle ':fzf-tab:*'                   continuous-trigger 'tab'
zstyle ':fzf-tab:*'                   accept-line enter

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

source <(fzf --zsh)
# enable-fzf-tab

cd_dirname() {
  cd "$(dirname ${1})"
}

vr() {
  nvim --server "$PWD/.nvimsocket" --remote-tab "$@" && nvim --server "$PWD/.nvimsocket" --remote-ui
}

vs() {
  rm -f "$PWD/.nvimsocket"
  nvim --listen "$PWD/.nvimsocket" --headless
}

# ---------------- FUNCTIONS ----------------
c(){
  git commit -m "$*"
}

esld(){
  local ext=".ts,.tsx,.js,.jsx"
  nodemon -w . \
    --ext "$ext" \
    --exec "eslint_d . --cache --ext $ext --quiet"
}

eslw(){
  pnpm esw . --cache --color --watch --changed --clear --fix --ext .ts,.tsx,.js,.jsx --quiet "${@}"
}

# Run the command given by "$@" in the background
silent_background() {
  setopt local_options no_notify no_monitor
  "$@" &|
}

switch_to_app() {
  osascript -e "tell application \"${1}\"" -e 'activate' -e 'end tell'
}

alias ff='fd'
alias _eza='eza --all --oneline --group-directories-first --no-user --git'
alias ls='_eza'
alias cls='clear;_eza'
alias clsa='clear;_eza -a'
alias lsa='_eza -lah'

t() {
  local d="${1}"
  [[ "${d}" =~ ^[0-9]+$ ]] && shift || d=1
  local t="${1:-.}"
  _eza --git-ignore -T -L$d $t
}

git_nvim(){
  local repo="$(git rev-parse --show-toplevel)"
  if [[ -z "$repo" ]]; then
    vo
  else
    git ls-files --full-name ${repo} | fzf
  fi
}

wip() {
  git add -A;
  git commit --no-verify -m "squash! ... WIP: ${*}"
}


alias ws='cd_workspace'
cd_workspace() {
  if [[ ! -z "${@}" ]]
  then
    cd "${WORKSPACE}/${@}"*
  else
    cd "${WORKSPACE}"
  fi
}

fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

fzf_query() {
  fzf --preview="$BAT_PREVIEW_COMMAND" --query="${@}"
}

alias vl="edit_last_file"
edit_last_file(){
 nvim "+normal! g'0" ""
}

# vim fuzzy open by filename with preview
fzf_edit_file() {
  fzf \
  --preview-window 'up,60%,border-bottom,+{2}+3/3' \
  --preview 'bat --color=always -r 0:100 {1} ' \
  --bind 'enter:become(nvim {1} +{2})'
}

# vim fuzzy open by file contents with preview and highlighted line
fzf_edit_grep() {
  rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~1' \
        --bind 'enter:become(nvim {1} +{2})'
}

# fbr - checkout git branch (including remote branches)
alias fbt='fzf_branches'
fzf_branches() {
  local branches branch
  branches=$(git branch --all --sort=-committerdate | grep -v -e HEAD -e remotes) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}


# fzf my PRs, return the PR number
fzf_pr_number() {
  local pr ghprs
  ghprs="$(GH_FORCE_TTY='50%' gh pr list --author @me)"
  pr=$( \
    echo "$ghprs" | \
    fzf \
      --ansi \
      --header-lines 3 \
      --preview 'GH_FORCE_TTY=$FZF_PREVIEW_COLUMNS gh pr view {1}' \
  )
  echo "$(echo "$pr" | awk '{print $1}')"
}

alias fpr='fzf_checkout_pr'
fzf_checkout_pr() {
  gh pr checkout "$(fzf_pulls)"
}

alias vlf='fzf_last_commit'
fzf_last_commit() {
  v "$(git rev-parse --show-toplevel)/$(git diff HEAD^ HEAD --name-only | fzf)"
}

alias vpr='v $(fzf_all_pr_files)'
fzf_all_pr_files() {
  echo "$(git rev-parse --show-toplevel)/$(git diff master...HEAD --name-only | fzf)"
}

dns() {
  curl -sI $1 | grep -E '(301|302|Server|Location|X-Cache|HTTP)'
}

confirm() {
  # call with a prompt string or use a default
  read "response?Are you sure? [y/N]"
  if [[ "$response" =~ ^[Yy]$ ]]
  then
    return 0
  fi
  return 1
}

# eval history
alias h='fzf_history'
fzf_history() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | gsed -r 's/ *[0-9]*\*? *//' | gsed -r 's/\\/\\\\/g')
}

randomsay() {
  cow=(`cowsay -l | tail -n +2 | tr  " "  "\n" | sort -R | head -n 1`)
  cowsay -f $cow "$@" | lolcat
}

alias why='grep_inuse_ports'
grep_inuse_ports() {
  if [[ -n "${1}" ]]; then
    lsof -nP -i4TCP:"${1}" | grep LISTEN
    return
  fi
  lsof -nP -i4TCP | grep LISTEN
}

alias portkill='kill_port_process'
kill_port_process() {
  if [[ -z "${1}" ]]; then
    echo "Usage: portkill <port>"
    return 1
  fi

  local processes=$(lsof -nP -i4TCP:"${1}" | grep LISTEN)

  if [[ -z "$processes" ]]; then
    echo "No processes found listening on port ${1}"
    return 1
  fi

  echo "Processes listening on port ${1}:"
  echo "$processes"

  local pids=$(echo "$processes" | awk '{print $2}')

  if confirm "Kill these processes?"; then
    echo "$pids" | xargs kill
    echo "Killed processes: $pids"
  else
    echo "Cancelled"
  fi
}

# replace() {
#     local search_pattern=$1
#     local replacement=$2
#     rg -F -l "$search_pattern" | xargs -I{} sed -i "s|$search_pattern|$replacement|g" {}
# }
replace () {
    local search_pattern=$1
    local replacement=$2
    rg -F -l "$search_pattern" | xargs -I{} sd -F "$search_pattern" "$replacement" {}
}
# ag / the_silver_searcher


export HG_DEFAULT_OPTS=(
  --follow
  --hidden
  --grid
  --printer=bat
  --wrap=never
  --fixed-strings
  --glob='!*.map'
  --glob='!pnpm-lock.yaml'
)

ag_default_cmd(){
  env BAT_PAGER="" BAT_STYLE="plain" \
    hgrep "${HG_DEFAULT_OPTS[@]}" "${@}" | \
    rg --passthru --no-line-number "${@}"
}

alias bg='batgrep'
alias gg='ag_default_cmd'
alias ggf='ag_default_cmd --files-with-matches'
alias gga='ag_with_context'
alias ggg='ag_default_cmd --skip-vcs-ignores'

debug() {
  if [[ "${DEBUG}" ]]; then
    return
  fi
  echo "DEBUG: $@" >&2
}

ag_with_context(){
  local c="${1}"
  shift
}

nvim_help(){
  nvim +":help ${*}" +:only
}

nvim_man(){
  nvim +":Man ${*}" +:only
}

help() {
  local c="${1}"
  [[ "${c}" =~ ^[0-9]+$ ]] && shift || c=10
  local cmd="${1}"
  shift
  local query="${@}"
  local sep="#$(printf -- '─%.0s' {1..80})"
  rg_query() { rg --color=never -NFi -C"${c}" --context-separator="${sep}" "${query}" "${1}" ; }
  batman() {
    bat -l man \
    --color=always \
    --style=numbers \
    --theme=$BAT_THEME \
    --wrap=never \
    --pager=never "${@}"
  }
  batman <(cat <<ENDHELP
${sep}
MANPAGE:
${sep}
$(rg_query <(man -Pcat "${cmd}" 2>/dev/null | col -b))
${sep}
HELP:
${sep}
$(rg_query <("${cmd}" --help || "${cmd}" -h || "${cmd}" -? | col -b))

ENDHELP

)
}

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=150 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}


es6() {
  lebab $1 -o $1 --transform commonjs
  lebab $1 -o $1 --transform no-strict
  lebab $1 -o $1 --transform obj-shorthand
  lebab $1 -o $1 --transform let
  lebab $1 -o $1 --transform arrow
  lebab $1 -o $1 --transform arrow-return
}

toggle_tmux_popup() {
  if [ "$(tmux display-message -p -F "#{session_name}")" = "popup" ];then
      tmux detach-client
  else
      tmux popup -d '#{pane_current_path}' -xC -yC -w80% -h75% -E "tmux attach -t popup || tmux new -s popup"
  fi
}

_nvr="$(which nvr)"
nvr_socket="/tmp/nvimsocket"
nvrd() {
  nohup nvim --listen ${nvr_socket} --headless >/dev/null &
  nvim --server ${nvr_socket} --remote-send ":e /tmp/.KEEPALIVE<CR>:call KeepAlive()<CR>"
}

# get the hex bytes of a string, e.g. for getting tmux/alacritty key codes
gethex(){
  echo -n "${*}" | xxd -g 1
}

awkp(){
  awk "{print \$${1}}"
}

startswith(){
  grep -F "^${*}"
}

# re-instal nix after a system update
renix() {
  sudo mv /etc/zshrc.backup-before-nix /etc/zshrc
  sudo mv /etc/bash.bashrc.backup-before-nix /etc/bash.bashrc
  sudo mv /etc/bashrc.backup-before-nix /etc/bashrc
  sh <(curl -L https://nixos.org/nix/install)
}

# Profiler
if [[ -n "$DEBUG_ZPROF" ]]; then
  zprof
fi

# bun completions
[ -s "/Users/skylar/.bun/_bun" ] && source "/Users/skylar/.bun/_bun"

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

eval "$(direnv hook zsh)"

# Auto tmux window naming using tmux-window-name plugin
tmux-window-name() {
  if [[ -z "$TMUX" ]]; then
    return
  fi

  # Trigger the tmux-window-name plugin
  PYTHONPATH="$($SYSTEM_PYTHON -m site --user-site)" $SYSTEM_PYTHON ~/.local/share/tmux/plugins/tmux-window-name/scripts/rename_session_windows.py
}

# Auto tmux window naming - run on directory change and periodically
if [ ! -z "$TMUX" ]; then
  add-zsh-hook chpwd tmux-window-name
  add-zsh-hook periodic tmux-window-name
fi
