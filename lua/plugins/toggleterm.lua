return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup{
      size = 20,
      direction = "float",
      start_in_insert = true,
      close_on_exit = true,
      open_mapping = [[<c-t>]],
    }

    -- Normal mode toggle
    vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

    -- Terminal mode: press <Esc> or <C-t> to close
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = "Close terminal" })
    vim.keymap.set("t", "<C-t>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], { desc = "Close terminal" })
  end,
}

