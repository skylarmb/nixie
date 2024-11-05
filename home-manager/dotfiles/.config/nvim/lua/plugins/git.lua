return {
  -- :Git commands
  { "tpope/vim-fugitive", cmd = { "Git" } },
  -- Git gutter signs
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▎" },
        topdelete = { text = "▎" },
        changedelete = { text = "▎" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    },
  },
  -- Nice 3 way merging
  {
    "samoshkin/vim-mergetool",
    cmd = { "MergeToolStart", "MergetoolToggle" },
  },
}
