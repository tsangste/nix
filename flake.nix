{
  description = "Steven Darwin system flake";

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

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
    let
      configuration = { pkgs, config, ... }: {

        nixpkgs.config.allowUnfree = true;

        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages =
          [
            pkgs.mkalias
            pkgs.vim
          ];

        homebrew = {
          enable = true;
          brews =
            [
              "awscli"
              "aws-iam-authenticator"
              "cairo"
              "checkov"
              "coreutils"
              "credstash"
              "fnm"
              "gnu-sed"
              "grep"
              "helm"
              "jq"
              "kubectl"
              "mas"
              "moreutils"
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
              "wget"
            ];
          casks =
            [
              "1password"
              "1password-cli"
              "docker"
              "firefox"
              "jetbrains-toolbox"
              "lens"
              "obsidian"
              "postman"
              "rectangle"
              "session-manager-plugin"
              "Tuple"
            ];
          masApps = {
            "Maccy" = 1527619437;
            "Xcode" = 497799835;
          };
          onActivation.cleanup = "zap";
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        fonts.packages =
          [
            pkgs.font-awesome
            pkgs.powerline-fonts
            pkgs.powerline-symbols
            (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
          ];

        system.activationScripts.applications.text =
          let
            env = pkgs.buildEnv {
              name = "system-applications";
              paths = config.environment.systemPackages;
              pathsToLink = "/Applications";
            };
          in
          pkgs.lib.mkForce ''
            # Set up applications.
            echo "setting up /Applications..." >&2
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
            while read src; do
              app_name=$(basename "$src")
              echo "copying $src" >&2
              ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
          '';

        system.defaults = {
          dock.autohide = true;
          finder.FXPreferredViewStyle = "clmv";
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
        };

        security.pam.enableSudoTouchIdAuth = true;

        # Auto upgrade nix package and the daemon service.
        services.nix-daemon.enable = true;
        # nix.package = pkgs.nix;

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true; # default shell on catalina
        # programs.fish.enable = true;

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 5;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."work" =
        let
          name = "Steven Tsang";
          username = "steven.tsang";
        in
        nix-darwin.lib.darwinSystem {
          modules =
            [
              configuration
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
              {
                users.users.${username}.home = "/Users/${username}";
              }
              home-manager.darwinModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.${username}.imports = [
                    ({ config, ... }: import ./home.nix {
                      inherit config;
                      pkgs = nixpkgs;
                      name = name;
                      username = username;
                    })
                  ];
                };
              }
            ];
        };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."work".pkgs;
    };
}
