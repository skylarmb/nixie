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

-- run a list of vim.cmds sequentially
function M.run_sequential_commands(commands)
  local function run_next(index)
    if index <= #commands then
      vim.schedule(function()
        vim.cmd(commands[index])
        run_next(index + 1)
      end)
    end
  end
  run_next(1)
end

-- Helper function to run async functions sequentially
-- @param fns Array of functions to run in sequence
function M.sequence_calls(fns)
  local function run_next(index)
    if index <= #fns then
      vim.schedule(function()
        fns[index]()
        run_next(index + 1)
      end)
    end
  end
  run_next(1)
end

M.keymap = require("user.utils.keymap")

function M.get_current_selection()
  -- Check if we're in visual mode
  local mode = vim.fn.mode()
  if not (mode == "v" or mode == "V" or mode == "") then
    return ""
  end

  -- Get the start and end positions of the visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- Get the current buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get the lines in the selection
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  -- Get the selected lines
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

  -- Handle the selection
  if #lines == 0 then
    return ""
  elseif #lines == 1 then
    -- Single line selection
    return string.sub(lines[1], start_col, end_col)
  else
    -- Multi-line selection
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
    return table.concat(lines, "\n")
  end
end

-- get the contents of the current buffer
function M.get_current_buffer_contents()
  local bufnr = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_count, false)
  return table.concat(lines, "\n")
end

return M
