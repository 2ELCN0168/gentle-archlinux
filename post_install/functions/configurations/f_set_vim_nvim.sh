#
### File: f_set_vim_nvim.sh
#
### Description: 
# Default configurations for vim/nvim.
#
### Author: 2ELCN0168
# Last updated: 2024-10-06
# 
### Dependencies:
# - vim;
# - neovim.
#
### Usage:
#
# 1. heredocs for config files;
# 2. Copy/paste into root home;
# 3. /etc/skel to apply for every new user.
#

set_vim_nvim() {

        cat <<-EOF > "/etc/skel/.vimrc"
        " NUMBERS
        set number
        set relativenumber

        " CODE
        syntax on
        colorscheme retrobox
        set background=dark

        " INDENT
        set autoindent
        set smartindent
        set tabstop=8
        set shiftwidth=8
        set expandtab

        set showmatch
        set matchtime=2

        set completeopt=menu,menuone,noselect
        set omnifunc=syntaxcomplete#Complete

        set laststatus=2

        set errorformat=%f\:%l\:%c\:\ %m

        set colorcolumn=80

        " SMART SEARCH
        set ignorecase
        set smartcase
        set incsearch 

        " DISPLAY INVISIBLE CHARS
        set list
        set listchars=tab:»·,trail:·

        " FOLDING
        set foldmethod=syntax
        set foldlevelstart=99

        " AUTOCLOSE
        inoremap " ""<Left>
        inoremap ' ''<Left>
        inoremap ( ()<Left>
        inoremap [ []<Left>
        inoremap { {}<Left>

        " HIGLIGHTING
        set cursorline
        set cursorcolumn

        " SAFE SAVE
        "set backup
        "set backupdir=~/.vim/backup//
        "set directory=~/.vim/swap//
        "set undodir=~/.vim/undo//
EOF
        # INFO:
        # Remove spaces caused by heredocs >:(
        sed -i 's/^[ \t]*//' "/etc/skel/.vimrc"

        cp "/etc/skel/.vimrc" "/root"

        mkdir -p "/etc/skel/.config/nvim"

        cat <<-EOF > "/etc/skel/.config/nvim/init.lua"
        -- SYNTAX / COLOR
        vim.cmd('syntax on')
        vim.cmd('colorscheme retrobox')
        vim.o.background = 'dark'
        vim.wo.cursorline = true

        -- DETECT FILETYPE
        vim.cmd('filetype plugin indent on')

        -- ENABLE NUMBERS
        vim.wo.number = true
        vim.wo.relativenumber = true

        -- FOLDING
        vim.wo.foldmethod = 'syntax'
        vim.wo.foldlevelstart = 99

        -- INDENT
        vim.o.autoindent = true
        vim.o.smartindent = true
        vim.o.expandtab = true
        vim.o.tabstop = 4
        vim.o.shiftwidth = 4
        vim.o.softtabstop = 4

        -- INVISIBLE CHARS
        vim.o.list = true
        vim.o.listchars = "tab:»·,trail:·,extends:#,nbsp:."

        -- SMART SEARCH
        vim.o.ignorecase = true
        vim.o.smartcase = true
        vim.o.incsearch = true
        vim.o.hlsearch = true

        -- EASY NAVIGATION
        vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true })
        vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true })
        vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true })
        vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })

        -- STATUS BAR
        vim.o.laststatus = 2
        vim.o.ruler = true

        -- BETTER WINDOW MANAGEMENT
        vim.o.splitbelow = true
        vim.o.splitright = true

        -- COLUMN LIMIT
        vim.wo.colorcolumn = "80"

        -- SAVE
        -- vim.o.backup = true
        -- vim.o.backupdir = "~/.config/nvim/backup//"
        -- vim.o.directory = "~/.config/nvim/swap//"
        -- vim.o.undofile = true
        -- vim.o.undodir = "~/.config/nvim/undo//"

        -- COMMAND HISTORY
        vim.o.history = 1000

        -- SCROLLING
        vim.o.scrolloff = 8
        vim.o.sidescrolloff = 8

        -- COPY/PASTE FROM SYSTEM CLIPBOARD
        vim.o.clipboard = 'unnamedplus'

        -- AUTO FORMAT COMMENTS
        vim.o.formatoptions = vim.o.formatoptions .. 'cro'
EOF

        # INFO:
        # Remove spaces caused by heredocs >:(
        sed -i 's/^[ \t]*//' "/etc/skel/.config/nvim/init.lua"

        cp -r "/etc/skel/.config" "/root"

}
