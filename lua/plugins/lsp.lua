return {
  'neovim/nvim-lspconfig',
  dependencies = {
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = {
          window = {
            winblend = 0,
          },
        },
      },
    },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Essential LSP keymaps
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        
        -- IMPORTANT: Hover documentation keymap
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        
        -- Signature help (shows function parameters as you type)
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', 'i')

        -- Document and workspace symbols
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Inlay hints toggle
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Enhanced capabilities for better autocompletion and imports
    capabilities.textDocument.completion.completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }

    -- Setup language servers (without Mason dependency)
    local lspconfig = require('lspconfig')

    -- TypeScript/JavaScript
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
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
      root_dir = function(fname)
        local util = require("lspconfig.util")
        if util.root_pattern("angular.json")(fname) then
          return nil
        end
        return util.root_pattern("tsconfig.json", "package.json", ".git")(fname)
      end,
    })

    -- HTML Language Server
    lspconfig.html.setup({
      capabilities = capabilities,
      filetypes = { 'html', 'twig', 'hbs' },
      settings = {
        html = {
          hover = {
            documentation = true,
            references = true,
          },
          completion = {
            attributeDefaultValue = "doublequotes",
          },
          format = {
            enable = true,
            wrapLineLength = 120,
            unformatted = "wbr",
            contentUnformatted = "pre,code,textarea",
            indentInnerHtml = false,
            preserveNewLines = true,
            indentHandlebars = false,
            endWithNewline = false,
            extraLiners = "head, body, /html",
            wrapAttributes = "auto",
          },
          suggest = {
            html5 = true,
          },
          validate = {
            scripts = true,
            styles = true,
          },
        },
      },
    })

    -- CSS Language Server  
    lspconfig.cssls.setup({
      capabilities = capabilities,
      filetypes = { "css", "scss", "less", "sass" },
      settings = {
        css = {
          validate = true,
          hover = {
            documentation = true,
            references = true,
          },
          completion = {
            completePropertyWithSemicolon = true,
            triggerPropertyValueCompletion = true,
          },
          lint = {
            compatibleVendorPrefixes = "ignore",
            vendorPrefix = "warning",
            duplicateProperties = "warning",
            emptyRules = "warning",
            importStatement = "ignore",
            boxModel = "ignore",
            universalSelector = "ignore",
            zeroUnits = "ignore",
            fontFaceProperties = "warning",
            hexColorLength = "error",
            argumentsInColorFunction = "error",
            unknownProperties = "warning",
            ieHack = "ignore",
            unknownVendorSpecificProperties = "ignore",
            propertyIgnoredDueToDisplay = "warning",
            important = "ignore",
            float = "ignore",
            idSelector = "ignore",
          },
        },
        scss = {
          validate = true,
          hover = {
            documentation = true,
            references = true,
          },
          completion = {
            completePropertyWithSemicolon = true,
            triggerPropertyValueCompletion = true,
          },
        },
        less = {
          validate = true,
          hover = {
            documentation = true,
            references = true,
          },
          completion = {
            completePropertyWithSemicolon = true,
            triggerPropertyValueCompletion = true,
          },
        },
      },
    })

    -- Emmet Language Server
    lspconfig.emmet_ls.setup({
      capabilities = capabilities,
      filetypes = { 
        'html', 
        'css', 
        'scss', 
        'sass', 
        'less', 
        'javascript', 
        'typescript', 
        'javascriptreact', 
        'typescriptreact' 
      },
      init_options = {
        html = {
          options = {
            ["bem.enabled"] = true,
          },
        },
      },
    })

    -- Angular Language Server
    lspconfig.angularls.setup({
      capabilities = capabilities,
      cmd = function()
        local cmd = "ngserver"
        if vim.fn.executable("ngserver") == 1 then
          return {
            cmd,
            "--stdio",
            "--tsProbeLocations",
            vim.fn.system("npm root -g"):gsub("\n", ""),
            "--ngProbeLocations", 
            vim.fn.system("npm root -g"):gsub("\n", ""),
          }
        else
          return {
            "node",
            vim.fn.system("npm root -g"):gsub("\n", "") .. "/@angular/language-server",
            "--stdio",
            "--tsProbeLocations",
            vim.fn.system("npm root -g"):gsub("\n", ""),
            "--ngProbeLocations",
            vim.fn.system("npm root -g"):gsub("\n", ""),
          }
        end
      end,
      filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
      root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),
    })

    -- Lua Language Server
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          runtime = { version = 'LuaJIT' },
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file('', true),
          },
          diagnostics = {
            globals = { 'vim' },
            disable = { 'missing-fields' },
          },
          format = {
            enable = false,
          },
          hint = {
            enable = true,
          },
        },
      },
    })
  end,
}
