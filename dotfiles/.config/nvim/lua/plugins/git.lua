return {
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
