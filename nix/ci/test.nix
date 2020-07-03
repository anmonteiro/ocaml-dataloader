{ ocamlVersion }:

let
  pkgs = import ../sources.nix { inherit ocamlVersion; };
  inherit (pkgs) lib stdenv fetchTarball ocamlPackages;

  dataloaderPkgs =  (import ./.. {
    inherit pkgs;
    doCheck = true;
  });

  dataloaderDrvs = lib.filterAttrs (_: value: lib.isDerivation value) dataloaderPkgs;

  in

  stdenv.mkDerivation {
    name = "dataloader-tests";
    src = ./../..;
    dontBuild = true;
    installPhase = ''
      touch $out
    '';
    buildInputs = (lib.attrValues dataloaderDrvs) ++ (with ocamlPackages; [ ocaml dune findlib pkgs.ocamlformat ]);
    doCheck = true;
    checkPhase = ''
      # Check code is formatted with OCamlformat
      dune build @fmt
    '';
  }
