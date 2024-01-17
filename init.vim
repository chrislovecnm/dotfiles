" mkdir -p $HOME/.config/nvim
" ln -s $HOME/.dotfiles/init.vim $HOME/.config/nvim/init.vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
