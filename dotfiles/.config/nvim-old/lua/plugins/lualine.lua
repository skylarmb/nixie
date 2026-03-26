local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = " ", warn = " " },
  colored = false,
  always_visible = true,
}

local diff = {
  "diff",
  colored = false,
  -- symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  symbols = { added = "+ ", modified = "~ ", removed = "- " }, -- changes diff symbols
  cond = hide_in_width,
}

local filetype = {
  "filetype",
  icons_enabled = false,
}

local location = {
  "location",
  padding = 0,
}

return {
  -- status line
  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          icons_enabled = true,
          globalstatus = true,
          component_separators = "",
          section_separators = { left = "", right = " " },
          disabled_filetypes = { "alpha", "dashboard", "NvimTree" },
          always_divide_middle = true,
          fmt = string.lower,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { diagnostics },
          lualine_c = {
            diff,
            {
              "filename",
              fmt = function(str)
                return str
              end,
              file_status = true, -- Displays file status (readonly status, modified status)
              newfile_status = false, -- Display new file status (new file means no write after created)
              path = 4, -- 4: Filename and parent dir
              shorting_target = 40, -- Shortens path to leave 40 spaces in the window
              symbols = {
                modified = "  ",
                readonly = "  ",
                unnamed = "  ",
                newfile = "  ",
              },
            },
          },
          lualine_x = {
            require("lsp-progress").progress,
            filetype,
          },
          lualine_y = { location },
          lualine_z = { "branch" },
        },
      })
    end,
  },
  {
    "linrongbin16/lsp-progress.nvim",
    event = { "VimEnter" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lsp-progress").setup()
    end,
  },
}
