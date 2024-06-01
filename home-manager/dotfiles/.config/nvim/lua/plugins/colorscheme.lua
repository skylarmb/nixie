THEME = os.getenv("THEME") or "dark"
vim.opt.background = "dark"

return {
  {
    "skylarmb/torchlight.nvim",
    lazy = false,
    config = function()
      require("torchlight").setup({
        contrast = "hard",
      })
    end,
  },
  { -- callbacks when system darkmode changes
    "f-person/auto-dark-mode.nvim",
    dependencies = { "zenbones", "lush" },
    enabled = false,
    event = "VeryLazy",
    priority = 1,
    config = function()
      vim.print("calling auto-dark-mode")
      require("auto-dark-mode").setup({
        update_interval = 5000,
        set_light_mode = function()
          vim.opt.background = "light"
          vim.cmd("colorscheme gruvbox-material")
        end,
        set_dark_mode = function()
          vim.opt.background = "dark"
          vim.cmd("colorscheme gruvbox-material")
        end,
      })
      require("auto-dark-mode").init()
    end,
  },
}
