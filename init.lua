-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
---@diagnostic disable-next-line
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })

---@diagnostic disable-next-line
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
-- local shortcuts
local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local o = vim.opt
local nmap = function(suffix, rhs, desc)
	vim.keymap.set("n", "" .. suffix, rhs, { desc = desc })
end
local nmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("n", "<leader>" .. suffix, rhs, { desc = desc })
end

-- Safely execute immediately
now(function()
	-- ╔═══════════════════════╗
	-- ║      colorscheme      ║
	-- ╚═══════════════════════╝
	-- add("sainnhe/gruvbox-material")
	-- add("folke/tokyonight.nvim")
	-- add("catppuccin/nvim")
	-- add("scottmckendry/cyberdream.nvim")
	add("sainnhe/everforest")
	require("plugins.colorscheme")
	-- ╔═══════════════════════╗
	-- ║      mini.basics      ║
	-- ╚═══════════════════════╝
	o.listchars = "tab:  ,extends:…,precedes:…,nbsp:␣" -- Define which helper symbols to show
	local basics = require("mini.basics")
	basics.setup({
		-- Options. Set to `false` to disable.
		options = {
			-- Extra UI features ('winblend', 'cmdheight=0', ...)
			extra_ui = true,
			-- Presets for window borders ('single', 'double', ...)
			win_borders = "bold",
		},
		mappings = {
			windows = true,
			move_with_alt = true,
		},
		autocommands = {
			relnum_in_visual_mode = true,
		},
	})
	-- ╔═══════════════════════╗
	-- ║      mini.sessions    ║
	-- ╚═══════════════════════╝
	local session = require("mini.sessions")
	session.setup({
		directory = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
		file = "session.vim",
	})
	--> keymaps
	map("n", "<Leader>ss", function()
		local cur_session = vim.v.this_session
		local ss = ""
		if cur_session and cur_session ~= "" then
			ss = vim.fn.fnamemodify(cur_session, ":t")
		else
			local cwd = vim.fn.getcwd()
			ss = vim.fn.fnamemodify(cwd, ":t")
		end
		session.write(ss)
	end, { desc = "[s]ave a global session based on current working directory" })
	map("n", "<Leader>sn", function()
		local cur_session = vim.v.this_session
		local ss = ""
		if cur_session and cur_session ~= "" then
			ss = vim.fn.fnamemodify(cur_session, ":t")
		else
			ss = vim.fn.input("Please enter new session name: \n> ")
		end
		if ss ~= "" then
			session.write(ss)
		end
	end, { desc = "Create a new session" })
	map("n", "<Leader>sl", function()
		---@diagnostic disable-next-line
		session.write(session.config.file)
	end, { desc = "save a [l]ocal session" })
	map("n", "<Leader>sp", function()
		session.select()
	end, {
		desc = "[p]ick a session",
	})
	map("n", "<Leader>sd", function()
		local sessions = {}
		local keystr = ""
		local n = 0
		for k, _ in pairs(session.detected) do
			n = n + 1
			sessions[n] = k
			keystr = keystr .. n .. ": " .. k .. "\n"
		end
		local numstr =
			vim.fn.input("Below are current sessions, please select the one to delete(1/2/...):\n" .. keystr .. "\n> ")
		if numstr == "" then
			return
		end
		local num = tonumber(numstr)
		if num <= n then
			session.delete(sessions[num])
		else
			print("You entered a wrong number")
		end
	end, {
		desc = "[d]elete a session",
	})
	-- ╔═══════════════════════╗
	-- ║      mini.starter     ║
	-- ╚═══════════════════════╝
	local current_hour = tonumber(os.date("%H"))
	local greeting
	if current_hour < 5 then
		greeting = "  Good night!"
	elseif current_hour < 12 then
		greeting = "󰼰 Good morning!"
	elseif current_hour < 17 then
		greeting = "  Good afternoon!"
	elseif current_hour < 20 then
		greeting = "󰖝  Good evening!"
	else
		greeting = "󰖔  Good night!"
	end
	local starter = require("mini.starter")
	starter.setup({
		evaluate_single = true,
		items = {
			starter.sections.builtin_actions(),
			starter.sections.recent_files(12, false),
			starter.sections.sessions(6, true),
		},
		header = ""
			.. "⠀⢀⣴⣦⠀⠀⠀⠀⢰⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n"
			.. "⣰⣿⣿⣿⣷⡀⠀⠀⢸⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n"
			.. "⣿⣿⣿⣿⣿⣿⣄⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n"
			.. "⣿⣿⣿⠈⢿⣿⣿⣦⢸⣿⣿⡇⠀⣠⠴⠒⠢⣄⠀⠀⣠⠴⠲⠦⣄⠐⣶⣆⠀⠀⢀⣶⡖⢰⣶⠀⢰⣶⣴⡶⣶⣆⣴⡶⣶⣶⡄\n"
			.. "⣿⣿⣿⠀⠀⠻⣿⣿⣿⣿⣿⡇⢸⣁⣀⣀⣀⣘⡆⣼⠁⠀⠀⠀⠘⡇⠹⣿⡄⠀⣼⡿⠀⢸⣿⠀⢸⣿⠁⠀⢸⣿⡏⠀⠀⣿⣿\n"
			.. "⠹⣿⣿⠀⠀⠀⠙⣿⣿⣿⡿⠃⢸⡀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⢀⡏⠀⢻⣿⣸⣿⠁⠀⢸⣿⠀⢸⣿⠀⠀⢸⣿⡇⠀⠀⣿⣿\n"
			.. "⠀⠈⠻⠀⠀⠀⠀⠈⠿⠋⠀⠀⠈⠳⢤⣀⣠⠴⠀⠈⠧⣄⣀⡠⠞⠁⠀⠀⠿⠿⠃⠀⠀⢸⣿⠀⢸⣿⠀⠀⠸⣿⡇⠀⠀⣿⡿\n"
			.. "\n"
			.. greeting,
		footer = "󰃭 " .. os.date("%Y-%m-%d") .. "  " .. os.date("%H:%M:%S") .. " 󱨱 " .. os.date("%A"),
	})
end)

-- Safely execute later
later(function()
	-- ╔═══════════════════════╗
	-- ║     dependencies      ║
	-- ╚═══════════════════════╝
	-- comments indicate that which plugin(s) are using this dependency.
	-- mini.tabline, mini.files
	-- add("nvim-tree/nvim-web-devicons")
	-- require("nvim-web-devicons").setup()
	require("mini.icons").setup()
	-- ╔═══════════════════════╗
	-- ║       mini.nvim       ║
	-- ╚═══════════════════════╝
	-- mini plugins, with simple setup
	require("mini.align").setup()
	require("mini.animate").setup()
	require("mini.bracketed").setup()
	require("mini.comment").setup()
	require("mini.cursorword").setup()
	require("mini.jump").setup()
	require("mini.jump2d").setup()
	-- ╔═══════════════════════╗
	-- ║        mini.ai        ║
	-- ╚═══════════════════════╝
	local gen_ai_spec = require("mini.extra").gen_ai_spec
	local ai = require("mini.ai")
	ai.setup({
		n_lines = 500,
		mappings = {
			-- Move cursor to corresponding edge of `a` textobject
			goto_left = "[[",
			goto_right = "]]",
		},
		custom_textobjects = {
			o = ai.gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}, {}),
			f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
			c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
			t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
			h = { "%f[%S][%w%p]+%f[%s]", "^().*()$" }, -- match content between space
			j = { "%f[^%c][^%c]*", "^%s*().-()%s*$" }, -- match whole line
			e = { -- Word with case
				{
					"%u[%l%d]+%f[^%l%d]",
					"%f[%S][%l%d]+%f[^%l%d]",
					"%f[%P][%l%d]+%f[^%l%d]",
					"^[%l%d]+%f[^%l%d]",
				},
				"^().*()$",
			},
			u = ai.gen_spec.function_call(), -- u for "Usage"
			U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
			-- from mini.extra
			B = gen_ai_spec.buffer(),
			D = gen_ai_spec.diagnostic(),
			I = gen_ai_spec.indent(),
			L = gen_ai_spec.line(),
			d = gen_ai_spec.number(),
		},
	})
	-- ╔═══════════════════════╗
	-- ║    mini.bufremove     ║
	-- ╚═══════════════════════╝
	local br = require("mini.bufremove")
	br.setup()
	map("n", "<leader>bd", function()
		br.delete()
	end, { desc = "Delete current buffer" })
	map("n", "<leader>bw", function()
		br.wipeout()
	end, { desc = "Wipeout current buffer" })
	map("n", "<leader>bh", function()
		br.unshow()
	end, { desc = "Unshow(hide) current buffer" })
	map("n", "<leader>bU", function()
		br.unshow_in_window()
	end, { desc = "Unshow(hide) current buffer in window" })
	-- ╔═══════════════════════╗
	-- ║       mini.clue       ║
	-- ╚═══════════════════════╝
	local clue = require("mini.clue")
	local compute_dynamic_width = function(buf_id)
		local max_width = 0.6 * vim.o.columns
		local widths = vim.tbl_map(vim.fn.strdisplaywidth, vim.api.nvim_buf_get_lines(buf_id, 0, -1, false))
		table.sort(widths)
		for i = #widths, 1, -1 do
			if widths[i] <= max_width then
				return widths[i]
			end
		end

		return max_width
	end

	local win_config_auto_width = function(buf_id)
		local width = compute_dynamic_width(buf_id)
		return {
			width = width,
		}
	end
	clue.setup({
		window = {
			config = win_config_auto_width,
		},
		triggers = {
			-- Leader triggers
			{ mode = "n", keys = "<leader>" },
			{ mode = "x", keys = "<leader>" },
			-- Built-in completion
			{ mode = "i", keys = "<C-x>" },
			-- `\` key
			{ mode = "n", keys = "\\" },
			-- `g` key
			{ mode = "n", keys = "g" },
			{ mode = "x", keys = "g" },
			-- Marks
			{ mode = "n", keys = "'" },
			{ mode = "n", keys = "`" },
			{ mode = "x", keys = "'" },
			{ mode = "x", keys = "`" },
			-- Registers
			{ mode = "n", keys = '"' },
			{ mode = "x", keys = '"' },
			{ mode = "i", keys = "<C-r>" },
			{ mode = "c", keys = "<C-r>" },
			-- Window commands
			{ mode = "n", keys = "<C-w>" },
			-- `z` key
			{ mode = "n", keys = "z" },
			{ mode = "x", keys = "z" },
			-- `[` and `]` key
			{ mode = "n", keys = "[" },
			{ mode = "x", keys = "[" },
			{ mode = "n", keys = "]" },
			{ mode = "x", keys = "]" },
		},
		clues = {
			-- Enhance this by adding descriptions for <Leader> mapping groups
			clue.gen_clues.builtin_completion(),
			clue.gen_clues.g(),
			clue.gen_clues.marks(),
			clue.gen_clues.registers(),
			clue.gen_clues.windows(),
			clue.gen_clues.z(),
			-- Add descriptions for mapping groups
			{ mode = "n", keys = "<Leader>b", desc = "+buffers" },
			{ mode = "n", keys = "<Leader>c", desc = "+code" },
			{ mode = "x", keys = "<Leader>c", desc = "+code" },
			{ mode = "n", keys = "<Leader>f", desc = "+find" },
			{ mode = "n", keys = "<Leader>m", desc = "+mason" },
			{ mode = "n", keys = "<Leader>ml", desc = "+lsp" },
			{ mode = "n", keys = "<Leader>mt", desc = "+tool installer" },
			{ mode = "n", keys = "<Leader>o", desc = "+obsidian" },
			{ mode = "x", keys = "<Leader>o", desc = "+obsidian" },
			{ mode = "n", keys = "<Leader>s", desc = "+session" },
			{ mode = "n", keys = "<Leader>t", desc = "+toggle" },
			{ mode = "n", keys = "<Leader>w", desc = "+window" },
			{ mode = "n", keys = "<Leader>y", desc = "+yanky" },
		},
	})
	-- ╔═══════════════════════╗
	-- ║    mini.completion    ║
	-- ╚═══════════════════════╝
	-- require("mini.completion").setup({
	-- 	window = {
	-- 		info = { border = "rounded" },
	-- 		signature = { border = "rounded" },
	-- 	},
	-- })
	-- ╔═══════════════════════╗
	-- ║       mini.diff       ║
	-- ╚═══════════════════════╝
	local diff = require("mini.diff")
	diff.setup({
		-- source = diff.gen_source.save(),
		view = {
			style = "sign",
			-- signs = { add = "+", change = "~", delete = "-" },
		},
	})
	map("n", "<leader>to", function()
		diff.toggle_overlay(0)
	end, { desc = "+mini diff overlay" })
	-- ╔═══════════════════════╗
	-- ║      mini.extra       ║
	-- ╚═══════════════════════╝
	local extra = require("mini.extra")
	extra.setup()
	-- ╔═══════════════════════╗
	-- ║      mini.files       ║
	-- ╚═══════════════════════╝
	local files = require("mini.files")
	files.setup({
		-- Module mappings created only inside explorer.
		-- Use `''` (empty string) to not create one.
		mappings = {
			synchronize = "w",
		},
		-- General options
		options = {
			-- Whether to delete permanently or move into module-specific trash
			permanent_delete = false,
		},
		-- Customization of explorer windows
		windows = {
			-- Whether to show preview of file/directory under cursor
			preview = true,
			-- Width of preview window
			width_preview = 80,
			-- Width of focused window
			width_focus = 25,
		},
	})
	--> setup keymap for mini.files
	map("n", "<A-e>", function()
		files.open()
	end, { desc = "Open mini files" })
	map("n", "<A-f>", function()
		files.open(vim.api.nvim_buf_get_name(0))
	end, { desc = "Open mini files" })
	--> show/hide dotfiles
	local show_dotfiles = true
	---@diagnostic disable-next-line
	local filter_show = function(fs_entry)
		return true
	end
	local filter_hide = function(fs_entry)
		return not vim.startswith(fs_entry.name, ".")
	end
	local toggle_dotfiles = function()
		show_dotfiles = not show_dotfiles
		local new_filter = show_dotfiles and filter_show or filter_hide
		files.refresh({ content = { filter = new_filter } })
	end
	--> set current working directory
	---@diagnostic disable-next-line
	local files_set_cwd = function(path)
		-- Works only if cursor is on the valid file system entry
		local cur_entry_path = files.get_fs_entry().path
		local cur_directory = vim.fs.dirname(cur_entry_path)
		vim.fn.chdir(cur_directory)
	end
	--> open in split window
	local map_split = function(buf_id, lhs, direction)
		local rhs = function()
			-- Make new window and set it as target
			local new_target_window
			vim.api.nvim_win_call(files.get_target_window(), function()
				vim.cmd(direction .. " split")
				new_target_window = vim.api.nvim_get_current_win()
			end)
			files.set_target_window(new_target_window)
		end
		-- Adding `desc` will result into `show_help` entries
		local desc = "Split " .. direction
		map("n", lhs, rhs, { buffer = buf_id, desc = desc })
	end

	autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local buf_id = args.data.buf_id
			map_split(buf_id, "gx", "belowright horizontal")
			map_split(buf_id, "gv", "belowright vertical")
			map("n", "g.", toggle_dotfiles, { buffer = buf_id, desc = "Show/hide dotfiles" })
			map("n", "gd", files_set_cwd, { buffer = args.data.buf_id, desc = "Set cwd" })
		end,
	})
	-- ╔═══════════════════════╗
	-- ║       mini.git        ║
	-- ╚═══════════════════════╝
	require("mini.git").setup()
	local align_blame = function(au_data)
		if au_data.data.git_subcommand ~= "blame" then
			return
		end

		-- Align blame output with source
		local win_src = au_data.data.win_source
		vim.wo.wrap = false
		vim.fn.winrestview({ topline = vim.fn.line("w0", win_src) })
		vim.api.nvim_win_set_cursor(0, { vim.fn.line(".", win_src), 0 })

		-- Bind both windows so that they scroll together
		vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
	end

	local au_opts = { pattern = "MiniGitCommandSplit", callback = align_blame }
	vim.api.nvim_create_autocmd("User", au_opts)
	-- ╔═══════════════════════╗
	-- ║    mini.hipatterns    ║
	-- ╚═══════════════════════╝
	local hi_words = require("mini.extra").gen_highlighter.words
	local hipatterns = require("mini.hipatterns")
	-- local censor_extmark_opts = function(_, match, _)
	-- 	local mask = string.rep("x", vim.fn.strchars(match))
	-- 	return {
	-- 		virt_text = { { mask, "Comment" } },
	-- 		virt_text_pos = "overlay",
	-- 		priority = 200,
	-- 		right_gravity = false,
	-- 	}
	-- end
	hipatterns.setup({
		highlighters = { -- %f[%w]()TODO()%f[%W]
			todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsFixme"),
			-- invalid = hi_words({ "Invalid", "invalid" }, "MiniHipatternsFixme"),
			done = hi_words({ "DONE", "Done", "done" }, "MiniHipatternsTodo"),
			note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsHack"),
			doing = hi_words({ "DOING", "Doing", "doing" }, "MiniHipatternsNote"),
			arrow = { pattern = "[-]+>", group = "MiniHipatternsHack" },
			-- censor = {
			-- 	pattern = "password: ()%S+()",
			-- 	group = "",
			-- 	extmark_opts = censor_extmark_opts,
			-- },
			hex_color = hipatterns.gen_highlighter.hex_color(),
		},
	})
	-- ╔═══════════════════════╗
	-- ║    mini.indentscope   ║
	-- ╚═══════════════════════╝
	local indent = require("mini.indentscope")
	indent.setup({})
	-- Disable for certain filetypes
	autocmd({ "FileType" }, {
		desc = "Disable indentscope for certain filetypes",
		callback = function()
			local ignore_filetypes = {
				"dashboard",
				"floaterm",
				"help",
				"lazy",
				"mason",
				"notify",
				"Trouble",
			}
			if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
				vim.b.miniindentscope_disable = true
			end
		end,
	})
	-- ╔═══════════════════════╗
	-- ║      mini.misc        ║
	-- ╚═══════════════════════╝
	local misc = require("mini.misc")
	misc.setup({
		-- Array of fields to make global (to be used as independent variables)
		make_global = { "put", "put_text" },
	})
	misc.setup_restore_cursor()
	misc.setup_auto_root()
	--> keymaps
	map("n", "<leader>tz", function()
		misc.zoom()
	end, { desc = "+buffer zoom" })
	-- ╔═══════════════════════╗
	-- ║      mini.move        ║
	-- ╚═══════════════════════╝
	require("mini.move").setup()
	-- ╔═══════════════════════╗
	-- ║     mini.notify       ║
	-- ╚═══════════════════════╝
	require("mini.notify").setup()
	vim.notify = require("mini.notify").make_notify()
	nmap_leader("n", function()
		---@diagnostic disable-next-line
		MiniNotify.show_history()
	end, "+notify history")
	-- ╔═══════════════════════╗
	-- ║      mini.pairs       ║
	-- ╚═══════════════════════╝
	require("mini.pairs").setup({
		modes = { command = true, terminal = false },
		mappings = {
			["<"] = { action = "open", pair = "<>", neigh_pattern = "[^\\]." },
			[">"] = { action = "close", pair = "<>", neigh_pattern = "[^\\]." },
			["'"] = {
				action = "closeopen",
				pair = "''",
				neigh_pattern = "[^a-eg-zA-Z\\'].",
				register = { cr = false },
			},
			['"'] = {
				action = "closeopen",
				pair = '""',
				neigh_pattern = '[^\\"].',
				register = { cr = false },
			},
			["`"] = {
				action = "closeopen",
				pair = "``",
				neigh_pattern = "[^\\`].",
				register = { cr = false },
			},
		},
	})
	-- ╔═══════════════════════╗
	-- ║      mini.pick        ║
	-- ╚═══════════════════════╝
	local pick = require("mini.pick")
	pick.setup({
		mappings = {
			caret_left = "<A-h>",
			caret_right = "<A-l>",

			choose = "<CR>",
			choose_in_split = "<A-x>",
			choose_in_tabpage = "<A-t>",
			choose_in_vsplit = "<A-v>",
			choose_marked = "<A-CR>",

			delete_char = "<BS>",
			delete_char_right = "<Del>",
			delete_left = "<C-u>",
			delete_word = "<A-Backspace>",

			mark = "<A-m>",
			mark_all = "<A-a>",

			move_down = "<A-j>",
			move_start = "<A-g>",
			move_up = "<A-k>",

			paste = "<A-p>",

			refine = "<A-r>",
			refine_marked = "<C-r>",

			scroll_down = "<A-d>",
			scroll_left = "<A-b>",
			scroll_right = "<A-f>",
			scroll_up = "<A-u>",
		},
		options = {
			use_cache = true,
		},
		source = {
			show = pick.default_show,
		},
	})
	--> keymaps
	local builtin = pick.builtin
	nmap_leader("fb", function()
		builtin.buffers()
	end, "Pick from buffers")
	nmap_leader("fB", function()
		extra.pickers.git_branches()
	end, "Pick from git branches")
	nmap_leader("fc", function()
		extra.pickers.commands()
	end, "Pick from neovim commands")
	nmap_leader("fC", function()
		extra.pickers.git_commits()
	end, "Pick from git commits")
	nmap_leader("fd", function()
		extra.pickers.diagnostic()
	end, "Pick from diagnostics")
	nmap_leader("fe", function()
		extra.pickers.explorer()
	end, "Pick from file exlorer")
	nmap_leader("ff", function()
		builtin.files()
	end, "Pick from files")
	nmap_leader("fF", function()
		extra.pickers.git_files()
	end, "Pick from git files")
	nmap_leader("fg", function()
		builtin.grep()
	end, "Pick from pattern matches with live feedback")
	nmap_leader("fG", function()
		-- builtin.hl_groups()
		builtin.grep_live()
	end, "Pick from highlight groups")
	nmap_leader("fh", function()
		builtin.help()
	end, "Pick from help docs")
	nmap_leader("fH", function()
		extra.pickers.history()
	end, "Pick from neovim history")
	nmap_leader("fl", function()
		extra.pickers.buf_lines({ scope = "current" })
	end, "Pick from lines of current buffer")
	nmap_leader("fL", function()
		extra.pickers.buf_lines()
	end, "Pick from buffer lines")
	nmap_leader("fm", function()
		extra.pickers.marks()
	end, "Pick from marks")
	nmap_leader("fo", function()
		extra.pickers.oldfiles()
	end, "Pick from old files")
	nmap_leader("fO", function()
		extra.pickers.options()
	end, "Pick from neovim options")
	nmap_leader("fp", function()
		extra.pickers.hipatterns()
	end, "Pick from hipatterns")
	nmap_leader("fr", function()
		builtin.resume()
	end, "Resume last pick window")
	nmap_leader("fR", function()
		extra.pickers.registers()
	end, "Pick from neovim registers")
	nmap_leader("fs", function()
		extra.pickers.spellsuggest()
	end, "Pick from spell suggestions")
	nmap_leader("fs", function()
		extra.pickers.treesitter()
	end, "Pick from treesitter nodes")
	-- lsp related
	nmap("gd", "<cmd>Pick lsp scope='definition'<cr>", "go to definition")
	nmap("gD", "<cmd>Pick lsp scope='declaration'<cr>", "go to declaration")
	nmap("gi", "<cmd>Pick lsp scope='implementation'<cr>", "go to implementation")
	nmap("gr", "<cmd>Pick lsp scope='references'<cr>", "go to references")
	nmap("gs", "<cmd>Pick lsp scope='document_symbol'<cr>", "show symbols in current file")
	nmap("gS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", "show symbols in workspace")
	nmap("gt", "<cmd>Pick lsp scope='type_definition'<cr>", "go to type_definition")
	-- ╔═══════════════════════╗
	-- ║     mini.splitjoin    ║
	-- ╚═══════════════════════╝
	local sj = require("mini.splitjoin")
	sj.setup({
		mappings = {
			toggle = "<leader>ta",
		},
	})
	-- ╔═══════════════════════╗
	-- ║    mini.statusline    ║
	-- ╚═══════════════════════╝
	local statusline = require("mini.statusline")
	local get_session = function()
		local session_name = vim.v.this_session
		if session_name and session_name ~= "" then
			return "| session: " .. vim.fn.fnamemodify(session_name, ":t")
		else
			return ""
		end
	end
	statusline.setup({
		content = {
			active = function()
				local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
				local git = statusline.section_git({ trunc_width = 40 })
				local mini_diff = statusline.section_diff({ trunc_width = 75 })
				local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
				local lsp = statusline.section_lsp({ trunc_width = 75 })
				local filename = statusline.section_filename({ trunc_width = 140 })
				local current_session = get_session()
				local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
				local location = statusline.section_location({ trunc_width = 75 })
				local search = statusline.section_searchcount({ trunc_width = 75 })

				return statusline.combine_groups({
					{ hl = mode_hl, strings = { mode } },
					{ hl = "MiniStatuslineDevinfo", strings = { git, mini_diff, diagnostics, lsp } },
					"%<", -- Mark general truncate point
					{ hl = "MiniStatuslineFilename", strings = { filename, current_session } },
					"%=", -- End left alignment
					{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
					{ hl = mode_hl, strings = { search, location } },
				})
			end,
		},
	})
	-- ╔═══════════════════════╗
	-- ║     mini.surround     ║
	-- ╚═══════════════════════╝
	local sr = require("mini.surround")
	sr.setup({
		n_lines = 500,
		respect_selection_type = true,
		search_method = "cover_or_next",
	})
	-- ╔═══════════════════════╗
	-- ║      mini.tabline     ║
	-- ╚═══════════════════════╝
	local tabline = require("mini.tabline")
	tabline.setup({
		-- Function which formats the tab label
		-- By default surrounds with space and possibly prepends with icon
		format = function(buf_id, label)
			local suffix = vim.bo[buf_id].modified and "* " or ""
			return "" .. tabline.default_format(buf_id, label) .. suffix .. ""
		end,
		tabpage_section = "right",
	})
	-- ╔═══════════════════════╗
	-- ║    mini.trailspace    ║
	-- ╚═══════════════════════╝
	local trail = require("mini.trailspace")
	trail.setup()
	nmap_leader("tt", function()
		trail.trim()
	end, "+trim trailing whitespace")
	nmap_leader("l", function()
		trail.trim_last_lines()
	end, "+trim trailing last lines")
	-- ╔═══════════════════════╗
	-- ║    mini.trailspace    ║
	-- ╚═══════════════════════╝
	require("mini.visits").setup()
	-- ╔═══════════════════════╗
	-- ║    non-mini-plugins   ║
	-- ╚═══════════════════════╝
	-- tree-sitter
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "master",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	require("plugins/tree-sitter")
	-- nvim-treesitter-endwise
	add("RRethy/nvim-treesitter-endwise")
	-- nvim-tree-pairs
	add("yorickpeterse/nvim-tree-pairs")
	require("tree-pairs").setup()
	----------
	-- leap --
	----------
	add("ggandor/leap.nvim")
	local leap = require("leap")
	map("n", "S", "<Plug>(leap)", { desc = "+leap backward or forward" })
	map("n", "<A-s>", "<Plug>(leap-from-window)", { desc = "+leap from window" })
	map({ "x", "o" }, "S", "<Plug>(leap)", { desc = "+leap backward or forward" })
	leap.opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
	leap.opts.special_keys.prev_target = "<backspace>"
	leap.opts.special_keys.prev_group = "<backspace>"
	require("leap.user").set_repeat_keys("<tab>", "<backspace>")
	------------
	-- noetab --
	------------
	add("kawre/neotab.nvim")
	require("neotab").setup({
		tabkey = "",
	})
	--------------
	-- obsidian --
	--------------
	add({
		source = "epwalsh/obsidian.nvim",
		depends = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-treesitter/nvim-treesitter",
		},
	})
	require("plugins/nvim-obsidian")
	------------------------
	-- vim-tmux-navigator --
	------------------------
	add("christoomey/vim-tmux-navigator")
	-------------
	-- conform --
	-------------
	add("stevearc/conform.nvim")
	local conform = require("conform")
	conform.setup({
		formatters_by_ft = {
			bash = { "shellcheck", "shfmt" },
			go = { "goimports", "gofumpt" },
			html = { "prettier" },
			jason = { "jq" },
			lua = { "stylua" },
			markdown = { "prettier" },
			python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
			yaml = { "yq" },
		},
		log_level = vim.log.levels.ERROR,
		notify_on_error = true,
		-- format_on_save = {
		-- 	lsp_format = "fallback",
		-- 	timeout_ms = 500,
		-- },
	})
	conform.formatters.markdownlint = {
		prepend_args = {
			"--disable",
			"MD034",
			"--",
		},
	}
	map({ "n", "v" }, "<leader>F", function()
		conform.format({ timeout_ms = 500, lsp_fallback = true })
	end, { desc = "+format buffer using formatter" })
	o.formatexpr = "v:lua.require'conform'.formatexpr()"
	---------------
	-- lspconfig --
	---------------
	add({
		source = "williamboman/mason-lspconfig.nvim",
		depends = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
	})
	-- mason setup
	require("mason").setup()
	nmap_leader("mm", "<cmd>Mason<cr>", "+mason open")
	nmap_leader("mL", "<cmd>MasonLog<cr>", "+mason log")
	-- mason tool installer setup
	require("mason-tool-installer").setup({
		ensure_installed = {
			"goimports",
			"gofumpt",
			"jq",
			"stylua",
			"yq",
			"codespell",
			"ruff",
			"golangci-lint",
			"shellcheck",
			"shfmt",
			-- html formatter
			"prettier",
			-- html linter
			"htmlhint",
			"markuplint",
			-- markdown linter
			-- "vale",
			"markdownlint",
		},
	})
	nmap_leader("mti", "<cmd>MasonToolsInstall<cr>", "+install tools")
	nmap_leader("mtu", "<cmd>MasonToolsInstall<cr>", "+update tools")
	nmap_leader("mtc", "<cmd>MasonToolsClean<cr>", "+clean tools not in ensure_installed list")
	-- mason-lspconfig
	require("plugins/mason-lspconfig")
	---------------
	-- nvim-lint --
	---------------
	add("mfussenegger/nvim-lint")
	require("plugins/nvim-lint")
	-----------
	-- yanky --
	-----------
	add("gbprod/yanky.nvim")
	require("yanky").setup()
	nmap_leader("yc", "<cmd>YankyClearHistory<cr>", "[c]lear yanky history")
	nmap_leader("yl", function()
		require("yanky.textobj").last_put()
	end, "[l]ast put text")
	nmap_leader("yp", "<Plug>(YankyPreviousEntry)", "+choose previous yank entry")
	nmap_leader("yn", "<Plug>(YankyNextEntry)", "+choose previous yank entry")
	nmap("<A-p>", "<Plug>(YankyPreviousEntry)", "Select previous entry through yank history")
	nmap("<A-n>", "<Plug>(YankyNextEntry)", "Select next entry through yank history")
	nmap("y", "<Plug>(YankyYank)", "Yank text")
	nmap("p", "<Plug>(YankyPutAfter)", "Put yanked text after cursor")
	nmap("P", "<Plug>(YankyPutBefore)", "Put yanked text before cursor")
	nmap("gp", "<Plug>(YankyGPutAfter)", "Put yanked text after selection")
	nmap("gP", "<Plug>(YankyGPutBefore)", "Put yanked text before selection")
	nmap("]p", "<Plug>(YankyPutIndentAfterLinewise)", "Put indented after cursor (linewise)")
	nmap("[p", "<Plug>(YankyPutIndentBeforeLinewise)", "Put indented before cursor (linewise)")
	nmap("]P", "<Plug>(YankyPutIndentAfterLinewise)", "Put indented after cursor (linewise)")
	nmap("[P", "<Plug>(YankyPutIndentBeforeLinewise)", "Put indented before cursor (linewise)")
	nmap(">p", "<Plug>(YankyPutIndentAfterShiftRight)", "Put after and indent right")
	nmap("<p", "<Plug>(YankyPutIndentAfterShiftLeft)", "Put after and indent left")
	nmap(">P", "<Plug>(YankyPutIndentBeforeShiftRight)", "Put before and indent right")
	nmap("<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", "Put before and indent left")
	nmap("=p", "<Plug>(YankyPutAfterFilter)", "Put after applying a filter")
	nmap("=P", "<Plug>(YankyPutBeforeFilter)", "Put before applying a filter")
	--------------
	-- nvim-cmp --
	--------------
	add({
		source = "hrsh7th/nvim-cmp",
		depends = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			{
				source = "L3MON4D3/LuaSnip",
				checkout = "v2.3.0",
				hooks = {
					post_checkout = function()
						vim.cmd("make install_jsregexp")
					end,
				},
				depends = { "rafamadriz/friendly-snippets" },
			},
			"saadparwaiz1/cmp_luasnip",
			"chrisgrieser/cmp_yanky",
		},
	})
	require("plugins/nvim-cmp")
	--------------
	-- undotree --
	--------------
	add("mbbill/undotree")
	nmap_leader("tu", "<cmd>UndotreeToggle<cr>", "+toggle undo tree")
	vim.g.undotree_WindowLayout = 2
	vim.g.undotree_DiffAutoOpen = 0
	vim.g.undotree_SplitWidth = 35
	vim.g.undotree_ShortIndicators = 1
	vim.g.undotree_SetFocusWhenToggle = 1
	---------------------
	-- render-markdown --
	---------------------
	add({
		source = "MeanderingProgrammer/render-markdown.nvim",
		depends = {
			"nvim-treesitter/nvim-treesitter",
			"echasnovski/mini.nvim",
		},
	})
	require("plugins/rendermarkdown")
	-----------------
	-- toggle term --
	-----------------
	add({
		source = "akinsho/toggleterm.nvim",
		checkout = "main",
	})
	require("toggleterm").setup({
		size = function(term)
			if term.direction == "horizontal" then
				return vim.o.lines * 0.5
			elseif term.direction == "vertical" then
				return vim.o.columns * 0.5
			end
		end,
		open_mapping = [[<C-\>]],
		shade_terminals = false,
	})
	-- keymaps
	local trim_spaces = true
	vim.keymap.set("v", "<space>ts", function()
		require("toggleterm").send_lines_to_terminal("visual_selection", trim_spaces, { args = vim.v.count })
	end, { desc = "+Send visual selection to terminal" })
	vim.keymap.set("n", "<space>tl", function()
		require("toggleterm").send_lines_to_terminal("single_line", trim_spaces, { args = vim.v.count })
	end, { desc = "+Send current line to terminal" })
	nmap_leader("tv", "<CMD>exe v:count1 . 'ToggleTerm direction=vertical'<CR>", "+ToggleTerm vertical")
	nmap_leader("th", "<CMD>exe v:count1 . 'ToggleTerm direction=horizontal'<CR>", "+ToggleTerm horizontal")
	nmap_leader("tf", "<CMD>ToggleTerm direction=float<CR>", "+ToggleTerm float")
	function _G.set_terminal_keymaps()
		local opts = { buffer = 0 }
		vim.keymap.set("t", "<C-t>", [[<C-\><C-n>]], opts)
		vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
		vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
		vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
		vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
		vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
	end
	-- if you only want these mappings for toggle term use term://*toggleterm#* instead
	vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	--------------
	-- blink.cmp--
	--------------
	--  local BLINKCMP_VERSION = "v0.2.1"
	-- add({
	-- 	source = "saghen/blink.cmp",
	-- 	depends = {
	-- 		"rafamadriz/friendly-snippets",
	-- 	},
	-- 	checkout = BLINKCMP_VERSION,
	-- })
	-- require("blink.cmp").setup({
	-- 	keymap = {
	-- 		show = "<C-c>",
	-- 		hide = "<C-e>",
	-- 		accept = "<Enter>",
	-- 		select_prev = { "<Up>", "<A-k>" },
	--      select_next = { "<Down>", "<A-j>" },
	--
	-- 		scroll_documentation_up = "<A-b>",
	-- 		scroll_documentation_down = "<A-f>",
	--
	-- 		snippet_forward = "<C-j>",
	-- 		snippet_backward = "<C-k>",
	-- 	},
	-- 	highlight = {
	-- 		-- sets the fallback highlight groups to nvim-cmp's highlight groups
	-- 		-- useful for when your theme doesn't support blink.cmp
	-- 		-- will be removed in a future release, assuming themes add support
	-- 		use_nvim_cmp_as_default = true,
	-- 	},
	--
	-- 	-- experimental auto-brackets support
	-- 	accept = { auto_brackets = { enabled = true } },
	--
	-- 	-- experimental signature help support
	-- 	trigger = { signature_help = { enabled = true } },
	-- })
	--------------
	-- nvim ufo --
	--------------
	-- add({
	--   source = "kevinhwang91/nvim-ufo",
	--   depends = {
	--     "kevinhwang91/promise-async",
	--   }
	-- })
	-- require("plugins/nvim-ufo")
end)

-- ╔══════════════════════════════════╗
-- ║  options, keymaps and autocmds   ║
-- ╚══════════════════════════════════╝
require("core")
