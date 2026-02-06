return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Configure formatters by filetype
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "eslint_d", "prettier" },
        javascriptreact = { "eslint_d", "prettier" },
        typescript = { "eslint_d", "prettier" },
        typescriptreact = { "eslint_d", "prettier" },
        json = { "eslint_d", "prettier" },
        -- Fallback: remove trailing whitespace for all files
        ["*"] = { "trim_whitespace" },
      },
    },
  },
}
