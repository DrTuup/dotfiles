# dotfiles

Personal macOS setup: shell, git, terminal and app configuration, plus the list of Homebrew packages I use.

## Layout

```
install.sh     bootstrap and maintenance script
Brewfile       all Homebrew formulae, casks, VS Code extensions and uv/npm/go tools
config/        config files that get symlinked into $HOME
```

## Bootstrap a new Mac

1. Install the Command Line Tools: `xcode-select --install`
2. Clone the repo to `~/repos/dotfiles`:
   ```sh
   git clone git@github.com:DrTuup/dotfiles.git ~/repos/dotfiles
   cd ~/repos/dotfiles
   ```
3. Run the installer:
   ```sh
   ./install.sh
   ```
   This installs Homebrew if needed, installs the 1Password app and CLI, and then pauses so you can sign in to 1Password. Enable **Settings → Developer → Integrate with 1Password CLI**, then press Enter. The script checks that `op` can read the LiteLLM key before it continues.
4. Optionally, apply macOS defaults: `./install.sh --macos`

## Usage

| Command | What it does |
| --- | --- |
| `./install.sh` | Homebrew, 1Password check, Brewfile install, symlinks (default) |
| `./install.sh --brew` | Only Homebrew, 1Password check and Brewfile |
| `./install.sh --links` | Only symlinks |
| `./install.sh --macos` | macOS defaults for Dock, Finder, trackpad, mouse and keyboard (opt-in) |
| `./install.sh --cleanup` | Also uninstall anything not listed in the Brewfile (opt-in, destructive) |
| `./install.sh --dry-run` | Print what would happen without changing anything. Combine with other flags. |

The script is safe to re-run. Correct symlinks are left alone. An existing file at a link target is moved to `<name>.bak-<timestamp>` before it is replaced.

## Secrets

Secrets are not stored in this repo. `config/.zshrc` defines `litellm_key`, which reads the key from 1Password the first time it is called:

```sh
litellm_key && some-command-that-needs-LITELLM_API_KEY
```

New shells don't call 1Password, so opening a terminal doesn't prompt for Touch ID. Only the first `litellm_key` call in a shell does.

## Adding a package

Add it to `Brewfile` with a comment above it, then run `./install.sh --brew`.

## Editing configs

Files in `config/` are symlinked, so edit them in the repo. Changes take effect in new shells, or after `source ~/.zshrc`.
