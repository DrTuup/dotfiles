#!/usr/bin/env bash
# install.sh - bootstrap and maintain this personal macOS setup.
#
# Usage:
#   ./install.sh               default run: Homebrew + 1Password check + Brewfile + symlinks
#   ./install.sh --brew        only Homebrew, 1Password check and Brewfile
#   ./install.sh --links       only symlinks
#   ./install.sh --macos       only macOS defaults (opt-in)
#   ./install.sh --cleanup     also remove anything not in the Brewfile (opt-in, destructive)
#   ./install.sh --dry-run     print what would happen, change nothing
#
# Flags can be combined, e.g. ./install.sh --links --dry-run
# Safe to re-run: existing correct symlinks are left alone, and existing
# files are backed up to *.bak-<timestamp> before being replaced.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$REPO/Brewfile"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
OP_SECRET_REF='op://Private/LiteLLM/Virtual Key'

DRY_RUN=0
DO_BREW=0
DO_LINKS=0
DO_MACOS=0
DO_CLEANUP=0

# Symlink manifest: "source (relative to repo)|target (absolute)"
LINKS=(
  "config/.gitconfig|$HOME/.gitconfig"
  "config/.zshrc|$HOME/.zshrc"
  "config/ghostty|$HOME/.config/ghostty/config"
  "config/starship.toml|$HOME/.config/starship.toml"
  "Brewfile|$HOME/Brewfile"
)

# ---------- helpers ----------

log()  { printf '==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }

# Runs a command, or only prints it in dry-run mode.
run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

usage() {
  sed -n '2,15p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

# ---------- Homebrew ----------

load_brew() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_brew() {
  load_brew
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew is installed"
    return
  fi

  # Homebrew's installer needs the Command Line Tools.
  if ! xcode-select -p >/dev/null 2>&1; then
    die "Command Line Tools are missing. Run 'xcode-select --install', then re-run this script."
  fi

  log "Installing Homebrew"
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew
}

# ---------- 1Password ----------
# 1Password has to be installed and signed in before `op` can read secrets,
# so it is installed first, then verified before the rest of the Brewfile runs.

onepassword_step() {
  log "1Password: checking CLI and app"

  local pkg
  for pkg in 1password 1password-cli; do
    if brew list --cask "$pkg" >/dev/null 2>&1; then
      log "$pkg is installed"
    else
      run brew install --cask "$pkg"
    fi
  done

  if [[ $DRY_RUN -eq 1 ]]; then
    log "[dry-run] would verify 'op whoami' and read '$OP_SECRET_REF'"
    return
  fi

  if ! op whoami >/dev/null 2>&1; then
    [[ -t 0 ]] || die "1Password is not signed in. Sign in, or run this script interactively."

    cat <<'MSG'

Open the 1Password app and sign in. Then enable:
  Settings -> Developer -> Integrate with 1Password CLI

MSG
    read -r -p "Press Enter once 1Password is signed in... " _
    op whoami >/dev/null 2>&1 \
      || die "'op whoami' still fails. Check the 1Password app and the CLI integration setting."
  fi

  op read "$OP_SECRET_REF" >/dev/null \
    || die "Could not read '$OP_SECRET_REF'. Check the vault, item and field names."

  log "1Password verified"
}

brew_step() {
  install_brew

  if ! command -v brew >/dev/null 2>&1; then
    if [[ $DRY_RUN -eq 1 ]]; then
      log "[dry-run] brew is not installed yet; skipping the remaining Brewfile checks"
      return
    fi
    die "brew is still not on PATH after installation."
  fi

  onepassword_step

  log "Installing Brewfile"
  run brew bundle install --file="$BREWFILE"

  if [[ $DO_CLEANUP -eq 1 ]]; then
    warn "--cleanup: removing anything installed but not listed in the Brewfile"
    run brew bundle cleanup --force --file="$BREWFILE"
  fi
}

# ---------- symlinks ----------

link_one() {
  local src="$REPO/$1"
  local dst="$2"

  if [[ -L $dst && "$(readlink "$dst")" == "$src" ]]; then
    log "ok: $dst"
    return
  fi

  run mkdir -p "$(dirname "$dst")"

  if [[ -e $dst || -L $dst ]]; then
    local bak="$dst.bak-$TIMESTAMP"
    warn "backing up existing $dst -> $bak"
    run mv "$dst" "$bak"
  fi

  log "link $dst -> $src"
  run ln -s "$src" "$dst"
}

links_step() {
  local entry
  for entry in "${LINKS[@]}"; do
    link_one "${entry%%|*}" "${entry#*|}"
  done
}

# ---------- macOS defaults (opt-in) ----------

macos_step() {
  log "macOS defaults (scripts/macos.sh)"
  run bash "$REPO/scripts/macos.sh"
}

# ---------- main ----------

main() {
  local selected=0
  local arg
  for arg in "$@"; do
    case "$arg" in
      --dry-run) DRY_RUN=1 ;;
      --brew)    DO_BREW=1; selected=1 ;;
      --links)   DO_LINKS=1; selected=1 ;;
      --macos)   DO_MACOS=1; selected=1 ;;
      --cleanup) DO_CLEANUP=1; DO_BREW=1; selected=1 ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown option: $arg (see --help)" ;;
    esac
  done

  # No step flags: run the default set (brew + links). macOS and cleanup are opt-in.
  if [[ $selected -eq 0 ]]; then
    DO_BREW=1
    DO_LINKS=1
  fi

  [[ $DRY_RUN -eq 1 ]] && log "DRY RUN: no changes will be made"

  if [[ $DO_BREW -eq 1 ]]; then brew_step; fi
  if [[ $DO_LINKS -eq 1 ]]; then
    log "Symlinks"
    links_step
  fi
  if [[ $DO_MACOS -eq 1 ]]; then macos_step; fi

  log "Done"
}

main "$@"
