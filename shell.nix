let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-26.05-small";
  pkgs = import nixpkgs { config = {}; overlays = []; };
  pythonEnv = pkgs.python313.withPackages (ps: with ps; [
    ipython
    pandas
    numpy
    uv
  ]);
in

pkgs.mkShellNoCC {
  packages = with pkgs; [
    pythonEnv
  ];
}
