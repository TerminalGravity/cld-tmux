# cld - Claude tmux Session Manager

A simple, intuitive CLI tool for managing persistent Claude Code sessions with tmux. Perfect for remote development via SSH.

## Features

- 🚀 **Simple Commands** - Just `cld [project]` to start
- 🔄 **Persistent Sessions** - Survive SSH disconnections
- 📁 **Project-Based** - Automatic project organization
- 🏷️ **Named Sessions** - Multiple sessions per project
- 📊 **Rich Information** - Activity tracking, context size
- 🎯 **Smart Defaults** - Works out of the box

## Installation

### Quick Install

```bash
curl -sSL https://raw.githubusercontent.com/terminalgravity/cld-tmux/main/install.sh | bash
```

### Manual Install

1. Clone the repository:
```bash
git clone https://github.com/terminalgravity/cld-tmux.git
cd cld-tmux
```

2. Run the installer:
```bash
./install.sh
```

Or manually:
```bash
cp cld ~/scripts/
chmod +x ~/scripts/cld
echo 'export PATH="$HOME/scripts:$PATH"' >> ~/.zshrc
```

## Requirements

- `tmux` - Terminal multiplexer
- `claude` - Claude Code CLI
- `zsh` - Z shell

## Usage

### Basic Commands

```bash
# Start session in current directory
cld

# Start session for a project
cld myproject

# Start from GitHub repo (auto-clones)
cld https://github.com/user/repo

# Named sessions for same project
cld myproject -n testing
cld myproject -n feature-x
```

### Session Management

```bash
# List all sessions with details
cld -l

# Kill a session
cld -k myproject-testing

# Rename a session
cld -r old-name new-name

# Interactive session picker
cld -s
```

### List View Information

When you run `cld -l`, you'll see:
- Session name and path
- Window/pane counts
- Last activity time (5m ago, 2h ago)
- Context size (when available)
- Project type detection

Example output:
```
Active Claude Sessions
────────────────────────────────────────────

● claude-api-server
  Path: /home/user/projects/api-server
  Type: Claude Project
  Windows: 2 │ Panes: 3 │ Active: 5m ago │ Context: 124M

● claude-frontend-testing
  Path: /home/user/projects/frontend
  Windows: 1 │ Panes: 1 │ Active: 2h ago
```

## Advanced Features

### Multiple Sessions per Project

Run different Claude contexts for the same project:

```bash
# Main development
cld myapp

# Testing session
cld myapp -n testing

# Bug fix session
cld myapp -n bugfix-api

# Feature branch
cld myapp -n feature-auth
```

### Session Renaming

Organize sessions as your work evolves:

```bash
cld -r claude-myapp-testing claude-myapp-staging
```

### Project Organization

Projects are automatically organized in `~/projects/` by default. Set a custom directory:

```bash
export CLD_PROJECTS_DIR="$HOME/work"
```

## Tips & Tricks

### tmux Shortcuts

- **Detach**: `Ctrl+b d` - Leave session running
- **Switch Windows**: `Ctrl+b [0-9]` - Jump between windows
- **List Windows**: `Ctrl+b w` - See all windows

### Workflow Examples

1. **Remote Development**:
   ```bash
   ssh myserver
   cld api-project
   # Work... disconnect anytime
   # Later: ssh myserver && cld api-project
   ```

2. **Multi-Context Development**:
   ```bash
   cld backend -n dev
   cld backend -n debug
   cld frontend
   ```

3. **Quick Project Switch**:
   ```bash
   cld -s  # Interactive picker
   ```

## Configuration

### Environment Variables

- `CLD_PROJECTS_DIR` - Default projects directory (default: `~/projects`)

### Completion

ZSH completion is included. Add to your `.zshrc`:

```bash
fpath=(~/.config/zsh/completions $fpath)
autoload -U compinit && compinit
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

Created by [terminalgravity](https://github.com/terminalgravity) for the Claude Code community.