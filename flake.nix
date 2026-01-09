{
  description = "Steven Nix for macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
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
              inherit username host email fullname;
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
              inherit username host email fullname;
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
