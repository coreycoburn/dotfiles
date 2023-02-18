###########################################################
# NEUTRINO ALIASES AND FUNCTIONS
# Feel free to make a pull request to add your own aliases
###########################################################

# General
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias src="source $HOME/.zshrc"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
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
# Paths
amp_path="$NEUTRINO_DIR/amp-dashboard"

# Open AMP repo in PhpStorm
alias amp="pstorm $amp_path"

# Change directory to AMP
alias cdamp="cd $amp_path"

###########################################################
# DASH
###########################################################
# Paths
dash_path="$NEUTRINO_DIR/dash"
dash_api_path="$dash_path/dash-api"
dash_client_path="$dash_path/dash-client"

# Open DASH repos in PhpStorm
alias dash="pstorm $dash_path"
alias dashapi="pstorm $dash_api_path"
alias dashclient="pstorm $dash_client_path"

# Change directory to DASH repos
alias cddash="cd $dash_path"
alias cddashapi="cd $dash_api_path"
alias cddashclient="cd $dash_client_path"

###########################################################
# Commands for all projects
###########################################################
# Run PHP commands in Docker containers
function php() {
 case $PWD in
   $dash_api_path)
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
   $dash_api_path)
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
  $dash_api_path)
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
   $dash_api_path)
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
   $dash_api_path)
     sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=off/g" ../.docker/env/.env.api
     docker-compose --file ../docker-compose.yml up -d api
     ;;
   *)
     echo "Xdebug off command not found for this project."
     ;;
   esac
}
