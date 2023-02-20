###########################################################
# NEUTRINO ALIASES AND FUNCTIONS
# Feel free to make a pull request to add your own aliases
###########################################################

# General
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias src="source $HOME/.zshrc"
alias c="clear"

# Change directory to Neutrino
alias cdneutrino="cd $NEUTRINO_DIR"

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

###########################################################
# AMP
###########################################################

# Open AMP repo in PhpStorm
alias amp="pstorm $AMP_DIR"

# Change directory to AMP
alias cdamp="cd $AMP_DIR"

###########################################################
# DASH
###########################################################

# Open DASH repos in PhpStorm
alias dash="pstorm $DASH_DIR"
alias dashapi="pstorm $DASH_API_DIR"
alias dashclient="pstorm $DASH_CLIENT_DIR"

# Change directory to DASH repos
alias cddash="cd $DASH_DIR"
alias cddashapi="cd $DASH_API_DIR"
alias cddashclient="cd $DASH_CLIENT_DIR"

###########################################################
# Functions for all projects
###########################################################
# Run PHP commands in Docker containers
function php() {
 case $PWD in
   $DASH_API_DIR)
     docker-compose --file ../docker-compose.yml exec api php "$@"
     ;;
   *)
     echo "PHP command not found for this project."
     ;;
   esac
}

# Run Composer commands in Docker containers
function composer() {
 case $PWD in
   $DASH_API_DIR)
     docker-compose --file ../docker-compose.yml exec api composer "$@"
     docker cp $(docker-compose --file ../docker-compose.yml ps -q api):/var/www/html/vendor .
     ;;
   *)
     echo "Composer command not found for this project."
     ;;
   esac
}

# Run Artisan commands in Docker containers
function artisan() {
  case $PWD in
  $DASH_API_DIR)
    docker-compose --file ../docker-compose.yml exec api php artisan "$@"
    ;;
  *)
    echo "Artisan command not found for this project."
    ;;
  esac
}

# Turn Xdebug on
function xoff() {
 case $PWD in
   $DASH_API_DIR)
     sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=debug,develop/g" ../.docker/env/.env.api
     docker-compose --file ../docker-compose.yml up -d api
     ;;
   *)
     echo "Xdebug on command not found for this project."
     ;;
   esac
}

# Turn Xdebug off
function xoff() {
 case $PWD in
   $DASH_API_DIR)
     sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=off/g" ../.docker/env/.env.api
     docker-compose --file ../docker-compose.yml up -d api
     ;;
   *)
     echo "Xdebug off command not found for this project."
     ;;
   esac
}
