{ config, pkgs, name, username, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/${user}/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -alF";

      rebuild = "darwin-rebuild switch --flake '.config/nix#work'";
      update = "nix flake update '.config/nix'";

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

  programs.git = {
    enable = true;
    userName = name;
    aliases = {
      all = "add -A";
      st = "status";
      wipe = "reset --hard && clean -xfd";
      update = "stash && pull --rebase && pop";
      a = "add";
      aa = "add -A";
      c = "commit";
      cm = "commit -m";
      d = "diff";
      s = "status";
    };
    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNvWJnENwYza2ab/ALsmG4yvXxM1KvJriJuE9LpTpZj";
    };
    includes = [
      {
        path = "~/.gitconfig.personal";
      }
      {
        path = "~/.gitconfig.work";
        condition = "gitdir:~/Development/work/**";
      }
    ];
  };

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
