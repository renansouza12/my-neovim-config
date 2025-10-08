return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "j-hui/fidget.nvim",
            opts = {
                notification = {
                    window = {
                        winblend = 0,
                    },
                },
            },
        },
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        ---------------------------------------------------------------------------
        -- LspAttach autocmd (your keymaps, unchanged)
        ---------------------------------------------------------------------------
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- Essential LSP keymaps
                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- Hover docs
                map("K", vim.lsp.buf.hover, "Hover Documentation")

                -- Signature help
                map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation", "i")

                -- Document highlight
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
                        end,
                    })
                end

                -- Inlay hints toggle
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        ---------------------------------------------------------------------------
        -- Capabilities (autocompletion, etc.)
        ---------------------------------------------------------------------------
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        ---------------------------------------------------------------------------
        -- Mason setup
        ---------------------------------------------------------------------------
        require("mason-lspconfig").setup({
            ensure_installed = {
                "tsserver",
                "html",
                "cssls",
                "emmet_ls",
                "angularls",
                "lua_ls",
                -- ❌ Don't include jdtls
            },
            automatic_installation = true,
        }) 

        ---------------------------------------------------------------------------
        -- mason-lspconfig handlers
        ---------------------------------------------------------------------------
        require("mason-lspconfig").setup_handlers({
            function(server_name)
                if server_name == "jdtls" then
                    return
                end
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities,
                })
            end,

            -- Custom: TypeScript/JavaScript
            ["tsserver"] = function()
                lspconfig.tsserver.setup({
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
            end,

            -- Custom: Lua
            ["lua_ls"] = function()
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
            end,
        })
    end,
}

