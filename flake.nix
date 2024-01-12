{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      url = "github:parallaxisjones/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim-flake,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    configModule = {
      # Add any custom options (and feel free to upstream them!)
      # options = ...

      config.vim.theme.enable = true;
      config.vim.theme.name = "dracula-nvim";
      config.vim.languages = {
        rust.enable = true;
        ts.enable = true;
        markdown.enable = true;
        zig.enable = true;
        html.enable = true;
        python.enable = true;
        nix.enable = true;
      };
      config.vim.treesitter.enable = true;
      config.vim.filetree.nvimTreeLua.enable = true;
    };
    maximalNeovim = neovim-flake.packages.${system}.maximal;
    customNeovim = maximalNeovim.extendConfiguration {
      modules = [configModule];
      inherit pkgs;
    };
  in {
    packages.${system}.neovim = customNeovim;

    nixosConfigurations.quadbox = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/quadbox/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
