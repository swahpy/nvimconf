-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
-- used to enable autocompletion (assign to every lsp server config)
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
				},
			}),
			on_attach = function(client, bufnr)
				local function check_codelens_support()
					local clients = vim.lsp.get_active_clients({ bufnr = 0 })
					for _, c in ipairs(clients) do
						if c.server_capabilities.codeLensProvider then
							return true
						end
					end
					return false
				end

				vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach", "BufEnter" }, {
					buffer = bufnr,
					callback = function()
						if check_codelens_support() then
							vim.lsp.codelens.refresh({ bufnr = 0 })
						end
					end,
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
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticsMode = "openFilesOnly", -- workspace, openFilesOnly
						typeCheckingMode = "standard", -- off, basic, standard, strict, all
						diagnosticSeverityOverrides = {
							reportUnknownMemberType = false,
							reportUnknownArgumentType = false,
							reportUnusedVariable = false, -- ruff handles this with F841
							reportUnusedImport = false, -- ruff handles this with F401
							reportAttributeAccessIssue = false,
						},
					},
				},
				python = {
					pythonPath = "./venv/bin/python",
				},
			},
		})
	end,
	["emmet_language_server"] = function()
		lspconfig.emmet_language_server.setup({
      capabilities = capabilities,
    })
	end,
	["typos_lsp"] = function()
		lspconfig.typos_lsp.setup({
			-- Logging level of the language server. Logs appear in :LspLog. Defaults to error.
			cmd_env = { RUST_LOG = "error" },
			init_options = {
				-- Custom config. Used together with a config file found in the workspace or its parents,
				-- taking precedence for settings declared in both.
				-- Equivalent to the typos `--config` cli argument.
				config = "~/.config/typos.toml",
				-- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
				-- Defaults to error.
				diagnosticSeverity = "Error",
			},
		})
	end,
}
--> setup mason-lspconfig
local mlc = require("mason-lspconfig")
mlc.setup({
	ensure_installed = {
		"ansiblels",
		"bashls",
		"dockerls",
		"docker_compose_language_service",
		"emmet_language_server",
		"gopls",
		"jsonls",
		"lua_ls",
		"markdown_oxide",
		"basedpyright",
		-- "ruff",
		"yamlls",
		"typos_lsp",
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
