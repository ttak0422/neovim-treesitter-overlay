<h1 align="center">
  neovim-treesitter-overlay
</h1>
<div align="center">
  <img alt="neovim" src="https://img.shields.io/badge/NeoVim-57A143.svg?&style=for-the-badge&logo=neovim&logoColor=white">
  <img alt="nix" src="https://img.shields.io/badge/nix-5277C3.svg?&style=for-the-badge&logo=NixOS&logoColor=white">
  <img alt="license" src="https://img.shields.io/github/license/ttak0422/neovim-treesitter-overlay?style=for-the-badge">
  <p>provide tested neovim and plugins</p>
</div>

> [!WARNING]
> This is experimental project. With the increase in the number of managed entities, it is expected that the content provided will be delayed from nightly releases.


## Status
[![Nix flake check](https://github.com/ttak0422/neovim-treesitter-overlay/actions/workflows/check.yml/badge.svg)](https://github.com/ttak0422/neovim-treesitter-overlay/actions/workflows/check.yml)

## Package
- neovim
- nvim-treesitter

## Overlay
- neovim-unwrapped
- neovim-nightly
- vimPlugins.nvim-treesitter

## Release cycle

```
  ┌────────────────────┬────────────────────────┐
  │                    │                        │
  │                    │                        │
  │                    ▼                        │
  │           ┌───────────────────┐             │
  │           │ Nightly Job Entry │             │
  │           └────────┬──────────┘             │
  │                    │                        │
  │                    │                 failed some checks
  │                    ▼                        │
  │          ┌─────────────────────┐            │
  │          │ Update all packages │            │
  │          └─────────┬───────────┘            │
  │                    │                        │
  │                    │                        │
  │                    ▼                        │
  │            ┌─────────────────┐              │
  │            │ Nix flake check ├──────────────┘
  │            └───────┬─────────┘
  │                    │
  │              all check passed
  │                    │ 
  │                    ▼
  │         ┌───────────────────────┐
  └─────────┤ Apply packages update │
            └───────────────────────┘
```
