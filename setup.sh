#!/bin/bash
# script to bootstrap setting up a mac with ansible 

function uninstall {

echo "WARNING : This will remove homebrew and all applications installed through it"
echo -n "are you sure you want to do that? [y/n] : "
read confirmation

if [ $confirmation == "y" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
    exit 0
else
  echo "keeping everything intact"
  exit 0
fi

}

if [ $1 == "uninstall" ]; then
    uninstall
fi

function homebrewCheck {

    if [ -f /usr/local/bin/brew ]; then
        echo "Homebrew is already installed."
    else
        yes | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew install ansible -y
    fi
}

echo "================================================="
echo "Setting up your mac using raulsanchezmv/mac-setup"
echo "================================================="

homebrewCheck

installdir="/tmp/mac-setup-$RANDOM"
mkdir $installdir

git clone https://github.com/raulsanchezmv/mac-setup.git $installdir 
if [ ! -d $installdir ]; then
    echo "failed to find mac-setup."
    echo "git cloned failed"
    exit 1
else
    cd $installdir 
    ansible-playbook -i ./inventory/macbook playbook.yml -K
fi

echo "cleaning up..."

rm -Rfv /tmp/$installdir

echo "and we are done! Enjoy!"

exit 0