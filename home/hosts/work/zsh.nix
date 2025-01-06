{ config, username, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
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
      PATH="/Users/${username}/Development/work/ssm-ssh-jumpbox/scripts:$PATH"

      eval "$(fnm env --use-on-cd --shell zsh)"
      eval "$(pyenv virtualenv-init -)"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "aws" "docker" "fnm" "npm" "pip" "terraform" "thefuck" "tldr" "yarn" ];
      theme = "agnoster";
      extraConfig = ''
        zstyle ':omz:plugins:yarn' berry yes
      '';
    };

    sessionVariables = {
      AWS_PROFILE = "staging";
      AWS_SDK_LOAD_CONFIG = 1;
    };
  };
}
