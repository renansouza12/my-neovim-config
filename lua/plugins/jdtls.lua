return {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
        local jdtls = require("jdtls")

        local home = os.getenv("USERPROFILE") or os.getenv("HOME")
        local workspace_dir = home .. "\\.local\\share\\eclipse\\" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

        local config = {
            cmd = {
                "C:/Program Files/Java/jdk-25/bin/java.exe",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xms1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                "-jar", vim.fn.glob(home .. "\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\plugins\\org.eclipse.equinox.launcher_*.jar"),
                "-configuration", home .. "\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\config_win",
                "-data", workspace_dir,
            },

            root_dir = require("jdtls.setup").find_root({ "gradlew", "mvnw", ".git" }),

            settings = {
                java = {
                    configuration = {
                        updateBuildConfiguration = "interactive",
                    },
                    completion = {
                        favoriteStaticMembers = {},
                    },
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                },
            },
        }

        jdtls.start_or_attach(config)
    end,
}

