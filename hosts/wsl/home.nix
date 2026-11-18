{ pkgs, username, ... }:

{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/nixos/home-manager.nix
    ../../modules/home-manager/aws.nix
    ../../modules/home-manager/fnm.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/zsh.nix
  ];

  home.packages = [
    pkgs.awscli2
    pkgs.kubectl
    pkgs.lens
  ];

  programs.zsh.initContent = ''
    if (( $+commands[kubectl] )); then
      source <(kubectl completion zsh)
    fi

    if (( $+commands[aws_completer] )); then
      autoload -Uz bashcompinit && bashcompinit
      complete -C aws_completer aws
    fi

    lens() {
      lens-desktop "$@" >/dev/null 2>&1 & disown
    }
  '';

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.homeDirectory = "/home/${username}";
}
