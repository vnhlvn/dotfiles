vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")
vim.keymap.set("n", "<leader>pg", [[:G<CR>]])
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>ff", "<CMD>lua vim.lsp.buf.format()<CR>")

vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file)
vim.keymap.set('n', '<leader>ht', require("harpoon.ui").toggle_quick_menu)

