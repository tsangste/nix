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
      After = [ "dbus.service" "gnome-keyring.service" ];
    };
    Service = {
      ExecStart = "${pkgs._1password-gui}/bin/1password --silent --disable-gpu --no-sandbox";
      Restart = "on-failure";
      RestartSec = "5s";
      Environment = [
        "PATH=${pkgs.coreutils}/bin:${pkgs.dbus}/bin"
        "DISPLAY=:0"
        "XDG_CURRENT_DESKTOP=GNOME"
        "XDG_RUNTIME_DIR=/run/user/1000"
        "GNOME_KEYRING_CONTROL=/run/user/1000/keyring"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
