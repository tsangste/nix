{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ../../modules/aws.nix
    ../../modules/git.nix
    ../../modules/pyenv.nix
    ./zsh.nix
  ];
}
