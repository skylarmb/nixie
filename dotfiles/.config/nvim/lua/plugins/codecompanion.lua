-- CodeCompanion: AI chat + inline edits, replaces Avante.
-- Uses the Anthropic adapter (expects ANTHROPIC_API_KEY in env).
return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    -- Lazy-load on commands so startup isn't affected
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
    },
    opts = {
      -- Default adapters for each interaction surface
      interactions = {
        chat = {
          adapter = "anthropic",
          model = "claude-sonnet-4-6",
        },
        inline = {
          adapter = "anthropic",
          model = "claude-sonnet-4-6",
        },
      },
    },
    keys = {
      -- Toggle chat buffer (mirrors old <leader>aa AvanteAsk)
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion: Toggle Chat",
      },
      -- Action palette (inline edits, prompt library, etc)
      {
        "<leader>ac",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion: Actions",
      },
      -- New chat buffer (mirrors old <leader>an AvanteChatNew)
      {
        "<leader>an",
        "<cmd>CodeCompanionChat<cr>",
        mode = { "n" },
        desc = "CodeCompanion: New Chat",
      },
      -- Add visual selection to the active chat (mirrors old <leader>ae)
      {
        "<leader>ae",
        "<cmd>CodeCompanionChat Add<cr>",
        mode = "v",
        desc = "CodeCompanion: Add Selection to Chat",
      },
    },
    init = function()
      -- Expand `cc` to `CodeCompanion` on the command line
      vim.cmd([[cab cc CodeCompanion]])
    end,
  },
}
