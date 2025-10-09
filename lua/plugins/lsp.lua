return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "j-hui/fidget.nvim",
            opts = {
                notification = { window = { winblend = 0 } },
            },
        },
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        ---------------------------------------------------------------------------
        -- LspAttach autocmd (your existing mappings)
        ---------------------------------------------------------------------------
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation", "i")

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        ---------------------------------------------------------------------------
        -- Capabilities (for autocompletion)
        ---------------------------------------------------------------------------
        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
        )

        ---------------------------------------------------------------------------
        -- Mason setup
        ---------------------------------------------------------------------------
        require("mason-lspconfig").setup({
            ensure_installed = {
                "ts_ls",     -- ✅ new name for tsserver
                "html",
                "cssls",
                "emmet_ls",
                "angularls",
                "lua_ls",
            },
            automatic_installation = true,
        })

        ---------------------------------------------------------------------------
        -- Setup servers manually (new approach)
        ---------------------------------------------------------------------------
        local lspconfig = require("lspconfig")

        -- TypeScript / JavaScript
        lspconfig.ts_ls.setup({
            capabilities = capabilities,
            init_options = {
                preferences = {
                    importModuleSpecifierPreference = "relative",
                    importModuleSpecifierEnding = "minimal",
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
            },
        })

        -- Lua
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    completion = { callSnippet = "Replace" },
                    runtime = { version = "LuaJIT" },
                    workspace = {
                        checkThirdParty = false,
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    diagnostics = {
                        globals = { "vim" },
                        disable = { "missing-fields" },
                    },
                    format = { enable = false },
                    hint = { enable = true },
                },
            },
        })

        -- Other servers
        for _, server in ipairs({ "html", "cssls", "emmet_ls", "angularls" }) do
            lspconfig[server].setup({ capabilities = capabilities })
        end
    end,
}

