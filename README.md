<div align="center">

# ⚡ Neovim Config

A fast, modern, and fully-featured Neovim setup — LSP, autocompletion, AI assistance, fuzzy finding, and a polished UI, all managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

[![Neovim](https://img.shields.io/badge/Neovim-%E2%89%A5%200.9-57A143?style=flat-square&logo=neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Made%20with-Lua-2C2D72?style=flat-square&logo=lua&logoColor=white)](https://www.lua.org)
</div>

---

## ✨ Features

- 🧠 **LSP & Completion** — `nvim-lspconfig` + `mason` for painless server management, `nvim-cmp` with LuaSnip snippets and lspkind icons
- 🤖 **AI Assistance** — [Avante](https://github.com/yetone/avante.nvim) (Ollama provider) and [Supermaven](https://github.com/supermaven-inc/supermaven-nvim) inline suggestions
- 🔍 **Navigation** — Telescope + fzf-lua fuzzy finding, Harpoon quick marks, Flash motions, Oil as a file explorer
- 🎨 **UI** — Tokyo Night (plus Catppuccin, Gruvbox, Ayu), bubbles-style lualine, Noice command line, Alpha dashboard, smooth cursor animations with smear-cursor
- 🌳 **Treesitter** — modern syntax highlighting and indentation
- 🔧 **Git** — Gitsigns hints in the gutter + LazyGit integration
- 🧹 **Quality of life** — which-key hints, Trouble diagnostics, todo-comments, mini.nvim modules (pairs, surround, indentscope, cursorword)

## 📋 Requirements

| Dependency | Notes |
|---|---|
| **Neovim** ≥ 0.9.0 | ≥ 0.10 recommended |
| **Git** ≥ 2.19.0 | plugin management |
| A [Nerd Font](https://www.nerdfonts.com/) | icons in UI and statusline |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | live grep (Telescope) |
| [fd](https://github.com/sharkdp/fd) | find files (Telescope) |
| [Node.js](https://nodejs.org/en/download) ≥ 22 (LTS) | LSP servers (managed via **fnm** recommended) |
| [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/) ≥ 1.22 | markdown-preview build |
| Build tools | Ubuntu/Debian: `sudo apt install build-essential` |

> Unix-based OS assumed (Linux / macOS).

## 🚀 Installation

Back up any existing configuration, then clone:

```bash
# Backup (optional but recommended)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone
git clone https://github.com/santtiag/nvim.git ~/.config/nvim

# Launch — lazy.nvim bootstraps and installs everything on first run
nvim
```

On first launch, plugins install automatically. Run `:checkhealth` afterwards to verify everything is in place, and `:Mason` to install additional language servers.

## 📁 Structure

```
~/.config/nvim
├── init.lua                       # Entry point
├── lazy-lock.json                 # Plugin versions lockfile
└── lua/core/
    ├── keymaps.lua                # Global key mappings
    ├── plugins.lua                # Plugin declarations (lazy.nvim)
    └── plugin_config/             # One config file per plugin
        ├── init.lua               # Loads every plugin config
        ├── lsp_config.lua         # LSP servers & capabilities
        ├── completions.lua        # nvim-cmp + snippets
        ├── avante.lua             # AI assistant (Ollama)
        ├── lualine.lua            # Statusline (bubbles style)
        ├── which-key.lua          # Keybinding hints
        ├── themes/                # Colorschemes
        │   ├── tokyo-night.lua
        │   ├── catppuccin.lua
        │   ├── gruvbox.lua
        │   └── ayu.lua
        └── ...                    # oil, noice, treesitter, gitsigns, etc.
```

## ⚙️ Configuration

Each plugin lives in its own file under `lua/core/plugin_config/`, so tweaking is straightforward:

- **Add a plugin** → declare it in `lua/core/plugins.lua`, create its config in `plugin_config/`, and require it from `plugin_config/init.lua`
- **Change the colorscheme** → edit `plugin_config/colorscheme.lua` (themes configured under `plugin_config/themes/`)
- **Keymaps** → global ones in `lua/core/keymaps.lua`; plugin-specific ones live next to each plugin's config
- **AI provider** → Avante is set up for a local Ollama instance in `plugin_config/avante.lua`; swap the provider/model there
