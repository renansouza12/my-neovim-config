return {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
        local jdtls = require("jdtls")

        local home = os.getenv("USERPROFILE") or os.getenv("HOME")
        local workspace_dir = home .. "\\.local\\share\\eclipse\\" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

        -- Mason jdtls install paths
        local mason_path = home .. "\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls"
        local launcher_jar = vim.fn.glob(mason_path .. "\\plugins\\org.eclipse.equinox.launcher_*.jar")
        local config_win = mason_path .. "\\config_win"

        -- Optional: Java debug/test extensions (for Spring Boot)
        local bundles = {}
        vim.list_extend(bundles,
        vim.split(vim.fn.glob(home .. "\\AppData\\Local\\nvim-data\\mason\\packages\\java-debug-adapter\\extension\\server\\com.microsoft.java.debug.plugin-*.jar"), "\n")
    )
    vim.list_extend(bundles,
    vim.split(vim.fn.glob(home .. "\\AppData\\Local\\nvim-data\\mason\\packages\\java-test\\extension\\server\\*.jar"), "\n")
)

local config = {
    cmd = {
        "C:/Program Files/Java/jdk-25/bin/java.exe",
         "-javaagent:" .. mason_path .. "\\lombok.jar",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-jar", launcher_jar,
        "-configuration", config_win,
        "-data", workspace_dir,
    },

    root_dir = require("jdtls.setup").find_root({ "gradlew", "mvnw", "pom.xml", ".git" }),

    settings = {
        java = {
            home = "C:/Program Files/Java/jdk-25",
            configuration = {
                updateBuildConfiguration = "automatic", -- 🔥 keep classpath synced
            },
            maven = { downloadSources = true },
            import = {
                gradle = { enabled = true },
                maven = { enabled = true },
            },
            eclipse = { downloadSources = true },
            signatureHelp = { enabled = true },
            completion = {
                favoriteStaticMembers = {},
                importOrder = { "java", "javax", "com", "org" },
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            codeGeneration = {
                toString = { template = "${object.className}{${member.name()}=${member.value()}}" },
            },
            referencesCodeLens = { enabled = true },
            implementationsCodeLens = { enabled = true },
        },
    },

    init_options = {
        bundles = bundles,
    },
}

jdtls.start_or_attach(config)
  end,
}

