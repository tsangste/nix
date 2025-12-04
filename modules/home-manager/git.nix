{ config, fullname, email, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = fullname;
        email = email;
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDNvWJnENwYza2ab/ALsmG4yvXxM1KvJriJuE9LpTpZj";
      };
      alias = {
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
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg."ssh".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
  };
}
