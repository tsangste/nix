{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/darwin/home-manager.nix
    ../../modules/home-manager/aws.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/pyenv.nix
    ./zsh.nix
  ];
}
