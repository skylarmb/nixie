-- -- A file of plugin specs to keep as reference, or that are still experimental
local M = {}

M.constants = {
  hard_background = {
    dark = {
      bg_dim = "#1D2224",
      bg0 = "#1D2224",
      bg1 = "#21272A",
      bg2 = "#282F32",
      bg3 = "#30383C",
      bg4 = "#394247",
      bg5 = "#3F494E",
      bg_visual = "#282f35",
      bg_red = "#493b40",
      bg_green = "#3f4841",
      bg_blue = "#384b55",
      bg_yellow = "#45443c",
    },
  },

  base_palette = {
    dark = {
      fg = "#B4B5A7",
      fgdark = "#AC9469",
      pink1 = "#B04D4E",
      red = "#B57A6A",
      orange = "#CB9800",
      orangedull = "#D0B35C",
      yellow = "#C2B11B",
      yellowlight = "#BCBD65",
      green = "#86A44F",
      green2 = "#5B9281",
      green3 = "#96B38F",
      pinkdark = "#D3859B",
      pinklight = "#E65154",
      aqua = "#33B1A6",
      blue = "#338E9F",
      yellowgrey = "#6D6048",
      blue2 = "#B2A77A",
      blue3 = "#44728A",
      blue4 = "#7D9196",
      blue5 = "#819EAD",
      purple = "#7075B2",
      purpledark = "#836AA3",
      grey = "#4F5045",
      grey0 = "#616255",
      grey1 = "#6C6D5F",
      grey2 = "#797A6A",
      grey3 = "#828372",
      grey4 = "#8B8C7A",
      grey5 = "#979985",
      grey6 = "#A0A28D",
      grey7 = "#A7A993",
      grey8 = "#B0B29B",
      grey9 = "#BABCA4",
      grey10 = "#C5C7AD",
      grey11 = "#CED0B5",
      statusline1 = "#6EBB9F",
      statusline2 = "#D3B980",
      statusline3 = "#E65255",
      none = "NONE",
    },
  },
  kana = {
    dragonBlack0 = "#0d0c0c",
    dragonBlack1 = "#12120f",
    dragonBlack2 = "#1D1C19",
    dragonBlack3 = "#181616",
    dragonBlack4 = "#282727",
    dragonBlack5 = "#393836",
    dragonBlack6 = "#625e5a",

    dragonWhite = "#c5c9c5",
    dragonGreen = "#87a987",
    dragonGreen2 = "#8a9a7b",
    dragonPink = "#a292a3",
    dragonOrange = "#b6927b",
    dragonOrange2 = "#b98d7b",
    dragonGray = "#a6a69c",
    dragonGray2 = "#9e9b93",
    dragonGray3 = "#7a8382",
    dragonBlue2 = "#8ba4b0",
    dragonViolet = "#8992a7",
    dragonRed = "#c4746e",
    dragonAqua = "#8ea4a2",
    dragonAsh = "#737c73",
    dragonTeal = "#949fb5",
    dragonYellow = "#c4b28a",
    dragonYellow2 = "#a99c8b",
    debug = "#ff00F0",
    -- "#8a9aa3",
  },
  kind_icons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
    Copilot = "",
  },
}

M.utils = {

  custom_highlights = function()
    -- set highlight overrides
    vim.cmd("hi NonText cterm=NONE ctermfg=NONE")
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "Grey" })
    vim.api.nvim_set_hl(0, "Search", { link = "TSWarning" }) -- yellow (default is puke green)
    vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "bg", fg = "bg", blend = 0 })
    vim.api.nvim_set_hl(0, "IncSearch", { link = "TSNote" })
    vim.api.nvim_set_hl(0, "TSTagAttribute", { link = "TSType" })
    vim.api.nvim_set_hl(0, "ErrorText", { undercurl = true, sp = "#ea6962" })
    vim.api.nvim_set_hl(0, "VirtualTextError", { link = "TSComment" })
    vim.api.nvim_set_hl(0, "VirtualTextWarning", { link = "TSComment" })
    vim.api.nvim_set_hl(0, "VirtualTextInfo", { link = "TSComment" })
    vim.api.nvim_set_hl(0, "BufferLineSeparator", { link = "Delimiter" })
    vim.api.nvim_set_hl(0, "BufferLineTabSeparator", { link = "Delimiter" })
    vim.api.nvim_set_hl(0, "BufferLineBackground", { link = "Delimiter" })
    vim.api.nvim_set_hl(0, "BufferLineFill", { link = "Delimiter" })
    vim.api.nvim_set_hl(0, "SidebarNvimLineNr", { link = "CursorLineNr" })
    vim.api.nvim_set_hl(0, "SidebarNvimLspDiagnosticsError", { link = "DiagnosticSignError" })
    vim.api.nvim_set_hl(0, "SidebarNvimLspDiagnosticsWarning", { link = "DiagnosticSignWarn" })
    vim.api.nvim_set_hl(0, "SidebarNvimLspDiagnosticsInfo", { link = "DiagnosticSignWarn" })
    vim.api.nvim_set_hl(0, "SidebarNvimLspDiagnosticsHint", { link = "DiagnosticSignHint" })
    vim.api.nvim_set_hl(0, "ExtraWhitespace", { link = "SpellBad" })
    vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "SignColumn", { link = "StatusLine" })
    vim.api.nvim_set_hl(0, "LineNr", { link = "StatusLine" })
    vim.api.nvim_set_hl(0, "illuminatedWord", { link = "LspReferenceText" })
  end,
  has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
  end,
}

M.disabled = {
  {
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_better_performance = 1
      set_colorscheme("light", "soft")
    end,
  },
  {
    "mcchrish/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.cmd("colorscheme forestbones")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      -- Default options:
      require("kanagawa").setup({
        -- compile = false, -- enable compiling the colorscheme
        -- undercurl = true, -- enable undercurls
        -- commentStyle = { italic = true },
        -- functionStyle = {},
        -- keywordStyle = { italic = true },
        -- statementStyle = { bold = true },
        -- typeStyle = {},
        -- transparent = false, -- do not set background color
        -- dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        -- terminalColors = true, -- define vim.g.terminal_color_{0,17}
        -- colors = { -- add/modify theme and palette colors
        --   palette = {},
        --   theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        -- },
        -- overrides = function(colors) -- add/modify highlights
        --   return {}
        -- end,
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "dragon", -- try "dragon" !
          light = "lotus",
        },
      })
      -- setup must be called before loading
      vim.cmd("colorscheme kanagawa")
    end,
  },

  {
    "dylanaraps/wal.vim",
    config = function()
      vim.opt.termguicolors = false
      vim.cmd("colorscheme wal")
    end,
  },

  {
    "sainnhe/gruvbox-material",
    lazy = false,
    config = function()
      vim.opt.termguicolors = true
      -- vim.g.gruvbox_material_background = 'soft'
      vim.g.gruvbox_material_better_performance = 1
      set_colorscheme()
    end,
  },
  {
    "RRethy/nvim-base16",
    config = function()
      -- vim.opt.background = "light"
      local light = require("colors.cigar-box")
      -- local light = require("colors.gruvbox-mesa")
      require("base16-colorscheme").setup(light.palette)
    end,
  },
  {
    "mcchrish/zenbones.nvim",
    lazy = false,
    priority = 1000,
    enabled = colorscheme == "zenbones",
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.g.forestbones = { lightness = "dim", darkness = "warm" }
      set_colorscheme("forestbones")
    end,
  },
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    enabled = colorscheme == "rose-pine",
    config = function()
      set_colorscheme("rose-pine")
    end,
  },
  {
    "savq/melange-nvim",
    enabled = colorscheme == "melange",
    config = function()
      set_colorscheme("melange")
    end,
  },
  {
    "sainnhe/sonokai",
    enabled = colorscheme == "sonokai",
    config = function()
      vim.g.sonokai_style = "espresso"
      vim.g.sonokai_better_performance = 1
      set_colorscheme("sonokai")
    end,
  },
  {
    "sainnhe/gruvbox-material",
    enabled = colorscheme == "gruvbox-material",
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_better_performance = 1
      set_colorscheme("gruvbox-material")
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    enabled = config.dark == "kanagawa",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      -- Default options:
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {
            dragonTeal = p.dragonYellow,
            dragonViolet = p.dragonYellow2,
            dragonBlue2 = p.statusline2,
            dragonAqua = p.dragonOrange2,
          },
          theme = {
            wave = {},
            lotus = {},
            dragon = {
              syn = {},
            },
            all = {},
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },

            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
          }
        end,
        theme = "wave", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "dragon", -- try "dragon" !
          light = "lotus",
        },
      })
      init_colorscheme("kanagawa")
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      -- dependencies
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "saadparwaiz1/cmp_luasnip" },
      -- UltiSnips support
      -- { "SirVer/ultisnips" },
      -- { "quangnguyen30192/cmp-nvim-ultisnips" },
    },
    config = function()
      local cmp = require("cmp")
      local cmp_action = require("lsp-zero").cmp_action()
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          -- ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          -- ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          -- ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          -- ["<Tab>"] = cmp_action.luasnip_supertab({
          --   behavior = cmp.ConfirmBehavior.Replace, -- important for copilot
          --   select = true,
          -- }),
          -- ["<S-Tab>"] = cmp_action.luasnip_shift_supertab({
          --   behavior = cmp.ConfirmBehavior.Replace, -- important for copilot
          --   select = true,
          -- }),
          -- ["<C-y>"] = cmp_action.luasnip_supertab({
          --   behavior = cmp.ConfirmBehavior.Replace, -- important for copilot
          --   select = true,
          -- }),
          ["<C-y>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            vim_item.kind = kind_icons[vim_item.kind]
            vim_item.menu = ({
              nvim_lsp = "",
              nvim_lua = "",
              luasnip = "",
              buffer = "",
              path = "",
              emoji = "",
            })[entry.source.name]
            return vim_item
          end,
        },
        sources = {
          -- Copilot Source
          { name = "copilot", group_index = 2 },
          -- Other Sources
          { name = "nvim_lsp", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "luasnip", group_index = 2 },
          -- { name = "nvim_lua" },
          -- { name = "nvim_lsp_signature_help" },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        experimental = {
          ghost_text = true,
        },
      })
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  -- lua rewrite of github official copilot plugin
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter", "LspAttach" },
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  -- copilot in autocomplete instead of ghost text
  {
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter", "LspAttach" },
    dependencies = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
  },
}

M.noop = {}
return M.noop
