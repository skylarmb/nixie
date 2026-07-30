return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        -- Disable blink's own ghost text: neocodeium already renders an inline
        -- suggestion, and having both draw virtual text at once causes overlap.
        ghost_text = { enabled = false },
      },
    },
  },
}
