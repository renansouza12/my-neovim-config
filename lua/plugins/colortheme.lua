
return {
  "rebelot/kanagawa.nvim",
  name = "kanagawa",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      compile = false,              -- don’t compile by default
      undercurl = true,
      commentStyle = { italic = true },
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      overrides = function(colors)
        -- You can override individual highlight groups here
        return {
          -- For example: make floating windows transparent
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          -- Maybe tweak Telescope borders
          TelescopeBorder = { fg = colors.theme.ui.special, bg = colors.theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = colors.theme.ui.special, bg = colors.theme.ui.bg_p1 },
          -- etc.
        }
      end,
    })

    vim.o.termguicolors = true
    vim.o.background = "dark"

    -- You can choose a variant, e.g. "wave", "dragon", "lotus"
    -- If you don’t set theme, it will use defaults via setup
    vim.cmd.colorscheme("kanagawa")
  end,
}

