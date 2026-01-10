{ pkgs, username, ... }:

{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/nixos/home-manager.nix
    ../../modules/home-manager/fnm.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.homeDirectory = "/home/${username}";
}
