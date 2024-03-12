{
  description = "Neovim flake (checked treesitter)";

  inputs = {
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ config, withSystem, ... }: {
      systems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { inputs', self', system, config, lib, pkgs, ... }: {
        _module.args.pkgs = import inputs.nixpkgs { inherit system; };

        packages = {
          neovim = inputs'.neovim-nightly-overlay.packages.neovim;
          nvim-treesitter = pkgs.vimPlugins.nvim-treesitter;
        };

        checks = {
          check-health-nvim-treesitter = let
            config = pkgs.neovimUtils.makeNeovimConfig {
              wrapRc = true;
              plugins = [{
                plugin = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
                config = ''
                  lua << EOF
                    ${builtins.readFile ./lua/nvim-treesitter.lua}
                  EOF
                '';
              }];
            };
            sut = pkgs.wrapNeovimUnstable self'.packages.neovim config;
          in pkgs.runCommand "check" {
            buildInputs = with pkgs; [ gnugrep ];
          } ''
            mkdir $out
            ERROR_EXISTS=`${sut}/bin/nvim --headless -c "checkhealth" -c "sleep 30" -c "quit" 2>&1 | grep -i "error"`
            if [ $ERROR_EXISTS ]; then
              echo "Errors found."
              exit 1
            else
              echo "No errors found."
              exit 0
            fi
          '';
        };
      };

      flake.overlay = final: prev:
        let inherit (prev.stdenv) system;
        in {
          neovim-unwrapped = self.packages.${system}.neovim;
          neovim-nightly = self.packages.${system}.neovim;
          vimPlugins = prev.vimPlugins // {
            nvim-treesitter = self.packages.${system}.nvim-treesitter;
          };
        };
    });
}
