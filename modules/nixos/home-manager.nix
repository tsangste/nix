{ config, pkgs, host, ... }:

{
  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake $NIX_CONFIG_DIR#${host}";
  };
}
