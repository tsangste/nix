{ config, ... }:

{
  home.file.".aws/cli/alias" = {
    source = ../dotfiles/aws/alias;
    recursive = true;
  };
}
