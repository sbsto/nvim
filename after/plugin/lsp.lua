local lsp = require('lsp-zero')

lsp.preset("recommended")

-- Fix Undefined global 'vim'
lsp.configure('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    lsp.default_keymaps({ buffer = bufnr })

    vim.keymap.set("n", "<leader>ra", function() vim.lsp.buf.rename() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        lsp.default_setup,
    },
})
