{ lib, pkgs, config, modulesPath, username, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";

  wsl.enable = true;
  wsl.defaultUser = username;

  environment.systemPackages = [
    pkgs.neovim
    pkgs.wget
    pkgs.git
  ];

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
