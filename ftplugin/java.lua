local jdtls = require('jdtls')

-- Determine OS
local home = os.getenv('USERPROFILE') or os.getenv('HOME')
local workspace_dir = home .. '/.local/share/nvim/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- Find mason installation path - FIXED METHOD
local jdtls_install = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

-- Check if jdtls is installed
if vim.fn.isdirectory(jdtls_install) == 0 then
    vim.notify('JDTLS not found. Please install it via :Mason', vim.log.levels.ERROR)
    return
end

-- Find the launcher jar
local launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')
if launcher_jar == '' then
    vim.notify('JDTLS launcher jar not found', vim.log.levels.ERROR)
    return
end

-- JDTLS configuration

local lombok_path = home .. '/.m2/repository/org/projectlombok/lombok/1.18.34/lombok-1.18.34.jar'

local config = {
    cmd = {
        'java',
        '-javaagent:' .. lombok_path,
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
        '-configuration', jdtls_install .. '/config_win',
        '-data', workspace_dir,
    },

    root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),

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
        bundles = {}
    },

    on_attach = function(client, bufnr)
        -- Keybindings for Java
        local opts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)

        -- Java specific keybindings
        vim.keymap.set('n', '<leader>oi', jdtls.organize_imports, opts)
        vim.keymap.set('n', '<leader>ev', jdtls.extract_variable, opts)
        vim.keymap.set('v', '<leader>ev', [[<ESC><CMD>lua require('jdtls').extract_variable(true)<CR>]], opts)
        vim.keymap.set('n', '<leader>ec', jdtls.extract_constant, opts)
        vim.keymap.set('v', '<leader>em', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
    end,
}

jdtls.start_or_attach(config)
