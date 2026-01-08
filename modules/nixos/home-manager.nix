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

  systemd.user.services._1password = {
    Unit = {
      Description = "1Password GUI";
    };
    Service = {
      ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
      Restart = "on-failure";
      RestartSec = "5s";
      Environment = [
        "PATH=${pkgs.coreutils}/bin:${pkgs.dbus}/bin"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
  programs.zsh.initExtra = ''
    if [ -n "$DISPLAY" ]; then
      systemctl --user import-environment DISPLAY WAYLAND_DISPLAY
      dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY
    fi
  '';
}
