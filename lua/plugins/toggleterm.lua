return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20,
            direction = "float",
            start_in_insert = true,
            close_on_exit = true,
            shell = "pwsh.exe -NoLogo",
            float_opts = {
                border = "curved",
                winblend = 0,
            },
        })

        vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
        vim.keymap.set("t", "<C-t>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = "Close terminal" })
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal insert mode" })
    end,
}
