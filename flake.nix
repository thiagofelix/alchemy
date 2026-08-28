{
  description = "Alchemy development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Pinned by nixpkgs to the exact versions the repo expects:
            #   package.json devEngines → bun 1.3.13, node 24
            #   package.json packageManager → pnpm 11.21.0
            #   .node-version → 24
            bun # 1.3.13 — every repo script runs via `bun`
            nodejs_24 # 24.19.0
            pnpm # 11.21.0 — workspace install/lockfile
            doppler # `pnpm download:env` / `download:external` (secrets)
            awscli2 # AWS testing profile (`aws sso login`) and `pnpm nuke`
            jq # scripts/nuke.sh and friends
            git
          ];

          shellHook = ''
            echo "alchemy dev shell — bun $(bun --version) · node $(node --version) · pnpm $(pnpm --version)"
          '';
        };
      });
}
