local expand = vim.fn.expand
local keymap = require("user.utils").keymap
local set = keymap.set
local c = keymap.c
local i = keymap.i
local leader = keymap.leader
local n = keymap.n
local nvo = keymap.nvo
local t = keymap.t
local v = keymap.v
local opts = keymap.opts
local cmd = keymap.cmd
local cword = keymap.expand.cword
local cexpr = keymap.expand.cexpr

-- Config --

n("<S-l>", "<cmd>bnext<CR>")
-- Navigate buffers
n("<S-h>", "<cmd>bprevious<CR>")

-- Clear highlights
leader("<leader>", "<cmd>nohlsearch<CR>")

-- Better paste
v("p", '"_dP')
nvo(")", "")

-- Insert --
-- Press jk fast to enter
set("i", "jk", "<ESC>")

-- Visual --
-- Stay in indent mode
v("<", "<gv")
v(">", ">gv")

-- Plugins --

-- NvimTree
n("`", "<cmd>NvimTreeFindFileToggle<CR>")

-- Comment
-- keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>")
-- keymap("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

-- DAP
leader("db", function()
  require("dap").toggle_breakpoint()
end)
leader("dc", function()
  require("dap").continue()
end)
leader("di", function()
  require("dap").step_into()
end)
leader("do", function()
  require("dap").step_over()
end)
leader("dO", function()
  require("dap").step_out()
end)
leader("dr", function()
  require("dap").repl.toggle()
end)
leader("dl", function()
  require("dap").run_last()
end)
leader("du", function()
  require("dapui").toggle()
end)
leader("dt", function()
  require("dap").terminate()
end)

------------ Movement ------------
-- always move by display lines when wrapping
nvo("k", "gk", opts.remap)
nvo("j", "gj", opts.remap)
-- faster scroll
nvo("K", "10gk", opts.remap)
nvo("J", "10gj", opts.remap)

-- beginning / end of line
nvo("H", "^", opts.remap)
nvo("L", "$l", opts.remap)
-- move by beginning of word instead of end of word
nvo("E", "b", opts.remap)
nvo("e", "w", opts.remap)
-- exit insert mode with jk
i("jk", "<ESC>l")
i("jj", "<ESC>l")
i("JJ", "<ESC>l")
i("KK", "<ESC>l")
-- exit insert for term mode
-- keymap("t", "jj", "<C-\\><C-n>")
t("jk", "<C-\\><C-n>")
t("<ESC>", "<C-\\><C-n>")
-- enter insert mode when pressing backspace from normal mode
nvo("<bs>", "i<bs>")
-- bounce between brackets
n("t", "%")
v("t", "%")
-- seamless tmux navigation
n("<C-h>", cmd("NvimTmuxNavigateLeft"))
n("<C-j>", cmd("NvimTmuxNavigateDown"))
n("<C-k>", cmd("NvimTmuxNavigateUp"))
n("<C-l>", cmd("NvimTmuxNavigateRight"))

------------ Editing ------------

-- redo with U
n("U", "<C-r>")
-- close buffers
n("qq", "m'" .. cmd(":close"))
n("qd", "m'" .. cmd(":Bdelete!"))
n("qa", "m'<cmd>wqa<CR>")
-- rebind macro recording to not conflict with qq
n("q", "")
leader("q", "q")
-- ww to write from normal mode
n("ww", cmd("w"))
-- yank current file name and line number
n("yl", "<cmd>let @*=expand('%') . ':' . line('.')<CR>")
-- yank current file name
n("yn", "<cmd>let @*=expand('%')<CR>")
-- show current yank rink
n("<C-y>", "<cmd>YRShow<CR>")
-- dupe line
nvo("<C-d>", "yyp")
nvo("0", '"0y')
nvo(")", '"0p')
-- join visual selection
set("x", "<leader>j", cmd("'<,'>join"))
-- browse source of current file
set("n", "<leader>gs", [[:silent !/bin/zsh -i -c 'browsesource "$(basename `git rev-parse --show-toplevel`)" %'<CR>]])

-- snippets
-- i("<Tab>", function()
--   return require("snippy").can_expand_or_advance() and "<plug>(snippy-expand-or-advance)" or "<tab>"
-- end)

-- move lines up and down
n("<c-n>", "<cmd>m +1<CR>")
n("<c-m>", "<cmd>m -2<CR>")
v("<c-n>", "<cmd>m '>+1<CR>gv=gv")
v("<c-m>", "<cmd>m '<-2<CR>gv=gv")
-- toggle wrap
-- keymap("n", "<leader>w", ":set wrap!<CR>")
-- indentation
n("<", "<<")
n(">", ">>")
v("<", "<gv")
v(">", ">gv")
-- clean whitespace
leader("W", "<cmd>StripWhitespace<CR>")

------------ Search ------------
n("<C-p>", "<cmd>Telescope find_files<cr>")
n("<C-b>", "<cmd>Telescope buffers<CR>")
n("<c-f>", "<cmd>Telescope live_grep<CR>")
leader("s", "/\\%V", { silent = false })
leader("th", "<cmd>Telescope highlights<CR>")
leader("o", "<cmd>Telescope jumplist<CR>")
leader("m", "<cmd>Telescope marks<CR>")
-- keymap("n", "<leader>c", ":%sno//g<LEFT><LEFT>", { silent = false }) -- replace word under cursor
-- jump back to last insert location. `I` mark is set in autocmds.lua
leader("i", "'I")
-- recently edited files
leader("z", "<cmd>Telescope oldfiles<cr>")
-- re-open picker
leader("p", "<cmd>Telescope resume<cr>")
-- jump to project roots via detection of package.json, .git, etc
leader("P", "<cmd>Telescope projects<cr>")

-- buffer search word under cursor
n("f", "*N")
-- non-recursive . motion
n(",", ".n")
-- Ack / ripgrep
n("F", cmd(":Ack!", cword), { silent = false })
leader("f", ":Ack ", { silent = false, remap = true })
leader("s", ":Acks /" .. expand("%s") .. "//<left><left>", { silent = false })
-- ack lines in listed buffers
-- leader("l", ":Back ", { silent = false })
-- help
leader("hw", cmd(":help ", cword))
leader("hh", cmd(":help ", cexpr))
-- replay notifications on to quickfix list
leader("m", function()
  vim.cmd([[Messages]])
  vim.cmd([[NotifierReplay]])
end)

------------ Tabs and Splits ------------
-- new vertical split
leader("vs", "<C-w><C-v>")
-- new horizontal split
leader("hs", "<C-w><C-s>")
-- resize splits by 10 columns
leader(",", "<c-w>10><CR>")
leader(".", "<c-w>10<<CR>")
leader("e", cmd("wincmd", "T"))
leader("l", cmd("wincmd", "L"))
leader("h", cmd("wincmd", "H"))
leader("j", cmd("wincmd", "J"))
leader("k", cmd("wincmd", "K"))
n("[", "<cmd>tabprev<cr>")
n("]", "<cmd>tabnext<cr>")
n("<M-1>", "1gt<CR>")
n("<M-2>", "2gt")

------------ File browsing ------------
leader("n", "<cmd>n<CR>")
-- file tree
n("`", "<cmd>NvimTreeFindFileToggle<cr>")
-- sidebar
leader("`", "<cmd>SidebarNvimToggle<cr>")

------------ Git ------------
-- git mergetool
n("mt", "<cmd>MergetoolToggle<CR>")
n("mgr", "<cmd>MergetoolDiffExchangeLeft<CR>")
n("mgl", "<cmd>MergetoolDiffExchangeRight<CR>")
leader("gd", "<cmd>Gdiff<CR>")

------------ Misc ------------
n("<D-s>", "<cmd>w<CR>") -- Save
v("<D-c>", '"+y') -- Copy
n("<D-v>", '"+P') -- Paste normal mode
v("<D-v>", '"+P') -- Paste visual mode
set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert modeend
leader("tt", "<cmd>ToDoTxtTasksToggle<CR>") -- TODO list
leader("tn", "<cmd>ToDoTxtCapture<CR>") -- TODO list
leader("a", "cs\"'", opts.remap) -- change quotes
leader("s", "cs'\"", opts.remap) -- change quotes
leader("I", cmd("Inspect")) -- Inspect highlight group under cursor
leader("c", cmd("cd ~/.config/nvim | tabe ./init.lua")) -- Inspect highlight group under cursor

------------ Command & Term mode ------------
-- expand %% to current dir name
c("%%", "<C-R>=expand('%:h').'/'<CR>")
-- GUI vim client paste command mode
c("<D-v>", "<C-R>+")
-- disable annoying default bind
c("<C-f>", "")
-- get me out of here!
c("<ESC>", "<C-c>")
-- open floating term
n("<C-t>", "<cmd>ToggleTerm<cr><insert>")
