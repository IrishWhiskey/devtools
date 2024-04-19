local pylsp = require("mason-registry").get_package("python-lsp-server")
pylsp:on("install:success", function()
    local function mason_package_path(package)
        local path = vim.fn.resolve(vim.fn.stdpath("data") .. "/mason/packages/" .. package)
        return path
    end

    local path = mason_package_path("python-lsp-server")
    local command = path .. "/venv/bin/pip"
    local args = {
        "install",
        "-U",
        "python-lsp-isort",
        "python-lsp-ruff",
        "pylsp-mypy",
    }
    print("installing pylsp dependencies...")

    require("plenary.job")
        :new({
            command = command,
            args = args,
            cwd = path,
            on_exit = function(j, return_val)
                print("installation done")
            end,
        })
        :start()
end)
