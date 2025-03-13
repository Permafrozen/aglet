{
  description = "Aglet is pretty Sigma.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ags, }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        default = ags.lib.bundle {
          inherit pkgs;
          src = ./src;
          name = "aglet";
          entry = "app.ts";
          gtk4 = true;

          # additional libraries and executables to add to gjs' runtime
          extraPackages = [ ags.packages.${system}.battery ];
        };
      };

      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = [
            # includes astal3 astal4 astal-io by default
            (ags.packages.${system}.default.override {
              extraPackages = [
                # cherry pick packages
                ags.packages.${system}.battery
              ];
            })
          ];
        };
      };
    };
}
