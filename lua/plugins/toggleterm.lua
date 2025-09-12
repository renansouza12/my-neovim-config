return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup{
      size = 20,
      direction = "float",
      start_in_insert = true,
      close_on_exit = true,
    }

    -- Normal mode toggle
    vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

    -- Terminal mode: press <Esc> to close
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = "Close terminal" })
  end,
}

