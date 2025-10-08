return {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    config = function()
        -- Setup Kanagawa
        require("kanagawa").setup({
            compile = true,            -- enable compilation for faster startup
            undercurl = true,          -- enable undercurl for diagnostics
            commentStyle = { italic = true },
            functionStyle = { bold = false },
            keywordStyle = { italic = true },
            statementStyle = { bold = true },
            typeStyle = {},
            variablebuiltinStyle = { italic = true },
            specialReturn = true,
            specialException = true,
            dimInactive = false,
            globalStatus = true,
            colors = {
                theme = {
                    all = {
                        ui = {
                            bg_gutter = "none",  -- make signcolumn transparent
                        },
                    },
                },
            },
        })

        -- enable colorscheme
        vim.cmd.colorscheme("kanagawa")

        -- UI options
        vim.o.termguicolors = true
        vim.o.background = "dark"

        -- highlight tweaks for plugins (like your old Poimandres config)
        local hl = vim.api.nvim_set_hl
        local colors = require("kanagawa.colors").setup() -- get palette

        -- Neo-tree background tweak
        hl(0, "NeoTreeNormal", { bg = "none" })
        hl(0, "NeoTreeNormalNC", { bg = "none" })

        -- Telescope borders / prompt
        hl(0, "TelescopeNormal", { bg = "none" })
        hl(0, "TelescopeBorder", { fg = colors.syn.comment, bg = "none" })
        hl(0, "TelescopePromptNormal", { bg = "none" })
        hl(0, "TelescopePromptBorder", { fg = colors.fun.red, bg = "none" })

        -- CMP menu
        hl(0, "CmpNormal", { bg = "none" })

        -- Gitsigns
        hl(0, "GitSignsAdd", { fg = colors.ui.green })
        hl(0, "GitSignsChange", { fg = colors.ui.yellow })
        hl(0, "GitSignsDelete", { fg = colors.ui.red })

        -- Trouble (LSP diagnostics list)
        hl(0, "TroubleNormal", { bg = "none" })

        -- Which-key popup
        hl(0, "WhichKeyFloat", { bg = "none" })
    end,
}

