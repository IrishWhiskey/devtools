return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        require("nvim-treesitter").install({
            "c", "cpp", "lua", "vim", "vimdoc", "query", "javascript", "python"
        })
    end,
}
