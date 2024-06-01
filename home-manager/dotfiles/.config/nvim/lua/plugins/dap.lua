-- DAP,
return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("go").setup()
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
  {
    "rcarriga/nvim-dap-ui",
    cmd = { "DapToggleBreakpoint", "DapToggleRepl", "DapStepInto" },
    lazy = true,
    dependencies = {
      { "mfussenegger/nvim-dap" },
      -- {
      --   "ravenxrz/DAPInstall.nvim",
      --   lazy = true,
      --   config = function()
      --     local dap_install = require("dap-install")
      --     dap_install.setup({})
      --     dap_install.config("python", {})
      --     dap_install.config("node", {})
      --     dap_install.config("go", {})
      --   end,
      -- },
    },
    opts = {
      expand_lines = true,
      icons = { expanded = "", collapsed = "", circular = "" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 0.33,
          position = "right",
        },
        {
          elements = {
            { id = "repl", size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5, -- Floats will be treated as percentage of your screen.
        border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  -- symbols and breakpoints right sidebar
  {
    "sidebar-nvim/sidebar.nvim",
    cmd = { "SidebarNvimOpen", "SidebarNvimToggle" },
    dependencies = {
      { "sidebar-nvim/sections-dap" },
    },
    config = function()
      require("sidebar-nvim").setup({
        open = false,
        bindings = {
          ["q"] = function()
            require("sidebar-nvim").close()
          end,
          ["r"] = function()
            require("sidebar-nvim").update()
          end,
        },
        todos = {
          icon = "",
          ignored_paths = { "~" }, -- ignore certain paths, this will prevent huge folders like $HOME to hog Neovim with TODO searching
          initially_closed = false, -- whether the groups should be initially closed on start. You can manually open/close groups later.
        },
        symbols = {
          icon = "ƒ",
        },
        disable_default_keybindings = 0,
        side = "right",
        initial_width = 35,
        hide_statusline = false,
        update_interval = 1000,
        sections = {
          "todos",
          "diagnostics",
          require("dap-sidebar-nvim.breakpoints"),
          "symbols",
        },
        dap = {
          breakpoints = {
            icon = "🔍",
          },
        },
        section_separator = {
          "",
          "⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯⎯",
          "",
        },
        section_title_separator = { "" },
      })
    end,
  },
}
