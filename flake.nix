{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    esp = {
      url = "github:MaienM/nixpkgs-esp-dev-rust";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { nixpkgs, flake-utils, esp, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      espPkgs = esp.packages.${system};
    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          espPkgs.esp-idf-full

          cargo
          clippy
          espflash
          ldproxy
        ];
        LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [ pkgs.libxml2 pkgs.zlib pkgs.stdenv.cc.cc.lib ]}";
        LIBCLANG_PATH = "${espPkgs.llvm-xtensa}/lib";
      };
    }
  );
}
