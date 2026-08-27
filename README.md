# Dev Tools

Bootstrap a new machine with my development tools. Supports **macOS** and
**Ubuntu** (and other apt-based distros).

## Usage

```sh
./deploy.sh
```

Run as your **normal user** — do not use sudo. The script uses `sudo`
internally on Linux for package installation (it will prompt for your
password once at the start). On macOS it installs Homebrew first if it's
missing.

Safe to re-run at any time: every step is idempotent.

## What it sets up

| Module  | What it does                                                                 |
|---------|------------------------------------------------------------------------------|
| `base`  | git, curl, build tools, luarocks, rustup, mise (node/python/lua toolchains)  |
| `zsh`   | zsh, oh-my-zsh, zsh-autosuggestions; sources `zsh/zshrc` from `~/.zshrc`    |
| `herdr` | herdr CLI + config symlink at `~/.config/herdr/config.toml`                  |
| `nvim`  | neovim (brew on macOS, official tarball on Linux), config symlink, jupytext  |

Finally it ensures zsh is your login shell.

## Layout

```
deploy.sh        Orchestrator: runs modules in dependency order
lib/common.sh    Shared helpers: platform detection, logging, packages, dotfiles
<module>/
  install.sh     System-level setup (packages, binaries); may use sudo
  setup.sh       User-level setup (dotfiles, config); never uses sudo
```

To add a module, just create a directory with an `install.sh` and/or
`setup.sh` — it runs automatically after the core modules. Add it to
`MODULES_ORDER` in `deploy.sh` if it has ordering dependencies.

## Notes

- Neovim config is **symlinked** from this repo (`~/.config/nvim`), so
  `git pull` updates your editor config; lazy.nvim's lockfile is written
  back into the repo, which you can commit to pin plugin versions.
- Platform detection, logging, and package installation come from
  `lib/common.sh` — source it at the top of any new script.
- Set `NVIM_VERSION` to override the pinned neovim release, e.g.
  `NVIM_VERSION=v0.11.2 ./deploy.sh`.
- To remove neovim entirely: `bash nvim/remove.sh`.
