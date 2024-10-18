local opt = vim.opt -- for conciseness

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- turn off swapfile
opt.swapfile = false

-- the minimum lines kept below or above the cursor line
opt.scrolloff = 10

-- used to align text
opt.colorcolumn = "120"

-- search
opt.hlsearch = true

-- auto reload file when it is changed outside
opt.autoread = true

opt.textwidth = 79

-- enable float window and colorscheme work properly
opt.winblend = 0
opt.termguicolors = true

-- needed by obsidian plugin
vim.opt.conceallevel = 2
