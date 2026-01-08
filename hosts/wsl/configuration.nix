{ username, ... }:

{
  networking.hostName = "wsl";

  wsl.enable = true;
  wsl.defaultUser = username;
}
