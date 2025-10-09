return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
  config = function()
    require("mason-lspconfig").setup({
      -- servers you want installed automatically
      ensure_installed = { "ts_ls", "html", "cssls", "emmet_ls", "angularls", "lua_ls", "jdtls" },
    })
  end,
}
