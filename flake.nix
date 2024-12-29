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
      email = "tsangste@gmail.com";

      mkSystem = { darwin, host, extraArgs }:
        darwin.lib.darwinSystem {
          modules = [
            ./modules/system/configuration.nix
            ({ lib, ... }: {
              inherit self;
              inherit (extraArgs // { brews = [ ]; casks = [ ]; masApps = { }; }) brews casks masApps;
            })
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = import ./modules/homebrew { inherit username; };
            }
            {
              users.users.${username}.home = "/Users/${username}";
            }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${username} = import ./home/hosts/${host};
                extraSpecialArgs = {
                  inherit fullname username email;
                };
              };
            }
          ]
          ++ (extraArgs.extraModules or [ ]); # Dynamically append extra Nix modules using extraArgs
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations = {
        "mini" = mkSystem {
          darwin = nix-darwin;
          host = "mini";
          extraArgs = {
            masApps = {
              "UTM Virtual Machines" = 1538878817;
            };
          };
        };
        "work" = mkSystem {
          darwin = nix-darwin;
          host = "work";
          extraArgs = {
            brews = [
              "awscli"
              "aws-iam-authenticator"
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
