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
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations = {
        "mini" = nix-darwin.lib.darwinSystem {
          modules =
            [
              ./configuration.nix
              ({ lib, ... }: {
                inherit self;
                brews = lib.mkMerge [ ];
                casks = lib.mkMerge [ ];
              })
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = import ./modules/homebrew.nix { inherit username; };
              }
              {
                users.users.${username}.home = "/Users/${username}";
              }
              home-manager.darwinModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = import ./home/hosts/mini;
                  extraSpecialArgs = {
                    inherit fullname;
                    inherit username;
                  };
                };
              }
            ];
        };
        "work" = nix-darwin.lib.darwinSystem {
          modules =
            [
              ./configuration.nix
              ({ lib, ... }: {
                inherit self;
                brews = lib.mkMerge [
                  [
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
                  ]
                ];
                casks = lib.mkMerge [
                  [
                    "docker"
                    "lens"
                    "postman"
                    "session-manager-plugin"
                    "Tuple"
                  ]
                ];
              })
              nix-homebrew.darwinModules.nix-homebrew
              {
                nix-homebrew = import ./modules/homebrew.nix { inherit username; };
              }
              {
                users.users.${username}.home = "/Users/${username}";
              }
              home-manager.darwinModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username} = import ./home/hosts/work;
                  extraSpecialArgs = {
                    inherit fullname;
                    inherit username;
                  };
                };
              }
            ];
        };
      };
    };
}
