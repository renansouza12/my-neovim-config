return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate", -- updates registry automatically
  config = function()
    require("mason").setup()
  end,
}
