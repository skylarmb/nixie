return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
      { "stevearc/dressing.nvim" },
      -- { "project.nvim" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "ignore_case", -- or "ignore_case" or "smart_case"
          },
          notify = {},
        },
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          file_ignore_patterns = {
            "^.git/",
            "^node_modules",
            "^build/",
            "^dist/",
            "^.pnpm/",
            "^.cache/",
            "*.js.map",
          },
          pickers = {
            find_files = {
              theme = "dropdown",
            },
            colorscheme = {
              enable_preview = true,
            },
          },
          vimgrep_arguments = {
            "rg",
            -- added
            "--no-config",
            "--follow",
            -- defaults
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          path_display = { "absolute" },
          wrap_results = true,
          mappings = {
            i = {
              ["<Down>"] = actions.cycle_history_next,
              ["<Up>"] = actions.cycle_history_prev,
              ["<Esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-s>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
            },
          },
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            vertical = { height = 0.7 },
            -- other layout configuration here
          },
        },
      })
      -- require("telescope").load_extension("projects")
      -- require("telescope").load_extension("fzf")
      require("telescope").load_extension("live_grep_args")
    end,
  },
}
