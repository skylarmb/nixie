return {
  -- dump command output to buffer with :Bufferize
  -- { "AndrewRadev/bufferize.vim", cmd = { "Bufferize" } },
  -- debug echo,
  -- { "vim-scripts/Decho", cmd = { "Decho" } },
  -- Bdelete!
  -- { "moll/vim-bbye", cmd = { "Bdelete", "Bwipeout" } },
  -- seamless jumping between tmux panes and buffers
  {
    "alexghergh/nvim-tmux-navigation",
    lazy = false,
    opts = {
      disable_when_zoomed = true, -- defaults to false
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {--[[ things you want to change go here]]
      float_opts = {
        border = "none",
      },
    },
  },
}
