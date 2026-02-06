return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        -- Show git-tracked files even if they start with .
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
  },
}
