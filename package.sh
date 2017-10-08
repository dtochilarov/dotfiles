#!/bin/bash

REPO=`dirname $0`

# Compress the files into a singe archive
echo "Preparing tarball"
tar -zcvf dotfiles.tar.gz \
    "${HOME}/.vim" \
    "${REPO}/bashrc" \
    "${REPO}/vimrc"

