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

  systemd.user.services."1password" = {
    Unit = {
      Description = "1Password GUI";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs._1password}/bin/1password --silent";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
