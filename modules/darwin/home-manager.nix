{ config, pkgs, host, ... }:

{
  home.shellAliases = {
    rebuild = "sudo darwin-rebuild switch --flake $NIX_CONFIG_DIR#${host}";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "/opt/homebrew/opt/gnu-sed/libexec/gnubin"
    "/opt/homebrew/opt/grep/libexec/gnubin"
    "/opt/homebrew/opt/coreutils/libexec/gnubin"
  ];

  programs.git.settings = {
    gpg."ssh".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  };
}
