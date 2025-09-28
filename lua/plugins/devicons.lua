return {
    "nvim-tree/nvim-web-devicons",
    config = function()
        require("nvim-web-devicons").setup({
            -- your personnal icons can go here (to override)
            override = {},
            -- globally enable default icons (default to false)
            default = true,
            -- globally enable "strict" selection of icons - icon will be looked up in
            -- different tables, first by filename, and if not found by extension; this
            -- prevents cases when file doesn't have any extension but still gets some icon
            -- because its name happened to match some extension (default to false)
            strict = true,
            -- same as `override` but specifically for overrides by filename
            override_by_filename = {},
            -- same as `override` but specifically for overrides by extension
            override_by_extension = {},
        })
    end,
}
