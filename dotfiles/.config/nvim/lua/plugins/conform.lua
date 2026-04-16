return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Configure formatters by filetype
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "eslint_d", "prettierd" },
        javascriptreact = { "eslint_d", "prettierd" },
        typescript = { "eslint_d", "prettierd" },
        typescriptreact = { "eslint_d", "prettierd" },
        json = { "prettierd" },
        nix = { "nixfmt" },
        -- Fallback: remove trailing whitespace for all files
        ["*"] = { "trim_whitespace" },
      },
    },
  },
}
