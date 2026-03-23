-- Smart splits for seamless navigation between nvim and wezterm panes
return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	config = function()
		require("smart-splits").setup({
			-- Ignored filetypes (only while resizing)
			ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
			-- Ignored buffer types (only while resizing)
			ignored_buftypes = { "nofile" },
			-- Enable multiplexer integration for wezterm
			multiplexer_integration = "wezterm",
		})
	end,
}
