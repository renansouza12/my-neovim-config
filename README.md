# Neovim Configuration for Windows

A modern Neovim setup optimized for web development (Angular, TypeScript, JavaScript) and Java development on Windows. This configuration uses Lazy.nvim as the plugin manager and includes LSP support, fuzzy finding, Git integration, and a beautiful UI.

> **Note:** This configuration was initially inspired by [this YouTube tutorial](https://www.youtube.com/watch?v=KYDG3AHgYEs) but has been heavily customized and adapted for Windows environments.

## Screenshots

<!-- Add your screenshots here -->

**Dashboard:**

![Dashboard](https://i.imgur.com/ag7yNfY.png)

**Coding View:**

![Coding](https://i.imgur.com/PIgUZf0.png)

**Telescope Fuzzy Finder:**

![Telescope](https://i.imgur.com/v63tpbO.png)

---

## Features

- 🚀 **Fast startup** with lazy loading via Lazy.nvim
- 🎨 **Beautiful UI** with Kanagawa color scheme
- 🔍 **Fuzzy finding** with Telescope
- 📝 **LSP support** for TypeScript, JavaScript, Angular, HTML, CSS, Lua, and Java
- ✨ **Auto-completion** with nvim-cmp
- 🌳 **File explorer** with Neo-tree
- 📊 **Git integration** with Gitsigns
- 💻 **Integrated terminal** with ToggleTerm
- 🎯 **Syntax highlighting** with Treesitter
- ⚡ **Optimized for Angular projects** with smart ignore patterns

---

## Requirements

### Essential
- **Neovim** >= 0.9.0
- **Git**
- **Node.js** (for LSP servers)
- **Java JDK** (if using Java development features)

### Optional (but recommended)
- **ripgrep** - For faster grep searches in Telescope
- **fd** - For faster file finding in Telescope
- A **Nerd Font** - For proper icon display (I recommend [JetBrains Mono Nerd Font](https://www.nerdfonts.com/))

---

## Installation

### 1. Backup your existing configuration (if any)

```powershell
# Windows PowerShell
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.backup
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.backup
```

### 2. Clone this repository

```powershell
git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME $env:LOCALAPPDATA\nvim
```

### 3. Start Neovim

```powershell
nvim
```

Lazy.nvim will automatically install all plugins on first launch. This may take a few minutes.

### 4. Install LSP servers

Once Neovim opens, Mason will automatically install the configured LSP servers:
- ts_ls (TypeScript/JavaScript)
- angularls (Angular)
- html
- cssls
- emmet_ls
- lua_ls

You can also manually manage servers with:
```vim
:Mason
```

---

## Windows-Specific Notes

### Known Issue: C Compiler Warning

When first launching Neovim, you may see repeated warnings:
```
No C compiler found! "cc", "gcc", "clang", "cl", "zig" are not executable
```

**This is safe to ignore.** Just press any key to continue. The warning appears because `telescope-fzf-native` requires a C compiler to build, but Telescope will work fine without it (just slightly slower).

**To fix this warning (optional):**

1. Install a C compiler:
   - **Option A:** Install [Visual Studio Build Tools](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022)
   - **Option B:** Install [mingw-w64](https://www.mingw-w64.org/)
   - **Option C:** Install [zig](https://ziglang.org/download/)

2. Or disable the fzf-native extension by modifying `plugins/telescope.lua`:
   ```lua
   -- Comment out or remove this line in telescope.lua
   -- pcall(require('telescope').load_extension, 'fzf')
   ```

### PowerShell Configuration

For the integrated terminal to work properly, make sure PowerShell is available in your PATH.

---

## Plugin List

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configuration |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/DAP/Linter installer |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Auto-completion |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | Color scheme |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | Buffer tabs |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git integration |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) | Terminal integration |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Indentation guides |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Dashboard |
| [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls) | Java LSP support |

---

## Key Mappings

Leader key is `<Space>`

### General

| Key | Mode | Action |
|-----|------|--------|
| `<C-s>` | Normal | Save file |
| `<leader>fs` | Normal | Force save file |
| `<C-q>` | Normal | Quit file |
| `<leader>ca` | Normal | Code action |

### File Navigation (Telescope)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>sf` | Normal | Search files |
| `<leader>sg` | Normal | Live grep (search text) |
| `<leader>sw` | Normal | Search current word |
| `<leader>sb` | Normal | Search buffers |
| `<leader><leader>` | Normal | Find existing buffers |
| `<leader>/` | Normal | Search in current buffer |
| `<leader>sh` | Normal | Search help |
| `<leader>sk` | Normal | Search keymaps |
| `<leader>sd` | Normal | Search diagnostics |

### LSP

| Key | Mode | Action |
|-----|------|--------|
| `gd` | Normal | Go to definition |
| `gr` | Normal | Go to references |
| `gI` | Normal | Go to implementation |
| `gD` | Normal | Go to declaration |
| `K` | Normal | Hover documentation |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal/Visual | Code action |
| `<leader>D` | Normal | Type definition |
| `[d` | Normal | Previous diagnostic |
| `]d` | Normal | Next diagnostic |
| `<leader>d` | Normal | Open diagnostic float |

### Buffer Management

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | Normal | Next buffer |
| `<S-Tab>` | Normal | Previous buffer |
| `<leader>x` | Normal | Close buffer |
| `<leader>b` | Normal | New buffer |

### Window Management

| Key | Mode | Action |
|-----|------|--------|
| `<leader>v` | Normal | Split vertically |
| `<leader>h` | Normal | Split horizontally |
| `<leader>se` | Normal | Make splits equal |
| `<leader>xs` | Normal | Close split |
| `<C-h/j/k/l>` | Normal | Navigate splits |
| `<Up/Down/Left/Right>` | Normal | Resize splits |

### Tab Management

| Key | Mode | Action |
|-----|------|--------|
| `<leader>to` | Normal | Open new tab |
| `<leader>tx` | Normal | Close tab |
| `<leader>tn` | Normal | Next tab |
| `<leader>tp` | Normal | Previous tab |

### Visual Mode

| Key | Mode | Action |
|-----|------|--------|
| `<` | Visual | Indent left (stay in indent mode) |
| `>` | Visual | Indent right (stay in indent mode) |
| `p` | Visual | Paste without yanking |

### Other

| Key | Mode | Action |
|-----|------|--------|
| `<leader>lw` | Normal | Toggle line wrap |
| `<C-d>` | Normal | Scroll down and center |
| `<C-u>` | Normal | Scroll up and center |
| `n/N` | Normal | Next/prev search and center |

---

## File Structure

```
nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── core/
│   │   ├── options.lua     # Neovim settings
│   │   └── keymaps.lua     # Key mappings
│   └── plugins/
│       ├── mason.lua
│       ├── jdtls.lua
│       ├── treesitter.lua
│       ├── colortheme.lua
│       ├── neotree.lua
│       ├── bufferline.lua
│       ├── lualine.lua
│       ├── telescope.lua
│       ├── lsp.lua
│       ├── autocompletion.lua
│       ├── gitsigns.lua
│       ├── alpha.lua
│       ├── indent-blankline.lua
│       ├── toggleterm.lua
│       ├── autopairs.lua
│       └── devicons.lua
```

---

## Customization

### Change Color Scheme

Edit `lua/plugins/colortheme.lua`. The current theme is Kanagawa. You can switch to other variants:
- `kanagawa-wave` (default)
- `kanagawa-dragon`
- `kanagawa-lotus`

Or replace with a different theme entirely.

### Add/Remove LSP Servers

Edit `lua/plugins/lsp.lua` and modify the `ensure_installed` table:

```lua
ensure_installed = {
    "ts_ls",
    "html",
    "cssls",
    -- Add your servers here
}
```

### Modify Keybindings

Edit `lua/core/keymaps.lua` to add or change key mappings.

### Adjust Neovim Settings

Edit `lua/core/options.lua` to change editor behavior (line numbers, indentation, etc.).

---

## Troubleshooting

### Plugins not loading
```vim
:Lazy sync
```

### LSP not working
```vim
:LspInfo
:Mason
```

### Treesitter errors
```vim
:TSUpdate
```

### Clear cache and reinstall
```powershell
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data
nvim
```

---

## Performance Tips for Large Projects (Angular)

This configuration includes optimizations for Angular projects:
- Smart ignore patterns for `node_modules`, `dist`, `.angular` cache
- Limited search results (1000 max)
- Optimized file sorters
- Preview file size limits

For even better performance on large projects, consider installing `fd` and `ripgrep`.

---

## Contributing

Feel free to fork this repository and customize it to your needs! If you find bugs or have suggestions, please open an issue.

---

## Credits

- Initial configuration inspired by [typecraft's Neovim tutorial](https://www.youtube.com/watch?v=KYDG3AHgYEs)
- Heavy modifications and Windows adaptations by me

---

## License

MIT License - Feel free to use and modify as you wish!
