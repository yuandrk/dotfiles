# CLAUDE.md

Context for AI assistants working in this repository and on this machine.

## What this repo is

Personal dotfiles, symlinked into place by `install.sh`. The repo is the source of
truth: `~/.zshrc`, `~/.tmux.conf`, `~/.config/nvim` and friends are all symlinks
pointing back here. **Editing the file in `$HOME` edits the repo.**

## Environment

| | |
|---|---|
| Machine | MacBook Air M3 (Apple Silicon, `arm64`) |
| OS | macOS 26 |
| Shell | `zsh` (`/bin/zsh`) — the login shell |
| Terminal | Ghostty 1.3.1, `TERM=xterm-ghostty` |
| Prompt | Starship (`starship/starship.toml`) |
| Sessions | zmx (`zmx attach <name>`, detach `ctrl+\`), **not** auto-started; prompt shows `[name]` |
| Multiplexer | tmux, prefix `C-a`, **not** auto-started — only for panes/windows/splits |
| Editor | Neovim + LazyVim (`$EDITOR=nvim`) |
| Package manager | Homebrew at **`/opt/homebrew`** (Apple Silicon path) |

The repo also supports Linux — `install.sh` has a curl-based path and `zsh/zshrc`
branches on `OS_TYPE`. Keep new code cross-platform; don't hardcode `/Users/yuandrk`
or assume `/opt/homebrew`.

Historical note: this config was originally written on Fedora under Flatpak with bash
and iTerm2. All of that is gone. Ignore any Fedora/Flatpak/`/home/yuandrk` references
you find in old docs or git history.

## Layout

```
zsh/zshrc          -> ~/.zshrc          aliases, functions, k8s + kind helpers
zsh/zprofile       -> ~/.zprofile       login shell: brew shellenv, PATH
bash/              -> ~/.bashrc etc.    kept for Linux / bash sessions only
tmux/tmux.conf     -> ~/.tmux.conf
starship/          -> ~/.config/starship.toml
ghostty/           -> ~/.config/ghostty
nvim/              -> ~/.config/nvim    LazyVim; lazy-lock.json is the plugin lockfile
kind/              -> ~/.config/kind    cluster manifests
claude/            -> ~/.claude/*       settings.json + statusline-command.sh (files only)
docs/setup/        -> ~/docs/setup      cheatsheets and nvim guide
Brewfile                                everything installed via `brew bundle`
install.sh                              symlinks + tool install
```

## Rules

**Machine-specific config goes in `~/.zshrc.d/*.zsh`, never in `zsh/zshrc`.**
The bottom of `zshrc` sources that directory. Installers that append `export PATH=...`
to `~/.zshrc` are writing into a tracked, public file — move those lines out. Note that
`zprofile` already puts `~/.local/bin` and `~/bin` on PATH with a duplicate guard, so a
PATH export for those is never needed.

**Only two files under `~/.claude` are tracked**: `settings.json` and
`statusline-command.sh`. Everything else there is credentials or session state and is
covered by `.gitignore`. Never symlink or commit the whole `~/.claude` directory.

**This repo is public.** No secrets, tokens, kubeconfigs, or real hostnames.

**New tools go in the `Brewfile`.** If you `brew install` something worth having on the
next machine, add it to the matching section. Claude Code is the exception — it installs
itself to `~/.local/bin/claude` and self-updates, so it is not a brew package.

**Persistent processes use zmx, not tmux.** From scripts or agents, start them with
`zmx run <name> -d <cmd>` and follow up with `zmx wait` / `zmx history` — never
`zmx attach` from non-interactive code. zmx quotes every argument itself, so a compound
command must go through `zmx run <name> -d zsh -c '…'` or stdin (`echo '…' | zmx run
<name>`) — `zmx run x -d 'a; b'` arrives as one word and fails with exit 127. A session
inherits the creator's environment, including `$SHELL`. Nested sessions are unsupported: inside one
(`$ZMX_SESSION` is set) use `zmx run`, or `env -u ZMX_SESSION zmx attach …` if you
truly must. tmux stays installed only for panes/windows/splits.

## Conventions

- Shell config uses banner comments (`# ===== SECTION =====`) — match that style.
- `install.sh` uses the `create_symlink` / `backup_file` / `print_*` helpers. Reuse them
  rather than calling `ln -s` directly.
- Commit messages: short imperative subject, scoped by area (`Ghostty: ...`, `zsh: ...`).
  **Do not add Co-Authored-By or any AI attribution.**

## Useful commands

```sh
./install.sh --minimal                            # re-link dotfiles only
brew bundle check --file=Brewfile                 # is the machine in sync?
brew bundle --file=Brewfile                       # install what's missing
echo '{}' | ~/.claude/statusline-command.sh       # debug the Claude status line
echo $PATH | tr ':' '\n' | sort | uniq -d         # find duplicated PATH entries
```
