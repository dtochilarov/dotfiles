# Dotfiles

Welcome to my dotfiles! This is my attempt to make my dev environment awesome.

## Quick start

Running `run.sh` will deploy all dotfiles onto your system. This will be done
via symlinking to the files in the repo. Any files which would be overwritten
are backed up to the backup folder in the repo. Nothing should be lost.

## Packaging

Recently I've found myself working on remote machines over ssh. The issue is
that those machines have no internet connection, which makes installation of
vim plugins and other add-ons a pain. So I've decided to use Travis CI to spin
up a VM, install everything as per my dotfiles and zip it up for easy acceess
later on. I might explore a packaging option later on.

