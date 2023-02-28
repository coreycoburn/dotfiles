#!/bin/bash

###########################################################
# NEUTRINO ALIASES AND FUNCTIONS
# Feel free to make a pull request to add your own aliases
###########################################################

# General
alias copyssh='pbcopy < "$HOME/.ssh/id_ed25519.pub"'
alias shrug='echo "¯\_(ツ)_/¯" | pbcopy'
alias src='source "$HOME/.zshrc"'
alias c="clear"

# Change directory to Neutrino
alias cdneutrino='cd "$NEUTRINO_DIR"'

###########################################################
# Git
###########################################################

alias ga='git add'
alias gaa='git add --all'
alias gb="git branch"
alias gba="git branch --all"
alias gbd="git branch --delete"
alias gs="git status"
alias gc="git checkout"
alias gcb="git checkout -b"
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
# Docker
###########################################################

alias build="./.docker/scripts/build.sh"
alias start="./.docker/scripts/start.sh"
alias stop="./.docker/scripts/stop.sh"
alias destroy="docker system prune -a"

###########################################################
# AMP
###########################################################

# Open AMP repo in PhpStorm
alias amp='pstorm "$AMP_DIR"'

# Change directory to AMP
alias cdamp='cd "$AMP_DIR"'

###########################################################
# DASH
###########################################################

# Open DASH repos in PhpStorm
alias dashapi='pstorm "$DASH_API_DIR"'
alias dashclient='pstorm "$DASH_CLIENT_DIR"'

# Change directory to DASH repos
alias cddashapi='cd "$DASH_API_DIR"'
alias cddashclient='cd "$DASH_CLIENT_DIR"'

# Run npm commands in Docker containers
alias dashnpm="docker-compose run --rm node npm"

###########################################################
# Functions for all projects
###########################################################
# Get the service name for the current project
function get_service() {
  case $PWD in
  "$AMP_DIR")
    echo "amp-app"
    ;;
  "$DASH_API_DIR")
    echo "dash-api"
    ;;
  *)
    echo "Project not found. Please add to neutrino_aliases.zsh."
    ;;
  esac
}

# Run PHP commands in Docker containers
function php() {
  docker-compose exec "$(get_service)" php "$@"
}

# Run Composer commands in Docker containers
function composer() {
  docker-compose exec "$(get_service)" composer "$@"
  docker cp "$(docker-compose ps -q "$(get_service)"):/var/www/html/vendor" .
}

# Run Artisan commands in Docker containers
function artisan() {
  docker-compose exec "$(get_service)" php artisan "$@"
}

# Turn Xdebug on
function xon() {
  sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=debug,develop/g" .docker/env/.env.app
  docker-compose up -d "$(get_service)"
}

# Turn Xdebug off
function xoff() {
  sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=off/g" .docker/env/.env.app
  docker-compose up -d "$(get_service)"
}

# SSH into AMP servers
function sshamp() {
  case "$1" in
  "prod")
    server_tld="amplistings.com"
    ;;
  "staging")
    server_tld="staging.amplistings.com"
    ;;
  "demo")
    server_tld="demo.amplistings.com"
    ;;
  *)
    echo "Server not found. Please select a server: prod, staging, or demo."
    return 1
    ;;
  esac

  if [ "$2" = "amp" ]; then
    sshpass -p "$AMP_USER_SERVER_PASSWORD" ssh -p 2080 -t "$AMP_USER_SERVER_USERNAME@$server_tld" \
      "cd /var/www/amp/amp-dashboard && bash -i"
    return 0
  fi

  sshpass -p "$PERSONAL_USER_SERVER_PASSWORD" ssh -p 2080 -t "$PERSONAL_USER_SERVER_USERNAME@$server_tld" \
    "cd /var/www/amp/amp-dashboard && bash -i"
  return 0
}
