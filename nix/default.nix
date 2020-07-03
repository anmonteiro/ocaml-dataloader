{ pkgs ? import ./sources.nix {}, doCheck ? false, ocamlVersion ? "4_10" }:

let
  inherit (pkgs) lib stdenv ocamlPackages;
in

with ocamlPackages;

rec {
  dataloader = buildDunePackage {
    pname = "dataloader";
    version = "0.0.1-dev";

    src = lib.gitignoreSource ./..;

    doCheck = false;
  };

  dataloader-lwt = buildDunePackage {
    pname = "dataloader-lwt";
    version = "0.0.1-dev";

    src = lib.gitignoreSource ./..;

    inherit doCheck;

    buildInputs = [ alcotest ];

    propagatedBuildInputs = [ dataloader lwt ];
  };
}
