-- Avante disabled — replaced with CodeCompanion (see plugins/codecompanion.lua).
-- To re-enable: uncomment the block below AND re-add
-- "lazyvim.plugins.extras.ai.avante" to lazyvim.json.
return {}

--[[
return {
  {
    "yetone/avante.nvim",
    opts = {
      provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-6",
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 4096,
          },
        },
      },
    },
    keys = {
      -- Add visual mode to keybinds that operate on selections
      { "<leader>aa", "<cmd>AvanteAsk<CR>", desc = "Ask Avante", mode = { "n", "v" } },
      { "<leader>ae", "<cmd>AvanteEdit<CR>", desc = "Edit Avante", mode = { "n", "v" } },
      { "<leader>an", "<cmd>AvanteChatNew<CR>", desc = "New Avante Chat", mode = { "n", "v" } },
    },
  },
}
--]]
