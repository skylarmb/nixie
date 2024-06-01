local hi_head = { bg = "#353532", fg = "#d5af67" }
local hi_tab = { bg = "#353532", fg = "#c9973a" }
local theme = {
  fill = { bg = "#292827", fg = "#c9973a" },
  head = hi_head,
  current_tab = { bg = "#4a482c", fg = "#dcbb7e" },
  tab = hi_tab,
  win = hi_tab,
  tail = hi_head,
  sep = "lualine_a_normal",
}

return {
  {
    "nanozuki/tabby.nvim",
    enabled = true,
    lazy = false,
    priority = 25,
    init = function()
      vim.opt.showtabline = 2
    end,
    config = function()
      local tabby = require("tabby.tabline")
      tabby.set(function(line)
        return {
          {
            { "    ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            local is_curr = tab.is_current()
            local is_first = tab.number() == 1
            local is_last = tab.number() == table.maxn(line.api.get_tabs())
            return {
              line.sep((is_first or is_curr) and "" or "", is_first and theme.head or theme.tab, hl),
              is_curr and "" or "",
              tab.number(),
              tab.name(),
              -- tab.close_btn("󱎘"),
              -- (is_first or is_curr) and "" or " ",
              line.sep(
                (tab.number() + 1) == line.api.get_current_tab() and "" or (is_curr or is_last) and "" or "",
                is_curr and hl or is_last and theme.tab or theme.sep,
                is_last and theme.fill or theme.tab
              ),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
              line.sep("", theme.win, theme.fill),
              win.is_current() and "" or "",
              win.buf_name(),
              " ",
              -- line.sep("", theme.win, theme.fill),
              hl = theme.win,
              margin = " ",
            }
          end),
          {
            line.sep("", theme.tail, theme.win),
            { "  ", hl = theme.tail },
          },
          hl = theme.fill,
        }
      end)
    end,
  },
}
