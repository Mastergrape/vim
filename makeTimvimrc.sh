#!/bin/sh

# check for stuff
command -v clang >/dev/null 2>&1 || { echo >&2 "I require clang but it's not installed.  Aborting."; exit 1; }
if [ ! -f /usr/share/dict/words ]; then
    echo "words dictionary not available, please install words package"
    exit 1;
fi

mkdir ~/.vim
mkdir ~/.vim/backup
mkdir ~/.vim/undodir
mv ./vimrc ~/.vimrc
cp -rf . ~/.vim/

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "FINISHED"
echo "If you want to use the ghc-mod vim plugin you have to install ghc-mod in cabal too!"
echo "[IMPORTANT] Please change Name in .vimrc and then run :PluginInstall"
