require("nvim-treesitter.configs").setup({
	ensure_installed = {
    "css",
		"go",
    "hcl",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "ocaml",
    "python",
    "rust",
    "svelte",
		"terraform",
    "typescript",
		"vim",
		"vimdoc",
	},

	sync_install = false,
	auto_install = true,

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},

	indent = {
		enable = true,
	},
})
