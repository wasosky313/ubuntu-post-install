#!/bin/bash

echo "Post-install script"

echo "update and upgrade SO"
sudo apt update
sudo apt  -y upgrade

# install basic
echo "installing the basic"
sudo apt install -y wget git curl gnome-tweaks gnome-shell-extensions gnome-shell-extension-manager build-essential terminator neovim openssh-server autojump qbittorrent vlc smplayer mc

# install nemo file manager
echo "Installing Nemo file manager"
sudo apt install -y nemo nemo-fileroller nemo-compare 
# set nemo as default file manager
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search

# install oh-my-zsh
echo "Install and setting oh-my-zsh"
sudo apt -y install zsh
# remove if exists
[ -d "$HOME/.oh-my-zsh" ] && rm -rf "$HOME/.oh-my-zsh"
sudo apt -y install zsh zsh-autosuggestions zsh-syntax-highlighting
# set default terminal
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

ZSHRC="$HOME/.zshrc"
if grep -q "^plugins=(git)" "$ZSHRC"; then
    sed -i 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)/' "$ZSHRC"
    echo "Plugins updated successfully .zshrc."
else
    echo "A linha 'plugins=(git)' não foi encontrada. Nenhuma alteração feita."
fi

echo "Finished oh-my-zsh"

# install google-chrome
echo "Installing google-chrome"
sudo rm -f /usr/share/keyrings/google-chrome.gpg
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | \
sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install -y google-chrome-stable
echo "google-chrome finished"

# Install Brave browser
echo "Installing Brave browser"
curl -fsS https://dl.brave.com/install.sh | sh
echo "Installing Brave browser"

# Install vscode
echo "Installing VSCode"
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | \
sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
sudo apt update
sudo apt install -y code
echo "Finished VScode"

# Install docker engine
echo "Installing docker engine"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
# sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
echo "Finished docker engine"

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# install flatpak
echo "******************************************************"
echo "************Installing and setting flatpak************"
echo "******************************************************"
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo "Installing gearlever appImage installer"
flatpak install flathub it.mijorus.gearlever
echo "Finished gearlever"
echo "Installing logseq"
flatpak install -y flathub com.logseq.Logseq
echo "Finished logseq"
echo "Installing DBeaver"
flatpak install -y flathub io.dbeaver.DBeaverCommunity
echo "Finished DBeaver"
echo "Installing InputLeap"
flatpak install -y flathub io.github.input_leap.input-leap
echo "Finished InputLeap"
echo "Installing Telegram"
flatpak install -y flathub org.telegram.desktop
echo "Finished Telegram"


echo "******************************************************"
echo "******************** SETTINGS ************************"
echo "******************************************************" 

# TODO make it
# echo "GIT ssh settings"
# ssh-keygen -t ed25519 -C $EMAIL -f ~/.ssh/id_ed25519 -N ""
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_ed25519
# git config --global user.email $EMAIL
# git config --global user.name $FULL_NAME
# echo "Test Github connection"
# ssh -T git@github.com
# echo "GIT shh settings finished"

# echo "GIT GPG settings"

# echo "GIT GPG settings finished"

echo "Gnome Styles"

# Set panel to mac style
echo "Set panel to mac style"
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true

echo "Set terminator as default terminal emulator"
gsettings set org.gnome.desktop.default-applications.terminal exec '/usr/bin/terminator'


echo "******* copy the key and paste into your github SSH settings ********"
cat ~/.ssh/id_ed25519.pub
echo "******************************************************" 

echo "************ Config autojum *************"
echo -e "\n. /usr/share/autojump/autojump.sh" >> ~/.bashrc
echo -e "\n. /usr/share/autojump/autojump.sh" >> ~/.zshrc
echo "************ Config autojum finished *************"
echo "******************************************************"

# TODO
# github settings
# add README.MD
# set variable email, name, github_token (ssh config)
# ask for sudo passwd before start
# install warp
# Install lunarVIM
# select packages



