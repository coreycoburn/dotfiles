###########################################################
# Shortcuts
###########################################################

alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias src="source $HOME/.zshrc"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias c="clear"

###########################################################
# Directories
###########################################################

alias dotfiles="pstorm $DOTFILES"
alias zshconfig="pstorm $HOME/.zshrc"
alias library="cd $HOME/Library"
alias dev="cd $HOME/Dev"

###########################################################
# Docker
###########################################################

alias docker-composer="docker-compose"

###########################################################
# Git
###########################################################

alias ga='git add'
alias gaa='git add --all'
alias gb="git branch"
alias gba="git branch --all"
alias gbd='git branch --delete'
alias gs="git status"
alias gch="git checkout"
alias gc='git commit --verbose'
alias gcb='git checkout -b'
alias gl="git log --oneline --decorate --color"
alias diff="git diff"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias nah="git reset --hard && git clean -df"
alias pull="git pull"
alias push="git push"

###########################################################
# General Laravel
###########################################################

alias fresh="artisan migrate:fresh --seed"
alias seed="artisan db:seed"
