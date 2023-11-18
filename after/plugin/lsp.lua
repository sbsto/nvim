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

local function format()
    local filetype = vim.bo.filetype
    local prettier_filetypes = {
        "javascript", "typescript", "css", "json", "yaml", "html", "markdown", "vue",
        "typescriptreact", "javascriptreact"
    }

    local bufnr = vim.api.nvim_get_current_buf()

    if vim.tbl_contains(prettier_filetypes, filetype) then
        local local_prettier = vim.fn.getcwd() .. '/node_modules/.bin/prettier'
        local prettier_cmd = vim.fn.executable(local_prettier) == 1 and local_prettier or
            (vim.fn.executable('prettier') == 1 and 'prettier')

        if not prettier_cmd then
            vim.lsp.buf.format({ bufnr = bufnr })
            return
        end

        local filename = vim.fn.expand('%:p')
        local cmd = prettier_cmd .. ' ' .. filename

        vim.fn.jobstart(cmd, {
            stdout_buffered = true,
            on_stdout = function(_, data)
                if data then
                    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, data)
                end
            end,
            on_exit = function(_, exit_code)
                if exit_code ~= 0 then
                    print("Prettier failed to format the file")
                end
            end,
        })
    else
        vim.lsp.buf.format({ bufnr = bufnr })
    end
end

lsp.on_attach(function(_, bufnr)
    local opts = { buffer = bufnr, remap = false }

    lsp.default_keymaps({ buffer = bufnr })

    vim.keymap.set("n", "<leader>fm", function() format() end, opts)
    vim.keymap.set("n", "<leader>ra", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<leader>gi", function() vim.lsp.buf.implementation() end, opts)
    vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

require('lspconfig').tsserver.setup({})

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'tsserver', 'eslint' },
    handlers = {
        lsp.default_setup,
    },
})
