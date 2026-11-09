# Neovim Configuration with LazyVim

This directory contains a Neovim configuration based on [LazyVim](https://www.lazyvim.org/), a modern Neovim configuration framework.

## Structure

```
nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/
│   │   ├── lazy.lua        # Lazy.nvim plugin manager setup
│   │   ├── options.lua     # Neovim options
│   │   ├── keymaps.lua     # Custom keybindings
│   │   └── autocmds.lua    # Auto commands
│   └── plugins/
│       └── example.lua     # Add your custom plugins here
└── README.md               # This file
```

## Features

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) - Fast and flexible plugin manager
- **Base Configuration**: [LazyVim](https://github.com/LazyVim/LazyVim) - Pre-configured Neovim setup
- **Sensible Defaults**: Optimized options, keymaps, and autocmds
- **Easy Customization**: Add your own plugins in `lua/plugins/`

## Key Features Included

LazyVim comes with many features out of the box:

- **LSP Support**: Language Server Protocol integration
- **Autocompletion**: nvim-cmp with various sources
- **Syntax Highlighting**: Treesitter-based syntax highlighting
- **File Explorer**: Neo-tree file explorer
- **Fuzzy Finder**: Telescope for finding files, text, and more
- **Git Integration**: Gitsigns, LazyGit integration
- **Terminal**: Toggleable terminal
- **Beautiful UI**: Modern colorscheme and UI components

## Keybindings

Leader is `<Space>`. Press it and wait — which-key lists every mapping;
`<leader>sk` searches them. Full list: https://www.lazyvim.org/keymaps

Common LazyVim defaults:

- File explorer: `<leader>e`
- Find files: `<leader>ff` · grep in project: `<leader>/`
- Next / previous buffer: `<Shift-l>` / `<Shift-h>`
- Split right / below: `<leader>|` / `<leader>-`
- Save: `<Ctrl-s>` · quit all: `<leader>qq`

Local additions (`lua/config/keymaps.lua`):

- `jk` — leave insert mode
- `<Ctrl-d>` / `<Ctrl-u>` — page down / up, cursor stays centred
- `J` / `K` in visual mode — move the selection down / up
- `p` in visual mode — paste without overwriting the yank

Trailing whitespace is stripped on save, except in Markdown and diffs
(`lua/config/autocmds.lua`).

## Customization

### Adding Custom Plugins

Create a new file in `lua/plugins/` directory. For example, `lua/plugins/mycustom.lua`:

```lua
return {
  {
    "plugin-author/plugin-name",
    opts = {
      -- plugin options
    },
    keys = {
      { "<leader>x", "<cmd>SomeCommand<cr>", desc = "Description" },
    },
  },
}
```

### Modifying Options

Edit `lua/config/options.lua` to change Neovim settings.

### Adding Keymaps

Edit `lua/config/keymaps.lua` to add your custom keybindings.

### Adding Autocmds

Edit `lua/config/autocmds.lua` to add automatic commands.

## First Launch

On the first launch, Neovim will:
1. Clone lazy.nvim plugin manager
2. Install all plugins automatically
3. Set up LSP servers as needed

This may take a few moments. Subsequent launches will be much faster.

## Updating Plugins

- Check for updates: `:Lazy check`
- Update plugins: `:Lazy update`
- View plugin status: `:Lazy`

## LSP Setup

LazyVim uses [mason.nvim](https://github.com/williamboman/mason.nvim) for managing LSP servers, formatters, and linters.

- Open Mason: `:Mason`
- Install language server: `:MasonInstall <server-name>`

## Useful Commands

- `:Lazy` - Open lazy.nvim plugin manager
- `:Mason` - Open Mason for LSP management
- `:LazyExtras` - Browse and enable LazyVim extras (language support, etc.)
- `:checkhealth` - Check Neovim health
- `:help lazyvim` - LazyVim documentation

## Resources

- [LazyVim Documentation](https://www.lazyvim.org/)
- [Neovim Documentation](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)

## Troubleshooting

If you encounter issues:
1. Run `:checkhealth` to diagnose problems
2. Check `:Lazy` for plugin errors
3. Ensure you have the latest Neovim version (0.9.0+)
4. Delete `~/.local/share/nvim` and `~/.cache/nvim` to start fresh
