local utils = require("user.utils")

-- local border = {
--   { "┏", "NormalFloat" },
--   { "━", "NormalFloat" },
--   { "┓", "NormalFloat" },
--   { "┃", "NormalFloat" },
--   { "┛", "NormalFloat" },
--   { "━", "NormalFloat" },
--   { "┗", "NormalFloat" },
--   { "┃", "NormalFloat" },
-- }

local smart_goto_definition = function()
  -- Get the current buffer number
  local current_bufnr = vim.api.nvim_get_current_buf()

  -- Make an LSP request for definition
  local params = vim.lsp.util.make_position_params()

  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx)
    if err then
      vim.notify("Error getting definition: " .. err.message, vim.log.levels.ERROR)
      return
    end

    if not result or vim.tbl_isempty(result) then
      vim.notify("No definition found", vim.log.levels.INFO)
      return
    end

    -- Handle both single response and response array
    local target = vim.tbl_islist(result) and result[1] or result

    -- Get the target URI and convert it to a buffer number if it's already loaded
    local target_uri = target.uri or target.targetUri
    local target_bufnr = vim.uri_to_bufnr(target_uri)

    -- If the target is in the same buffer, use regular definition jump
    if target_bufnr == current_bufnr then
      vim.lsp.buf.definition()
    else
      -- If target is in a different buffer, use preview
      require("goto-preview").goto_preview_definition()
    end
  end)
end

-- Text Box Border Wrapper Function
-- local create_box_border = function(contents)
--   if not contents or #contents == 0 then
--     return {}
--   end
--   local max_width = 0 -- Find the longest line to determine box width
--   for _, line in ipairs(contents) do
--     max_width = math.max(max_width, #line)
--   end
--   local box_width = max_width + 2 -- Add 2 for left and right padding
--   local result = {} -- Create the bordered box
--   table.insert(result, "╭" .. string.rep("─", box_width) .. "╮") -- Top border
--   for _, line in ipairs(contents) do -- Content lines
--     local padded_line = line .. string.rep(" ", max_width - #line) -- Right-pad the line to max_width
--     table.insert(result, "│ " .. padded_line .. " │")
--   end
--   table.insert(result, "╰" .. string.rep("─", box_width) .. "╯") -- Bottom border
--   return result
-- end

local setup_cmp = function()
  local cmp = require("cmp")
  require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    copilot_node_command = os.getenv("HOME") .. "/.nix-profile/bin/node",
  })
  require("copilot_cmp").setup()
  local popup_style = {
    border = "rounded",
    col_offset = -2,
    scrollbar = false,
    scrolloff = 0,
    zindex = 1001,
  }
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = "luasnip", option = { show_autosnippets = true }, priority = 1000 },
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "copilot" },
      { name = "path" },
    }),
    experimental = {
      ghost_text = true,
    },
    window = {
      completion = popup_style,
      documentation = popup_style,
    },
    formatting = {
      format = require("lspkind").cmp_format({
        mode = "text_symbol", -- show only symbol annotations
        ellipsis_char = "...",
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default
      }),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-y>"] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
    }),
  })
  require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets" })
end

local on_attach = function(client, bufnr)
  local opts = { buffer = true, silent = true, noremap = true }
  local diag_err = { buffer = bufnr, severity = vim.diagnostic.severity.ERROR }
  local diag_any = { buffer = bufnr }
  local keymap = require("user.utils").keymap
  keymap.n("gq", function()
    vim.diagnostic.setloclist()
  end, opts)

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

  --
  keymap.n("gd", smart_goto_definition, opts)

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
end

return {
  -- standalone typescript LSP config, alternative to nvim-lspconfig with more features
  {
    "pmizio/typescript-tools.nvim",
    priority = 10,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          -- spawn additional tsserver instance to calculate diagnostics on it
          separate_diagnostic_server = true,
          -- "change"|"insert_leave" determine when the client asks the server about diagnostic
          publish_diagnostic_on = "insert_leave",
          -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
          -- "remove_unused_imports"|"organize_imports") -- or string "all"
          -- to include all supported code actions
          -- specify commands exposed as code_actions
          expose_as_code_action = {},
          -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
          -- not exists then standard path resolution strategy is applied
          tsserver_path = nil,
          -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
          -- (see 💅 `styled-components` support section)
          tsserver_plugins = {},
          -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
          -- memory limit in megabytes or "auto"(basically no limit)
          tsserver_max_memory = "auto",
          -- described below
          tsserver_format_options = {},
          tsserver_file_preferences = {
            importModuleSpecifierPreference = "non-relative",
            importModuleSpecifierEnding = "minimal",
          },
          -- locale of all tsserver messages, supported locales you can find here:
          -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
          tsserver_locale = "en",
          -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
          -- complete_function_calls = true,
          include_completions_with_insert_text = true,
          -- CodeLens
          -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
          -- possible values: ("off"|"all"|"implementations_only"|"references_only")
          code_lens = "off",
          -- by default code lenses are displayed on all referencable values and for some of you it can
          -- be too much this option reduce count of them by removing member references from lenses
          disable_member_code_lens = true,
          -- JSXCloseTag
          -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
          -- that maybe have a conflict if enable this feature. )
          jsx_close_tag = {
            enable = false,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    -- opts = function(_, opts)
    --   opts.diagnostics = {
    --     float = {
    --       border = "rounded",
    --     },
    --   }
    --   return opts
    -- end,
  },

  -- floating previews for LSP definitions, references etc

  {
    "mason-org/mason-lspconfig.nvim",
    priority = 9,
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
      })

      -- -- Override floating window appearance to add both border + shadow
      -- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      -- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      --   opts = opts or {}
      --   opts.border = "shadow"
      --   contents = create_box_border(contents)
      --   return orig_util_open_floating_preview(contents, syntax, opts, ...)
      -- end

      -- require("mason-lspconfig").setup_handlers({
      --   -- The first entry (without a key) will be the default handler
      --   -- and will be called for each installed server that doesn't have
      --   -- a dedicated handler.
      --   function(server_name) -- default handler (optional)
      --     require("lspconfig")[server_name].setup({
      --       on_attach = on_attach,
      --     })
      --   end,
      -- })

      require("lspconfig").gleam.setup({
        on_attach = on_attach,
      })
      require("lspconfig")["typescript-tools"].setup({
        on_attach = on_attach,
      })

      setup_cmp()
    end,
  },
  {
    "mhartington/formatter.nvim",
    lazy = false,
    config = function()
      local es_formatters = {
        require("formatter.filetypes.typescript").eslint_d,
        require("formatter.filetypes.typescript").prettierd,
      }
      require("formatter").setup({
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          lua = { require("formatter.filetypes.lua").stylua },
          json = es_formatters,
          typescript = es_formatters,
          typescriptreact = es_formatters,
          javascript = es_formatters,
          javascriptreact = es_formatters,
          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
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
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "LspAttach" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim", -- vs-code like pictograms
      "zbirenbaum/copilot.lua",
      "zbirenbaum/copilot-cmp",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",
    },
  },
}
