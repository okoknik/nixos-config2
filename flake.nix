{
  description = "NixOS Flake";

  # `inputs` are the dependencies of the flake,
  # and `outputs` function will return all the build results of the flake.
  # Each item in `inputs` will be passed as a parameter to
  # the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.
    
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
  };

  # parameters in function `outputs` are defined in `inputs` and
  # can be referenced by their names. 
  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  outputs = { self, nixpkgs, home-manager, impermanence, nixos-hardware, ... }@inputs: { # insert nixvim here

    nixosConfigurations = {
      "framework" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # specialArgs = {...};  # pass custom arguments into all sub module.
        modules = [
          ./configuration.nix
		      home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.niklas = import ./home.nix;
          }
          impermanence.nixosModules.impermanence
	        nixos-hardware.nixosModules.framework-amd-ai-300-series
        ];
     
      };
    };
  };
}
