-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

------------ File Type Settings ------------
-- Set .env files to bash filetype for syntax highlighting
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.cmd("set ft=bash")
  end,
})

------------ Marks & Navigation ------------
-- Set mark when leaving insert mode (used for '<leader>i keymap)
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    vim.cmd("normal! m'")
    vim.cmd("normal! mI")
  end,
})

------------ Special Buffer Behavior ------------
-- Disable line numbers, color column, and set buffer options for certain filetypes
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "veil", "NvimTree" },
  callback = function()
    vim.cmd([[
      setlocal nonumber colorcolumn=""
      set nobuflisted
      set bufhidden=wipe
    ]])
    vim.keymap.set("n", "qq", "<cmd>cclose<CR>", { noremap = true, silent = true, buffer = true })
    vim.keymap.set("n", "q", "", { noremap = true, silent = true, buffer = true })
  end,
})

------------ Help & Man Pages Layout ------------
-- Position help/man windows in right split if terminal is large enough
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help", "man" },
  callback = function()
    vim.keymap.set({ "n", "x" }, "q", "<cmd>Bwipeout<cr>")
    if tonumber(vim.fn.winwidth("%")) < 160 then
      return
    end
    vim.cmd("wincmd L")
  end,
})

------------ Spell Checking Settings ------------
-- Enable spell checking for commit messages and markdown files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

------------ Window Resizing ------------
-- Auto resize splits when window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

------------ Highlight on Yank ------------
-- Highlight yanked region briefly
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})
