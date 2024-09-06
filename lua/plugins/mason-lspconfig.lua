-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
-- used to enable autocompletion (assign to every lsp server config)
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Ensure that dynamicRegistration is enabled! This allows the LS to take into account actions like the
-- Create Unresolved File code action, resolving completions for unindexed code blocks, ...
capabilities.workspace = {
	didChangeWatchedFiles = {
		dynamicRegistration = true,
	},
}
local lspconfig = require("lspconfig")
local handlers = {
	-- default handler for installed servers
	function(server_name)
		lspconfig[server_name].setup({
			capabilities = capabilities,
		})
	end,
	--> setup for markdown_oxide
	["markdown_oxide"] = function()
		lspconfig.markdown_oxide.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- refresh codelens on TextChanged and InsertLeave as well
				vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach" }, {
					buffer = bufnr,
					callback = vim.lsp.codelens.refresh,
				})
				-- trigger codelens refresh
				vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
				-- setup Markdown Oxide daily note commands
				if client.name == "markdown_oxide" then
					vim.api.nvim_create_user_command("Daily", function(args)
						local input = args.args
						vim.lsp.buf.execute_command({ command = "jump", arguments = { input } })
					end, { desc = "Open daily note", nargs = "*" })
				end
			end,
		})
	end,
	--> setup for lua language server
	["lua_ls"] = function()
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
						},
					},
				},
			},
		})
	end,
	["ruff"] = function()
		lspconfig.ruff.setup({
			capabilities = capabilities,
			---@diagnostic disable-next-line:unused-local
			on_attach = function(client, bufnr)
				if client.name == "ruff" then
					-- Disable hover in favor of Pyright
					client.server_capabilities.hoverProvider = false
				end
			end,
			cmd_env = { RUFF_TRACE = "messages" },
			init_options = {
				settings = {
					logLevel = "debug",
					logFile = "~/.local/state/nvim/ruff.log",
				},
			},
		})
	end,
	["basedpyright"] = function()
		lspconfig.basedpyright.setup({
			capabilities = capabilities,
			settings = {
				basedpyright = {
					disableOrganizeImports = true,
					analysis = {
						autoImportCompletions = true,
					},
				},
			},
		})
	end,
	-- refer to https://github.com/astral-sh/ruff-lsp/issues/384
	-- ["pyright"] = function()
	-- 	lspconfig.pyright.setup({
	-- 		capabilities = capabilities,
	-- 		settings = {
	-- 			pyright = {
	-- 				-- Using Ruff's import organizer
	-- 				disableOrganizeImports = true,
	-- 			},
	-- 			python = {
	-- 				analysis = {
	-- 					diagnosticSeverityOverrides = {
	-- 						-- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#type-check-diagnostics-settings
	-- 						-- reportUndefinedVariable = "none",
	-- 						-- reportAssignmentType = "none",
	-- 						-- Just put below line here as per official documents, but it doesn't workspace
	-- 						-- so I used above setup to disable certain diagnostics.
	-- 						-- Ignore all files for analysis to exclusively use Ruff for linting
	-- 						-- ignore = { "*" },
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	})
	-- end,
}
--> setup mason-lspconfig
local mlc = require("mason-lspconfig")
mlc.setup({
	ensure_installed = {
		"ansiblels",
		"bashls",
		"dockerls",
		"docker_compose_language_service",
		"gopls",
		"jsonls",
		"lua_ls",
		"markdown_oxide",
		-- "pyright",
		"basedpyright",
		-- "ruff",
		"yamlls",
	},
	handlers = handlers,
})
--> setup keymaps
local nmap_leader = function(suffix, rhs, desc)
	vim.keymap.set("n", "<Leader>" .. suffix, rhs, { desc = desc })
end
nmap_leader("mli", function()
	local servers = vim.fn.input("Please enter lsp servers to install: ")
	vim.cmd("LspInstall " .. servers)
end, "[M]ason install lsp servers")
nmap_leader("mlu", function()
	local servers = vim.fn.input("Please enter lsp servers to install: ")
	vim.cmd("LspUninstall " .. servers)
end, "[U]ninstall mason lsp servers")
