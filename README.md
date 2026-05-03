# prowlet-nix

A Nix Flake for [prowlet](https://github.com/loiccoyle/prowlet), a shell script to query the Prowlarr search API from the CLI.

## 🚀 Quick Start

Run `prowlet` instantly without installing it:

```bash
nix run github:leoxyeo/prowlet-nix
```

## 🛠 Installation

### 1. Nix Profile
To install it to your user profile:

```bash
nix profile install github:leoxyeo/prowlet-nix
```

### 2. NixOS Configuration (Flakes)
Add this repository to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    prowlet.url = "github:leoxyeo/prowlet-nix";
  };

  outputs = { self, nixpkgs, prowlet, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit prowlet; };
      modules = [
        ./configuration.nix
        # OR use the provided module directly:
        prowlet.nixosModules.default
      ];
    };
  };
}
```

If you use the provided module, `prowlet` is added to `environment.systemPackages` automatically.

## 📦 Dependencies Included
This flake automatically wraps `prowlet` with the following runtime dependencies:
- `curl`
- `jq`
- `xdg-utils` (for `xdg-open`)
