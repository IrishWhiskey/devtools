return {
    "terrortylor/nvim-comment",
    config = function()
        require('nvim_comment').setup({
            comment_empty = false,
            create_mappings = false
        })

        vim.keymap.set("n", "<C-l>", ":CommentToggle<CR>")
        vim.keymap.set("v", "<C-l>", ":'<,'>CommentToggle<CR>")
    end
}
