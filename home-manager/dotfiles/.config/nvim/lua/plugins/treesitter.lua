return {
  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        auto_install = true,
        ensure_installed = {
          "lua",
          "markdown",
          "markdown_inline",
          "bash",
          "python",
          "typescript",
          "regex",
        },
        incremental_selection = { enable = false },
        textobjects = { enable = true },
        sync_install = false,
        highlight = {
          enable = true, -- false will disable the whole extension
          custom_captures = {
            ["tsxTag"] = "TSSymbol",
            ["tsxTagName"] = "TSSymbol",
            ["constructor"] = "TSSymbol",
          },
        },
        autopairs = {
          enable = true,
        },
        indent = { enable = true },
      })
    end,
  },
  -- treesitter powered auto-closing tags for html, tsx, etc.
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  -- context aware comment formatting, e.g. for jsx render() fn
  -- { "JoosepAlviste/nvim-ts-context-commentstring", event = "VeryLazy" },
}
