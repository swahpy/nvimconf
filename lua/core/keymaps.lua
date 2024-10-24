-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set -- for conciseness
local nmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
end

---------------------
-- General Keymaps --
---------------------

-- use jk to exit insert mode
map("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- execute command in commandline window
-- map("n", ":", ":<C-f>", { desc = "Open commandline window instead of just commandline" })

-- window management
nmap_leader("we", "<C-w>=", "Make splits equal size")
nmap_leader("ww", "<cmd>close<CR>", "Close current split window")
-- Move window
nmap_leader("wK", "<C-w>K", "Move window to top")
nmap_leader("wJ", "<C-w>J", "Move window to bottom")
nmap_leader("wH", "<C-w>H", "Move window to left")
nmap_leader("wL", "<C-w>L", "Move window to right")
nmap_leader("w-", "<cmd>split<cr>", "Split window horizontally")
nmap_leader("w|", "<cmd>vsplit<cr>", "Split window vertically")
nmap_leader("wx", "<cmd>split<cr>", "Split window horizontally")
nmap_leader("wv", "<cmd>vsplit<cr>", "Split window vertically")
nmap_leader("wk", "<C-w><C-k>", "Move focus to top window")
nmap_leader("wj", "<C-w><C-j>", "Move focus to bottom window")
nmap_leader("wh", "<C-w><C-h>", "Move focus to left window")
nmap_leader("wl", "<C-w><C-l>", "Move focus to right window")

-- move and navigation
map("n", "<C-d>", "12j", { desc = "Scroll down by 12 lines" })
map("n", "<C-u>", "12k", { desc = "Scroll up by 12 lines" })
map("i", "<A-l>", "<Right>", { desc = "Moving right in insert mode " })
map("i", "<A-h>", "<Left>", { desc = "Moving left in insert mode " })
map("i", "<A-m>", "<Up>", { desc = "Moving up in insert mode " })
map("i", "<A-n>", "<Down>", { desc = "Moving down in insert mode " })
-- better up/down
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- navigation in command mode
map("c", "<A-b>", "<S-Left>", { desc = "Move back a word" })
map("c", "<A-f>", "<S-Right>", { desc = "Move forward a word" })
map("c", "<C-a>", "<Home>", { desc = "Move to start" })
map("c", "<C-e>", "<End>", { desc = "Move to end" })

-- save and quit buffer
map("n", "<a-q>", "<cmd>qa<cr>", { desc = "Quit nvim" })
-- save file
map({ "i", "x", "n", "s" }, "<A-w>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- indent
map("v", "<", "<gv", { noremap = true, silent = true, desc = "" })
map("v", ">", ">gv", { noremap = true, silent = true, desc = "" })

-- -- Move Lines
-- map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
-- map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
-- map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
-- map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
-- map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
-- map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Buffers
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Goto right buffer" })
map("n", "<S-h>", "<cmd>bprev<cr>", { desc = "Goto left buffer" })
nmap_leader("bp", "<cmd>b#<cr>", "Goto previous buffer")
nmap_leader("bf", "<cmd>bfirst<cr>", "Goto first buffer")
nmap_leader("bl", "<cmd>blast<cr>", "Goto last buffer")
nmap_leader("bn", "<cmd>bmod<cr>", "Goto next buffer")
nmap_leader("ba", "<cmd>buffers<cr>", "List all buffers")
nmap_leader("bg", function()
	local buf = vim.fn.input("Please enter the buffer number you want to go: \n> ")
	vim.cmd("buffer " .. buf)
end, "Goto specific buffer using its number")

-- lsp
-- toggle lsp inlay hints:
nmap_leader("ti", function ()
  if vim.lsp.inlay_hint.is_enabled({}) then
    vim.lsp.inlay_hint.enable(false)
    return
  end
  vim.lsp.inlay_hint.enable(true)
end, "+toggle lsp inlay hints")
