return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            -- Disable K hover keymap so we can use it for fast scroll up
            { "K", false },
            -- Disable default gd and gD keymaps to use custom ones
            { "gd", false },
            { "gD", false },
          },
        },
      },
    },
  },
  -- Preview definition in floating window (disabled: floating window crash)
  -- {
  --   "rmagatti/goto-preview",
  --   event = "LspAttach",
  --   opts = {
  --     width = 120,
  --     height = 68, -- 16:10 ratio
  --     stack_floating_preview_windows = false, -- re-use float
  --   },
  -- },
  -- VSCode-style peek preview for LSP definitions/references
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    opts = {
      border = {
        enable = true,
      },
      theme = {
        mode = "darken",
      },
    },
  },
}
