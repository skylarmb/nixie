-- Configure which-key to avoid recursion with remapped keys
return {
	{
		"folke/which-key.nvim",
		opts = {
			-- Disable triggers that conflict with remapped motion keys (j->gj, etc.)
			triggers = {
				{ "<auto>", mode = "nxso" },
				{ "<leader>", mode = { "n", "v" } },
			},
		},
	},
}
