return {
  -- Free <leader>gg from LazyVim's Lazygit binding so Neogit owns it
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>gg", false },
    },
  },
  -- Nice 3-way merging
  {
    "samoshkin/vim-mergetool",
    cmd = { "MergetoolStart", "MergetoolToggle" },
    init = function()
      -- Use 3-way split layout: base, merged, remote
      vim.g.mergetool_layout = "bmr"
    end,
  },
}
