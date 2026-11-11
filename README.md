<div align="center">

# ⚡ Neovim Config

A fast, modern Neovim setup — LSP, completion, fuzzy finding, and a polished UI, managed with [lazy.nvim](https://github.com/folke/lazy.nvim). The repo also holds the Ghostty, Herdr, and Starship configs.

[![Neovim](https://img.shields.io/badge/Neovim-%E2%89%A5%200.11-57A143?style=flat-square&logo=neovim&logoColor=white)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Made%20with-Lua-2C2D72?style=flat-square&logo=lua&logoColor=white)](https://www.lua.org)
</div>

---

## ✨ Features

- 🧠 **LSP & Completion** — native `vim.lsp.config` + `mason`, `blink.cmp`, inline diagnostics, code actions with preview
- 🧹 **Formatting** — `conform` with ruff (Python) and prettier (web, JSON, YAML, Markdown), falling back to the LSP
- 🔍 **Navigation** — fff for files and grep, Telescope for the rest, Flash motions, Yazi as a file explorer
- 🎨 **UI** — 19 switchable theme families (Kanagawa by default), Heirline statusline, Alpha dashboard, Noice command palette, Dropbar breadcrumbs, Incline, Satellite scrollbar, cursor and yank animations
- 🔧 **Git** — Gitsigns, LazyGit, CodeDiff for VS Code style reviews
- 💾 **Sessions** — per-directory sessions with Persisted, restored from the dashboard
- 🐍 **Python** — virtual environment switching with venv-selector
- 📝 **Markdown** — in-buffer rendering and live browser preview
- 🥋 **Habits** — Hardtime hints for better motions

## 📋 Requirements

`./install.sh` installs all of this on macOS (Homebrew), Ubuntu/Debian, Fedora, and Arch.

| Dependency | Notes |
|---|---|
| **Neovim** ≥ 0.11 | `vim.lsp.config` |
| **Git**, `curl`, C toolchain | plugins and native binaries |
| A [Nerd Font](https://www.nerdfonts.com/) | Iosevka Nerd Font is the default |
| [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd) | search and venv discovery |
| [Node.js](https://nodejs.org/en/download) and npm | LSP servers and prettier |
| Python 3 with `venv` | ruff, installed through Mason |
| [LazyGit](https://github.com/jesseduffield/lazygit), [Yazi](https://github.com/sxyazi/yazi) | Git UI and file explorer |

> Unix-based OS assumed (Linux / macOS).

## 🚀 Installation

```bash
# Backup (optional but recommended)
mv ~/.config/nvim ~/.config/nvim.bak

git clone https://github.com/santtiag/nvim.git ~/.config/nvim
~/.config/nvim/install.sh
```

The script installs dependencies, links the terminal configs, and installs plugins and formatters. Run `:checkhealth` afterwards to verify everything is in place.

## 📁 Structure

```
~/.config/nvim
├── init.lua                       # Entry point
├── install.sh                     # Bootstrap for a new machine
├── lazy-lock.json                 # Plugin versions lockfile
├── ghostty/                       # Linked as ~/.config/ghostty
├── herdr/config.toml              # Linked into ~/.config/herdr
├── starship.toml                  # Linked into ~/.config
└── lua/core/
    ├── keymaps.lua                # Options and global key mappings
    ├── plugins.lua                # Plugin declarations (lazy.nvim)
    └── plugin_config/             # Per-plugin config
        ├── alpha.lua              # Dashboard
        ├── lsp_config.lua         # LSP servers and diagnostics
        ├── completions.lua        # blink.cmp
        ├── which-key.lua          # Most key mappings
        ├── themes/                # Colorscheme options
        └── ...
```

## ⚙️ Configuration

- **Add a plugin** → declare it in `lua/core/plugins.lua`, with `opts` inline or `config = use('name')` pointing to a file in `plugin_config/`
- **Change the colorscheme** → `<leader>ft` previews and picks a theme; the choice is remembered and only that theme loads at startup
- **Keymaps** → global ones in `lua/core/keymaps.lua`, plugin ones in `plugin_config/which-key.lua`
- **Ghostty theme** → Noctalia regenerates `ghostty/themes/noctalia`, which is gitignored; `noctalia.default` is the tracked copy for machines without Noctalia
