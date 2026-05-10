return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      local neocodeium = require("neocodeium")
      local blink = require("blink.cmp")

      -- Clear neocodeium's ghost-text suggestion when blink's menu opens,
      -- so the two completion UIs don't fight for the same screen real estate.
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          neocodeium.clear()
        end,
      })

      neocodeium.setup({
        -- Only request neocodeium suggestions when blink's menu is hidden.
        filter = function()
          return not blink.is_visible()
        end,
      })

      -- Accept the current suggestion.
      vim.keymap.set("i", "<A-f>", neocodeium.accept)
    end,
  },

  -- Tell blink.cmp not to auto-open in normal insert mode (still auto-shows in cmdline).
  -- This lets neocodeium's inline ghost text be the primary suggestion UI;
  -- trigger blink manually when you want it.
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "default"
          end,
        },
      },
    },
  },
}
