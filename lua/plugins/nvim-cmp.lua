vim.opt.completeopt = { "menu", "menuone", "noselect" }
require("luasnip.loaders.from_vscode").lazy_load()
--> loading custom snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets/" })
--> cmp setup <--
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<A-j>"] = cmp.mapping.select_next_item(),
		["<A-k>"] = cmp.mapping.select_prev_item(),
		["<A-d>"] = cmp.mapping.scroll_docs(-4),
		["<A-u>"] = cmp.mapping.scroll_docs(4),
		["<C-d>"] = cmp.mapping.open_docs(),
		["<C-h>"] = cmp.mapping.close_docs(),
		["<C-c>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				if luasnip.expandable() then
					luasnip.expand()
				else
					cmp.confirm({
						select = true,
					})
				end
			else
				fallback()
			end
		end),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				if #cmp.get_entries() == 1 then
					cmp.confirm({ select = true })
				else
					cmp.select_next_item()
				end
			elseif luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			else
				require("neotab").tabout()
				-- vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(Tabout)", true, true, true), "")
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	-- Setup if preview window to be bordered
	-- window = {
	--   completion = cmp.config.window.bordered(),
	--   documentation = cmp.config.window.bordered(),
	-- },
	sources = {
		{
			name = "nvim_lsp",
			option = {
				markdown_oxide = {
					keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
				},
			},
		},
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{
			name = "cmp_yanky",
			option = {
				-- only suggest items which match the current filetype
				onlyCurrentFiletype = false,
				-- only suggest items with a minimum length
				minLength = 3,
			},
		},
	},
})

--> setup for cmp-cmdline <--
-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})
-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
	matching = { disallow_symbol_nonprefix_matching = false },
})

-- local s = luasnip.snippet
-- local t = luasnip.text_node
-- local i = luasnip.insert_node
-- local fmt = require("luasnip.extras.fmt").fmt
--
-- luasnip.add_snippets("lua", {
-- 	s("var", fmt("local {} = {}\n{}", { i(1, "name"), i(2, "value"), i(0) })),
-- })
