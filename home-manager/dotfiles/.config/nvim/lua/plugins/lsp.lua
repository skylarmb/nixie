-- some pieces of this need to be called in a specific order (e.g. null-ls and mason stuff), so one mega setup fn is the simplest solution

local box = {
  bl = "┗",
  br = "┛",
  h = "━",
  tl = "┏",
  tr = "┓",
  v = "┃",
}

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
  Copilot = "",
}

local severity = vim.diagnostic.severity
local severity_icons = {
  [severity.ERROR] = "",
  [severity.WARN] = "",
  [severity.INFO] = "",
  [severity.HINT] = "",
  -- eslint_d = "",
  -- eslint = "",
  -- tsserver = "",
  -- typescript = "",
  -- lua_syntax_check = "󰢱",
  -- lua_diagnostics = "󰢱",
}

local function setup_lsp()
  local illuminate = require("illuminate")
  local colorizer = require("colorizer")
  local null_ls = require("null-ls")
  local lspconfig = require("lspconfig")

  ---- LSP ----
  local lsp = require("lsp-zero").preset({
    name = "recommended",
    float_border = "shadow",
    set_lsp_keymaps = {
      preserve_mappings = true,
      omit = { "[d", "]d", "gs", "K" },
    },
  })

  local on_attach = function(client, bufnr)
    local opts = { buffer = true, silent = true, noremap = true }
    local diag_err = { buffer = bufnr, severity = vim.diagnostic.severity.ERROR }
    local diag_any = { buffer = bufnr }
    local keymap = require("user.utils").keymap
    keymap.n("gli", "<cmd>LspInfo<cr>", opts)
    keymap.n("glI", "<cmd>Mason<cr>", opts)

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
    keymap.n("gs", function()
      -- attempt to jump source definition (ignoring .d.ts shadowing)
      require("typescript").goToSourceDefinition(vim.fn.win_getid(), { fallback = true })
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
    keymap.n("gf", function()
      vim.lsp.buf.format({
        async = false,
        timeout_ms = 2000,
        filter = function(c)
          -- ignore language server formatters as null-ls replaces LSP format
          --    tsserver  => prettier, eslint
          --    lua_ls    => stylua
          -- etc
          return c.name == "null-ls"
        end,
      })

      local typescript = require("typescript")
      typescript.actions.fixAll()
      typescript.actions.addMissingImports()
      typescript.actions.removeUnused()
    end)

    illuminate.on_attach(client)
    colorizer.attach_to_buffer(bufnr)
    local open_float = vim.lsp.util.open_floating_preview
    vim.lsp.util.open_floating_preview = function(contents, syntax, o)
      local function border(side)
        local b = string.rep(box.h, (o.width or 80) - 2)
        if side == "top" then
          return box.tl .. b .. box.tr
        end
        return box.bl .. b .. box.br
      end
      local function is_box_char(char)
        local res = char:match("^[" .. table.concat(vim.tbl_values(box), "|") .. "]")
        return res
      end
      contents = vim.tbl_filter(function(v)
        return v ~= "" and v ~= nil
      end, contents)
      local first = contents[1]
      local last = contents[#contents]
      if not is_box_char(first) then
        table.insert(contents, 1, border("top"))
      end
      if not is_box_char(last) then
        table.insert(contents, border("bottom"))
      end
      contents = vim.tbl_map(function(v)
        if not is_box_char(v) then
          return string.format("%s %-78s %s", box.v, v, box.v)
        end
        return v
      end, contents)
      local res = open_float(contents, "Pmenu", o)
      return res
    end
    vim.diagnostic.config({
      virtual_text = false,
      float = {
        scope = "line",
        border = "shadow",
        severity_sort = true,
        source = false,
        header = "",
        prefix = "",
        format = function(diagnostic)
          local source = string.lower(diagnostic.source):gsub("[^%w]", "_"):gsub("_$", "")
          local prefix = (severity_icons[diagnostic.severity] or "") .. " "
          local message = " " .. diagnostic.message .. " "
          return prefix .. source .. " \n" .. message
        end,
      },
    })
  end

  lsp.on_attach(on_attach)

  lsp.set_server_config({
    single_file_support = false,
  })

  lsp.set_sign_icons({
    error = "",
    warn = "",
    hint = "",
    info = "◌",
  })

  lsp.format_on_save({
    servers = {
      ["null-ls"] = { "typescript", "typescriptreact", "javascript", "javascriptreact", "python" }, -- "lua", "dockerfile" },
      ["tsserver"] = {},
      -- ["denols"] = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
      ["gopls"] = { "go" },
      ["lua_ls"] = {},
      ["dockerls"] = { "dockerfile" },
    },
    format_opts = {
      async = false,
      timeout_ms = 2000,
    },
  })

  lsp.ensure_installed({
    -- Replace these with whatever servers you want to install
    "tsserver",
    "gopls",
    "lua_ls",
    "dockerls",
  })
  -- local denols_cmd = { "deno", "lsp" }
  -- local tsproject = lsp.dir.find_first({ "tsconfig.json" })
  -- if tsproject ~= nil then
  --   denols_cmd = { "deno", "lsp", "--config", tsproject .. "/tsconfig.json" }
  -- end
  -- lspconfig.denols.setup({
  --   root_dir = function()
  --     return lsp.dir.find_first({ "tsconfig.json" })
  --   end,
  --   cmd = denols_cmd
  -- })
  -- lspconfig.tsserver.setup()
  require("typescript").setup({
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false, -- enable debug logging for commands
    go_to_source_definition = {
      fallback = true, -- fall back to standard LSP definition on failure
    },
    server = { -- pass options to lspconfig's setup method
      on_attach = on_attach,
      root_dir = function()
        return lsp.dir.find_first({
          "package.json",
          "tsconfig.json",
          "pnpm-workspace.yaml",
          ".luarc.json",
          ".stylua.toml",
          ".git",
        })
      end,
    },
  })

  lsp.skip_server_setup({ "denols" })

  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  })

  lspconfig.slint_lsp.setup({})

  lspconfig.pyright.setup({})

  lsp.setup()

  ---- NULL-LS ----
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  local hover = null_ls.builtins.hover
  null_ls.setup({
    debug = false,
    sources = {
      formatting.stylua,
      -- formatting.luaformatter,
      formatting.gofmt,
      formatting.htmlbeautifier,
      formatting.jq,
      formatting.black,

      formatting.prettierd,
      formatting.prettierd,

      formatting.eslint_d,
      diagnostics.eslint_d,
      code_actions.eslint_d,

      hover.printenv,
    },
    log = {
      level = "debug",
    },
  })

  require("mason-null-ls").setup({
    ensure_installed = {
      "eslint_d",
      "prettierd",
      "stylua",
      "shellcheck",
      "goimports",
    },
    automatic_installation = false,
    handlers = {}, -- nil handler will use default handler for all sources
  })

  ---- CMP ----
  require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
  })
  require("copilot_cmp").setup()
  local cmp = require("cmp")

  local popup_style = {
    border = "shadow",
    col_offset = -2,
    scrollbar = false,
    scrolloff = 0,
    -- side_padding = 4,
    zindex = 1001,
  }
  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "luasnip" },
      { name = "copilot" },
      { name = "nvim_lsp" },
      { name = "path" },
      { name = "buffer" },
    },
    experimental = {
      ghost_text = true,
    },
    window = {
      completion = popup_style,
      documentation = popup_style,
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        vim_item.kind = kind_icons[vim_item.kind]
        vim_item.menu = ({
          luasnip = "",
          nvim_lsp = "",
          nvim_lua = "",
          buffer = "",
          path = "",
          emoji = "",
        })[entry.source.name]
        return vim_item
      end,
    },
    mapping = {
      ["<C-y>"] = cmp.mapping.confirm({
        -- documentation says this is important.
        -- I don't know why.
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      }),
    },
  })
  require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets" })
end

return {
  {
    "VonHeikemen/lsp-zero.nvim",
    lazy = true,
    event = { "BufRead" },
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      {
        -- Optional
        "williamboman/mason.nvim",
        build = function()
          vim.cmd("MasonUpdate")
        end,
      },
      { "williamboman/mason-lspconfig.nvim" }, -- Optional
      { "jose-elias-alvarez/null-ls.nvim" },
      { "jay-babu/mason-null-ls.nvim" },

      -- Shims / API for tsserver functionality
      { "jose-elias-alvarez/typescript.nvim" },

      -- Autocompletion
      { "hrsh7th/nvim-cmp" }, -- Required, managed in cmp.lua
      { "hrsh7th/cmp-nvim-lsp" }, -- Required, managed in cmp.lua
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "zbirenbaum/copilot.lua" },
      { "zbirenbaum/copilot-cmp" },
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
      }, -- Required, managed in cmp.lua
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = setup_lsp,
  },
  -- floating previews for LSP definitions, references etc
  {
    "folke/trouble.nvim",
    opts = {
      severity = vim.diagnostic.severity.ERROR,
    },
  },
  {
    "rmagatti/goto-preview",
    event = { "LspAttach" },
    dependencies = {
      "trouble.nvim",
      { "telescope.nvim" },
      { "nvim-colorizer.lua" },
      {
        "CosmicNvim/cosmic-ui",
        dependencies = { "nui.nvim", "plenary.nvim" },
        config = function()
          require("cosmic-ui").setup()
        end,
      },
    },
    config = function()
      require("goto-preview").setup({
        width = 120,
        height = 68, -- 16:10 ratio
        border = { box.tl, box.h, box.tr, box.v, box.br, box.h, box.bl, box.v },
        stack_floating_preview_windows = false,
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = { "InsertEnter", "LspAttach" },
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
