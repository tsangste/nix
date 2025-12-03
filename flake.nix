{
  description = "Steven Nix for macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, ... }:
    let
      fullname = "Steven Tsang";
      username = "steven.tsang";
      email = "3403544+tsangste@users.noreply.github.com";

      mkDarwinSystem = { darwin, host, extraArgs }:
        darwin.lib.darwinSystem {
          modules = [
            ./modules/darwin/configuration.nix
            {
              users.users.${username}.home = "/Users/${username}";
            }
            ({ lib, ... }: {
              inherit self;
              brews = if builtins.hasAttr "brews" extraArgs then extraArgs.brews else [ ];
              casks = if builtins.hasAttr "casks" extraArgs then extraArgs.casks else [ ];
              masApps = if builtins.hasAttr "masApps" extraArgs then extraArgs.masApps else { };
            })
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                # Install Homebrew under the default prefix
                enable = true;

                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                enableRosetta = true;

                # User owning the Homebrew prefix
                user = username;
              };
            }
            home-manager.darwinModules.home-manager
            (import ./modules/common/home-manager.nix {
              inherit username host email fullname;
            })
          ];
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations = {
        "mini" = mkDarwinSystem {
          darwin = nix-darwin;
          host = "mini";
          extraArgs = {
            masApps = {
              "UTM Virtual Machines" = 1538878817;
            };
          };
        };
        "work" = mkDarwinSystem {
          darwin = nix-darwin;
          host = "work";
          extraArgs = {
            brews = [
              "awscli"
              "aws-iam-authenticator"
              "aws-sam-cli"
              "cairo"
              "checkov"
              "credstash"
              "fnm"
              "helm"
              "kubectl"
              "pango"
              "pixman"
              "pipx"
              "pre-commit"
              "pyenv-virtualenv"
              "python-setuptools"
              "pipenv"
              "terraform-docs"
              "tilt"
              "tfenv"
              "tflint"
              "yarn"
              "yq"
            ];
            casks = [
              "docker"
              "lens"
              "postman"
              "session-manager-plugin"
              "Tuple"
            ];
          };
        };
      };
    };
}
