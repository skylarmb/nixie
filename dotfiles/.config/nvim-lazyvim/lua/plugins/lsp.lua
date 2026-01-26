return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            -- Disable K hover keymap so we can use it for fast scroll up
            { "K", false },
          },
        },
      },
    },
  },
}
