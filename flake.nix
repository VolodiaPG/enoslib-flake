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

        enoslib = pkgs.python39Packages.buildPythonPackage rec {
          pname = "enoslib";
          version = "v8.0.0";
          src = pkgs.fetchgit {
            url = "https://gitlab.inria.fr/discovery/enoslib";
            rev = version;
            sha256 = "sha256-hVzS9jRMbnAYIeZcmOU2sPGbJioAqwbVOelejTcCFBI=";
          };

          propagatedBuildInputs = with pkgs.python39Packages; [
            netaddr

            rich'
            cryptography
            sshtunnel
            ipywidgets
            python-vagrant
            packaging

            pytz
            distem'
            iotlabsshcli'
            ring'
            execo'
            jsonschema'
            python-grid5000'

            pkgs.ansible
          ];

          doCheck = false;
        };
      in
      {
        formatter = pkgs.nixpkgs-fmt;

        packages = { 
          enoslib = enoslib;
          default = enoslib;
        };
        
        overlay = import ./overlay.nix { inherit self; };

        devShell = pkgs.mkShell
          {
            buildInputs =
              [
                enoslib
              ];

            inputsFrom = builtins.attrValues self.packages.${system};
          };
      });
}
