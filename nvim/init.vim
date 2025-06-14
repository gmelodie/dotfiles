" vim-bootstrap b990cad

"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

let g:vim_bootstrap_langs = "c,go,html,javascript,python"
let g:vim_bootstrap_editor = "nvim"				" nvim or vim

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent exec "!\curl -fLo " . vimplug_exists . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  let g:not_finish_vimplug = "yes"

  " autocmd VimEnter * PlugInstall
endif


" Required:
call plug#begin(expand('~/.config/nvim/plugged'))

" so that :checkhealth doesnt complain
let g:loaded_node_provider = 0

"*****************************************************************************
"" Plug install packages
"*****************************************************************************
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'f-person/git-blame.nvim'
Plug 'vim-scripts/grep.vim'
Plug 'bronson/vim-trailing-whitespace'

Plug 'goolord/alpha-nvim'
Plug 'echasnovski/mini.icons'

Plug 'stevearc/aerial.nvim' " replace tagbar
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " replace ctags
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-tree.lua' " replace nerdtree
Plug 'kyazdani42/nvim-web-devicons' " for nvim-tree
Plug 'gmelodie/project.nvim' " for pwd

Plug 'neovim/nvim-lspconfig'

Plug 'ryanoasis/vim-devicons'
Plug 'sbdchd/neoformat'

Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'karb94/neoscroll.nvim'
Plug 'voldikss/vim-floaterm'

Plug 'bkad/CamelCaseMotion'

call plug#end()

" camel case motion
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie


"" vim-sneak + vim-surround (https://gist.github.com/LanHikari22/6b568683d81cbb7a2252fac86f6f4a4b)

let g:surround_no_mappings= 1
let g:sneak#s_next = 1 "" press s/S to go to next/previous match
xmap <S-s> <Plug>Sneak_S
xmap z <Plug>VSurround
nmap yzz <Plug>Yssurround
nmap yz  <Plug>Ysurround
nmap dz  <Plug>Dsurround
nmap cz  <Plug>Csurround
omap s <Plug>Sneak_s
" S mapped with v to make it inclusive, similarly to other backward motions in
" my config (0 mapped to v0, ^ mapped to v^, etc)
omap S v<Plug>Sneak_S


"" alpha.nvim (startify theme)
lua << EOF
require'alpha'.setup(require'alpha.themes.startify'.config)
EOF

"" Rust formatting
let g:rustfmt_autosave = 1

"" git-blame
let g:gitblame_enabled = 0

"" FZF
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif
let g:make = 'gmake'
if exists('make')
        let g:make = 'make'
endif
Plug 'Shougo/vimproc.vim', {'do': g:make}


"" Neoscroll
" lua require('neoscroll').setup()


"" Vim-Session
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

if v:version >= 703
  Plug 'Shougo/vimshell.vim'
endif

" Colorscheme
Plug 'ellisonleao/gruvbox.nvim'
Plug 'itchyny/lightline.vim'

" Snippets
Plug 'honza/vim-snippets'

call plug#end()

"*****************************************************************************
"" LSPs
"*****************************************************************************


lua require('lsp.rust')
lua require('lsp.c')
lua require('lsp.go')
lua require('lsp.python')
" lua require('lsp.nim')

"*****************************************************************************
"*****************************************************************************


" Required:
filetype plugin indent on


"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary


"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Map leader to ,
let mapleader=','

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Directories for swp files (SET THIS)
set directory=~/.nvim/
" set nobackup
" set noswapfile

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" nvim-tree
lua << EOF
  require("project_nvim").setup {
      -- dirs that contain the following are set as root
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", ".nimble", "Cargo.toml", "Makefile" },
  }

  -- enable 24-bit colour
  vim.opt.termguicolors = true

  require("nvim-tree").setup({
      filters = {
        custom = { '.git' },
      },
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true
      },
  })
EOF
nnoremap <silent> <F3> :NvimTreeToggle<CR>

" session management
let g:session_directory = "~/.config/nvim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

"*****************************************************************************
"" Visual Settings
"*****************************************************************************

set mousemodel=popup
set t_Co=256
"set guioptions=egmrti
set gfn=Monospace\ 10

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  " IndentLine
  let g:indentLine_enabled = 1
  let g:indentLine_concealcursor = 'inc'
  let g:indentLine_setConceal = 0
  let g:indentLine_char = '┆'
  let g:indentLine_faster = 1

endif

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


" Gruvbox colorscheme
syntax on
set ruler
set number
set background=dark
set termguicolors
set relativenumber

" no annoying italics
lua << EOF
require("gruvbox").setup({
  italic = {
    strings = false,
    comments = false,
    folds = false,
    emphasis = false,
  }
})
EOF
colorscheme gruvbox


" Lightline (only show name of non-focused file)
let g:lightline = {}
let g:lightline.component_function = { 'lineinfo': 'LightlineLineinfo' }

function! LightlineLineinfo() abort
    if winwidth(0) < 86
        return ''
    endif

    let l:current_line = printf('%-3s', line('.'))
    let l:max_line = printf('%-3s', line('$'))
    let l:lineinfo = ' ' . l:current_line . '/' . l:max_line
    return l:lineinfo
endfunction

"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" vim-fugitive
if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif
set diffopt+=vertical

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall


" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'

" vimshell.vim
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_prompt =  '$ '


"*****************************************************************************
"" Functions
"*****************************************************************************
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

set autoread

"*****************************************************************************
"" Mappings
"*****************************************************************************

"" Split
" new splits are put below and to the right
set splitbelow
set splitright
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

"" FLoatTerm
noremap <Leader>t :FloatermToggle<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>


"" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>

" FZF magic
nnoremap <silent> <leader>e :Files<CR>
nnoremap <silent> <leader>r :Rg<CR>


" Go to definition
nnoremap J <Cmd>lua vim.lsp.buf.definition()<CR>
autocmd VimEnter * nnoremap K <C-o>
"

let g:go_doc_keywordprg_enabled = 0 " remove stupid vim-go K mapping

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>

"" Close buffer
noremap <leader>c :bd<CR>

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Close window
"" Might conflict with another in mac
noremap <C-c> <C-w>c

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

"" Open current line on GitHub
nnoremap <Leader>o :.Gbrowse<CR>

"*****************************************************************************
"" Custom configs
"*****************************************************************************

" c
autocmd FileType c setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 expandtab

" Treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "python", "javascript", "html", "css", "go", "c", "rust", "nim", "bash" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF


" Aerial
lua << EOF
require("aerial").setup({
  show_guides = true,
  layout = {
    max_width = { 80, 0.35 },
    width = nil,
    min_width = { 40, 0.25 },
  },
  filter_kind = false, -- Show all symbol kinds
})
EOF
nnoremap <F4> :AerialToggle!<CR>


" nim
" suppress 'no change necessary' neoformat messages
let g:neoformat_only_msg_on_error = 1
let g:neoformat_enabled_nim = ['nph']
" tab is 2 spaces
autocmd FileType nim setlocal shiftwidth=2 softtabstop=2 expandtab
" only run format on save for nim files (others should use lsps)
augroup fmt
  autocmd!
  autocmd BufWritePre *.nim Neoformat
augroup END


" go (vim-go)
" For gopls issues (source
" https://github.com/golang/tools/blob/master/gopls/doc/vim.md)
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_doc_keywordprg_enabled = 0 " remove stupid vim-go K mapping

let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
" let g:syntastic_go_checkers = ['golint', 'govet']
" let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_structs = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_extra_types = 1

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4

augroup completion_preview_close
  autocmd!
  if v:version > 703 || v:version == 703 && has('patch598')
    autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
  endif
augroup END

augroup go

  au!
  au Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  au Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  au Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  au Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

  au FileType go nmap <Leader>dd <Plug>(go-def-vertical)
  au FileType go nmap <Leader>dv <Plug>(go-doc-vertical)
  au FileType go nmap <Leader>db <Plug>(go-doc-browser)

  " au FileType go nmap <leader>r  <Plug>(go-run)
  " au FileType go nmap <leader>t  <Plug>(go-test)
  au FileType go nmap <Leader>gt <Plug>(go-coverage-toggle)
  au FileType go nmap <Leader>i <Plug>(go-info)
  au FileType go nmap <silent> <Leader>l <Plug>(go-metalinter)
  au FileType go nmap <C-g> :GoDecls<cr>
  au FileType go nmap <leader>dr :GoDeclsDir<cr>
  au FileType go imap <C-g> <esc>:<C-u>GoDecls<cr>
  au FileType go imap <leader>dr <esc>:<C-u>GoDeclsDir<cr>
  au FileType go nmap <leader>rb :<C-u>call <SID>build_go_files()<CR>

augroup END


" html
" for html files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab


" javascript
let g:javascript_enable_domhtmlcss = 1

" vim-javascript
augroup vimrc-javascript
  autocmd!
  autocmd FileType javascript set tabstop=4|set shiftwidth=4|set expandtab softtabstop=4
augroup END


" python
" vim-python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END

"*****************************************************************************
"*****************************************************************************

"" Include user's local vim config
if filereadable(expand("~/.config/nvim/local_init.vim"))
  source ~/.config/nvim/local_init.vim
endif

"*****************************************************************************
"" Convenience variables
"*****************************************************************************


" be able to go up and down single row at md and txt files
autocmd FileType markdown nnoremap j gj
autocmd FileType markdown nnoremap k gk

autocmd FileType text nnoremap j gj
autocmd FileType text nnoremap k gk

" diff for two lines (https://vi.stackexchange.com/a/7350)
command! -nargs=* Ld call LineDiff(<f-args>)
command! -range Ld call LineDiff(<line1>, <line2>)
command! -range Ldiff call LineDiff(<line1>, <line2>)

function! LineDiff(...)

    " Check the number of arguments
    " And get lines numbers
    if len(a:000) == 0
        let l1=line(".")
        let l2=line(".")+1
    elseif len(a:000) == 1
        let l1 =line(".")
        let l2 =a:1
    elseif len(a:000) == 2
        let l1 = a:1
        let l2 = a:2
    else
        echom "bad number of arguments"
        return;
    endif

    " Get the content of the lines
    let line1 = getline(l1)
    let line2 = getline(l2)

    let pattern = ""

    " Compare lines and create pattern of diff
    for i in range(strlen(line1))
        if strpart(line1, i, 1) != strpart(line2, i, 1)
            if pattern != ""
                let pattern = pattern . "\\|"
            endif
            let pattern = pattern . "\\%" . l1 . "l" . "\\%" . ( i+1 ) . "c"
            let pattern = pattern . "\\|" . "\\%" . l2 . "l" . "\\%" . ( i+1 ) . "c"
        endif
    endfor

    " Search and highlight the diff
    execute "let @/='" . pattern . "'"
    set hlsearch
    normal n
endfunction

