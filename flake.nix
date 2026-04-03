{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };

      # rustToolchain = pkgs.rust-bin.nightly.latest.default;
      rustToolchain = pkgs.rust-bin.nightly.latest.default.override {
        # targets = [ "thumbv7em-none-eabihf" ];
        extensions = [ "rust-src" "llvm-tools-preview" ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          rustToolchain

          # Dev tools
          rust-analyzer
          clippy
          rustfmt

          # libs
          glibc

          # Build deps
          pkg-config
          openssl

          # Debugging
          gdb

          # Misc useful stuff
          git
          cargo-watch

          # virtual machine
          qemu
        ];

        shellHook = ''
          echo "🦀 Rust dev environment loaded"
          echo "Rust version: $(rustc --version)"
        '';
      };
    };
}
