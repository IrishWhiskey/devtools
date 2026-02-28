return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-web-devicons").setup { default = true }

        require("nvim-tree").setup {
            -- Auto-refresh tree when files change on disk
            filesystem_watchers = {
                enable = true,
            },
            -- Keep tree in sync with currently edited file
            update_focused_file = {
                enable = true,
                update_root = false,
            },
            renderer = {
                icons = {
                    webdev_colors = true,
                    git_placement = "before",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                },
            },
        }
    end,
}
