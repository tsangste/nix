{ config, pkgs, name, username, ... }:

{
  imports = [
    ../../modules/common { inherit config pkgs username; }
    ../../modules/git { inherit name; }
    ../../modules/pyenv
    ./zsh { inherit config; }
  ];
}
