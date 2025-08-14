-- trigger a smooth scroll if a cursor jump would go beyond the window
-- otherwise do normal cursor jump

return {
  -- -- UI libs used by some plugins
  { "nvim-tree/nvim-web-devicons", lazy = false },

  -- nicer quickfix window
  { "kevinhwang91/nvim-bqf", event = "VeryLazy" },

  -- unobstrusive notifier
  -- {
  --   "vigoux/notifier.nvim",
  --   event = { "VimEnter" },
  --   opts = {
  --     components = {
  --       "nvim", -- Nvim notifications (vim.notify and such)
  --       "lsp",
  --     },
  --     component_name_recall = true,
  --   },
  -- },
  -- Notifications
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      require("notify").setup({
        stages = "fade_in_slide_out",
        background_colour = "FloatShadow",
        timeout = 3000,
      })
      vim.notify = require("notify")
    end,
  },
  -- dynamic identation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufRead",
    opts = {},
  },

  -- preview dialog for LSP actions
  -- {
  --   "aznhe21/actions-preview.nvim",
  -- },
  -- preview definition in floating window
  {
    "rmagatti/goto-preview",
    event = { "LspAttach" },
    dependencies = {
      { "trouble.nvim" },
      { "telescope.nvim" },
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
  -- {
  --   "rachartier/tiny-glimmer.nvim",
  --   event = "VeryLazy",
  --   priority = 10, -- Needs to be a really low priority, to catch others plugins keybindings.
  --   config = function()
  --     require("tiny-glimmer").setup({
  --       overwrite = {
  --         yank = {
  --           enabled = true,
  --         },
  --         search = {
  --           enabled = true,
  --           default_animation = {
  --             name = "pulse",
  --
  --             settings = {
  --               from_color = "Normal",
  --               to_color = "CursorLine",
  --             },
  --           },
  --         },
  --         paste = {
  --           enabled = true,
  --         },
  --         undo = {
  --           enabled = true,
  --         },
  --         redo = {
  --           enabled = true,
  --           redo_mapping = "U",
  --         },
  --       },
  --       -- Animations for other operations
  --       presets = {
  --         pulsar = {
  --           enabled = true,
  --           on_events = { "CursorMoved", "CmdlineEnter", "WinEnter" },
  --         },
  --       },
  --       animations = {
  --         pulse = {
  --           from_color = "Normal",
  --           to_color = "CursorLine",
  --         },
  --       },
  --     })
  --     require("tiny-glimmer").change_hl("all", { from_color = "Normal", to_color = "CursorLine" })
  --   end,
  -- },
}
