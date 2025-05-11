return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
    },
    config = function()
        local lsp = require('lsp-zero')

        lsp.preset("recommended")

        lsp.on_attach(function(client, bufnr)
            local opts = {buffer = bufnr, remap = false}

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end)

        local lspconfig = require("lspconfig")

        require('mason').setup({
            ui = {
                check_outdated_packages_on_open = false,
            },
        })

        require('mason-lspconfig').setup({
            ensure_installed = {
                "eslint",
                "rust_analyzer",
                "pylsp"
            },
            automatic_installation = false,
            handlers = {
                lsp.default_setup,
                lua_ls = function()
                    local lua_opts = lsp.nvim_lua_ls()
                    lspconfig.lua_ls.setup(lua_opts)
                end,
                pylsp = function()
                    lspconfig.pylsp.setup({
                        on_attach = lsp.on_attach,
                        capabilities = lsp.capabilities,
                        settings = {
                            pylsp = {
                                configurationSources = { "pycodestyle" },
                                plugins = {
                                    autopep8 = { enabled = false },
                                    flake8 = { enabled = false },
                                    jedi_completion = { enabled = true, fuzzy = true },
                                    jedi_definition = { enabled = true },
                                    jedi_hover = { enabled = true },
                                    jedi_references = { enabled = true },
                                    jedi_signature_help = { enabled = true },
                                    jedi_symbols = { enabled = true },
                                    mccabe = { enabled = false },
                                    preload = { enabled = false },
                                    pycodestyle = { enabled = false },
                                    pyflakes = { enabled = false },
                                    rope_autoimport = { code_actions = { enabled = false }},
                                    rope_autoimport = { completions = { enabled = false }},
                                    yapf = { enabled = false },
                                    ruff = { enabled = true, formatEnabled = true },
                                    pylsp_mypy = { enabled = false },
                                    -- black = { enabled = false },
                                    isort = { enabled = true }
                                }
                            }
                        }
                    })
                end,
            },
        })

        local cmp = require('cmp')
        local cmp_select = {behavior = cmp.SelectBehavior.Select}

        cmp.setup({
            sources = {
                {name = 'path'},
                {name = 'nvim_lsp'},
                {name = 'nvim_lua'},
                {name = 'luasnip', keyword_length = 2},
                {name = 'buffer', keyword_length = 3},
            },
            formatting = lsp.cmp_format({details = false}),
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
        })
    end,
}
