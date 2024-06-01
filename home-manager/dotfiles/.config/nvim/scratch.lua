local test = vim.fn.system("git rev-parse --show-toplevel") .. "/" .. vim.fn.expand("%")
print(test)
print(test:gsub("%s+", ""))
