local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local function select_formatter(filetype)
	if vim.fn.filereadable(vim.fn.getcwd() .. "/biome.json") == 1 then
		return require("formatter.filetypes." .. filetype).biome
	else
		return require("formatter.filetypes." .. filetype).prettier
	end
end

local plugins = {
	{
		"shaunsingh/seoul256.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	},
	{
		"nvim-treesitter/playground",
	},
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },

	-- Autocompletion
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },

	-- Snippets
	{ "rafamadriz/friendly-snippets" },

	  {
	    'stevearc/oil.nvim',
	    opts = {},
	    dependencies = { { "echasnovski/mini.icons", opts = {} } },
	  },

	-- Supermaven
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({})
		end,
	},

	-- formatter
	{
		"mhartington/formatter.nvim",
		lazy = false,
		config = function()
			require("formatter").setup({
				filetype = {
					typescript = select_formatter("typescript"),
					typescriptreact = select_formatter("typescriptreact"),

					svelte = select_formatter("svelte"),
					javascript = select_formatter("javascript"),
					javascriptreact = select_formatter("javascriptreact"),
					css = select_formatter("css"),
					html = select_formatter("html"),
					yaml = select_formatter("yaml"),
					json = select_formatter("json"),
					ocaml = {
						require("formatter.filetypes.ocaml").ocamlformat,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					rust = {
						require("formatter.filetypes.rust").rustfmt,
					},
          go = {
            require("formatter.filetypes.go").gofumpt,
          },
          nix = {
            require("formatter.filetypes.nix").nixpkgs_fmt,
          },
				},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local theme = require("lualine.themes.seoul256")
			theme.normal.b.bg = "none"
			theme.normal.c.bg = "none"
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = theme,
					component_separators = { left = " ", right = " " },
					section_separators = { left = " ", right = " " },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
}

require("lazy").setup(plugins)
