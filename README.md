# prowlet-nix

Nix flake for [prowlet](https://github.com/loiccoyle/prowlet) — query the Prowlarr search API from the command line.

> **Note:** Linux only. `prowlet` relies on `xdg-open` and optionally `systemctl`, neither of which exist on macOS.

## Quick Start

```bash
nix run github:leoxyeo/prowlet-nix
```

## Installation

### Nix Profile

```bash
nix profile install github:leoxyeo/prowlet-nix
```

### NixOS (via overlay — recommended)

In your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    prowlet-nix.url = "github:leoxyeo/prowlet-nix";
  };

  outputs = { self, nixpkgs, prowlet-nix, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      modules = [
        { nixpkgs.overlays = [ prowlet-nix.overlays.default ]; }
        ./configuration.nix
      ];
    };
  };
}
```

Then in `configuration.nix`:

```nix
{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.prowlet ];
}
```

### NixOS (via nixosModule — one-liner)

Adds prowlet to `systemPackages` automatically:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    prowlet-nix.url = "github:leoxyeo/prowlet-nix";
  };

  outputs = { self, nixpkgs, prowlet-nix, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      modules = [
        prowlet-nix.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
```

## Updating

This flake pins a specific upstream commit. To update to the latest:

1. Get the latest commit SHA from [upstream](https://github.com/loiccoyle/prowlet/commits/main)
2. Update `rev` and `version` in `package.nix`
3. Run `nix-prefetch-github loiccoyle prowlet --rev <new-sha>` to get the new hash
4. Run `nix flake update` to refresh `flake.lock`

## Dependencies

All runtime dependencies are automatically injected via `wrapProgram`:

| Package | Purpose |
|---------|---------|
| `curl` | HTTP requests to the Prowlarr API |
| `jq` | JSON parsing and output formatting |
| `xdg-utils` | `prowlet open` - opens Prowlarr dashboard |

## License

Nix packaging is licensed under MIT. The prowlet source code is subject to its own [license](https://github.com/loiccoyle/prowlet/blob/main/LICENSE).
