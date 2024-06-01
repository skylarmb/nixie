-- template
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "foo" },
--   callback = function()
--   end,
-- })

-- special syntax handling
-- vim.api.nvim_create_autocmd({ "ColorSchemePre" }, {
--   pattern = { "*" },
--   callback = function()
--     vim.cmd([[highlight clear]])
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ "ColorScheme" }, {
--   pattern = { "*" },
--   callback = function()
--     vim.cmd([[highlight Normal guifg=#fdf4c1 guibg=NONE]])
--
--     vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", fg = "#fdf4c1" })
--     vim.api.nvim_set_hl(0, "NonText", { bg = "NONE", fg = "NONE" })
--     vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", fg = "#282828" })
--   end,
-- })

-- If accidentally editing a git-relative absolute file path that does not
-- exist, but it is an actual file path relative to the git root, edit the file
vim.api.nvim_create_autocmd("BufWinEnter", {
  once = true,
  pattern = "*",
  callback = function()
    local path = vim.fn.expand("<afile>")
    local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("%s+", "")
    local git_relative_path = vim.fn.system("git ls-files --full-name | grep -o " .. path):gsub("%s+", "")
    local git_path = git_root .. "/" .. git_relative_path
    local exists = vim.fn.filereadable
    -- edit git path instead of absolute path
    if exists(path) == 0 and exists(git_path) == 1 then
      vim.cmd("new " .. git_path)
      vim.cmd("wincmd o")
      vim.cmd("filetype detect")
      vim.schedule(function()
        vim.notify("Editing git path instead:")
        vim.notify(git_relative_path)
      end)
      return
    end
  end,
})
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   pattern = "*",
--   callback = function()
--   end,
-- })

-- vim.api.nvim_create_autocmd("User", {
--   pattern = "ScrollEnd",
--   callback = function()
--     -- print("----END-----------------------------------------------------")
--     vim.wo.cursorline = true
--     vim.o.tabline = "%!TabbyRenderTabline()"
--
--     vim.cmd("IndentBlanklineEnable")
--     vim.cmd("set eventignore=")
--     vim.cmd("IlluminateResume")
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "ScrollStart",
--   callback = function()
--     -- print("----START-----------------------------------------------------")
--     vim.wo.cursorline = false
--     -- freeze the tabline during scroll so it doesnt constantly re-render on every CursorMoved event
--     local tabline_tmp = vim.api.nvim_exec2([[echo TabbyRenderTabline()]], { output = true })
--     vim.o.tabline = tabline_tmp.output
--     vim.cmd("IndentBlanklineDisable")
--     vim.cmd("IlluminatePause")
--     vim.cmd("set eventignore=CursorMoved,WinScrolled")
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "*.Jenkinsfile", "Jenkinsfile" },
  callback = function()
    vim.cmd("set ft=groovy")
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "Dockerfile.handlebars", "*.Dockerfile.handlebars" },
  callback = function()
    vim.cmd("set ft=dockerfile")
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyInstall",
  callback = function()
    vim.cmd("helptags ALL")
    vim.notify("Regenerated helptags!")
  end,
})

-- autocmd InsertLeave * execute 'normal! mI'
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    vim.cmd("normal! m'")
    vim.cmd("normal! mI")
  end,
})

vim.api.nvim_create_autocmd({ "QuitPre" }, {
  callback = function()
    require("project_nvim.utils.history").write_projects_to_history()
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

local function safe_path_name(path)
  local name = path:gsub("/", "_")
  return name
end

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

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- -- Automatically close tab/vim when nvim-tree is the last window in the tab
-- vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

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

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd("StripWhitespace")
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

vim.api.nvim_create_autocmd({ "ColorSchemePre" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd([[highlight clear]])
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "kanagawa-kai.lua" },
  callback = function()
    vim.cmd("colorscheme kanagawa-kai")
    -- refresh remote nvim instances
    os.execute("nvr -cc 'colorscheme kanagawa-kai'")
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
vim.keymap.set("n", "<Leader>b", function()
  local curbufnr = vim.api.nvim_get_current_buf()
  local buflist = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buflist) do
    if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
      vim.cmd("bd " .. tostring(bufnr))
    end
  end
end, { silent = true, desc = "Close unused buffers" })

-- pause illuminate and colorizer on large files
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count >= 1000 then
      vim.cmd("IlluminatePauseBuf")
      vim.notify("Illuminate paused")
    end
  end,
})

-- override some plugin keymaps to noop
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.keymap.set({ "n", "v", "o" }, ")", function() end, { noremap = true, silent = true, buffer = true })
    vim.keymap.set({ "n", "v", "o" }, "(", function() end, { noremap = true, silent = true, buffer = true })
  end,
})

-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = {},
--   callback = function()
--     local name = vim.api.nvim_buf_get_name(0)
--     local ft = vim.api.nvim_buf_get_option(0, "filetype")
--     if name == "" and ft == "" then
--       vim.notify("Empty buffer!!")
--       vim.cmd(":Startify")
--     else
--       vim.notify("name: " .. name .. " ft: " .. ft)
--     end
--   end,
-- })

-- -- refresh lualine on LSP progress
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
-- vim.cmd([[
-- augroup lualine_augroup
--     autocmd!
--     autocmd User LspProgressStatusUpdated lua require("lualine").refresh()
-- augroup END
-- ]])
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.slint" },
  callback = function()
    vim.cmd("setlocal filetype=slint")
  end,
})
