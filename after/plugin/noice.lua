require("noice").setup({
	cmdline = {
		enabled = true,
		view = "cmdline_popup",
	},
	views = {
		cmdline_popup = {
			position = {
				row = "100%",
				col = 0,
			},
			size = {
				width = "auto",
				height = "auto",
			},
			border = {
				style = "none",
			},
			win_options = {
				winhighlight = "NormalFloat:Normal",
			},
		},
	},
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = true,
		command_palette = false,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = true,
	},
})
