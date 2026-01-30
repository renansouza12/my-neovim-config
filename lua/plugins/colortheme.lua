return {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
        -- REQUIRED: these are global variables (vim.g), not setup()
        vim.g.gruvbox_material_background = "hard" -- soft | medium | hard
        vim.g.gruvbox_material_foreground = "material" -- material | mix | original
        vim.g.gruvbox_material_enable_italic = true
        vim.g.gruvbox_material_enable_bold = true
        vim.g.gruvbox_material_better_performance = 1

        -- Optional but nice
        vim.g.gruvbox_material_ui_contrast = "high" -- low | high
        vim.g.gruvbox_material_float_style = "dim"

        vim.o.termguicolors = true
        vim.o.background = "dark"
        vim.cmd("colorscheme gruvbox-material")
    end,
}

