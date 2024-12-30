# ❄️ Nix macOS Configuration

## Commands to know
- Rebuild and switch the system configuration:
```bash
rebuild
``` 

- Update nix package manager:
```bash
update
```

## Installation

Prerequisites:
- [Nix installed and running](https://nixos.org/download/)
- [Flakes enabled](https://nixos.wiki/wiki/flakes)

Clone the repo and cd into it:

```bash
git clone https://github.com/tsangste/nix ~/.config/nix && cd ~/.config/nix
```

Initialise configuration based on your computer name

```bash
nix run nix-darwin --experimental-features "nix-command flakes" -- switch --flake '.#yourComputer'
```
