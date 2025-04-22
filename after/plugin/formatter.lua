local augroup = vim.api.nvim_create_augroup("FormatterTailwind", { clear = true })
vim.api.nvim_create_autocmd("User", {
	pattern = "FormatterPost",
	group = augroup,
	callback = function()
		local ft = vim.bo.filetype
		local tailwind_filetypes = {
			"svelte",
			"typescriptreact",
			"javascriptreact",
			"html",
			"typescript",
			"vue",
			"css",
			"handlebars",
		}

		for _, allowed_ft in ipairs(tailwind_filetypes) do
			if ft == allowed_ft then
				vim.cmd("TailwindAutoSortRun")
				break
			end
		end
	end,
})
