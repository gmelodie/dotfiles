-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader must be set before lazy
vim.g.mapleader = ','

-- Disable providers we don't use
vim.g.loaded_node_provider = 0

-- ============================================================================
-- Plugins
-- ============================================================================

require('lazy').setup({
  -- Git
  'tpope/vim-fugitive',
  'airblade/vim-gitgutter',
  'f-person/git-blame.nvim',

  -- Editing
  'tpope/vim-commentary',
  'tpope/vim-surround',
  'bronson/vim-trailing-whitespace',
  'justinmk/vim-sneak',
  'chrisgrieser/nvim-spider',

  -- UI
  { 'ellisonleao/gruvbox.nvim', priority = 1000 },
  'goolord/alpha-nvim',
  'echasnovski/mini.icons',
  'nvim-tree/nvim-web-devicons',
  { 'nvim-lualine/lualine.nvim',  dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { 'romgrk/barbar.nvim',         dependencies = { 'nvim-tree/nvim-web-devicons' } },
  'Yggdroot/indentLine',

  -- File tree & project
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  'DrKJeff16/project.nvim',

  -- Fuzzy finding
  { 'junegunn/fzf', build = './install --bin' },
  'junegunn/fzf.vim',

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

  -- Nim syntax (treesitter nim parser is unreliable)
  'alaviss/nim.nvim',

  -- LSP
  'neovim/nvim-lspconfig',

  -- Formatting
  'sbdchd/neoformat',

  -- Terminal
  'voldikss/vim-floaterm',

  -- Symbols outline
  'stevearc/aerial.nvim',

  -- Utilities
  'nvim-lua/plenary.nvim',
  { 'greggh/claude-code.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
})

-- ============================================================================
-- Basic settings
-- ============================================================================

vim.opt.fileencoding = 'utf-8'

vim.opt.backspace = { 'indent', 'eol', 'start' }

vim.opt.tabstop     = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth  = 4
vim.opt.expandtab   = true

vim.opt.hidden = true

vim.opt.hlsearch  = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true

vim.opt.directory   = vim.fn.expand('~/.nvim/')
vim.opt.fileformats = { 'unix', 'dos', 'mac' }
vim.opt.shell       = vim.env.SHELL or '/bin/sh'
vim.opt.autoread    = true

-- ============================================================================
-- Visual settings
-- ============================================================================

vim.opt.termguicolors = true
vim.opt.mousemodel    = 'popup'
vim.opt.ruler         = true
vim.opt.number        = true
vim.opt.relativenumber = true
vim.opt.background    = 'dark'
vim.opt.scrolloff     = 3
vim.opt.laststatus    = 2
vim.opt.modeline      = true
vim.opt.modelines     = 10
vim.opt.title         = true
vim.opt.titleold      = 'Terminal'
vim.opt.titlestring   = '%F'
vim.opt.splitbelow    = true
vim.opt.splitright    = true
vim.opt.diffopt:append('vertical')
vim.opt.wildmode      = { 'list:longest', 'list:full' }
vim.opt.wildignore:append({ '*.o', '*.obj', '.git', '*.rbc', '*.pyc', '__pycache__' })

-- Relative number toggle
local numtoggle = vim.api.nvim_create_augroup('numbertoggle', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave' }, {
  group = numtoggle,
  callback = function() vim.opt.relativenumber = true end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter' }, {
  group = numtoggle,
  callback = function() vim.opt.relativenumber = false end,
})

-- ============================================================================
-- Plugin configs
-- ============================================================================

-- nvim-spider (camel/kebab/snake case word motions)
vim.keymap.set({ 'n', 'o', 'x' }, 'w', "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set({ 'n', 'o', 'x' }, 'e', "<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set({ 'n', 'o', 'x' }, 'b', "<cmd>lua require('spider').motion('b')<CR>")

-- vim-sneak + vim-surround
vim.g.surround_no_mappings = 1
vim.g['sneak#s_next'] = 1
vim.keymap.set('x', '<S-s>', '<Plug>Sneak_S',   { remap = true })
vim.keymap.set('x', 'z',    '<Plug>VSurround',  { remap = true })
vim.keymap.set('n', 'yzz',  '<Plug>Yssurround', { remap = true })
vim.keymap.set('n', 'yz',   '<Plug>Ysurround',  { remap = true })
vim.keymap.set('n', 'dz',   '<Plug>Dsurround',  { remap = true })
vim.keymap.set('n', 'cz',   '<Plug>Csurround',  { remap = true })
vim.keymap.set('o', 's',    '<Plug>Sneak_s',    { remap = true })
-- S mapped with v to make it inclusive
vim.keymap.set('o', 'S',    'v<Plug>Sneak_S',   { remap = true })

-- alpha.nvim
local ok_alpha, alpha = pcall(require, 'alpha')
if ok_alpha then
  alpha.setup(require('alpha.themes.startify').config)
end

-- git-blame
vim.g.gitblame_enabled = 0

-- Rust formatting
vim.g.rustfmt_autosave = 1

-- project.nvim
local ok_project, project_nvim = pcall(require, 'project_nvim')
if ok_project then
  project_nvim.setup({
    patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', '.nimble', 'Cargo.toml' },
  })
end

-- nvim-tree
local ok_tree, nvim_tree = pcall(require, 'nvim-tree')
if ok_tree then
  nvim_tree.setup({
    filters = { custom = { '.git' } },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
  })
end

-- gruvbox
require('gruvbox').setup({
  italic = {
    strings  = false,
    comments = false,
    folds    = false,
    emphasis = false,
  },
})
vim.cmd.colorscheme('gruvbox')

-- lualine
require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators   = { left = '', right = '' },
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'filename' },
    lualine_c = { 'diff' },
    lualine_x = {},
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
})

-- barbar
require('barbar').setup({
  clickable = false,
  animation = false,
  icons = {
    buffer_index = true,
    button = '',
  },
})

-- IndentLine
vim.g.indentLine_enabled       = 1
vim.g.indentLine_concealcursor = 'inc'
vim.g.indentLine_setConceal    = 0
vim.g.indentLine_char          = '┆'
vim.g.indentLine_faster        = 1

-- Treesitter
local ok_ts, ts_configs = pcall(require, 'nvim-treesitter.configs')
if ok_ts then
  ts_configs.setup({
    ensure_installed = { 'lua', 'python', 'javascript', 'html', 'css', 'go', 'c', 'rust', 'bash' },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  })
end

-- Claude (must come after treesitter)
local ok_claude, claude = pcall(require, 'claude-code')
if ok_claude then
  claude.setup({
    window = {
      split_ratio    = 0.35,
      position       = 'float',
      enter_insert   = true,
      hide_numbers   = true,
      hide_signcolumn = true,
      float = {
        width    = '75%',
        height   = '85%',
        row      = 'center',
        col      = 'center',
        relative = 'editor',
        border   = 'rounded',
      },
    },
    refresh = {
      enable             = true,
      updatetime         = 100,
      timer_interval     = 500,
      show_notifications = true,
    },
    git   = { use_git_root = true },
    shell = { separator = '&&', pushd_cmd = 'pushd', popd_cmd = 'popd' },
    command = 'claude',
    command_variants = {
      continue = '--continue',
      resume   = '--resume',
      verbose  = '--verbose',
    },
    keymaps = {
      toggle = {
        normal   = '<leader>ac',
        terminal = '<C-,>',
        variants = {
          continue = '<leader>aC',
          verbose  = '<leader>aV',
        },
      },
      window_navigation = true,
      scrolling         = true,
    },
  })
end

-- Aerial
require('aerial').setup({
  show_guides = true,
  layout = {
    max_width = { 80, 0.35 },
    width     = nil,
    min_width = { 40, 0.25 },
  },
  filter_kind = false,
})

-- Neoformat
vim.g.neoformat_only_msg_on_error = 1
vim.g.neoformat_enabled_nim       = { 'nph' }

-- FZF
if vim.fn.executable('rg') == 1 then
  vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  vim.opt.grepprg = 'rg --vimgrep'
else
  vim.env.FZF_DEFAULT_COMMAND = "find * -path '*/\\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o -type f -print -o -type l -print 2>/dev/null"
end

-- LSPs
require('lsp.rust')
require('lsp.c')
require('lsp.go')
require('lsp.python')

-- ============================================================================
-- Autocommands
-- ============================================================================

-- Sync syntax highlight from start
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function() vim.cmd('syntax sync maxlines=200') end,
})

-- Remember cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line('$') then
      vim.cmd("normal! g`\"")
    end
  end,
})

-- Wrapping for txt files
local function setup_wrapping()
  vim.opt_local.wrap      = true
  vim.opt_local.wrapmargin = 2
  vim.opt_local.textwidth = 79
end
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern  = '*.txt',
  callback = setup_wrapping,
})

-- Filetype-specific settings
vim.api.nvim_create_autocmd('FileType', {
  pattern  = 'make',
  callback = function() vim.opt_local.expandtab = false end,
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern  = 'CMakeLists.txt',
  callback = function() vim.bo.filetype = 'cmake' end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern  = { 'c', 'cpp' },
  callback = function()
    vim.opt_local.tabstop   = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern  = 'html',
  callback = function()
    vim.opt_local.tabstop   = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern  = 'javascript',
  callback = function()
    vim.opt_local.tabstop    = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab  = true
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern  = 'python',
  callback = function()
    vim.opt_local.expandtab   = true
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.tabstop     = 8
    vim.opt_local.colorcolumn = '79'
    vim.opt_local.softtabstop = 4
    vim.opt_local.formatoptions:append('croq')
    vim.opt_local.cinwords = 'if,elif,else,for,while,try,except,finally,def,class,with'
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern  = 'nim',
  callback = function()
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab   = true
    vim.opt_local.foldenable  = false
  end,
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern  = '*.go',
  callback = function()
    vim.opt_local.expandtab   = false
    vim.opt_local.tabstop     = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Nim: format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group    = vim.api.nvim_create_augroup('fmt', { clear = true }),
  pattern  = '*.nim',
  callback = function() vim.cmd('Neoformat') end,
})

-- Markdown/text: move by visual line
vim.api.nvim_create_autocmd('FileType', {
  pattern  = { 'markdown', 'text' },
  callback = function()
    vim.keymap.set('n', 'j', 'gj', { buffer = true })
    vim.keymap.set('n', 'k', 'gk', { buffer = true })
  end,
})

-- Autocompile dwmblocks when blocks.h is saved
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern  = vim.fn.expand('~/dotfiles/suckless/dwmblocks/blocks.h'),
  callback = function()
    vim.fn.system('cd ~/dotfiles/suckless/dwmblocks && sudo make install && { killall -q dwmblocks; setsid dwmblocks & }')
  end,
})

-- Load local config if present
local local_config = vim.fn.expand('~/.config/nvim/local_init.vim')
if vim.fn.filereadable(local_config) == 1 then
  vim.cmd('source ' .. local_config)
end

-- ============================================================================
-- Keymaps
-- ============================================================================

-- Search: center on match
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Splits
vim.keymap.set('n', '<Leader>h', ':<C-u>split<CR>')
vim.keymap.set('n', '<Leader>v', ':<C-u>vsplit<CR>')

-- Git (fugitive)
vim.keymap.set('n', '<Leader>ga',  ':Gwrite<CR>')
vim.keymap.set('n', '<Leader>gc',  ':Gcommit<CR>')
vim.keymap.set('n', '<Leader>gsh', ':Gpush<CR>')
vim.keymap.set('n', '<Leader>gll', ':Gpull<CR>')
vim.keymap.set('n', '<Leader>gs',  ':Gstatus<CR>')
vim.keymap.set('n', '<Leader>gb',  ':Gblame<CR>')
vim.keymap.set('n', '<Leader>gd',  ':Gvdiff<CR>')
vim.keymap.set('n', '<Leader>gr',  ':Gremove<CR>')
vim.keymap.set('n', '<Leader>o',   ':.Gbrowse<CR>')

-- FloatTerm
vim.keymap.set('n', '<Leader>t', ':FloatermToggle<CR>')

-- Tabs
vim.keymap.set('n', '<Tab>',   'gt')
vim.keymap.set('n', '<S-Tab>', 'gT')
vim.keymap.set('n', '<S-t>',   ':tabnew<CR>', { silent = true })

-- Set working directory to current file's dir
vim.keymap.set('n', '<leader>.', ':lcd %:p:h<CR>')

-- FZF
vim.keymap.set('n', '<leader>e', ':Files<CR>',   { silent = true })
vim.keymap.set('n', '<leader>r', ':Rg<CR>',      { silent = true })
vim.keymap.set('n', '<leader>b', ':Buffers<CR>', { silent = true })
vim.keymap.set('c', '<C-P>', '<C-R>=expand("%:p:h") . "/" <CR>')

-- LSP
vim.keymap.set('n', 'J', '<Cmd>lua vim.lsp.buf.definition()<CR>')
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function() vim.keymap.set('n', 'K', '<C-o>') end,
})

-- Clipboard
vim.keymap.set({ 'n', 'v' }, 'YY',        '"+y<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+gP<CR>')
vim.keymap.set({ 'n', 'v' }, 'XX',        '"+x<CR>')

-- Buffer navigation
vim.keymap.set('n', '<leader>q', ':bp<CR>')
vim.keymap.set('n', '<leader>z', ':bp<CR>')
vim.keymap.set('n', '<leader>w', ':bn<CR>')
vim.keymap.set('n', '<leader>x', ':bn<CR>')
vim.keymap.set('n', '<leader>c', ':bd<CR>')

-- Clear search highlight
vim.keymap.set('n', '<leader><space>', ':noh<CR>', { silent = true })

-- Window navigation
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-c>', '<C-w>c')

-- Maintain visual mode after indent
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Move visual block
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- NvimTree / Aerial toggles
vim.keymap.set('n', '<F3>', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<F4>', ':AerialToggle!<CR>')

-- ============================================================================
-- Command abbreviations
-- ============================================================================

for _, abbr in ipairs({
  'W! w!', 'Q! q!', 'Qall! qall!', 'Wq wq', 'Wa wa',
  'wQ wq', 'WQ wq', 'W w', 'Q q', 'Qall qall',
}) do
  vim.cmd('cnoreabbrev ' .. abbr)
end

-- ============================================================================
-- LineDiff: highlight character-level differences between two lines
-- ============================================================================

local function line_diff(l1, l2)
  l1 = l1 or vim.fn.line('.')
  l2 = l2 or l1 + 1
  local line1 = vim.fn.getline(l1)
  local line2 = vim.fn.getline(l2)
  local pattern = ''
  for i = 1, math.min(#line1, #line2) do
    if line1:sub(i, i) ~= line2:sub(i, i) then
      if pattern ~= '' then pattern = pattern .. '\\|' end
      pattern = pattern .. '\\%' .. l1 .. 'l\\%' .. i .. 'c'
      pattern = pattern .. '\\|\\%' .. l2 .. 'l\\%' .. i .. 'c'
    end
  end
  vim.fn.setreg('/', pattern)
  vim.opt.hlsearch = true
  vim.cmd('normal! n')
end

local function ld_cmd(opts)
  if opts.range == 2 then
    line_diff(opts.line1, opts.line2)
  else
    local args = vim.split(vim.trim(opts.args), '%s+')
    if #args == 2 then
      line_diff(tonumber(args[1]), tonumber(args[2]))
    elseif #args == 1 and args[1] ~= '' then
      line_diff(nil, tonumber(args[1]))
    else
      line_diff()
    end
  end
end

vim.api.nvim_create_user_command('Ld',    ld_cmd, { nargs = '*', range = true })
vim.api.nvim_create_user_command('Ldiff', ld_cmd, { nargs = '*', range = true })
