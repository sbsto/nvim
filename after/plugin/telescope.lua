local builtin = require('telescope.builtin')

function config()
  builtin.live_grep({
    additional_args = function(opts)
      return { "--hidden", "--glob", "!.git/*" }
    end
  })
end

vim.keymap.set('n', '<leader>ff', config, {})
vim.keymap.set('n', '<leader>fw', config, {})
