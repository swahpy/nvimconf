local lint = require("lint")

lint.linters_by_ft = {
	go = { "golangcilint" },
	html = { "htmlhint", "markuplint" },
	markdown = { "markdownlint-cli2" },
	python = { "ruff" },
}

--> setup lint rules for markdown_lint
lint.linters["markdownlint-cli2"].args = {
	"--config",
	os.getenv("HOME") .. "/.config/.markdownlint.yaml",
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
