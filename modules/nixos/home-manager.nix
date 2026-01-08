{ config, pkgs, host, ... }:

{
  home.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake $NIX_CONFIG_DIR#${host}";
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "~/.1password/agent.sock";
  };

  programs.git.settings = {
    gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
  };
}
