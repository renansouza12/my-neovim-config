return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        require("rose-pine").setup({
            variant = "moon", -- "main", "moon", or "dawn"
            dark_variant = "main",
            styles = {
                bold = true,
                italic = true,
                transparency = true, -- handles background transparency for you
            },
        })

        vim.o.termguicolors = true
        vim.o.background = "dark"
        vim.cmd("colorscheme rose-pine")
    end,
}
