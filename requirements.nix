self: super:
let
  pythonPackagesOverlays = prev: [
    (python-final: python-prev: rec {
      wirerope' = python-prev.buildPythonPackage rec {
        name = "wirerope";
        version = "0.4.5";
        src = prev.fetchgit {
          url = "https://github.com/youknowone/wirerope";
          rev = "81c533d6df479cae80f74b5c298c4236f98f0158";
          sha256 = "sha256-IZOu3JNNd/g19KeaeeJUXr0Ia+n5iffuZqNonfwCG8k=";
          #leaveDotGit = true;
        };
        # nativeBuildInputs = [ git ];
        propagatedBuildInputs = with python-final; [
          six
        ];
        doCheck = false;
      };
      ring' = python-prev.buildPythonPackage rec {
        name = "ring";
        version = "0.9.1";
        src = prev.fetchgit {
          url = "https://github.com/youknowone/ring";
          rev = "8e4eb90b13d6480e50c63266e041e491c7c41dfe";
          sha256 = "sha256-VmNXfntVFlXmvx9OjZ0VuIlHY5CPS3N+MJlL8YkrKcw=";
          #leaveDotGit = true;
        };
        # nativeBuildInputs = [ git ];
        propagatedBuildInputs = with python-final; [
          attrs
          wirerope'
        ];
        doCheck = false;
      };

      execo' = python-prev.buildPythonPackage rec {
        pname = "execo";
        version = "2.6.8";
        src = python-prev.fetchPypi {
          inherit pname version;
          sha256 = "sha256-xkAMVQxAy9zx2P6R8I/Xz7afQJP0c0I8hddrKeEcPF4=";
        };
      };

      # pytz' = python-prev.buildPythonPackage rec {
      #   pname = "pytz";
      #   version = "2022.1";
      #   src = python-prev.fetchPypi {
      #     inherit pname version;
      #     sha256 = "sha256-HnYOL+aoFjvAs9mhnE+ENCr6Cir/6/qoSwG5eKAuyqc=";
      #   };
      # };

      jsonschema' = python-prev.buildPythonPackage rec {
        pname = "jsonschema";
        version = "3.0.2";
        src = python-prev.fetchPypi {
          inherit pname version;
          sha256 = "sha256-jUore2wiN+AZnI6hptPgW/EY4omuK517pEQYKilZVg0=";
        };
        doCheck = false;
        nativeBuildInputs = with python-final; [ setuptools-scm ];
        propagatedBuildInputs = with python-final; [ attrs importlib-metadata functools32 pyrsistent ];
      };
      jsonschema = jsonschema';

      argparse' = python-prev.buildPythonPackage rec {
        pname = "argparse";
        version = "1.4.0";
        src = python-prev.fetchPypi {
          inherit pname version;
          sha256 = "sha256-YrCJpVvh2JSc0rx+DfC9254Cj678jDIDjMhIYq791uQ=";
        };
        # doCheck = false;
      };

      ssh-python' = python-prev.buildPythonPackage rec {
        pname = "ssh-python";
        version = "0.10.0";
        src = python-prev.fetchPypi {
          inherit pname version;
          sha256 = "sha256-ZFlypiAbOGvHs4CQFO4p1JqB0DVCIgqUrPBSykbF+Mg=";
        };
        # We don't want to build with CMake, just include it for the libssh2 bindings.
        dontUseCmakeConfigure = true;
        nativeBuildInputs = with prev; [ cmake ];

        SYSTEM_LIBSSH2 = "1";
        buildInputs = with prev; [libssh2 openssl zlib ];
      };

      ssh2-python' = python-prev.buildPythonPackage rec {
        pname = "ssh2-python";
        version = "0.27.0";

        src = python-prev.fetchPypi {
          inherit pname version;
          sha256 = "sha256-plsU/0S3oFzpDHCvDeZE0wwdB+dtrFDfjg19K5QJYjs=";
        };

        # We don't want to build with CMake, just include it for the libssh2 bindings.
        dontUseCmakeConfigure = true;
        nativeBuildInputs = with prev; [ cmake ];

        SYSTEM_LIBSSH2 = "1";

        buildInputs = with prev; [ libssh2 openssl zlib ];
      };

      parallel-ssh' = python-prev.buildPythonPackage rec {
        pname = "parallel-ssh";
        version = "2.10.0";
        src = python-prev.fetchPypi {
          inherit pname version;
          sha256 = "sha256-i5JfQ5cqVJrgkKVfVXvrU6GWhWZtvrFmswQ9YfXrLbk=";
        };
        # doCheck = false;
        propagatedBuildInputs = with python-final;[
          # python-prev.gevent
          gevent
          ssh2-python'
          ssh-python'
        ];
      };

      iotlabcli' = python-prev.buildPythonPackage rec {
        pname = "iotlabcli";
        version = "3.3.0";
        src = python-prev.fetchPypi {
          inherit pname version;
          sha256 = "sha256-5IHWTzaRrc9WSLFDWyA7VDkisYoV9ITRpirjbSLPf34=";
        };
        doCheck = false;
        propagatedBuildInputs = with python-final; [
          # python-prev.requests
          # python-prev.jmespath
          requests
          jmespath
        ];
      };

      iotlabsshcli' = python-prev.buildPythonPackage rec {
        pname = "iotlabsshcli";
        version = "1.1.0";
        src = prev.fetchgit {
          url = "https://github.com/GuilloteauQ/ssh-cli-tools";
          rev = "bfe257be31941f906539680d3a220c682b9ee5e6";
          sha256 = "sha256-b29z/amJGP/36YKIaZlu2Tdo7oJXSqRT/z3cLIi5TtI=";
          #leaveDotGit = true;
        };
        doCheck = false;
        propagatedBuildInputs = with python-final; [
          scp
          psutil
          gevent
          parallel-ssh'
          iotlabcli'
        ];
      };

      distem' = python-prev.buildPythonPackage rec {
        pname = "distem";
        version = "0.0.5";
        src = prev.fetchgit {
          url = "https://gitlab.inria.fr/myriads-team/python-distem";
          rev = "650931b377c35470e3c72923f9af2fd9c37f0470";
          sha256 = "sha256-brrs350eC+vBzLJmdqw4FnjNbL+NgAfnqWDjsMiEyZ4=";
          #leaveDotGit = true;
        };
        # doCheck = false;
        propagatedBuildInputs = [
          python-final.requests
        ];
      };

      python-grid5000' = python-prev.buildPythonPackage rec {
        pname = "python-grid5000";
        version = "1.2.4";
        src = prev.fetchgit {
          url = "https://gitlab.inria.fr/msimonin/python-grid5000";
          rev = "a6d6d3858a819e37b530b5846129b88714a1aefc";
          sha256 = "sha256-wfDyoaOn0Dlbz/metxskbN4frsJbkEe8byUeO01upV8=";
        };
        doCheck = false;
        propagatedBuildInputs = [
          python-final.pyyaml
          python-final.requests
          python-final.ipython
        ];
      };

      rich' = python-prev.rich.overrideAttrs
        (old: rec {
          version = "12.0.0";

          src = prev.fetchFromGitHub {
            owner = "Textualize";
            repo = old.pname;
            rev = "v${version}";
            sha256 = "sha256-YnJ+F6OWVgEsApckg8Z8hxiepqDdkNMx9HDfHoYwsDg=";
          };
        });
    })
  ];
in
{
  python39 = super.python39.override {
    packageOverrides = super.lib.composeManyExtensions (pythonPackagesOverlays super);
  };
  ansible = super.ansible.override {
    ansible = self.python39.pkgs.ansible.override {
      jsonschema = self.python39.pkgs.jsonschema';
    };
  };
}
