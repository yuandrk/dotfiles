# Neovim Quick Guide

This guide covers the essentials for using Neovim with LazyVim in your dotfiles environment.

## Getting Started

### Launch Neovim

```bash
nvim              # Start with empty buffer
nvim file.txt     # Open a specific file
nvim .            # Open file explorer in current directory
```

**First Launch**: Plugins will install automatically (takes 1-2 minutes). Be patient!

### Basic Modes

- **Normal Mode**: Default mode for navigation and commands (press `ESC` or `jk`)
- **Insert Mode**: Type text (press `i`, `a`, `o`, etc.)
- **Visual Mode**: Select text (press `v`, `V`, or `Ctrl-v`)
- **Command Mode**: Run commands (press `:`)

## Essential Keybindings

### Leader Key
- Leader: `Space`
- Local Leader: `\`

### File Operations

```
Space-e         Toggle file explorer (Neo-tree)
Space-ff        Find files (Fuzzy search)
Space-fg        Find text in files (Grep)
Space-fr        Recent files
Space-fb        File browser

Ctrl-s          Save file
Space-w         Save file
Space-q         Quit
Space-qq        Quit all
```

### Navigation

```
h/j/k/l         Move left/down/up/right
w/b             Next/previous word
gg              Go to top of file
G               Go to bottom of file
Ctrl-d          Scroll down (half page)
Ctrl-u          Scroll up (half page)
{number}G       Go to line number (e.g., 42G)
```

### Editing

```
i               Insert before cursor
a               Insert after cursor
o               Insert new line below
O               Insert new line above
jk              Exit insert mode (custom)

dd              Delete line
yy              Copy (yank) line
p               Paste after cursor
P               Paste before cursor

u               Undo
Ctrl-r          Redo

/pattern        Search forward
?pattern        Search backward
n               Next search result
N               Previous search result
Space-nh        Clear search highlights
```

### Window Management

```
Space-sv        Split window vertically
Space-sh        Split window horizontally
Space-se        Make splits equal size
Space-sx        Close current split

Ctrl-h/j/k/l    Navigate between windows
```

### Buffer Management

```
Shift-l         Next buffer
Shift-h         Previous buffer
]b              Next buffer
[b              Previous buffer
Space-bd        Delete buffer
```

### Tab Management

```
Space-to        Open new tab
Space-tx        Close current tab
Space-tn        Next tab
Space-tp        Previous tab
```

## Code Features

### LSP (Language Server Protocol)

```
gd              Go to definition
gr              Go to references
K               Show documentation/hover
Space-ca        Code actions
Space-rn        Rename symbol
Space-f         Format code

]d              Next diagnostic (error/warning)
[d              Previous diagnostic
Space-xx        Show diagnostics list
```

### Completion

- Start typing and completion menu appears automatically
- `Tab` / `Shift-Tab`: Navigate completions
- `Enter`: Accept completion
- `Ctrl-Space`: Trigger completion manually

### Comments

```
gcc             Toggle comment for current line
gc{motion}      Comment using motion (e.g., gcap for paragraph)
```

In Visual mode:
```
gc              Toggle comment for selection
```

## Plugin Management

### Lazy.nvim (Plugin Manager)

```
:Lazy           Open plugin manager
:Lazy update    Update all plugins
:Lazy sync      Install/update/clean plugins
:Lazy clean     Remove unused plugins
:Lazy check     Check for updates
```

### Mason (LSP/Tool Installer)

```
:Mason          Open Mason UI
:MasonInstall <name>    Install language server/tool
:MasonUninstall <name>  Uninstall tool
```

**Common Language Servers**:
- Python: `:MasonInstall pyright`
- JavaScript/TypeScript: `:MasonInstall typescript-language-server`
- Go: `:MasonInstall gopls`
- Rust: `:MasonInstall rust-analyzer`
- Lua: `:MasonInstall lua-language-server`
- Bash: `:MasonInstall bash-language-server`

### LazyVim Extras

```
:LazyExtras     Browse and enable language support/features
```

Enable extras for your languages (Python, Go, TypeScript, etc.)

## Advanced Features

### Telescope (Fuzzy Finder)

```
Space-Space     Command palette
Space-ff        Find files
Space-fg        Grep in files
Space-fb        File browser
Space-fr        Recent files
Space-fw        Find word under cursor
Space-gc        Git commits
Space-gs        Git status
```

### Terminal

```
Space-ft        Open floating terminal
Space-fT        Open terminal in split
Ctrl-\          Toggle terminal (in terminal mode)
```

### Git Integration

```
Space-gg        LazyGit (Git TUI)
]h              Next git hunk
[h              Previous git hunk
Space-gp        Preview git hunk
Space-gb        Git blame line
```

### Text Objects

```
ciw             Change inner word
ci"             Change inside quotes
ci{             Change inside braces
dap             Delete around paragraph
yip             Yank inside paragraph
```

## Useful Commands

### File Operations
```
:w              Write (save) file
:q              Quit
:wq or :x       Write and quit
:q!             Quit without saving
:e file.txt     Edit file
:saveas file    Save as
```

### Search and Replace
```
:%s/old/new/g       Replace all in file
:%s/old/new/gc      Replace all with confirmation
:s/old/new/g        Replace in current line
```

### Helpful Commands
```
:checkhealth        Check Neovim health
:help <topic>       Get help on any topic
:Tutor              Interactive Neovim tutorial
:version            Show Neovim version
```

## Tips & Tricks

### Productivity Tips

1. **Use relative line numbers**: Jump with `5j` or `3k`
2. **Master dot command (.)**: Repeats last change
3. **Use marks**: `ma` to set mark 'a', `'a` to jump back
4. **Learn text objects**: `ci"`, `da{`, `yip` are powerful
5. **Use command history**: Press `:` then arrow up/down

### Common Workflows

**Editing a config file**:
```
nvim ~/.bashrc
# Make changes
:w
:q
```

**Project navigation**:
```
nvim .              # Start in project root
Space-e             # Open file tree
Space-ff            # Quick file search
Space-fg            # Search in files
```

**Git workflow**:
```
Space-gg            # Open LazyGit
# Make commits, push, etc in LazyGit
```

**Code editing**:
```
gd                  # Go to definition
K                   # Read documentation
Space-ca            # See available actions
Space-rn            # Rename symbol
Space-f             # Format code
```

## Customization

Your Neovim config is in: `~/.config/nvim/` (symlinked to `~/dotfiles/nvim/`)

### Add Custom Plugins

Create a file in `~/dotfiles/nvim/lua/plugins/`:

```lua
-- ~/dotfiles/nvim/lua/plugins/my-plugins.lua
return {
  {
    "plugin-author/plugin-name",
    opts = {
      -- plugin options
    },
  },
}
```

### Modify Settings

Edit: `~/dotfiles/nvim/lua/config/options.lua`

### Add Keymaps

Edit: `~/dotfiles/nvim/lua/config/keymaps.lua`

### Add Auto Commands

Edit: `~/dotfiles/nvim/lua/config/autocmds.lua`

## Troubleshooting

### Plugins Not Working
```
:Lazy sync          # Sync all plugins
:checkhealth        # Check for issues
```

### LSP Not Working
```
:Mason              # Install language server
:LspInfo            # Check LSP status
:checkhealth lsp    # Check LSP health
```

### Start Fresh
```bash
# Backup and remove Neovim data
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Restart Neovim - plugins will reinstall
nvim
```

### Performance Issues
```
:Lazy profile       # Check plugin load times
```

## Learning Resources

### Built-in Help
```
:help               # Neovim help
:Tutor              # Interactive tutorial
:help <keyword>     # Help on specific topic
```

### Recommended Learning Path

1. Complete `:Tutor` (30 minutes)
2. Practice basic navigation (h/j/k/l, w/b, gg/G)
3. Master insert mode (`i`, `a`, `o`) and exiting (`jk` or `ESC`)
4. Learn basic editing (`dd`, `yy`, `p`, `u`)
5. Explore file finding (`Space-ff`, `Space-fg`)
6. Try LSP features (`gd`, `K`, `Space-ca`)
7. Gradually add more commands to your workflow

### External Resources

- LazyVim docs: https://www.lazyvim.org/
- Neovim docs: https://neovim.io/doc/
- Vim Adventures (game): https://vim-adventures.com/

## Quick Reference Card

```
# Most Used Commands
nvim file           Open file
jk or ESC           Exit insert mode
Space-e             File explorer
Space-ff            Find files
Space-fg            Search in files
Ctrl-s              Save
:q                  Quit

# Navigation
h/j/k/l             Left/Down/Up/Right
w/b                 Word forward/back
gg/G                Top/Bottom of file

# Editing
i/a/o               Insert mode
dd                  Delete line
yy                  Copy line
p                   Paste
u                   Undo
Ctrl-r              Redo

# Code
gd                  Go to definition
K                   Show docs
Space-ca            Code actions
Space-f             Format

# Plugins
:Lazy               Plugin manager
:Mason              LSP installer
:LazyExtras         Enable languages
```

## Support

For detailed documentation:
```bash
cat ~/dotfiles/nvim/README.md
:help lazyvim
```

Happy coding! 🚀
