return {
  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
      -- silent = true suppresses the "Server started on port ..." notify on every startup
      require("neocodeium").setup({ silent = true })

      -- Register neocodeium as LazyVim's `ai_accept` action. LazyVim's blink.cmp
      -- config maps <Tab> to snippet_forward -> ai_nes -> ai_accept -> fallback,
      -- so this makes <Tab> the single keybind for accepting a suggestion while
      -- still falling back to snippet jump / indent when none is visible.
      LazyVim.cmp.actions.ai_accept = function()
        local neocodeium = require("neocodeium")
        if neocodeium.visible() then
          neocodeium.accept()
          return true
        end
      end
    end,
  },
}
