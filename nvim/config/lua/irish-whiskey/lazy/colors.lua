return {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
        function SetColor(color)
            color = color or "rose-pine"
            vim.cmd.colorscheme(color)

            vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
            vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
        end

        SetColor()
    end
}
