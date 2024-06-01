local defer = require("lib/defer")

local easing = "quadratic"
local base_scalar = 10 -- ms per line scrolled

-- trigger a smooth scroll if a cursor jump would go beyond the window
-- otherwise do normal cursor jump
local function doscroll(lines)
  local normal_key = lines > 0 and "j" or "k"
  -- if vim.g.neovide then
  --   vim.cmd("norm! 10g" .. normal_key)
  --   return
  -- end

  local neoscroll = require("neoscroll")
  local duration_ms = math.abs(lines) * base_scalar
  -- local indent = require("indent_blankline.commands")

  local smooth_scroll = defer.throttle_leading(function()
    -- indent.refresh(false, true)
    neoscroll.scroll(lines, true, duration_ms, easing)
  end, 50)

  return function()
    local height = vim.api.nvim_win_get_height(0)
    local next = vim.fn.winline() + lines
    local scroll = true
    -- don't scroll if we're at the top
    if lines < 0 and not ((next - 1) <= 0) then
      scroll = false
    end
    -- don't scroll if we're at the bottom
    if lines > 0 and not ((next + 1) > height) then
      scroll = false
    end
    if scroll then
      smooth_scroll()
    else
      vim.cmd("norm! 10g" .. normal_key)
    end
  end
end

return {
  -- UI libs used by some plugins
  { "nvim-lua/plenary.nvim", lazy = false },
  { "MunifTanjim/nui.nvim", event = "VeryLazy" },
  { "nvim-tree/nvim-web-devicons", lazy = false },
  -- nicer quickfix window
  { "kevinhwang91/nvim-bqf", event = "VeryLazy" },
  -- unobstrusive notifier
  {
    "vigoux/notifier.nvim",
    event = { "VimEnter" },
    opts = {
      components = {
        "nvim", -- Nvim notifications (vim.notify and such)
      },
      component_name_recall = true,
    },
  },
  -- breadcrumbs
  {
    "SmiteshP/nvim-navic",
    event = "User FileOpened",
  },
  -- dynamic identation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufRead",
    opts = {},
  },
  -- -- start screen
  { "mhinz/vim-startify", lazy = false },

  {
    "aznhe21/actions-preview.nvim",
  },
}
