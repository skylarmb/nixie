return {
  -- show color codes with background color
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup({
        -- filetype overrides
      }, {
        -- default options
        "*", -- Highlight all files, but customize some others.
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        mode = "background", -- Set the display mode.
      })
    end,
    init = function()
      -- enable colorizer for any language that has an LSP
      vim.api.nvim_create_autocmd({ "LspAttach" }, {
        callback = function()
          vim.cmd("ColorizerAttachToBuffer")
          -- refresh hex color code highlighting when not editing (can get out of sync)
        end,
      })
      vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
        callback = function()
          vim.cmd("ColorizerReloadAllBuffers")
        end,
      })
    end,
  },
  -- highlight expression under cursor
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },

        delay = 200,
        filetypes_denylist = {
          "dirvish",
          "fugitive",
          "alpha",
          "NvimTree",
          "packer",
          "neogitstatus",
          "Trouble",
          "lir",
          "Outline",
          "spectre_panel",
          "toggleterm",
          "DressingSelect",
          "TelescopePrompt",
        },
        filetypes_allowlist = {},
        modes_denylist = {},
        modes_allowlist = {},
        providers_regex_syntax_denylist = {},
        providers_regex_syntax_allowlist = {},
        under_cursor = true,
      })
    end,
    init = function()
      vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree" }
      vim.api.nvim_set_keymap(
        "n",
        "<a-n>",
        '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<a-p>",
        '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
        { noremap = true }
      )
    end,
  },
  -- dim inactive code regions
  {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup({
        dimming = {
          alpha = 0.75, -- amount of dimming
          inactive = true,
        },
      })
    end,
  },
}
