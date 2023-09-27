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
alias ip='curl -s ifconfig.me | tee >(pbcopy) >/dev/null && echo "Your IP address has been copied to clipboard"'

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
alias grf="gc main -- " # Resets the current branch file to the state of main branch file. Ex. grf .env.example

###########################################################
# General Laravel
###########################################################

alias fresh="a migrate:fresh --seed"
alias seed="a db:seed"

###########################################################
# Docker
###########################################################

alias build="./.docker/scripts/build.sh"
alias start="./.docker/scripts/start.sh"
alias stop="./.docker/scripts/stop.sh"
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

###########################################################
# AMP
###########################################################

# Open AMP repo in PhpStorm
#alias amp='pstorm "$AMP_DIR"'
function amp() {
    (cd "$AMP_DIR" && bash amp "$@")
}

function cire() {
    bash cire "$@"
}

function coco() {
    (bash coco "$@")
}



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

###########################################################
# Functions for all projects
###########################################################
# Automated Testing
function t() {
  if [ -n "$1" ]; then
    a test --filter "$1"
  else
    a test
  fi
}

# Run Artisan commands in Docker containers
function a() {
  docker-compose exec "$(get_app_service)" php artisan "$@"
}

# Run Artisan commands in Docker containers
function npm() {
  if [ -z "$(get_node_service)" ]; then
    echo "Docker project not found. Using host's NPM."
    command npm "$@"
  else
    if [ "$1" = "install" ] || [ "$1" = "remove" ]; then
      docker-compose up -d "$(get_node_service)"
      docker-compose exec "$(get_node_service)" npm "$@"
      docker cp "$(docker-compose ps -q "$(get_node_service)"):/app/node_modules" .
      docker-compose stop "$(get_node_service)"
    else
      docker-compose run --rm "$(get_node_service)" npm "$@"
    fi
  fi
}

# Turn Xdebug on
function xon() {
  sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=debug,develop/g" .docker/env/.env.api
  docker-compose up -d "$(get_app_service)"
}

# Turn Xdebug off
function xoff() {
  sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=off/g" .docker/env/.env.api
  docker-compose up -d "$(get_app_service)"
}

function docker_destroy() {
  echo -e "\n\e[38;2;239;68;68mWARNING! This will factory reset all Docker data\e[0m"
  echo -n "Are you sure you want to continue?  [y/N] "
  read -r answer
  if [[ "$answer" =~ ^([Yy]|[Yy][Ee][Ss])$ ]]; then
    # Process here
    echo -e "\nProcessing factory reset...\n"

    docker container stop "$(docker container ls -q)" \
      && docker container rm --force "$(docker container ls -aq)" \
      && docker container prune -f && docker image prune -f \
      && docker volume prune -f && docker system prune -a -f

    echo -e "\nAll the Docker data has been destroyed!"
  else
    echo -e "\nFactory reset canceled."
  fi
}

function docker_shell() {
  docker-compose exec "$(get_app_service)" bash
  docker-compose exec "$1" sh
}

# SSH into AMP servers
function ssh_amp() {
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
  "cire-api")
        server_tld="api.cire.amplistings.com"
        ;;
  "cire-demo")
      server_tld="cire.demo.amplistings.com"
      ;;
  "2023")
      server_tld="2023.app.amplistings.com"
      ;;
  "ai")
        server_tld="ai.amplistings.com"
        ;;
  "ssotest")
        server_tld="ssotest.amplistings.com"
        ;;
  *)
    echo "Server not found. Please select a server: prod, staging, demo, cire-demo, 2023, or ai."
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

# SSH into CIRE API servers
function ssh_cire_api() {
  case "$1" in
  "prod")
    server_tld="api.cire.amplistings.com"
    ;;
  *)
    echo "Server not found. Please select a server: prod."
    return 1
    ;;
  esac

  sshpass -p "$AMP_USER_SERVER_PASSWORD" ssh -p 2080 -t "$AMP_USER_SERVER_USERNAME@$server_tld" \
    "cd /home/amp/cire-api && bash -i"
  return 0
}

# SSH into Dash API servers
function ssh_dash_api() {
  case "$1" in
  "prod")
    server_tld="api.dash.amplistings.com"
    ;;
  *)
    echo "Server not found. Please select a server: prod."
    return 1
    ;;
  esac

  sshpass -p "$AMP_USER_SERVER_PASSWORD" ssh -p 2080 -t "$AMP_USER_SERVER_USERNAME@$server_tld" \
    "cd /var/www/amp/dash-api && bash -i"
  return 0
}

# SSH into Dash client servers
function ssh_dash_client() {
  case "$1" in
  "prod")
    server_tld="dash.amplistings.com"
    ;;
  *)
    echo "Server not found. Please select a server: prod."
    return 1
    ;;
  esac

  sshpass -p "$AMP_USER_SERVER_PASSWORD" ssh -p 2080 -t "$AMP_USER_SERVER_USERNAME@$server_tld" \
    "cd /var/www/amp/dash-client && bash -i"
  return 0
}

###########################################################
# Helper/Abstract Functions
###########################################################
# Get the app service name for the current project
function get_app_service() {
  case $PWD in
  "$AMP_DIR")
    echo "amp-app"
    ;;
  "$DASH_API_DIR")
    echo "dash-api"
    ;;
  *)
    echo "Project not found for app. Please add to neutrino_aliases.zsh."
    ;;
  esac
}

# Get the node service name for the current project
function get_node_service() {
  case $PWD in
  "$AMP_DIR")
    echo "amp-node"
    ;;
  *)
    echo ""
    ;;
  esac
}
