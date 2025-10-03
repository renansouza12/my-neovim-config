local home = os.getenv("USERPROFILE") or os.getenv("HOME")
local jdtls = require("jdtls")

-- Project root detection
local root_markers = { "gradlew", "mvnw", "pom.xml", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)

if root_dir == nil then
    return
end

-- Workspace directory (unique per project)
local workspace_dir = home .. "/.jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
workspace_dir = workspace_dir:gsub("\\", "/") -- fix paths on Windows

-- Reuse LSP capabilities from cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Config for jdtls
local config = {
    cmd = { "jdtls", "-data", workspace_dir },
    root_dir = root_dir,
    capabilities = capabilities,
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" }, -- decompiler
        },
    },
    init_options = {
        bundles = {}, -- later we can add debug/test bundles
    },
}

-- Start or attach jdtls
jdtls.start_or_attach(config)

