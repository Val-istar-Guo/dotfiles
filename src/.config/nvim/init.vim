" 插件启动
call plug#begin('~/.config/nvim/plugged')
  Plug 'tpope/vim-surround'
  Plug 'asvetliakov/vim-easymotion'
  Plug 'vim-scripts/argtextobj.vim'
call plug#end()

" 自动安装未安装的插件
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" 公用剪切板
set clipboard^=unnamed,unnamedplus
"  if exists('$WSLENV')
"    autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/mnt/c/Windows/System32/clip.exe', @0) | endif
"  endif

" 设置leader
let mapleader = "\<Space>"

" 取消双leader
" vim-easymotion默认为双leader，取消了比较方便
map <Leader> <Plug>(easymotion-prefix)


" 复制后高亮
augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank()
augroup END


if exists('g:vscode')
  " VSCOde extension"
  " 不创建备份文件
  set nobackup
  " 使用keyboard-quickfix插件
  nnoremap z= <Cmd>call VSCodeNotify('keyboard-quickfix.openQuickFix')<CR>
  " 使用vscode原生提供的能力代替vim-commentary
  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine

  " 转到文件中上一个问题
  nnoremap g[ <Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>
  " 转到文件中下一个问题
  nnoremap g] <Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>

  " 用H替换掉^
  noremap H ^
  " 用L替换掉$
  noremap L $

  " 使用vscode的undo替换nvim的undo
  nnoremap u <Cmd>call VSCodeNotify('undo')<CR>

  " 切换 VsCode 侧边栏
  nnoremap <Leader>b <Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>

  " 修复 VsCode 不支持 quick-scope 插件
  highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

  " 修复 VsCode 不支持 vim-sandwich 插件
  highlight OperatorSandwichBuns guifg='#aa91a0' gui=underline ctermfg=172 cterm=underline
  highlight OperatorSandwichChange guifg='#edc41f' gui=underline ctermfg='yellow' cterm=underline
  highlight OperatorSandwichAdd guibg='#b1fa87' gui=none ctermbg='green' cterm=none
  highlight OperatorSandwichDelete guibg='#cf5963' gui=none ctermbg='red' cterm=none
else
  " 以正常模式启动nvim时加载的配置项
  " 显示行号
  set number
  " 设置相对行号
  set relativenumber
  " 设置行宽
  set textwidth=80
  " 设置自动换行
  set wrap
  " 是否显示状态栏
  set laststatus=2
  " 语法高亮
  syntax on
  " 支持鼠标
  set mouse=a
  " 设置编码格式
  set encoding=utf-8
  " 启用256色
  set t_Co=256
  " 开启文件类型检查
  filetype indent on
  " 设置自动缩进
  set autoindent
  " 设置tab缩进数量
  set tabstop=4
  " 设置>>与<<的缩进数量
  set shiftwidth=4
  " 将缩进转换为空格
  set expandtab
  " 自动高亮匹配符号
  set showmatch
  " 自动高亮匹配搜索结果
  set nohlsearch
  " 开启逐行搜索，也就是说按下一次按键就继续一次搜索
  set incsearch
  " 开启类型检查
  " set spell spelllang
  " 开启命令补全
  set wildmenu
  " 不创建备份文件
  set nobackup
  " 不创建交换文件
  set noswapfile
  " 多窗口下光标移动到其他窗口时自动切换工作目录
  set autochdir
endif
