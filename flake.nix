{
  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
    src.url = "github:BeyondTheClouds/enoslib?rev=a9e30b09bd7d4191b5645f5c85191d94029938cd";
    src.flake = false;
  };

  outputs =
    { self
    , dream2nix
    , src
    ,
    } @ inp:
    (dream2nix.lib.makeFlakeOutputs {
      systems = [ "x86_64-linux" ];
      config.projectRoot = ./.;
      source = src;
      
      settings = [
        {
          # optionally define python version
          subsystemInfo.pythonAttr = "python310";
        }
      ];
    })
    // {
      # checks.x86_64-linux.aiohttp = self.packages.x86_64-linux.main;
      # default.x86_64-linux.default = self.packages.x86_64-linux.main;
      defaultPackage = self.packages.x86_64-linux.main;
    };

}
