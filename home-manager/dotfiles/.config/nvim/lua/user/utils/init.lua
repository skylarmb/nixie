local M = {}

function M.logger(file)
  local function log(level)
    return function(func, msg)
      vim.schedule(function()
        vim.notify(file .. ".lua: " .. "bg: " .. vim.o.background .. ", in function '" .. func .. "': " .. msg, level)
      end)
    end
  end

  return {
    info = log(vim.log.levels.INFO),
    warn = log(vim.log.levels.WARN),
    error = log(vim.log.levels.ERROR),
  }
end

local logger = M.logger("user/utils")

-- run system command and capture output
function M.shell_cmd(command)
  local output = function(exit, stdout, stderr)
    stdout = stdout:gsub("[\n\r]$", "")
    stderr = stderr:gsub("[\n\r]$", "")
    return { exit = exit, stdout = stdout, stderr = stderr }
  end

  local tmpfile = "/tmp/lua_execute_tmp_file"
  local exit = os.execute(command .. " > " .. tmpfile .. " 2> " .. tmpfile .. ".err")

  local stdout_file = io.open(tmpfile)
  if stdout_file == nil then
    logger.error("shell_cmd", "failed to create stdout_file")
    return output(1, "", "")
  end
  local stdout = stdout_file:read("*all")

  local stderr_file = io.open(tmpfile .. ".err")
  if stderr_file == nil then
    logger.error("shell_cmd", "failed to create sterr_file")
    return output(1, "", "")
  end
  local stderr = stderr_file:read("*all")

  stdout_file:close()
  stderr_file:close()
  if exit ~= 0 then
    logger.error("shell_cmd", stderr)
  end
  os.remove(tmpfile)
  os.remove(tmpfile .. ".err")

  return output(exit, stdout, stderr)
end

-- warning: very expensive! only use for debugging broken modules
function M.prequire(module)
  local ok, err = pcall(require, module)
  if not ok then
    logger.error("prequire", "Error loading " .. module .. ": " .. err)
  end
end

M.keymap = require("user.utils.keymap")

return M
