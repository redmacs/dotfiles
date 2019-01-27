#!/bin/bash

# load variables
. ../var.sh

if [ "$1" == "--remove" ] || [ "$1" == "-r" ]; then
    echo "omf uninstall nvm" | fish
    echo "Uninstalling Oh My Fish"
    curl -L http://get.oh-my.fish > install
    fish install --uninstall
    brew uninstall fish      # removing fish
    echo "Uninstalling powerline"
    rm -rf ~/powerline-shell # removing old version of powerline
    pip3 uninstall -y powerline-shell # removing new version of powerline shell
    rm -rf ~/.config/powerline-shell
    echo "Uninstalling nvm"
    rm -rf ~/.nvm/
    exit
fi


# Make sure homebrew is installed first
if [[ ! "$(type -P brew)" ]]; then
    echo "Installing Homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Installine powerline shell
pip3 install powerline-shell
mkdir -p ~/.config/powerline-shell/custom-segments
cp $DOTFILES_FOLDER/fish/powerline-shell/custom-segments/*.py ~/.config/powerline-shell/custom-segments/
cp $DOTFILES_FOLDER/fish/powerline-shell/config.json ~/.config/powerline-shell/config.json


# Install fish && nvm
if [[ ! "$(type -P fish)" ]]; then
    echo "Installing Fish"
    brew install fish
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
fi

# Install oh my fish
if [[ ! "$(type -P omf)" ]]; then
    echo "Installing Oh My Fish"
    curl -L http://get.oh-my.fish > install
    fish install --noninteractive --yes
    echo "omf install nvm" | fish
    echo "omf install aws" | fish # AWS cli autocompletion for fish
fi

# Copying fish configuration
echo "Copy Fish configuration file"
cp $DOTFILES_FOLDER/fish/config.fish ~/.config/fish/config.fish

# Install node with nvm using "latest" and "lts" alias
LATEST_NODE_VERSION=$(echo "nvm ls-remote --no-colors | awk 'END{print}'" | fish | awk '{print $1}')
LATEST_LTS_NODE_VERSION=$(echo "nvm ls-remote --lts --no-colors | awk 'END{print}'" | fish | awk '{print $1}')

echo "Installing node $LATEST_NODE_VERSION as latest"
echo "nvm install $LATEST_NODE_VERSION" | fish
echo "nvm alias latest $LATEST_NODE_VERSION" | fish

echo "Installing node $LATEST_LTS_NODE_VERSION as lts"
echo "nvm install $LATEST_LTS_NODE_VERSION" | fish
echo "nvm alias lts $LATEST_LTS_VERSION" | fish
