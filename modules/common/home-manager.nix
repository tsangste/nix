{ username, host, email, fullname }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ../../hosts/${host}/home.nix;
    extraSpecialArgs = {
      inherit email host fullname username;
    };
  };
}
