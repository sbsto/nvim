local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
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
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			require("tokyonight").setup({ transparency = true })
			vim.cmd("colorscheme tokyonight")
		end,
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

	-- Copilot
	{ "github/copilot.vim" },

	-- nvim tree
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, noremap = true, silent = true, nowait = true }
			end

			-- custom mappings
			vim.keymap.set("n", "<leader>tt", api.tree.toggle, opts("Toggle"))

			vim.keymap.set("n", "<leader>e", api.tree.focus, opts("Toggle"))

			require("nvim-tree").setup(require("sbsto.configs.nvimtree"))
		end,
	},
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
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					rust = {
						require("formatter.filetypes.rust").rustfmt,
					},
				},
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		opts = {
			-- add any options here
		},
		lazy = false,
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- set this if you want to always pull the latest change
		opts = {
			-- add any opts here
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
            local theme = require('lualine.themes.seoul256');
            theme.normal.b.bg = 'none'
            theme.normal.c.bg = 'none'
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
					globalstatus = false, refresh = {
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
