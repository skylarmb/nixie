vim.fn.setenv("TERM", "screen-256color")

-- dont run expensive plugins in child nvims
if os.getenv("NVIM") ~= nil then
  return
end

-- set leader before config / plugins
vim.g.mapleader = " "
require("user/options")

-- lazy load plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "folke/lazy.nvim" }, -- lazy.nvim can manage itself
  { import = "plugins" },
}, {
  defaults = {
    lazy = true,
    version = false, -- always use the latest git commit
  },
  dev = {
    path = "~/workspace/nvim_dev",
    patterns = { "local" },
  },
  install = { colorscheme = { "torchlight" } },
  checker = {
    enabled = true,
    concurrency = 1, -- set to 1 to check for updates very slowly
    notify = false, -- get a notification when new updates are found
    frequency = 60 * 60 * 24 * 7, -- check for updates once a week
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      -- disable some rtp plugins that I don't use
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("user/keymaps")
require("user/autocommands")
