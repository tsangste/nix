{ pkgs, ... }:

{
  home.packages = [ pkgs.fnm ];

  programs.zsh.initContent = ''
    eval "$(fnm env --use-on-cd --shell zsh)"
  '';
}
