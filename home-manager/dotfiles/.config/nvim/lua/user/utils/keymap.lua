local M = {}

local opts = {
  default = { silent = true, remap = false },
  remap = { silent = true, remap = true },
  buffer = { buffer = true, silent = true, noremap = true },
}
M.opts = opts

local expand = {
  cword = "<C-R>=expand('<cword>')<CR>",
  cexpr = "<C-R>=expand('<cexpr>')<CR>",
}
M.expand = expand

local cmd = function(...)
  local c = table.concat({ ... }, " ")
  if string.sub(c, 1, 1) == ":" then
    return c .. "<cr>"
  end
  return function()
    vim.cmd(c)
  end
end
M.cmd = cmd

local set = function(mode, keys, bind, opt)
  opt = opt or opts.default
  vim.keymap.set(mode, keys, bind, opt)
end
M.set = set

local setter = function(mode, prefix, suffix)
  prefix = prefix or ""
  suffix = suffix or ""
  return function(keys, bind, opt)
    set(mode, prefix .. keys .. suffix, bind, opt)
  end
end

M.c = setter("c")
M.i = setter("i")
M.leader = setter("n", "<leader>")
M.n = setter("n")
M.nvo = setter({ "n", "v", "o" })
M.t = setter("t")
M.v = setter("v")

return M
