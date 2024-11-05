
return {
  {
    "skylarmb/torchlight.nvim",
    lazy = false,
    config = function()
      vim.opt.background = "dark"
      require("torchlight").setup({
        contrast = "hard",
      })
    end,
  }
}
