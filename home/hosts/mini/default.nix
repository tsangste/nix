{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ../../modules/git.nix
    ../../modules/zsh.nix
  ];
}
