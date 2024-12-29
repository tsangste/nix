{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common
    ../../modules/git
    ../../modules/pyenv
    ./zsh
  ];
}
