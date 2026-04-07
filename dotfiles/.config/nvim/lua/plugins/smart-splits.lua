-- Smart splits for seamless navigation between nvim and the active multiplexer
return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	config = function()
		require("smart-splits").setup({
			-- Ignored filetypes (only while resizing)
			ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
			-- Ignored buffer types (only while resizing)
			ignored_buftypes = { "nofile" },
			-- tmux mode: move between nvim and tmux panes with Ctrl+h/j/k/l.
			multiplexer_integration = "tmux",
			-- wezterm-native mode:
			-- multiplexer_integration = "wezterm",
		})
	end,
}
