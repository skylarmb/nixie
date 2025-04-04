return {
  -- "Cursor"-like AI code editing
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
      windows = {
        width = 50, -- default % based on available width
      },
      -- add any opts here
      -- for example
      provider = "claude",
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "o3-mini", -- your desired model (or use gpt-4o, etc.)
        timeout = 30000, -- timeout in milliseconds
        temperature = 0, -- adjust if needed
        max_tokens = 4096,
        -- reasoning_effort = "high", -- only supported for reasoning models (o1, etc.)
      },
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-7-sonnet-20250219",
        temperature = 0,
        max_tokens = 4096,
      },
      rag_service = {
        enabled = false, -- Enables the RAG service
        host_mount = os.getenv("HOME") .. "/workspace", -- Host mount path for the rag service
        -- provider = "openai", -- The provider to use for RAG service (e.g. openai or ollama)
        -- llm_model = "", -- The LLM model to use for RAG service
        -- embed_model = "", -- The embedding model to use for RAG service
        -- endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
      },
      dual_boost = {
        enabled = false,
        first_provider = "openai",
        second_provider = "claude",
        prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
        timeout = 120000, -- Timeout in milliseconds
      },
      file_selector = {
        --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
        provider = "telescope",
        -- Options override for custom providers
        provider_opts = {},
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
        },
        opts = {
          file_types = { "Avante" },
        },
        ft = { "Avante" },
      },
    },
  },
}
