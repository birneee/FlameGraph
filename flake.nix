{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packageName = "flamegraph";
      in {
        packages.${packageName} = pkgs.stdenv.mkDerivation {
          name = "${packageName}";
          src = self;
          buildInputs = [ pkgs.perl ];
          installPhase = ''
            mkdir -p $out/bin
            for x in $src/*.pl $src/*.awk $src/dev/*.pl $src/dev/*.d; do
              cp $x $out/bin
            done
          '';
        };
        packages.default = self.packages.${system}.${packageName};
      }
    );
}