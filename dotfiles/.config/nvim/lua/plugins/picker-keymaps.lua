-- Disable Snacks' default <leader><space> picker binding so we can use it
-- for :nohlsearch in keymaps.lua
return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader><space>", false },
    },
    opts = {
      -- Show dotfiles/dot-dirs (e.g. .github/) in pickers while still respecting .gitignore
      picker = { hidden = true },
    },
  },
}
