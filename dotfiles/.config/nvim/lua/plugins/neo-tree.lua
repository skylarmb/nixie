return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          -- Unmap `/` so it falls through to default vim text search
          -- instead of triggering neo-tree's fuzzy_finder
          ["/"] = "noop",
        },
      },
      filesystem = {
        filtered_items = {
          -- Show git-tracked files even if they start with .
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        -- Keep the tree synced to the current buffer as you switch files
        follow_current_file = {
          enabled = true,
        },
      },
    },
  },
}
