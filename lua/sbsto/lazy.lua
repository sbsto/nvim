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

local plugins = {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"rose-pine/neovim",
		as = "rose-pine",
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	},
	{
		"nvim-treesitter/playground",
	},
	{
		"theprimeagen/harpoon",
	},
	{ "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
	{ "neovim/nvim-lspconfig" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },

	-- Autocompletion
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-nvim-lua" },

	-- Snippets
	{ "L3MON4D3/LuaSnip" },
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
			print("running formatter config")
			require("formatter").setup({
				filetype = {
					typescript = {
						require("formatter.filetypes.typescript").prettier,
					},
					typescriptreact = {
						require("formatter.filetypes.typescriptreact").prettier,
					},
					javascript = {
						require("formatter.filetypes.javascript").prettier,
					},
                    javascriptreact = {
                        require("formatter.filetypes.javascriptreact").prettier,
                    },
                    css = {
                        require("formatter.filetypes.css").prettier,
                    },
                    html = {
                        require("formatter.filetypes.html").prettier,
                    },
                    yaml = {
                        require("formatter.filetypes.yaml").prettier,
                    },
                    json = {
                        require("formatter.filetypes.json").prettier,
                    },
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
				},
			})
		end,
	},
}

require("lazy").setup(plugins)
