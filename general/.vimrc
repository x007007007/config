set number
set cursorline " 突出显示当前行
set ruler " 打开状态栏标尺
set tabstop=4
set expandtab
set shiftwidth=4 " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4

set nobackup " 覆盖文件时不备份
set autochdir " 自动切换当前目录为当前文件所在的目录
set backupcopy=yes " 设置备份时的行为为覆盖

set ignorecase smartcase " 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感
set nowrapscan " 禁止在搜索到文件两端时重新搜索
" set incsearch " 输入搜索内容时就显示搜索结果
set hlsearch " 搜索时高亮显示被找到的文本
set noerrorbells " 关闭错误信息响铃
set novisualbell " 关闭使用可视响铃代替呼叫
set t_vb= " 置空错误铃声的终端代码
syntax on

filetype indent plugin on

set autoindent
set cursorline
set showmatch


filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

if filereadable(expand("~/.vim/vimrc.vundle.list"))
source ~/.vim/vimrc.vundle.list
endif


let g:airline#extensions#tabline#enabled = 1
let g:Powerline_symbols = 'fancy'

