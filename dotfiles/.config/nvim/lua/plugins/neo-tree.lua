return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          -- Show git-tracked files even if they start with .
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    },
  },
}
