---------- Editor ----------
return {
  -- quote/bracket and surround motions
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },
  -- Autopairs, integrates with both cmp and treesitter
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {
      check_ts = true, -- treesitter integration
    }
  },
  -- respect editorconfig files
  { "editorconfig/editorconfig-vim", lazy = false },
  -- nuke whitespace
  { "ntpeters/vim-better-whitespace", lazy = false },
  -- sorting as a motion
  { "christoomey/vim-sort-motion", event = "VeryLazy" },
  -- treesitter-aware commenting that works with TSX
  {
    "numToStr/Comment.nvim",
    event = { "VeryLazy" },
  },
}
