local utils = require("user.utils")

local border = {
  { "┗", "FloatBorder" },
  { "━", "FloatBorder" },
  { "┛", "FloatBorder" },
  { "┃", "FloatBorder" },
  { "┏", "FloatBorder" },
  { "▁", "FloatBorder" },
  { "┓", "FloatBorder" },
  { "┃", "FloatBorder" },
}

local on_attach = function(client, bufnr)
  local opts = { buffer = true, silent = true, noremap = true }
  local diag_err = { buffer = bufnr, severity = vim.diagnostic.severity.ERROR }
  local diag_any = { buffer = bufnr }
  local keymap = require("user.utils").keymap
  keymap.n("gq", function()
    vim.diagnostic.setloclist()
  end, opts)

  ---------------------------------------------------------------------------
  -- DIAGNOSTIC
  ---------------------------------------------------------------------------
  -- errors
  keymap.n("gE", function()
    vim.diagnostic.goto_prev(diag_err)
  end, opts)
  keymap.n("gP", function()
    vim.diagnostic.goto_prev(diag_err)
  end, opts)
  -- all diagnostics
  keymap.n("gp", function()
    vim.diagnostic.goto_next(diag_any)
  end, opts)
  keymap.n("ge", function()
    vim.diagnostic.goto_next(diag_any)
  end, opts)
  keymap.leader("lq", function()
    vim.diagnostic.setloclist()
  end)
  keymap.n("gl", function()
    vim.diagnostic.open_float()
  end)
  keymap.leader("wd", function()
    vim.cmd("TroubleToggle workspace_diagnostics")
  end)

  -- hints and help
  keymap.n("gh", function()
    vim.lsp.buf.signature_help()
  end, opts)

  keymap.n("rn", function()
    require("cosmic-ui").rename()
  end, opts)
  keymap.n("ga", function()
    require("cosmic-ui").code_actions()
  end)
  keymap.v("ga", function()
    require("cosmic-ui").range_code_actions()
  end, opts)

  -- preview lsp jumps by default
  keymap.n("gd", function()
    require("goto-preview").goto_preview_definition()
  end, opts)
  keymap.n("gD", function()
    require("goto-preview").goto_preview_type_definition()
  end)
  keymap.n("gi", function()
    require("goto-preview").goto_preview_implementation()
  end)
  keymap.n("gr", function()
    require("goto-preview").goto_preview_references()
  end)
  keymap.n("gp", function()
    require("goto-preview").close_all_win()
  end)

  -- cosmic handlers
  keymap.n("rn", function()
    require("cosmic-ui").rename()
  end)
  keymap.n("ga", function()
    require("cosmic-ui").code_actions()
  end)
  keymap.v("ga", function()
    require("cosmic-ui").range_code_actions()
  end)

  -- default lsp handlers, good as a fallback for above preview behavior
  keymap.n("gld", function()
    vim.lsp.buf.definition()
  end, opts)
  keymap.n("gli", function()
    vim.lsp.buf.declaration()
  end)
  keymap.n("glt", function()
    vim.lsp.buf.declaration()
  end)
  keymap.n("glr", function()
    vim.lsp.buf.references()
  end)
  keymap.leader("glR", function()
    vim.lsp.buf.rename()
  end)
  keymap.leader("gla", function()
    vim.lsp.buf.code_action()
  end)
  keymap.leader("ls", function()
    vim.lsp.buf.signature_help()
  end)

  -- fix everything
  keymap.nvo("gf", function()
    vim.cmd(":FormatWrite")

    local filetype = vim.bo[bufnr].filetype
    if vim.tbl_contains({ "typescript", "typescriptreact", "javascript", "javascriptreact" }, filetype) then
      local ts_tools = require("typescript-tools.api")
      utils.sequence_calls({
        function()
          ts_tools.remove_unused_imports(true)
        end,
        function()
          ts_tools.add_missing_imports(true)
        end,
        function()
          ts_tools.fix_all(true)
        end,
      })
    end
  end)

  require("illuminate").on_attach(client)
  require("colorizer").attach_to_buffer(bufnr)
end

return {
  -- standalone typescript LSP config, alternative to nvim-lspconfig with more features
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },

  -- floating previews for LSP definitions, references etc
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
      },
      {
        "neovim/nvim-lspconfig",
      },
    },

    config = function()
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
        automatic_installation = true,
      })
      -- To instead override globally
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      require("mason-lspconfig").setup_handlers({
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            on_attach = on_attach,
          })
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        ["rust_analyzer"] = function()
          require("rust-tools").setup({})
        end,
      })
    end,
  },
  {
    "mhartington/formatter.nvim",
    lazy = false,
    config = function()
      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require("formatter.filetypes.lua").stylua,
          },
        },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {
      severity = vim.diagnostic.severity.ERROR,
    },
    keys = {
      {
        "<leader>t",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
    },
  },
}
