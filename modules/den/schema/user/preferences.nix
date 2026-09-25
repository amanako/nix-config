{lib, ...}: {
  den.schema.user = {
    host,
    config,
    ...
  }: {
    options = let
      inherit
        (lib)
        mkOption
        types
        ;
    in {
      preferences = mkOption {
        type = types.submodule {
          options = let
            mkPrefOption = pref: {
              default ? null,
              example ? "",
              description ? "Preferred ${pref} package name.",
            }:
              mkOption {
                type = lib.types.nullOr lib.types.str;
                inherit
                  default
                  example
                  description
                  ;
              };
          in {
            editor = mkPrefOption "text editor" {
              example = "hx";
            };

            term = mkPrefOption "terminal" {
              example = "ghossty";
            };

            browser = mkPrefOption "web browser" {
              example = "firefox";
            };

            fileManager = mkPrefOption "file manager" {
              example = "thunar";
            };

            monofont = mkOption {
              type = types.submodule {
                options = {
                  package = mkOption {
                    type = types.str;
                    example = "nerd-fonts.victor-mono";
                    description = ''
                      Nixpkgs package name providing the preferred font, resolved by
                      consumers as `pkgs.''${package}`. A package name and not a
                      derivation because `pkgs` is not in scope in entries.
                      Read by consumers that accept a package.
                    '';
                  };

                  name = mkOption {
                    type = types.str;
                    example = "VictorMono Nerd Font";
                    description = ''
                      Family name of the font as reported by fontconfig. Read by
                      consumers that only accept a family name. It cannot be
                      derived from `package` since one package may ship several
                      families.
                    '';
                  };
                };
              };
              default = {
                package = "nerd-fonts.victor-mono";
                name = "VictorMono Nerd Font";
              };
              description = ''
                Preferred monospace font, the single source of truth for both the
                package and its family name. Consumers that need a package read
                `package` and resolve it themselves, consumers that need a family
                name read `name`, so both halves have to be updated together when
                changing the font.
              '';
            };

            fallbacks = mkOption {
              type = types.submodule {
                options = let
                  mkFallbackOption = role: program:
                    mkOption {
                      type = types.str;
                      default = program;
                      description = "Fallback ${role} (nixpkgs package name).";
                    };
                in {
                  editor = mkFallbackOption "text editor" "helix";
                  term = mkFallbackOption "terminal" "alacritty";
                  browser = mkFallbackOption "web browser" "firefox";
                  fileManager = mkFallbackOption "file manager" "nemo";
                };
              };
              default = {};
              example = {
                term = "kitty";
              };
              description = ''
                Default programs (as nixpkgs package names) consumers use when the
                corresponding preference is not set. The package for a fallback is
                installed automatically for users who lack the preference.
              '';
            };

            effective = mkOption {
              type = types.attrsOf types.str;
              readOnly = true;
              default =
                config.preferences.fallbacks
                |> lib.mapAttrs (name: fallback: let
                  pref = config.preferences.${name};
                in
                  if pref != null
                  then pref
                  else fallback);
              description = ''
                Resolved preference: the explicit value when set, otherwise the
                configured `fallbacks` entry. Single source of truth for consumers
                that only need a runnable program name.
              '';
            };
          };
        };

        example = {
          browser = "zen-beta";
          term = "kitty";
          editor = "nvim";
          fileManager = "nautilus";
          monofont = {
            package = "nerd-fonts.victor-mono";
            name = "VictorMono Nerd Font";
          };
        };

        description = ''
          Common applications the user would like available.
          Used for keybindings in compositors and shells and some default settings.
          Default value of `null` is used to express "no preference"; consumers then fall
          back to a sensible default or skip the preference-driven feature accordingly.
          `monofont` is the exception, it carries both the package and its family name and
          comes with a default of its own, since neither half is derivable from the other.
        '';
      };

      repoRoot = mkOption {
        type = types.path;
        default = host.repoRoot;
        example = "/home/user/nix-config";
        description = ''
          Root folder of repository where flake resides. Corresponding option of `host.repoRoot`
          This in inherited from host by default and is readonly if user is not primary, that is if isPrimaryUser option is false.
          Otherwise, setting this option for all users present on host alleviates host the need to set it themself.
        '';
        readOnly = !config.isPrimaryUser;
      };
    };
  };
}
