-- template
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "foo" },
--   callback = function()
--   end,
-- })

vim.api.nvim_create_augroup("__formatter__", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "__formatter__",
  command = ":FormatWrite",
})

-- Format Gleam files on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.gleam",
  callback = function()
    vim.cmd("silent !gleam format %")
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { ".env", ".env.*" },
  callback = function()
    vim.cmd("set ft=bash")
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyInstall",
  callback = function()
    vim.cmd("helptags ALL")
    vim.notify("Regenerated helptags!")
  end,
})

-- set mark when leaving insert mode
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    vim.cmd("normal! m'")
    vim.cmd("normal! mI")
  end,
})

vim.api.nvim_create_user_command("FindFiles", function()
  require("telescope.builtin").find_files({ cwd = vim.loop.cwd() })
end, {})

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

-- help window in right split if term is large enough
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

-- check spelling in commit messages and READMEs
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- auto resize splits when window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- close unused buffers
local id = vim.api.nvim_create_augroup("startup", {
  clear = false,
})

local persistbuffer = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.fn.setbufvar(bufnr, "bufpersist", 1)
end
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = id,
  pattern = { "*" },
  callback = function()
    vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
      buffer = 0,
      once = true,
      callback = function()
        persistbuffer()
      end,
    })
  end,
})

-- -- pause illuminate and colorizer on large files
-- vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
--   callback = function()
--     local line_count = vim.api.nvim_buf_line_count(0)
--     if line_count >= 500 then
--       vim.cmd("IlluminatePauseBuf")
--       vim.notify("Illuminate paused")
--     end
--   end,
-- })

-- refresh lualine on LSP progress
vim.api.nvim_create_augroup("lualine_augroup", {
  clear = false,
})

vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = function()
    require("lualine").refresh({
      scope = "tabpage", -- scope of refresh all/tabpage/window
      place = { "statusline" }, -- lualine segment ro refresh.
    })
  end,
})
