{ lib, pkgs, config, ... }:

with lib;

{
  options = {
    self = mkOption {
      type = types.anything;
      description = "Reference to the flake's self context.";
    };

    brews = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "The list of Homebrew packages to install via `brew install`.";
    };

    casks = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "The list of Homebrew GUI applications to install via `brew install --cask`.";
    };

    masApps = mkOption {
      type = types.attrsOf types.int;
      default = { };
      description = "Mac App Store applications (names mapped to IDs).";
    };
  };

  config = {
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages =
      [
        pkgs.mkalias
        pkgs.neovim
        pkgs.opnix
      ];

    environment.variables = {
      NIX_CONFIG_DIR = "$HOME/.config/nix";
    };

    homebrew = {
      enable = true;
      brews =
        [
          "coreutils"
          "gnu-sed"
          "grep"
          "jq"
          "mas"
          "moreutils"
          "thefuck"
          "tlrc"
          "wget"
        ] ++ config.brews;
      casks =
        [
          "1password"
          "1password-cli"
          "firefox"
          "jetbrains-toolbox"
          "obsidian"
          "rectangle"
        ] ++ config.casks;
      masApps = {
        "Maccy" = 1527619437;
        "Xcode" = 497799835;
      } // config.masApps;
      onActivation.cleanup = "zap";
      onActivation.autoUpdate = true;
      onActivation.upgrade = true;
    };

    fonts.packages =
      [
        pkgs.font-awesome
        pkgs.powerline-fonts
        pkgs.powerline-symbols
        pkgs.nerd-fonts.jetbrains-mono
      ];

    system.activationScripts.applications.text =
      let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = ["/Applications"];
        };
      in
      pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

    system.activationScripts.postActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    system.defaults = {
      dock.autohide = true;
      finder.FXPreferredViewStyle = "clmv";
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
    };

    # OpNix system-level secrets configuration
    services.onepassword-secrets = {
      enable = true;
      tokenFile = "/etc/opnix-token";

      secrets = {
        gitPat = {
          reference = "op://Service/GitHub Pat/credential";
          path = ".config/tokens/github";
        };
      };
    };

    security.pam.services.sudo_local.touchIdAuth = true;

    # Auto upgrade nix package.
    # nix.package = pkgs.nix;

    # Necessary for using flakes on this system.
    nix.settings.experimental-features = "nix-command flakes";

    # Create /etc/zshrc that loads the nix-darwin environment.
    programs.zsh.enable = true; # default shell on catalina
    system.primaryUser = "steven.tsang";

    # Set Git commit hash for darwin-version.
    system.configurationRevision = config.self.rev or config.self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 5;

    # The platform the configuration will be used on.
    nixpkgs.hostPlatform = "aarch64-darwin";
  };
}
