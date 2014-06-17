#!/bin/sh

# check for stuff
command -v clang >/dev/null 2>&1 || { echo >&2 "I require clang but it's not installed.  Aborting."; exit 1; }
if [ ! -f /usr/share/dict/words ]; then
    echo "words dictionary not available, please install words package"
    exit 1;
fi

mkdir ~/.vim
mkdir ~/.vim/bundle
mkdir ~/.vim/backup
mv ./vimrc ~/.vimrc
cp -rf . ~/.vim/

cd ~/.vim/bundle

git clone https://github.com/eagletmt/ghcmod-vim.git
git clone https://github.com/sjl/gundo.vim.git
git clone https://github.com/lukerandall/haskellmode-vim.git
git clone https://github.com/vim-scripts/matchit.zip.git
git clone https://github.com/fholgado/minibufexpl.vim.git
git clone https://github.com/eagletmt/neco-ghc.git
git clone https://github.com/ujihisa/neco-look.git
git clone https://github.com/Shougo/neocomplete.vim.git
git clone https://github.com/scrooloose/nerdcommenter.git
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/ervandew/supertab.git
git clone https://github.com/scrooloose/syntastic.git
git clone https://github.com/majutsushi/tagbar.git
git clone https://github.com/SirVer/ultisnips.git
git clone https://github.com/Shougo/unite.vim.git
git clone https://github.com/dag/vim2hs.git
git clone https://github.com/altercation/vim-colors-solarized.git
git clone https://github.com/ehamberg/vim-cute-python.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/takac/vim-hardtime.git
git clone https://github.com/osyo-manga/vim-marching.git
git clone https://github.com/hrsh7th/vim-neco-calc.git
git clone https://github.com/Shougo/vimproc.vim.git
git clone https://github.com/osyo-manga/vim-reunions.git
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/vimwiki/vimwiki.git

cd vimproc.vim
make
cd
echo "FINISHED"
echo "If you want to use the ghc-mod vim plugin you have to install ghc-mod in cabal too!"
echo "Please change Name in .vimrc"
