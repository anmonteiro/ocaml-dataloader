let
  pkgs = import ./nix/sources.nix {};
  inherit (pkgs) lib;
  dataloaderPkgs = pkgs.recurseIntoAttrs (import ./nix { inherit pkgs; });
  dataloaderDrvs = lib.filterAttrs (_: value: lib.isDerivation value) dataloaderPkgs;

  filterDrvs = inputs:
    lib.filter
      (drv:
        # we wanna filter our own packages so we don't build them when entering
        # the shell. They always have `pname`
        !(lib.hasAttr "pname" drv) ||
        drv.pname == null ||
        !(lib.any (name: name == drv.pname || name == drv.name) (lib.attrNames dataloaderDrvs)))
      inputs;

in
  with pkgs;

  (mkShell {
    inputsFrom = lib.attrValues dataloaderDrvs;
    buildInputs = with ocamlPackages; [ merlin ocamlformat utop ];
  }).overrideAttrs (o : {
    propagatedBuildInputs = filterDrvs o.propagatedBuildInputs;
    buildInputs = filterDrvs o.buildInputs;
  })
