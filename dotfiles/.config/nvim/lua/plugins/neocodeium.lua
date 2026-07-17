return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local neocodeium = require("neocodeium")
      neocodeium.setup({})

      -- Accept the current suggestion.
      vim.keymap.set("i", "<C-y>", function()
        require("neocodeium").accept()
      end)
      vim.keymap.set("i", "<M-f>", function()
        require("neocodeium").accept()
      end)
      vim.keymap.set("i", "ƒ", function()
        require("neocodeium").accept()
      end)
    end,
  },
}
