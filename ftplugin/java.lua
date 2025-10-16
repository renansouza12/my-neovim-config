-- This file should be at: ~/.config/nvim/ftplugin/java.lua (or AppData/Local/nvim/ftplugin/java.lua on Windows)
-- It will run automatically when opening Java files

-- CRITICAL: Prevent running multiple times for the same buffer
-- This is what fixes the "jdtls starts multiple times" issue
if vim.b.jdtls_configured then
    return
end
vim.b.jdtls_configured = true

local jdtls = require('jdtls')

-- Determine OS
local home = os.getenv('USERPROFILE') or os.getenv('HOME')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.local/share/nvim/jdtls-workspace/' .. project_name

-- Ensure workspace directory exists
vim.fn.mkdir(workspace_dir, 'p')

-- Find mason installation path
local jdtls_install = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

-- Check if jdtls is installed
if vim.fn.isdirectory(jdtls_install) == 0 then
    vim.notify('JDTLS not found. Please install it via :Mason', vim.log.levels.ERROR)
    return
end

-- Find the launcher jar
local launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')
if launcher_jar == '' then
    vim.notify('JDTLS launcher jar not found at: ' .. jdtls_install .. '/plugins/', vim.log.levels.ERROR)
    return
end

-- Determine config directory based on OS
local config_dir
if vim.fn.has('win32') == 1 then
    config_dir = jdtls_install .. '/config_win'
elseif vim.fn.has('mac') == 1 then
    config_dir = jdtls_install .. '/config_mac'
else
    config_dir = jdtls_install .. '/config_linux'
end

-- Lombok path (optional - comment out if not using Lombok)
local lombok_path = home .. '/.m2/repository/org/projectlombok/lombok/1.18.34/lombok-1.18.34.jar'
local lombok_arg = vim.fn.filereadable(lombok_path) == 1 and '-javaagent:' .. lombok_path or nil

-- Build cmd table
local cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher_jar,
    '-configuration', config_dir,
    '-data', workspace_dir,
}

-- Add Lombok agent if available
if lombok_arg then
    table.insert(cmd, 2, lombok_arg)
end

-- Get capabilities from nvim-cmp if available
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
    capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
end

-- JDTLS configuration
local config = {
    cmd = cmd,
    root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),
    capabilities = capabilities,
    
    settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            format = {
                enabled = true,
            },
        },
        signatureHelp = { enabled = true },
        completion = {
            favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
            },
        },
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
            },
        },
        codeGeneration = {
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
        },
    },

    init_options = {
        bundles = {},
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
    },

    on_attach = function(client, bufnr)
        -- Java specific keybindings
        local opts = { noremap = true, silent = true, buffer = bufnr }
        
        vim.keymap.set('n', '<leader>oi', jdtls.organize_imports, vim.tbl_extend('force', opts, { desc = 'Organize Imports' }))
        vim.keymap.set('n', '<leader>ev', jdtls.extract_variable, vim.tbl_extend('force', opts, { desc = 'Extract Variable' }))
        vim.keymap.set('v', '<leader>ev', [[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]], vim.tbl_extend('force', opts, { desc = 'Extract Variable' }))
        vim.keymap.set('n', '<leader>ec', jdtls.extract_constant, vim.tbl_extend('force', opts, { desc = 'Extract Constant' }))
        vim.keymap.set('v', '<leader>em', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], vim.tbl_extend('force', opts, { desc = 'Extract Method' }))
        
        -- Standard LSP keymaps are handled by your LspAttach autocmd in lsp.lua
        -- No need to duplicate them here
    end,
}

-- Start or attach to jdtls
jdtls.start_or_attach(config)
