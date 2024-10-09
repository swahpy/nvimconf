require("markview").setup({
	modes = { "n", "v", "c", "nc", "i" },
	hybrid_modes = { "n", "i" },

	callbacks = {
		on_enable = function(buf, win)
			vim.o.foldmethod = "expr"
			vim.o.foldexpr = "nvim_treesitter#foldexpr()"
		end,
	},
	injections = {
		languages = {
			--- Key is the language
			markdown = {
				--- When true, other injections are replaced
				--- with the ones provided here
				---@type boolean
				override = false,
				query = [[
            (section
                (atx_heading)) @fold (#set! @fold)
        ]],
			},
		},
	},

	checkboxes = {
		checked = {
			text = "",
			hl = "Green",
		},
		unchecked = {
			text = "",
		},
	},
	headings = {

		--- Amount of character to shift per heading level
		---@type integer
		shift_width = 0,

		heading_1 = {
			style = "label",
			shift_char = "",
      hl = "Red",
			icon = " ",
      icon_hl = "Red",
      sign = "󰌕 ",
      sign_hl = "Red",
		},
		heading_2 = {
			style = "label",
			shift_char = "",
      hl = "Orange",
			icon = " ",
      icon_hl = "Orange",
      sign = "󰌕 ",
      sign_hl = "Orange",
		},
		heading_3 = {
			style = "label",
			shift_char = "",
      hl = "Yellow",
			icon = " ",
      icon_hl = "Yellow",
      sign = "󰌕 ",
      sign_hl = "Yellow",
		},
		heading_4 = {
			style = "label",
			shift_char = "",
      hl = "Green",
			icon = " ",
      icon_hl = "Green",
      sign = "󰌕 ",
      sign_hl = "Green",
		},
		heading_5 = {
			style = "label",
			shift_char = "",
			hl = "Blue",
			icon = " ",
      icon_hl = "Blue",
      sign = "󰌕 ",
      sign_hl = "Blue",
		},
		heading_6 = {
			style = "label",
			shift_char = "",
      hl = "Aqua",
			icon = " ",
      icon_hl = "Aqua",
      sign = "󰌕 ",
      sign_hl = "Aqua",
		},
	},
	links = {
		hyperlinks = {
			custom = {
				{ hl = "Blue", match_string = "https:", icon = " ", corner_right = " " },
				{ hl = "Blue", match_string = "^http:", icon = " ", corner_right = " " },
				{ hl = "Aqua", match_string = "%.md", icon = "󱅷 " },
			},
		},
	},
	list_items = {
		shift_width = 2,
		indent_size = 3,
	},
})
