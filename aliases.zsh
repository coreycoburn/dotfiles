# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias src="source $HOME/.zshrc"
alias ll="/usr/local/opt/coreutils/libexec/gnubin/ls -AhlFo --color --group-directories-first"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias c="clear"

# Directories
alias dotfiles="pstorm $DOTFILES"
alias zshconfig="pstorm $HOME/.zshrc"
alias library="cd $HOME/Library"
alias dev="cd $HOME/Dev"

# Laravel
alias fresh="php artisan migrate:fresh --seed"
alias seed="php artisan db:seed"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run watch"

# Composer
alias ci="composer install"
alias cim="COMPOSER_MEMORY_LIMIT=-1 ci"

# Switching branches
alias switch="ci && npm install && npm run dev"

# Docker
alias docker-composer="docker-compose"

# Database
function db() {
  [ ! -f .env ] && {
    echo "No .env file found."
    exit 1
  }

  DB_CONNECTION=$(grep DB_CONNECTION .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
  DB_HOST=$(grep DB_HOST .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
  DB_PORT=$(grep DB_PORT .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
  DB_DATABASE=$(grep DB_DATABASE .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
  DB_USERNAME=$(grep DB_USERNAME .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)
  DB_PASSWORD=$(grep DB_PASSWORD .env | grep -v -e '^\s*#' | cut -d '=' -f 2-)

  DB_URL="${DB_CONNECTION}://${DB_USERNAME}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_DATABASE}"

  echo "Opening ${DB_URL}"
  open $DB_URL
}

# Git

# Git aliases
alias nah="git reset --hard && git clean -df" # clear changes since last commit
alias reflog="git reflog show"                # show you the history of HEAD
alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"

# Work
alias neutrino="cd $HOME/Dev/Neutrino"
alias amp="neutrino && cd amp-dashboard && pstorm ."
alias dash="neutrino && cd dash && pstorm ."
alias dashapi="neutrino && cd dash/dash-api && pstorm ."
alias dashclient="neutrino && cd dash/dash-client && pstorm ."

function art() {
  if [[ $(basename $(pwd)) == "dash" ]]; then
    docker-compose exec api php artisan $1
  fi
  if [[ $(basename $(pwd)) == "dash-api" ]]; then
    docker-compose --file ../docker-compose.yml exec api php artisan $1
  fi
}

function composer() {
  if [[ $(basename $(pwd)) == "dash" ]]; then
    docker-compose exec api composer $1 $2 $3
    docker cp $(docker-compose ps -q api):/var/www/html/vendor dash-api
  fi
  if [[ $(basename $(pwd)) == "dash-api" ]]; then
    docker-compose --file ../docker-compose.yml exec api composer $1 $2 $3
    docker cp $(docker-compose --file ../docker-compose.yml ps -q api):/var/www/html/vendor .
  fi
}

function xon() {
  if [[ $(basename $(pwd)) == "dash" ]]; then
    sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=debug,develop/g" .docker/env/.env.api
    docker-compose up -d api
  fi
  if [[ $(basename $(pwd)) == "dash-api" ]]; then
    sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=debug,develop/g" ../.docker/env/.env.api
    docker-compose --file ../docker-compose.yml up -d api
  fi
}

function xoff() {
  if [[ $(basename $(pwd)) == "dash" ]]; then
    sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=off/g" .docker/env/.env.api
    docker-compose up -d api
  fi
  if [[ $(basename $(pwd)) == "dash-api" ]]; then
    sed -i "" "s/XDEBUG_MODE=.*/XDEBUG_MODE=off/g" ../.docker/env/.env.api
    docker-compose --file ../docker-compose.yml up -d api
  fi
}
