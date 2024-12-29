{ name, ... }:

{
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
}
