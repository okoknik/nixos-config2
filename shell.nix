{ pkgs ? import <nixpkgs> {}}:
  let
    libPath = with pkgs; lib.makeLibraryPath [
      # load external libraries that you need in your rust project here
      stdenv.cc.cc.lib 
   ];
in
  pkgs.mkShell rec {
    buildInputs = with pkgs; [
      nil
    ];
}
