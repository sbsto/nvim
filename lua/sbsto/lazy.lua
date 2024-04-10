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
  if vim.fn.filereadable(vim.fn.getcwd() .. '/biome.json') == 1 then
    -- Return the Biome formatter if biome.json exists
    return require("formatter.filetypes." .. filetype).biome
  else
    -- Return the Prettier formatter if biome.json doesn't exist
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
}

require("lazy").setup(plugins)
