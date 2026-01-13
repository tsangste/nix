{ username, host, email, fullname, opnix }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = {
      imports = [
        opnix.homeManagerModules.default
        ../../hosts/${host}/home.nix
      ];
    };
    extraSpecialArgs = {
      inherit email host fullname username opnix;
    };
  };
}
