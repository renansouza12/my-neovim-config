return {
  "olivercederborg/poimandres.nvim",
  name = "poimandres",
  lazy = false,
  priority = 1000,
  config = function()
    require("poimandres").setup {
      bold_vert_split        = false, -- Set to true if you like bold window separators
      dim_nc_background      = false, -- Dim background of non-current windows
      disable_background     = false, -- Set true if you want transparency
      disable_float_background = false,
      disable_italics        = false, -- Disable all italics
    }

    -- enable colorscheme
    vim.cmd.colorscheme("poimandres")

    -- UI options for safety
    vim.o.termguicolors = true
    vim.o.background = "dark"

    -- Integrations / highlights
    -- Poimandres doesn’t ship explicit integrations like Catppuccin,
    -- so we link highlights here to keep plugins consistent.
    local hl = vim.api.nvim_set_hl
    local colors = require("poimandres.palette")

    -- Neo-tree background tweak
    hl(0, "NeoTreeNormal", { bg = "none" })
    hl(0, "NeoTreeNormalNC", { bg = "none" })

    -- Telescope borders / prompt
    hl(0, "TelescopeNormal", { bg = "none" })
    hl(0, "TelescopeBorder", { fg = colors.blue, bg = "none" })
    hl(0, "TelescopePromptNormal", { bg = "none" })
    hl(0, "TelescopePromptBorder", { fg = colors.cyan, bg = "none" })

    -- CMP menu
    hl(0, "CmpNormal", { bg = "none" })

    -- Gitsigns
    hl(0, "GitSignsAdd", { fg = colors.green })
    hl(0, "GitSignsChange", { fg = colors.yellow })
    hl(0, "GitSignsDelete", { fg = colors.red })

    -- Trouble (LSP diagnostics list)
    hl(0, "TroubleNormal", { bg = "none" })

    -- Which-key popup
    hl(0, "WhichKeyFloat", { bg = "none" })
  end,
}

