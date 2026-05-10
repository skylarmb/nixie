-- Highlights color codes (#fff, rgb(...), hsl(...), etc.) inline in buffers.
return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        -- Don't highlight color *names* like "blue" — only actual codes.
        names = false,
      },
    },
  },
}
