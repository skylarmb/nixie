-- Disable Snacks' default <leader><space> picker binding so we can use it
-- for :nohlsearch in keymaps.lua
return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader><space>", false },
    },
  },
}
