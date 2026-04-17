-- In-buffer markdown previewer. Replaces LazyVim's `lang.markdown` extra
-- (which bundled render-markdown.nvim + markdown-preview.nvim).
return {
  {
    "OXY2DEV/markview.nvim",
    -- Load eagerly so preview is active as soon as a markdown buffer opens.
    -- Markview recommends `lazy = false` for reliable filetype handling.
    lazy = false,
    -- Treesitter parsers for markdown are already ensured via example.lua,
    -- so no extra dependencies needed here.
    opts = {},
  },
}
