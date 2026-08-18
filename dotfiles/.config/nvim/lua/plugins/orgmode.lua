-- Emacs-style Org mode for Neovim (pure Lua implementation).
-- Provides .org file support, agenda view, TODO management, and capture templates.
return {
  {
    "nvim-orgmode/orgmode",
    -- Load eagerly for .org filetype detection and to register the treesitter
    -- parser before any .org file is opened.
    event = "VeryLazy",
    ft = { "org" },
    opts = {
      -- Agenda scans all .org files under ~/org recursively.
      org_agenda_files = "~/org/**/*",
      -- Default destination for `org_capture` when no template specifies a file.
      org_default_notes_file = "~/org/refile.org",
    },
  },
}
