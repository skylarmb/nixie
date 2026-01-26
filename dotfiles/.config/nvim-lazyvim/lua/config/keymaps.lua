-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local opts_remap = { remap = true, silent = true }
local opts_noremap = { remap = false, silent = true }
local opts_silent_false = { remap = false, silent = false }

------------ Buffer Navigation ------------
map("n", "<S-l>", "<cmd>bnext<CR>", opts_noremap)
map("n", "<S-h>", "<cmd>bprevious<CR>", opts_noremap)
map("n", "}", "<cmd>bnext<CR>", opts_noremap)
map("n", "{", "<cmd>bprevious<CR>", opts_noremap)

------------ Movement & Navigation ------------
-- Move by display lines when wrapping
map({ "n", "v", "o" }, "k", "gk", opts_remap)
map({ "n", "v", "o" }, "j", "gj", opts_remap)
-- Faster scroll
map({ "n", "v", "o" }, "K", "10gk", opts_remap)
map({ "n", "v", "o" }, "J", "10gj", opts_remap)
-- Beginning/end of line
map({ "n", "v", "o" }, "H", "^", opts_remap)
map({ "n", "v", "o" }, "L", "$l", opts_remap)
-- Move by beginning of word instead of end of word
map({ "n", "v", "o" }, "E", "b", opts_remap)
map({ "n", "v", "o" }, "e", "w", opts_remap)
-- Bounce between brackets
map("n", "t", "%", opts_noremap)
map("v", "t", "%", opts_noremap)
-- Tab navigation
map("n", "[", "<cmd>tabprev<cr>", opts_noremap)
map("n", "]", "<cmd>tabnext<cr>", opts_noremap)
map("n", "<M-1>", "1gt<CR>", opts_noremap)
map("n", "<M-2>", "2gt<CR>", opts_noremap)

------------ Insert Mode Exits ------------
-- Exit insert mode with jk/jj/JJ/KK
map("i", "jk", "<ESC>l", opts_noremap)
map("i", "jj", "<ESC>l", opts_noremap)
map("i", "JJ", "<ESC>l", opts_noremap)
map("i", "KK", "<ESC>l", opts_noremap)
-- Exit terminal mode
map("t", "jk", "<C-\\><C-n>", opts_noremap)
map("t", "<ESC>", "<C-\\><C-n>", opts_noremap)
-- Enter insert mode from normal with backspace
map({ "n", "v", "o" }, "<bs>", "i<bs>", opts_noremap)

------------ Editing & File Operations ------------
-- Clear highlights
map("n", "<leader><leader>", "<cmd>nohlsearch<CR>", opts_noremap)
-- Better paste in visual mode
map("v", "p", '"_dP', opts_noremap)
-- Redo with U
map("n", "U", "<C-r>", opts_noremap)
-- Close buffers
map("n", "qq", "m'" .. "<cmd>close<CR>", opts_noremap)
map("n", "qa", "m'<cmd>wqa<CR>", opts_noremap)
-- Save from normal mode
map("n", "ww", "<cmd>w<CR>", opts_noremap)
-- Yank filename and line number
map("n", "yl", "<cmd>let @*=expand('%') . ':' . line('.')<CR>", opts_noremap)
-- Yank filename
map("n", "yn", "<cmd>let @*=expand('%')<CR>", opts_noremap)
-- Duplicate line
map({ "n", "v", "o" }, "<C-d>", "yyp", opts_noremap)
-- Copy from register 0
map({ "n", "v", "o" }, "0", '"0y', opts_noremap)
-- Paste from register 0
map({ "n", "v", "o" }, ")", '"0p', opts_noremap)
-- Join visual selection
map("x", "<leader>j", "<cmd>'<,'>join<CR>", opts_noremap)
map("v", "<leader>j", "<cmd>'<,'>join<CR>", opts_noremap)

------------ Line Movement & Indentation ------------
-- Move lines up and down
map("n", "<c-n>", "<cmd>m +1<CR>", opts_noremap)
map("n", "<c-m>", "<cmd>m -2<CR>", opts_noremap)
map("v", "<c-n>", "<cmd>m '>+1<CR>gv=gv", opts_noremap)
map("v", "<c-m>", "<cmd>m '<-2<CR>gv=gv", opts_noremap)
-- Indentation
map("n", "<", "<<", opts_noremap)
map("n", ">", ">>", opts_noremap)
map("v", "<", "<gv", opts_noremap)
map("v", ">", ">gv", opts_noremap)

------------ Search & Replace ------------
-- Search and replace
map("n", "<leader>s", ":%s//g<left><left>", opts_silent_false)
-- Search word under cursor in buffer
map("n", "f", "*N", opts_noremap)
-- Repeat last search result
map("n", ",", ".n", opts_noremap)

------------ Windows & Splits ------------
-- New splits
map("n", "<leader>vs", "<C-w><C-v>", opts_noremap)
map("n", "<leader>hs", "<C-w><C-s>", opts_noremap)
-- Resize splits by 10 columns
map("n", "<leader>,", "<c-w>10><CR>", opts_noremap)
map("n", "<leader>.", "<c-w>10<<CR>", opts_noremap)
-- Window movement
map("n", "<leader>e", "<cmd>wincmd T<CR>", opts_noremap)
map("n", "<leader>l", "<cmd>wincmd L<CR>", opts_noremap)
map("n", "<leader>h", "<cmd>wincmd H<CR>", opts_noremap)
map("n", "<leader>j", "<cmd>wincmd J<CR>", opts_noremap)
map("n", "<leader>k", "<cmd>wincmd K<CR>", opts_noremap)

------------ File Navigation & Creation ------------
-- Toggle file explorer
map("n", "`", "<cmd>Neotree toggle<CR>", opts_noremap)
-- New file
map("n", "<leader>n", "<cmd>n<CR>", opts_noremap)

------------ Command & Terminal Mode ------------
-- Expand %% to current directory in command mode
map("c", "%%", "<C-R>=expand('%:h').'/'<CR>", opts_noremap)
-- GUI paste in command mode
map("c", "<D-v>", "<C-R>+", opts_noremap)
-- Disable default binding
map("c", "<C-f>", "", opts_noremap)
-- Exit command mode
map("c", "<ESC>", "<C-c>", opts_noremap)

------------ macOS Keybinds (Cmd key) ------------
map("n", "<D-s>", "<cmd>w<CR>", opts_noremap) -- Save
map("v", "<D-c>", '"+y', opts_noremap) -- Copy
map("n", "<D-v>", '"+P', opts_noremap) -- Paste normal
map("v", "<D-v>", '"+P', opts_noremap) -- Paste visual
map("i", "<D-v>", '<ESC>l"+Pli', opts_noremap) -- Paste insert

------------ LSP Diagnostics ------------
map("n", "ge", function()
  vim.diagnostic.goto_next({ buffer = 0 })
end, opts_noremap)
