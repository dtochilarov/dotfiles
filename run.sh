#!/bin/bash

# Exit if any command returns a non-zero code.
set -e

# Get the repo folder
REPO=$(dirname $0)

# Create a backup directory for previous configs. Nothing should ever be lost!
BACKUPS="${REPO}/backups"
mkdir -p "${BACKUPS}"
TIMESTAMP=$(date +%s%N)

### Configure BASH

# For all config files create symlinks
for BASH_FILE_NAME in $(ls $REPO/bashrc)
do
    TARGET="${HOME}/.${BASH_FILE_NAME}"
    SOURCE="${REPO}/bashrc/${BASH_FILE_NAME}"
    if [ -f "${TARGET}" ] || [ -L "${TARGET}" ]
    then
        mv "${TARGET}" "${BACKUPS}/${BASH_FILE_NAME}_${TIMESTAMP}"
    fi
    echo "Linking ${SOURCE} -> ${TARGET}"
    ln -s "${SOURCE}" "${TARGET}"
done
echo "Bash config files deployed!"
echo "(Old bash config files are backed up in ${BACKUPS})"


### Configure VIM

# Assert vim is installed ("set -e" will abort if it isn't)
vim --version

# Copy .vimrc
VIMRC_NAME="vimrc"
TARGET="${HOME}/.${VIMRC_NAME}"
SOURCE="${REPO}/vimrc/${VIMRC_NAME}"
if [ -f "${TARGET}" ] || [ -L "${TARGET}" ]
then
    mv "${TARGET}" "${BACKUPS}/${VIMRC_NAME}_${TIMESTAMP}"
fi
echo "Linking ${SOURCE} -> ${TARGET}"
ln -s "${SOURCE}" "${TARGET}"

# Download vim-plug
curl --create-dirs -o "${HOME}/.vim/autoload/plug.vim" \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Create a folder for the plugins
mkdir "${HOME}/.vim/plugged"

# Create a temporary vimrc containing only the plugins from the original
# vimrc. This is required because VIM will complain as soon as it starts
# that plugins are not available.
TMP_VIMRC_NAME="tmp_vimrc"
sed -n "/^call plug#begin/,/^call plug#end/p" \
    "${REPO}/vimrc/${VIMRC_NAME}" > "${REPO}/vimrc/${TMP_VIMRC_NAME}"

# Install plugins using the temporary vimrc
vim -u "${REPO}/vimrc/${TMP_VIMRC_NAME}" +PlugInstall +qall
# Remove the temp file
rm "${REPO}/vimrc/${TMP_VIMRC_NAME}"
# Confirm it is all good!
echo "VIM config files deployed"

