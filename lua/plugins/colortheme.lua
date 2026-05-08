return {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_foreground = "material"
        vim.g.gruvbox_material_enable_italic = true
        vim.g.gruvbox_material_enable_bold = true
        vim.g.gruvbox_material_better_performance = 1
        vim.g.gruvbox_material_ui_contrast = "high"
        vim.g.gruvbox_material_float_style = "dim"
        vim.g.gruvbox_material_transparent_background = 2  -- 0: disabled | 1: normal | 2: full
        vim.o.termguicolors = true
        vim.o.background = "dark"
        vim.cmd("colorscheme gruvbox-material")

        local highlights = {
            "Normal",
            "NormalNC",
            "NormalFloat",
            "FloatBorder",
            "SignColumn",
            "StatusLine",
            "StatusLineNC",
            "TabLine",
            "TabLineFill",
            "TabLineSel",
            "EndOfBuffer",
            "LineNr",
            "CursorLineNr",
            "FoldColumn",
            "Folded",
            -- Neo-tree
            "NeoTreeNormal",
            "NeoTreeNormalNC",
            "NeoTreeEndOfBuffer",
            "NeoTreeWinSeparator",
        }

        for _, hl in ipairs(highlights) do
            vim.api.nvim_set_hl(0, hl, { bg = "NONE", ctermbg = "NONE" })
        end
    end,
}
