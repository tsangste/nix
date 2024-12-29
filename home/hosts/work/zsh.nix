{ config, username, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -alF";

      rebuild = "darwin-rebuild switch --flake $NIX_CONFIG_DIR#work";
      update = "nix flake update $NIX_CONFIG_DIR";

      kcuc = "kubectl config use-context";
      kcsc = "kubectl config set-context";
      kcdc = "kubectl config delete-context";
      kccc = "kubectl config current-context";
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
      PATH="/Users/${username}/Development/work/ssm-ssh-jumpbox/scripts:$PATH"

      eval "$(fnm env --use-on-cd --shell zsh)"
      eval "$(pyenv virtualenv-init -)"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "aws" "docker" "npm" "pip" "terraform" ];
      theme = "agnoster";
    };
  };
}
