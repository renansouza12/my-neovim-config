return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                "ts_ls",
                "html",
                "cssls",
                "emmet_ls",
                "angularls",
                "lua_ls", -- Lua (for Neovim config)
            },
            automatic_installation = true,
        })
    end
}
