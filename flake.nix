{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # hyprland shiz
    hyprland.url = "github:hyprwm/Hyprland";

    # walker and elephant
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # noctalia shiz
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{self, nixpkgs,home-manager,...}:{
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem{
        specialArgs = { inherit inputs; }; #used to pass hyprland vars in configuration.nix
        modules = [
          ./configuration.nix
          ./noctalia.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.tony = import ./home.nix;
          }
        ];
      };
    };
  };
}
