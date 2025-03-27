-- Core initialization
require('core.options')
require('core.keymaps')
require('core.autocmds')
require('core.lazy')     -- This loads plugins

-- Set colorscheme after plugins are loaded
vim.cmd('colorscheme habamax')

require('core.lsp')      -- LSP configuration
require('core.telescope') -- Telescope configuration
require('core.treesitter') -- Treesitter configuration

-- Load custom configurations
require('custom.keymap') -- Your existing custom keymaps
