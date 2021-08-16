#!/bin/bash
# shellcheck disable=SC1090,SC2086

if [ ! -d "/workspace/.gitpodify" ]; then
  /home/gitpod/.local/bin/init-gitpodify-dir # Init tthat directory first if doesn't exists.
fi

SESSION_LOG_ID=$(openssl rand -hex 12)
SESSION_LOG_TIMESTAMP=$(date +%s)
DOTFILES_LOG="/workspace/.gitpodify/logs/dotfiles-source.$SESSION_LOG_TIMESTAMP-$SESSION_LOG_ID.log"
DOTFILES_CLONE_PATH=/workspace/.gitpodify/personal-dotfiles

### Copied from https://gitlab.com/friendly-telegram/friendly-telegram/-/blob/master/install.sh - start ###
runout() {
  # Runs the arguments and spins once per line of stdout (tee'd to logfile), also piping stderr to logfile
  { "$@" 2>>$DOTFILES_LOG || return $?; } | while read -r line; do
    spin
    printf "%s\n" "$line" >> $DOTFILES_LOG
  done
}
### Copied from https://gitlab.com/friendly-telegram/friendly-telegram/-/blob/master/install.sh - end ###

CUSTOM_GITPOD_BASHRC=${CUSTOM_GITPOD_BASHRC:-"$DOTFILES_CLONE_PATH/bashrc/gitpod"}
if [ -d $DOTFILES_CLONE_PATH ]; then
  runout git -C $DOTFILES_CLONE_PATH fetch --all
  runout git -C $DOTFILES_CLONE_PATH pull
  source "$CUSTOM_GITPOD_BASHRC"
fi