{ pkgs, ... }:

{  
let
    # List of module files to be imported
    moduleFiles = [
      ../modules/boot-loader.nix
      ../modules/services.nix
      ../modules/users.nix
      ../modules/fonts.nix
      # Pending fixes
      # ../modules/fish.nix
      # ../modules/graphics.nix
    ];

    # Import each module and build a list of configurations
    importedModules = builtins.map (file: import file) moduleFiles;

    # Combine configurations (if needed)
    combinedConfig = builtins.foldl' (acc: module: acc // module) {} importedModules;

  in
    # You can use the combinedConfig in your build or configuration
    pkgs.callPackage ./configuration.nix {
      inherit combinedConfig;
    }
}
