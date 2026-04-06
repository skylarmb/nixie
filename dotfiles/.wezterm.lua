-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- config.default_prog = { os.getenv("NIX_PROFILE_BIN") .. "/zsh", "--login", "-c", "tmux new-session -A -s main -t main" }

-- config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_max_width = 48
config.tab_bar_at_bottom = true
config.automatically_reload_config = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.font_size = 22.0
config.font = wezterm.font("DankMono Nerd Font Mono", { weight = "Bold" })
-- config.font = wezterm.font("AtkinsonHyperlegibleMono Nerd Font")
-- local fg = "#E3CA9A"
local fg = "#e8d4ae"
config.colors = {
	-- Default colors
	foreground = fg,
	background = "#131312",

	-- Normal colors
	ansi = {
		"#131312", -- black
		"#D0654B", -- red
		"#979764", -- green
		"#E3A138", -- yellow
		"#848A68", -- blue
		"#D97E4A", -- magenta
		"#799173", -- cyan
		"#E3CA9A", -- white
	},

	-- Bright colors
	brights = {
		"#575547", -- bright black
		"#D0654B", -- bright red
		"#979764", -- bright green
		"#E3A138", -- bright yellow
		"#848A68", -- bright blue
		"#D97E4A", -- bright magenta
		"#799173", -- bright cyan
		"#E8D2A9", -- bright white
	},

	-- Other settings from your config
	cursor_fg = "#131312",
	cursor_bg = fg,
	selection_fg = "#131312",
	selection_bg = fg,
}

local function tmux_prefix(key)
	local act = wezterm.action
	return act.Multiple({
		act.SendKey({ key = "b", mods = "CTRL" }),
		act.SendKey({ key = key }),
	})
end

-- Smart-splits.nvim integration for seamless navigation
local function is_vim(pane)
	-- Check if the foreground process is vim/nvim
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim" or process_name == "vim"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "CTRL|ALT" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- Pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "CTRL|ALT" or "CTRL" },
				}, pane)
			else
				-- Use wezterm's native pane navigation/resizing
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

local mod_key = "CMD"

-- Set leader key to Ctrl+A (like tmux)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- { key = "1", mods = mod_key, action = tmux_prefix("1") },
	-- { key = "2", mods = mod_key, action = tmux_prefix("2") },
	-- { key = "3", mods = mod_key, action = tmux_prefix("3") },
	-- { key = "4", mods = mod_key, action = tmux_prefix("4") },
	-- { key = "5", mods = mod_key, action = tmux_prefix("5") },
	-- { key = "6", mods = mod_key, action = tmux_prefix("6") },
	-- { key = "7", mods = mod_key, action = tmux_prefix("7") },
	-- { key = "8", mods = mod_key, action = tmux_prefix("8") },
	-- { key = "9", mods = mod_key, action = tmux_prefix("9") },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
	{ key = "Enter", mods = mod_key, action = wezterm.action.TogglePaneZoomState },
	{ key = "b", mods = mod_key, action = tmux_prefix("p") },
	{ key = "g", mods = mod_key, action = tmux_prefix("g") },
	-- Word movement: Alt+Left/Right and Ctrl+b/f send ESC+b/f for zsh vi-mode
	{ key = "LeftArrow", mods = "ALT", action = wezterm.action({ SendString = "\27b" }) },
	{ key = "RightArrow", mods = "ALT", action = wezterm.action({ SendString = "\27f" }) },
	{ key = "e", mods = "CTRL", action = wezterm.action({ SendString = "\27f" }) },
	-- Word deletion: Alt+Backspace and Alt+d
	{ key = "Backspace", mods = "ALT", action = wezterm.action({ SendString = "\27\127" }) },
	{ key = "d", mods = "ALT", action = wezterm.action({ SendString = "\27d" }) },
	-- Pane navigation: Ctrl+H/J/K/L with smart-splits integration
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- Pane resizing: Ctrl+Alt+H/J/K/L with smart-splits integration
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
	-- Pane operations with leader key (Ctrl+A): splits, zoom, close, clear, and new tab
	{ key = "s", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
	{ key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "d", mods = "LEADER", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
	{ key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	-- Send literal Ctrl+A to the terminal (press Ctrl+A twice)
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
}

-- config.window_decorations = "TITLE"

-- Tab bar styling to match tmux theme (simple background colors)
-- Colors from tmux colorscheme.conf
local BG_CURRENT = "#4a482c" -- GREEN_DIM - active tab background
local FG_CURRENT = "#dcbb7e" -- FG0 - active tab text
local BG_B = "#292827" -- BG4 - inactive tab background
local FG_B = "#c49138" -- FG4 - inactive tab text
local BG_BAR = "#1a1a19" -- BG0 from tmux theme - tab bar background

-- Fancy tab bar configuration
config.window_frame = {
	font = wezterm.font({ family = "DankMono Nerd Font Mono", weight = "Bold" }),
	font_size = 20.0,
	active_titlebar_bg = BG_BAR,
	inactive_titlebar_bg = BG_BAR,
}

config.colors.tab_bar = {
	background = BG_BAR,
	inactive_tab_edge = BG_B,
	active_tab = {
		bg_color = BG_CURRENT,
		fg_color = FG_CURRENT,
	},
	inactive_tab = {
		bg_color = BG_B,
		fg_color = FG_B,
	},
	inactive_tab_hover = {
		bg_color = BG_B,
		fg_color = FG_CURRENT,
	},
	new_tab = {
		bg_color = BG_BAR,
		fg_color = FG_B,
	},
	new_tab_hover = {
		bg_color = BG_B,
		fg_color = FG_CURRENT,
	},
}

config.inactive_pane_hsb = {
	brightness = 0.7,
}

return config
