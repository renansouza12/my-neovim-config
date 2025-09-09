return{
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup{
            size = 20,
            open_mapping = [[<leader>t]],
            direction = "float",
            start_in_insert = true,
            close_on_exit = true,
        }
    end,
}
