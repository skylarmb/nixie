-- Smart splits for seamless navigation between nvim and wezterm panes
return {
	"mrjones2014/smart-splits.nvim",
	lazy = false,
	config = function()
		-- Set IS_NVIM user variable for wezterm detection
		vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
			callback = function()
				vim.fn.system("wezterm cli set-user-var IS_NVIM true")
			end,
		})
		vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
			callback = function()
				vim.fn.system("wezterm cli set-user-var IS_NVIM false")
			end,
		})

		require("smart-splits").setup({
			-- Ignored filetypes (only while resizing)
			ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
			-- Ignored buffer types (only while resizing)
			ignored_buftypes = { "nofile" },
			-- Enable multiplexer integration for wezterm
			multiplexer_integration = "wezterm",
		})

		-- Recommended mappings for navigation
		-- Use Ctrl+h/j/k/l to navigate between splits
		vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
		vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
		vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
		vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)

		-- Resizing splits with Ctrl+Alt+h/j/k/l
		vim.keymap.set("n", "<C-A-h>", require("smart-splits").resize_left)
		vim.keymap.set("n", "<C-A-j>", require("smart-splits").resize_down)
		vim.keymap.set("n", "<C-A-k>", require("smart-splits").resize_up)
		vim.keymap.set("n", "<C-A-l>", require("smart-splits").resize_right)
	end,
}
