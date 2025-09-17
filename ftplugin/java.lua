local home = os.getenv("USERPROFILE") or os.getenv("HOME")
local jdtls = require("jdtls")

-- Project root detection
local root_markers = { "gradlew", "mvnw", "pom.xml", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)

if root_dir == nil then
    return
end

-- Workspace directory (separate per project)
local workspace_dir = home .. "/.jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Config for jdtls
local config = {
    cmd = {
        "jdtls",
        "-data", workspace_dir,
    },
    root_dir = root_dir,
    settings = {
        java = {},
    },
    init_options = {
        bundles = {},
    },
}

-- Start or attach jdtls
jdtls.start_or_attach(config)

