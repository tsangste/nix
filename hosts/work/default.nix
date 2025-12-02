{ config, pkgs, ... }:

{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/aws.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/pyenv.nix
    ./zsh.nix
  ];
}
