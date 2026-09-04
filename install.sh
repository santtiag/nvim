#!/usr/bin/env bash
# Bootstrap Neovim deps, Herdr, Starship, Ghostty, and this repo's configs.
# macOS (Homebrew), Ubuntu/Debian, Fedora, Arch. Safe to rerun.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="${HERDR_INSTALL_DIR:-$HOME/.local/bin}"
PATH="$LOCAL_BIN:$HOME/.cargo/bin:$PATH"
export PATH
PM=""
APT_UPDATED=0

if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  # shellcheck disable=SC1091
  . "$HOME/.nvm/nvm.sh"
fi

ok()   { printf ' \033[32m>\033[0m %s\n' "$*"; }
warn() { printf ' \033[33m!\033[0m %s\n' "$*"; }
err()  { printf ' \033[31m✗\033[0m %s\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

need() {
  local cmd
  for cmd in "$@"; do
    have "$cmd" || { err "need '$cmd'"; exit 1; }
  done
}

ensure_path() {
  mkdir -p "$LOCAL_BIN"
  case ":$PATH:" in
    *":$LOCAL_BIN:"*) ;;
    *) export PATH="$LOCAL_BIN:$PATH" ;;
  esac
}

append_once() {
  local file="$1" needle="$2" line="$3"
  [[ -f "$file" ]] || touch "$file"
  grep -Fq "$needle" "$file" && return 0
  printf '\n%s\n' "$line" >>"$file"
  ok "appended to $file"
}

link_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    ok "already linked $(basename "$dest")"
    return 0
  elif [[ -e "$dest" ]]; then
    if cmp -s "$src" "$dest"; then
      rm -f "$dest"
    else
      local bak="${dest}.bak.$(date +%Y%m%d%H%M%S)"
      mv "$dest" "$bak"
      warn "backed up $dest -> $bak"
    fi
  fi
  ln -sfn "$src" "$dest"
  ok "linked $dest"
}

detect_pm() {
  case "$(uname -s)" in
    Darwin)
      have brew || { err "install Homebrew first: https://brew.sh"; exit 1; }
      PM=brew
      ;;
    Linux)
      # shellcheck disable=SC1091
      [[ -f /etc/os-release ]] && . /etc/os-release
      local id="${ID:-} ${ID_LIKE:-}"
      case "$id" in
        *arch*|*manjaro*|*endeavouros*|*artix*|*garuda*) PM=pacman ;;
        *fedora*|*rhel*|*centos*) PM=dnf ;;
        *debian*|*ubuntu*|*pop*|*mint*|*elementary*) PM=apt ;;
        *)
          have pacman && PM=pacman
          have dnf && PM=dnf
          have apt-get && PM=apt
          ;;
      esac
      [[ -n "$PM" ]] || { err "unsupported distro (need apt, dnf, or pacman)"; exit 1; }
      ;;
    *) err "unsupported OS: $(uname -s)"; exit 1 ;;
  esac
  ok "package manager: $PM"
}

pkg_install() {
  [[ $# -gt 0 ]] || return 0
  case "$PM" in
    brew) brew install "$@" ;;
    dnf) sudo dnf install -y "$@" ;;
    pacman) sudo pacman -S --needed --noconfirm "$@" ;;
    apt)
      if [[ "$APT_UPDATED" -eq 0 ]]; then
        sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
        APT_UPDATED=1
      fi
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
      ;;
  esac
}

# Install distro packages only for commands that are missing.
ensure_cmd() {
  local cmd="$1"
  shift
  if have "$cmd"; then
    ok "$cmd already installed"
    return 0
  fi
  ok "installing $cmd"
  pkg_install "$@"
  have "$cmd" || warn "installed packages but '$cmd' is still not on PATH"
}

host_triple() {
  local os arch
  case "$(uname -s)" in
    Linux) os=linux ;;
    Darwin) os=macos ;;
    *) echo ""; return 1 ;;
  esac
  case "$(uname -m)" in
    x86_64|amd64) arch=x86_64 ;;
    aarch64|arm64) arch=aarch64 ;;
    *) echo ""; return 1 ;;
  esac
  echo "${os}-${arch}"
}

nvim_ge() {
  have nvim || return 1
  local ver maj min
  ver="$(nvim --version | awk 'NR==1 { print $2 }')"
  ver="${ver#v}"
  maj="${ver%%.*}"
  min="${ver#*.}"; min="${min%%.*}"
  [[ "$maj" =~ ^[0-9]+$ && "$min" =~ ^[0-9]+$ ]] || return 1
  (( maj > 0 || min >= 11 ))
}

install_nvim_release() {
  local triple url tmp
  triple="$(host_triple)" || { err "no Neovim binary for this CPU"; return 1; }
  case "$triple" in
    linux-x86_64) url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" ;;
    linux-aarch64) url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz" ;;
    macos-x86_64) url="https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz" ;;
    macos-aarch64) url="https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz" ;;
    *) err "no Neovim tarball for $triple"; return 1 ;;
  esac
  ok "installing Neovim from GitHub (need >= 0.11 for this config)"
  tmp="$(mktemp -d)"
  curl -fsSL "$url" | tar xz -C "$tmp"
  rm -rf "$HOME/.local/opt/nvim"
  mkdir -p "$HOME/.local/opt"
  mv "$tmp"/nvim-* "$HOME/.local/opt/nvim"
  ln -sfn "$HOME/.local/opt/nvim/bin/nvim" "$LOCAL_BIN/nvim"
  rm -rf "$tmp"
}

install_lazygit_release() {
  have lazygit && return 0
  local ver arch asset tmp
  ver="$(curl -fsSL https://api.github.com/repos/jessedavis/lazygit/releases/latest \
    | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p' | head -1)"
  [[ -n "$ver" ]] || { warn "could not resolve lazygit version"; return 1; }
  case "$(uname -s)-$(uname -m)" in
    Linux-x86_64|Linux-amd64) arch=Linux_x86_64 ;;
    Linux-aarch64|Linux-arm64) arch=Linux_arm64 ;;
    Darwin-x86_64) arch=Darwin_x86_64 ;;
    Darwin-arm64) arch=Darwin_arm64 ;;
    *) warn "no lazygit asset for this CPU"; return 1 ;;
  esac
  asset="lazygit_${ver}_${arch}.tar.gz"
  ok "installing lazygit $ver"
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/jessedavis/lazygit/releases/download/v${ver}/${asset}" \
    | tar xz -C "$tmp" lazygit
  install -m 755 "$tmp/lazygit" "$LOCAL_BIN/lazygit"
  rm -rf "$tmp"
}

install_yazi_release() {
  have yazi && return 0
  local triple tmp name
  case "$(uname -s)-$(uname -m)" in
    Linux-x86_64|Linux-amd64) name=yazi-x86_64-unknown-linux-gnu ;;
    Linux-aarch64|Linux-arm64) name=yazi-aarch64-unknown-linux-gnu ;;
    Darwin-x86_64) name=yazi-x86_64-apple-darwin ;;
    Darwin-arm64) name=yazi-aarch64-apple-darwin ;;
    *) warn "no yazi asset for this CPU"; return 1 ;;
  esac
  ok "installing yazi"
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/sxyazi/yazi/releases/latest/download/${name}.zip" -o "$tmp/yazi.zip"
  need unzip
  unzip -qo "$tmp/yazi.zip" -d "$tmp"
  install -m 755 "$tmp/$name/yazi" "$LOCAL_BIN/yazi"
  [[ -f "$tmp/$name/ya" ]] && install -m 755 "$tmp/$name/ya" "$LOCAL_BIN/ya"
  rm -rf "$tmp"
}

ensure_fd() {
  if have fd; then
    ok "fd already installed"
    return 0
  fi
  if have fdfind; then
    ln -sfn "$(command -v fdfind)" "$LOCAL_BIN/fd"
    ok "linked fdfind -> $LOCAL_BIN/fd"
    return 0
  fi
  case "$PM" in
    brew|pacman) pkg_install fd ;;
    dnf|apt) pkg_install fd-find ;;
  esac
  if have fdfind && ! have fd; then
    ln -sfn "$(command -v fdfind)" "$LOCAL_BIN/fd"
  fi
  have fd || warn "fd not on PATH (Ubuntu package is fd-find)"
}

ensure_yarn() {
  have yarn && { ok "yarn already installed"; return 0; }
  if have corepack; then
    corepack enable >/dev/null 2>&1 || true
    corepack prepare yarn@stable --activate >/dev/null 2>&1 || true
  fi
  have yarn && { ok "yarn via corepack"; return 0; }
  if have npm; then
    npm install -g yarn
  else
    warn "yarn missing — markdown-preview needs it (install Node first)"
  fi
}

ensure_iosevka() {
  if have fc-list && grep -qi iosevka <<<"$(fc-list)"; then
    ok "Iosevka font present"
    return 0
  fi
  case "$PM" in
    brew)
      brew install --cask font-iosevka-nerd-font
      return 0
      ;;
    pacman)
      pkg_install ttf-iosevka-nerd
      return 0
      ;;
  esac
  local zip dest
  dest="$HOME/.local/share/fonts/IosevkaNerd"
  mkdir -p "$dest"
  zip="$(mktemp)"
  ok "installing Iosevka Nerd Font"
  if curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Iosevka.zip" -o "$zip"; then
    unzip -qo "$zip" -d "$dest"
    have fc-cache && fc-cache -f "$HOME/.local/share/fonts" >/dev/null
  else
    warn "could not download Iosevka Nerd Font — install one from https://www.nerdfonts.com"
  fi
  rm -f "$zip"
}

install_unix_deps() {
  ensure_cmd git git
  ensure_cmd curl curl
  ensure_cmd wget wget
  ensure_cmd unzip unzip
  ensure_cmd tar tar

  if have gcc && have make; then
    ok "C toolchain already installed"
  else
    case "$PM" in
      brew) pkg_install gcc make ;;
      dnf) pkg_install gcc gcc-c++ make ;;
      pacman) pkg_install base-devel ;;
      apt) pkg_install build-essential ;;
    esac
  fi

  if nvim_ge; then
    ok "neovim already installed ($(nvim --version | head -1))"
  else
    ensure_cmd nvim neovim
    nvim_ge || install_nvim_release
    nvim_ge || { err "Neovim >= 0.11 is required (vim.lsp.config)"; exit 1; }
  fi

  ensure_cmd rg ripgrep
  ensure_fd
  ensure_cmd fzf fzf
  case "$PM" in
    brew) ensure_cmd node node ;;
    *) ensure_cmd node nodejs ;;
  esac
  if ! have npm; then
    case "$PM" in
      brew) pkg_install node ;;
      *) pkg_install npm ;;
    esac
  else
    ok "npm already installed"
  fi
  ensure_yarn

  if have lazygit; then
    ok "lazygit already installed"
  else
    pkg_install lazygit || true
    have lazygit || install_lazygit_release
  fi

  if have yazi; then
    ok "yazi already installed"
  else
    pkg_install yazi || true
    have yazi || install_yazi_release
  fi
  if have yazi && ! have ya; then
    warn "yazi is installed but 'ya' is not on PATH (yazi.nvim needs it)"
  fi

  if [[ "$(uname -s)" == Linux ]]; then
    have wl-copy || have xclip || have xsel || pkg_install wl-clipboard xclip || true
  fi
}

install_herdr() {
  if have herdr; then
    ok "herdr already installed ($(herdr --version 2>/dev/null | head -1))"
    return 0
  fi
  need curl
  ok "installing herdr"
  curl -fsSL https://herdr.dev/install.sh | sh
}

install_starship() {
  if have starship; then
    ok "starship already installed ($(starship --version | head -1))"
    return 0
  fi
  need curl
  ok "installing starship"
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$LOCAL_BIN"
}

install_ghostty() {
  if have ghostty; then
    ok "ghostty already installed ($(ghostty --version 2>/dev/null | head -1))"
    return 0
  fi
  case "$PM" in
    brew)
      ok "installing ghostty via Homebrew"
      brew install --cask ghostty
      ;;
    pacman)
      ok "installing ghostty via pacman"
      pkg_install ghostty
      ;;
    dnf)
      ok "installing ghostty via Fedora COPR"
      sudo dnf copr enable -y scottames/ghostty
      sudo dnf install -y ghostty
      ;;
    apt)
      ok "installing ghostty (Ubuntu/Debian community package)"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
      ;;
    *)
      err "install Ghostty from https://ghostty.org/docs/install/binary"
      return 1
      ;;
  esac
}

link_configs() {
  link_file "$ROOT/herdr/config.toml" "$HOME/.config/herdr/config.toml"
  link_file "$ROOT/ghostty/config" "$HOME/.config/ghostty/config"
  link_file "$ROOT/ghostty/shaders/cursor_smear.glsl" \
    "$HOME/.config/ghostty/shaders/cursor_smear.glsl"
  link_file "$ROOT/starship.toml" "$HOME/.config/starship.toml"
}

setup_shell() {
  local rc init
  case "${SHELL:-}" in
    *zsh*)  rc="$HOME/.zshrc";  init='eval "$(starship init zsh)"' ;;
    *bash*) rc="$HOME/.bashrc"; init='eval "$(starship init bash)"' ;;
    *)
      [[ -f "$HOME/.zshrc" ]] || return 0
      rc="$HOME/.zshrc"
      init='eval "$(starship init zsh)"'
      ;;
  esac
  append_once "$rc" '.local/bin' "export PATH=\"\$HOME/.local/bin:\$PATH\""
  append_once "$rc" 'starship init' "$init"
}

# Teaches any coding agent how to split Herdr panes and start sibling agents.
# Uses the copy bundled with the installed binary (herdr --skill), not a git clone.
install_herdr_skill() {
  have herdr || { err "herdr missing; skip skill"; return 1; }

  local skill_dir="$HOME/.agents/skills/herdr"
  mkdir -p "$skill_dir"
  herdr --skill >"$skill_dir/SKILL.md"
  ok "wrote bundled herdr skill"

  local dest
  for dest in \
    "$HOME/.claude/skills" \
    "$HOME/.cursor/skills" \
    "$HOME/.codex/skills" \
    "$HOME/.grok/skills" \
    "$HOME/.config/opencode/skills" \
    "$HOME/.copilot/skills"; do
    mkdir -p "$dest"
    ln -sfn "$skill_dir" "$dest/herdr"
  done
  ok "linked herdr skill into agent dirs"

  have npx || return 0
  local tmp
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/herdr"
  cp "$skill_dir/SKILL.md" "$tmp/herdr/SKILL.md"
  npx --yes skills add "$tmp" --skill herdr -g --agent '*' -y \
    || warn "npx skills add failed; common agents already have the skill"
  rm -rf "$tmp"
}

# Session restore / lifecycle hooks. Needs the agent config dir AND the binary.
install_integration() {
  local name="$1" dir="$2"
  shift 2
  [[ -d "$dir" ]] || return 0
  local bin found=0
  for bin in "$@"; do
    if have "$bin"; then
      found=1
      break
    fi
  done
  [[ "$found" -eq 1 ]] || return 0
  if herdr integration install "$name"; then
    ok "herdr integration: $name"
  else
    warn "herdr integration failed: $name"
  fi
}

install_herdr_integrations() {
  have herdr || return 0
  install_integration cursor "$HOME/.cursor" cursor-agent agent
  install_integration claude "$HOME/.claude" claude
  install_integration opencode "$HOME/.config/opencode" opencode
  install_integration grok "$HOME/.grok" grok
  install_integration codex "$HOME/.codex" codex
  install_integration copilot "$HOME/.copilot" copilot
  install_integration devin "$HOME/.config/devin" devin
  install_integration droid "$HOME/.factory" droid
  install_integration kimi "$HOME/.kimi-code" kimi
  install_integration kilo "$HOME/.config/kilo" kilo
  install_integration hermes "$HOME/.hermes" hermes
  install_integration qodercli "$HOME/.qoder" qodercli
  install_integration qwen "$HOME/.qwen" qwen
  install_integration pi "$HOME/.pi" pi
  install_integration omp "$HOME/.omp" omp
  install_integration mastracode "$HOME/.mastracode" mastracode
  install_integration antigravity-cli "$HOME/.gemini" gemini agy
}

summary() {
  printf '\n'
  ok "done"
  have nvim && nvim --version | head -1
  have rg && rg --version | head -1
  have fd && fd --version | head -1
  have fzf && fzf --version | head -1
  have node && echo "node $(node -v)"
  have yarn && echo "yarn $(yarn --version 2>/dev/null)"
  have lazygit && echo "lazygit $(lazygit --version 2>/dev/null | head -1)"
  have yazi && yazi --version | head -1
  have herdr && herdr --version | head -1
  have starship && starship --version | head -1
  have ghostty && ghostty --version | head -1
  have herdr && herdr integration status || true
  printf '\n open Ghostty (it launches Herdr). First nvim run installs plugins via lazy.nvim.\n'
}

main() {
  need curl
  ensure_path
  detect_pm
  install_unix_deps
  ensure_iosevka
  install_herdr
  install_starship
  install_ghostty
  link_configs
  setup_shell
  install_herdr_skill || warn "herdr skill step failed"
  install_herdr_integrations
  summary
}

main "$@"
