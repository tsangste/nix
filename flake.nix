{
  description = "Steven Nix for macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opnix.url = "github:brizzbuzz/opnix";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, nix-homebrew, home-manager, opnix, ... }:
    let
      fullname = "Steven Tsang";
      username = "steven.tsang";
      email = "3403544+tsangste@users.noreply.github.com";

      mkSystem = { host }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit self username; };
          modules = [
            inputs.nixos-wsl.nixosModules.default
            ./modules/nixos/configuration.nix
            ./hosts/${host}/configuration.nix
            home-manager.nixosModules.home-manager
            (import ./modules/common/home-manager.nix {
              inherit username host email fullname opnix;
            })
            ({ ... }: {
              nixpkgs.overlays = [
                (final: prev: {
                  _1password = (import nixpkgs-unstable {
                    system = prev.system;
                    config.allowUnfree = true;
                  })._1password;
                  _1password-gui = (import nixpkgs-unstable {
                    system = prev.system;
                    config.allowUnfree = true;
                  })._1password-gui;
                })
              ];
            })
          ];
        };

      mkDarwinSystem = { darwin, host }:
        darwin.lib.darwinSystem {
          specialArgs = { inherit self; };
          modules = [
            ./modules/darwin/configuration.nix
            ./hosts/${host}/configuration.nix
            {
              users.users.${username}.home = "/Users/${username}";
            }
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
              inherit username host email fullname opnix;
            })
          ];
        };
    in
    {
      nixosConfigurations = {
        "wsl" = mkSystem {
          host = "wsl";
        };
      };

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations = {
        "mini" = mkDarwinSystem {
          darwin = nix-darwin;
          host = "mini";
        };
        "work" = mkDarwinSystem {
          darwin = nix-darwin;
          host = "work";
        };
      };
    };
}
