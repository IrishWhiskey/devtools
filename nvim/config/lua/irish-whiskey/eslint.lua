local function set_tab_width_from_eslint()
    local eslint_config_file = vim.fn.findfile(".eslintrc.json", ".;")
    if eslint_config_file == "" then return end

    local config = vim.fn.json_decode(vim.fn.readfile(eslint_config_file))
    local rules = config.rules or {}
    local indent = rules.indent

    if indent and indent[2] then
        local tabWidth = indent[2]
        vim.bo.tabstop = tabWidth
        vim.bo.shiftwidth = tabWidth
        vim.bo.expandtab = true
    end
end

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.js,*.jsx,*.ts,*.tsx",
    callback = set_tab_width_from_eslint
})
