{ pkgs ? import ./sources.nix {}, doCheck ? true, ocamlVersion ? "4_10" }:

let
  inherit (pkgs) lib stdenv ocamlPackages;
  genSrc = { dirs, files }: lib.filterGitSource {
    src = ./..;
    inherit dirs;
    files = files ++ [ "dune-project" ];
  };

in

with ocamlPackages;

rec {
  dataloader = buildDunePackage {
    pname = "dataloader";
    version = "0.0.1-dev";

    src = genSrc {
      dirs = [ "dataloader" ];
      files = [ "dataloader.opam" ];
    };

    checkInputs = [ alcotest ];
    inherit doCheck;
  };

  dataloader-lwt = buildDunePackage {
    pname = "dataloader-lwt";
    version = "0.0.1-dev";

    src = genSrc {
      dirs = [ "dataloader-lwt" ];
      files = [ "dataloader-lwt.opam" ];
    };

    inherit doCheck;
    checkInputs = [ alcotest ];

    propagatedBuildInputs = [ dataloader lwt ];
  };
}
