-- trigger a smooth scroll if a cursor jump would go beyond the window
-- otherwise do normal cursor jump

return {
  -- -- UI libs used by some plugins
  { "nvim-tree/nvim-web-devicons", lazy = false },

  -- nicer quickfix window
  { "kevinhwang91/nvim-bqf", event = "VeryLazy" },

  -- unobstrusive notifier
  {
    "vigoux/notifier.nvim",
    event = { "VimEnter" },
    opts = {
      components = {
        "nvim", -- Nvim notifications (vim.notify and such)
        "lsp",
      },
      component_name_recall = true,
    },
  },
  -- dynamic identation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufRead",
    opts = {},
  },

  -- preview dialog for LSP actions
  {
    "aznhe21/actions-preview.nvim",
  },
  -- preview definition in floating window
  {
    "rmagatti/goto-preview",
    event = { "LspAttach" },
    dependencies = {
      { "trouble.nvim" },
      { "telescope.nvim" },
      { "nvim-colorizer.lua" },
      {
        "CosmicNvim/cosmic-ui",
        dependencies = { "nui.nvim", "plenary.nvim" },
        config = function()
          require("cosmic-ui").setup()
        end,
      },
    },
    config = function()
      require("goto-preview").setup({
        width = 120,
        height = 68, -- 16:10 ratio
        stack_floating_preview_windows = false, -- re-use float
      })
    end,
  },
}
