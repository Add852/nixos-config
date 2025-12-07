{ pkgs, inputs, ... }:
{
  home-manager.users.tony = {
    # import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
    ];

    # enable the systemd service (for tracking gui changes)
    # programs.noctalia-shell.systemd.enable = true;
    
    # configure options
    programs.noctalia-shell = {
      enable = true;
      settings = {
        # configure noctalia here; defaults will
        # be deep merged with these attributes.
        # bar = {
        #   density = "compact";
        #   position = "top";
        #   showCapsule = false;
        #   widgets = {
        #     left = [
        #       {
        #         id = "ControlCenter";
        #         useDistroLogo = true;
        #       }
        #       {
        #         id = "WiFi";
        #       }
        #       {
        #         id = "Bluetooth";
        #       }
        #     ];
        #     center = [
        #       {
        #         hideUnoccupied = false;
        #         id = "Workspace";
        #         labelMode = "none";
        #       }
        #     ];
        #     right = [
        #       {
        #         alwaysShowPercentage = false;
        #         id = "Battery";
        #         warningThreshold = 30;
        #       }
        #       {
        #         formatHorizontal = "HH:mm";
        #         formatVertical = "HH mm";
        #         id = "Clock";
        #         useMonospacedFont = true;
        #         usePrimaryColor = true;
        #       }
        #     ];
        #   };
        # };
        # colorSchemes.predefinedScheme = "Monochrome";
        # general = {
        #   avatarImage = "/home/drfoobar/.face";
        #   radiusRatio = 0.2;
        # };
        # location = {
        #   monthBeforeDay = true;
        #   name = "Marseille, France";
        # };
      };
      # this may also be a string or a path to a JSON file,
      # but in this case must include *all* settings.
    };
  };
}