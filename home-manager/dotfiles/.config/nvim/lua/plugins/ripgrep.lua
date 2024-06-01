local ag_opts = "--vimgrep --width 4096 --literal --hidden --follow --ignore-case"

return {
  -- structured search and replace
  {
    "cshuaimin/ssr.nvim",
    keys = { "<leader>sr" },
    config = function()
      require("ssr").setup({
        border = "shadow",
        keymaps = {
          close = "q",
          next_match = "<leader>j",
          prev_match = "<leader>k",
          replace_confirm = "<leader>.",
          replace_all = "<leader>a",
        },
      })
    end,
    init = function()
      vim.keymap.set({ "n", "x" }, "<leader>sr", function()
        require("ssr").open()
      end)
    end,
  },
  -- ripgrep multi-file/buffer/quickfix search and replace
  {
    "wincent/ferret",
    cmd = { "Ack", "Back" },
    branch = "main",
    config = function()
      vim.g.FerretMap = 0
      -- vim.g.FerretExecutable = 'ag,rg' -- prefer ag
      vim.g.FerretExecutableArguments = {
        ag = ag_opts,
      }
      vim.g.FerretVeryMagic = 0
    end,
  },
  {
    "jremmen/vim-ripgrep",
    cmd = { "Rg" },
    config = function()
      vim.g.rg_command = "rg --hidden --follow --smart-case --vimgrep"
      vim.g.rg_highlight = true
      vim.g.rg_derive_root = true
      vim.g.rg_root_types = { "package.json", "pnpm-workspace.yaml", ".git" }
    end,
  },
}
