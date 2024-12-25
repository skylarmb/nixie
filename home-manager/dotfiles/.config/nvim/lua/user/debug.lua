-- Place this in your init.lua or a separate debug file

local function setup_directory_debugging()
  -- Track the last known directory
  local last_dir = vim.fn.getcwd()

  -- Create an augroup for our autocommands
  local debug_group = vim.api.nvim_create_augroup("DirectoryDebug", { clear = true })

  -- Monitor directory changes
  vim.api.nvim_create_autocmd({ "DirChanged" }, {
    group = debug_group,
    callback = function(args)
      local new_dir = vim.fn.getcwd()
      local event_info = {
        ["Old Directory"] = last_dir,
        ["New Directory"] = new_dir,
        ["Change Scope"] = args.scope,
        ["Event"] = args.event,
        ["Buffer"] = vim.api.nvim_get_current_buf(),
        ["File"] = vim.api.nvim_buf_get_name(0),
        ["Window"] = vim.api.nvim_get_current_win(),
        ["Tab"] = vim.api.nvim_get_current_tabpage(),
      }

      -- Log the change
      print("Directory Change Detected:")
      for key, value in pairs(event_info) do
        print(string.format("%s: %s", key, value))
      end

      -- Update last known directory
      last_dir = new_dir
    end,
  })

  -- Monitor buffer events that might trigger directory changes
  vim.api.nvim_create_autocmd({ "BufEnter", "BufNew", "BufNewFile" }, {
    group = debug_group,
    callback = function(args)
      local cur_dir = vim.fn.getcwd()
      if cur_dir ~= last_dir then
        print(string.format("Buffer event %s caused directory change:", args.event))
        print(string.format("From: %s", last_dir))
        print(string.format("To: %s", cur_dir))
        last_dir = cur_dir
      end
    end,
  })

  -- Command to check current directory state
  vim.api.nvim_create_user_command("DebugDirState", function()
    local state = {
      ["Global CWD"] = vim.fn.getcwd(-1),
      ["Tab CWD"] = vim.fn.getcwd(-1, vim.api.nvim_get_current_tabpage()),
      ["Window CWD"] = vim.fn.getcwd(vim.api.nvim_get_current_win()),
      ["Current Buffer"] = vim.api.nvim_buf_get_name(0),
      ["autochdir"] = vim.o.autochdir,
    }

    print("Current Directory State:")
    for key, value in pairs(state) do
      print(string.format("%s: %s", key, value))
    end
  end, {})
end

-- setup_directory_debugging()
