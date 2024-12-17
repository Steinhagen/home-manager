{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.programs.lutris;

  defaultMigrationVersion = 14;
  defaultWidth = 800;
  defaultHeight = 600;
  defaultWindowX = 26;
  defaultWindowY = 23;
  defaultMaximized = false;
  defaultSelectedCategory = "category:all";

  boolToStr = value: if value then "True" else "False";

  lutrisConf = ''
    [services]
    gog = True
    egs = True
    ea_app = True
    ubisoft = True
    steam = True

    [lutris]
    library_ignores =
    migration_version = ${toString cfg.migrationVersion}
    width = ${toString cfg.width}
    height = ${toString cfg.height}
    window_x = ${toString cfg.windowX}
    window_y = ${toString cfg.windowY}
    maximized = ${boolToStr cfg.maximized}
    selected_category = ${cfg.selectedCategory}
  '';
in
{
  meta.maintainers = [ maintainers.rapiteanu ];

  options = {
    programs.lutris = {
      enable = mkEnableOption "Open Source gaming platform for GNU/Linux";

      package = mkOption {
        type = types.package;
        default = pkgs.lutris;
        defaultText = literalExpression "pkgs.lutris";
        description = "The Lutris package to use.";
      };

      extraPackages = mkOption {
        type = with types; listOf package;
        default = [ ];
        example = literalExpression "[ pkgs.wineWowPackages.staging pkgs.winetricks ]";
        description = "Packages that should be available to Lutris.";
      };

      migrationVersion = mkOption {
        type = types.ints.positive;
        default = defaultMigrationVersion;
        example = 14;
        description = "Lutris migration version";
      };

      width = mkOption {
        type = types.ints.positive;
        default = defaultWidth;
        example = 800;
        description = "Window width.";
      };

      height = mkOption {
        type = types.ints.positive;
        default = defaultHeight;
        example = 600;
        description = "Window height.";
      };

      windowX = mkOption {
        type = types.ints.positive;
        default = defaultWindowX;
        example = 26;
        description = "Window location on X axis.";
      };

      windowY = mkOption {
        type = types.ints.positive;
        default = defaultWindowY;
        example = 23;
        description = "Window location on X axis.";
      };

      maximized = mkOption {
        type = types.bool;
        default = defaultMaximized;
        description = ''
          Resize the window to the size of the smallest session for
          which it is the current window.
        '';
      };

      selectedCategory = mkOption {
        type = types.str;
        default = defaultSelectedCategory;
        example = "category:all";
        description = ''
          Selected category shown when oppening the application.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    home.packages = [ (cfg.package.override { extraPkgs = pkgs: cfg.extraPackages; }) ];

    # xdg.dataFile."lutris/lutris.conf".text = lutrisConf;
    xdg.configFile."lutris/lutris.conf".text = lutrisConf;
  };
}
