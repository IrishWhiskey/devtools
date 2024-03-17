vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- paste without copying highlited text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- delete in void register (so text won't be copied)
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- yank in unix clipboard (can then be pasted with C-v)
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])
