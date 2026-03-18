-- Temporarily disable fancy UI overlays to debug crash
return {
	{
		"folke/noice.nvim",
		opts = {
			cmdline = { enabled = false },
			messages = { enabled = false },
			popupmenu = { enabled = false },
		},
	},
	{ "stevearc/dressing.nvim", enabled = false },
}
