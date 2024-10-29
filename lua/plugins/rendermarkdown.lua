require("render-markdown").setup({
	file_types = { "markdown", "quarto" },
	render_modes = true,
	heading = {
		border = true,
		icons = { " ", " ", " ", " ", " ", " " },
		sign = false,
	},
	link = {
		custom = {
			web = { pattern = "^http[s]?://", icon = " ", highlight = "Blue" },
      python = { pattern = '%.py$', icon = '󰌠 ', highlight = 'Green' },
      local_file = { pattern = "%.md$", icon = '󱅷 ', highlight = "Aqua" },
		},
	},
})
