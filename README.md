# Dotfiles

Personal shell setup for macOS (Apple Silicon), with a Linux fallback:
**zsh + Ghostty + zmx + Starship + Neovim (LazyVim) + a Kubernetes toolkit.**
Everything in `$HOME` is a symlink back into this repo, so editing `~/.zshrc` edits the repo.

## What's inside

| Path | Linked to | What it does |
|---|---|---|
| `zsh/zshrc` | `~/.zshrc` | aliases, functions, key bindings |
| `zsh/zprofile` | `~/.zprofile` | login shell: Homebrew env, PATH |
| `bash/bashrc`, `bash/bash_profile` | `~/.bashrc`, `~/.bash_profile` | short version of the zsh config, for Linux servers |
| `bash/inputrc` | `~/.inputrc` | readline keys for bash (Home/End/Delete, word jump) |
| `ghostty/` | `~/.config/ghostty` | terminal: theme, keys, notifications |
| `starship/starship.toml` | `~/.config/starship.toml` | prompt: `[zmx session]`, git, language, k8s context |
| `nvim/` | `~/.config/nvim` | LazyVim; notes in [`nvim/README.md`](nvim/README.md) |
| `claude/` | `~/.claude/statusline-command.sh` | Claude Code status line; `settings.example.json` is copied once, not linked |
| `docs/setup/` | `~/docs/setup` | [`CHEATSHEET.txt`](docs/setup/CHEATSHEET.txt) — every alias and key on one page |
| `Brewfile` | | every tool, installed with `brew bundle` |
| `install.sh` | | symlinks + tool install |
| `CLAUDE.md` | | context and rules for AI assistants |

## Install

```bash
git clone https://github.com/yuandrk/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh              # interactive
./install.sh --all        # everything, no prompts
./install.sh --minimal    # symlinks only, skip tools
```

- **macOS**: installs Homebrew if missing, then everything in the `Brewfile`.
  Docker Desktop is installed by hand (`brew install --cask docker-desktop`).
- **Linux** (x86_64 or arm64): downloads Starship, Neovim, zmx, kubectl and k9s into
  `~/.local/bin`; the bash config is used.
- Existing real files are backed up as `*.backup.<timestamp>`; existing symlinks are replaced.
- **Update**: `git pull && ./install.sh --minimal`, then open a new tab.
- **Machine-specific config** goes in `~/.zshrc.d/*.zsh` (sourced last, not tracked) —
  never in `zsh/zshrc`. Installers that append `export PATH=…` to `~/.zshrc` or
  `~/.zprofile` are editing this public repo; move those lines there.

## Keys

Line editing works the same as bash on a stock Linux box — in zsh (`KEY BINDINGS` in
`zsh/zshrc`) and in bash (`bash/inputrc`).

| Key | Action |
|---|---|
| `Ctrl-A` / `Ctrl-E` | start / end of line — also `Cmd-←` / `Cmd-→` and Home / End (`Fn-←` / `Fn-→`) |
| `Opt-←` / `Opt-→` | word back / forward (same as `Alt-B` / `Alt-F`) |
| `Ctrl-W` | delete back to the previous space |
| `Opt-Backspace` | delete one word back — stops at `/ . - _` |
| `Ctrl-U` / `Ctrl-K` | delete to start / end of line (`Cmd-Backspace` = `Ctrl-U`) |
| `Ctrl-Y` | paste back what was deleted |
| `Ctrl-R` | search history |
| `Alt-.` | last argument of the previous command |
| `Ctrl-X Ctrl-E` | edit the command in `$EDITOR` (nvim) |

`Ctrl-←` / `Ctrl-→` are bound for word jumps too, but macOS gives them to Mission Control
unless *Keyboard → Shortcuts → Mission Control → Move left/right a space* is turned off.

### Ghostty

Ghostty does tabs and splits itself — there is no tmux. It uses the same colour scheme
as Neovim (TokyoNight Moon). `Cmd-Shift-P` opens a palette with every action.

| Key | Action |
|---|---|
| `Cmd-T` / `Cmd-W` | new tab / close; `Cmd-1` … `Cmd-8` go to tab |
| `Cmd-Shift-R` | name the tab |
| `Cmd-D` / `Cmd-Shift-D` | split right / down |
| `Cmd-Alt-arrows` | move between splits (`Cmd-Ctrl-arrows` resizes, `Cmd-Ctrl-=` equalizes) |
| `Cmd-Shift-Enter` | zoom the current split to the whole tab, and back |
| `Cmd-↑` / `Cmd-↓` | jump to the previous / next prompt |
| `Cmd-F` | search the scrollback (`Cmd-G` next match) |
| `Cmd-Shift-S` | open the whole scrollback as a text file |
| `Cmd-K` | clear screen |
| `` Cmd-` `` | drop-down terminal, from any app |
| `Cmd-Shift-,` | reload the config |

Selecting text copies it, and `Cmd`-click opens a link. A command that ran longer than
10 seconds sends a notification when it finishes, if you were looking elsewhere.
Windows, tabs and splits come back after a restart.

## Sessions: zmx

A [zmx](https://zmx.sh) session keeps running after you close the tab; the prompt shows `[name]` inside one.

```bash
zmx attach <name>         # attach, creating it if needed (detach: ctrl+\)
zmx ls                    # list sessions
zmx kill <name>           # kill a session
zmx run <name> -d <cmd>   # run a command without attaching (scripts, agents)
zmx wait <name>           # wait for a detached run; returns its exit code
zmx history <name> | tail -100   # scrollback (`zmx tail <name>` to follow)
zmx send <name> <text>    # raw input to the session (append \r to run it)

# zmx quotes every argument: 'a; b' arrives as one word (exit 127). Instead:
zmx run job -d zsh -c 'a; b'     # or: echo 'a; b' | zmx run job
```

Never `zmx attach` from a script. Inside a session use `zmx run`, or
`env -u ZMX_SESSION zmx attach …` if you really need to nest.

## Shell shortcuts

```bash
.. / ... / ....        # cd up 1 / 2 / 3
ll / la                # ls -lh / ls -lhA
gs ga gc gp gl gd      # git status / add / commit / push / log --graph / diff
mkcd <dir>             # mkdir + cd
extract <file>         # unpack tar, gz, bz2, zip
ff / ffd <pattern>     # find files / directories by name
k / kgp / kl / kex     # kubectl / get pods / logs / exec -it — k9s for everything else
```

That is all of them, on purpose. The same on one page, with the keys:
`cat ~/docs/setup/CHEATSHEET.txt`.

## Neovim

LazyVim with a few extras (see [`nvim/README.md`](nvim/README.md)). Press `Space` and wait:
which-key lists every mapping, and `Space s k` searches them. `:Lazy` manages plugins,
`:LazyExtras` adds language support, `:Mason` installs LSPs and formatters.
Local additions: `jk` leaves insert mode, and trailing whitespace is stripped on save.

## Security

This repo is public: no secrets, tokens, kubeconfigs or real hostnames. `.gitignore`
covers the usual suspects, and `~/.claude/settings.json` is deliberately a real file
rather than a symlink into this repo (Claude Code writes private settings there). Check
`git diff --cached` before every commit.

## License

MIT
