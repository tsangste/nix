{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/zsh.nix
  ];
}
