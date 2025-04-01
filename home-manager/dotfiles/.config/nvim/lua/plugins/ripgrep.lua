local ag_opts = "--vimgrep --width 4096 --literal --hidden --follow --ignore-case"

return {
  {
    "jremmen/vim-ripgrep",
    cmd = { "Rg" },
    config = function()
      vim.g.rg_command = "rg --hidden --follow --smart-case --vimgrep"
      vim.g.rg_highlight = true
      vim.g.rg_derive_root = true
      vim.g.rg_root_types = { "package.json", "pnpm-workspace.yaml", ".git" }
    end,
  },
}
