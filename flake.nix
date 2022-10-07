{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system: # leverage flake-utils
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import ./requirements.nix) ];
        };

        lib = pkgs.lib;
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        packages = rec {
          enoslib = pkgs.python39Packages.buildPythonPackage rec {
            pname = "enoslib";
            version = "8.0.0a23";
            src = pkgs.fetchgit {
              url = "https://gitlab.inria.fr/discovery/enoslib";
              rev = version;
              sha256 = "sha256-tCMgdnyv7Lt6xf0LoJbndZpCyE91+YvbOn0VaLYwruY=";
            };

            propagatedBuildInputs = with pkgs.python39Packages; [
              netaddr

              rich'
              cryptography
              sshtunnel
              ipywidgets
              python-vagrant

              pytz
              distem'
              iotlabsshcli'
              ring'
              diskcache'
              execo'
              jsonschema'
              python-grid5000'

              pkgs.ansible
            ];
            
            doCheck = false;
          };
          default = enoslib;
        };
        devShell = pkgs.mkShell
          {
            buildInputs = with pkgs;
              [
                self.packages.${system}.enoslib
              ];

            inputsFrom = builtins.attrValues self.packages.${system};
          };
      });
}