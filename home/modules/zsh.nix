{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -alF";

      rebuild = "darwin-rebuild switch --flake $NIX_CONFIG_DIR#mini";
      update = "nix flake update $NIX_CONFIG_DIR";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initExtra = ''
      PATH="/opt/homebrew/bin:$PATH"
      PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
      PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
      PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "npm" ];
      theme = "agnoster";
    };
  };
}
