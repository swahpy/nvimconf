local lint = require("lint")

lint.linters_by_ft = {
	go = { "golangcilint" },
	markdown = { "markdownlint" },
	python = { "ruff" },
}

--> setup lint rules for markdown_lint
local mdl = lint.linters.markdownlint
mdl.args = {
	"--disable",
	"MD013",
	"MD024",
	"MD034",
	"--",
}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft` for the current filetype
		lint.try_lint()
	end,
})

vim.keymap.set("n", "<leader><leader>l", function()
	lint.try_lint()
end, { desc = "Trigger linting for current file" })
