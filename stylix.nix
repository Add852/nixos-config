{ inputs, config, pkgs, ... }:
{
  stylix = {
    enable = true;
    
    # image = ./bliss_sunset.jpg; #generate base16scheme on wallpaper, more colors, better: /etc/stylix/palette.html
    polarity = "dark"; #lean towards generating darker images

    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-pale.yaml";
    # look for color schemes here = https://github.com/tinted-theming/schemes/tree/spec-0.11/base16
    base16Scheme = { #based on gruv # --box-dark-pale.yaml: hAdjust to your liking (Guide): https://nix-community.github.io/stylix/styling.html
      base00 = "#262626";
      base01 = "#3a3a3a";
      base02 = "#4e4e4e";
      base03 = "#8a8a8a";
      base04 = "#949494";
      base05 = "#dab997";
      base06 = "#d5c4a1";
      base07 = "#ebdbb2";
      base08 = "#d75f5f";
      base09 = "#ff8700";
      base0A = "#ffaf00";
      base0B = "#afaf00";
      base0C = "#85ad85";
      base0D = "#83adad";
      base0E = "#d485ad";
      base0F = "#d65d0e";
    };
    
    # Look for Icon packs here: https://www.gnome-look.org/browse?cat=132&ord=latest
    icons = {
      enable = true;
      package = pkgs.gruvbox-plus-icons;
      dark = "Gruvbox-Plus-Dark";
      light = "Gruvbox-Plus-Light";
    };
    
    fonts = { #Look for fonts here: https://www.nerdfonts.com/font-downloads
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12; #default: 12
        terminal = 16; #default: 12
        desktop = 10; #default: application
        popups = 10; #default: desktop
      };
    };
    
    opacity = {
      applications = 0.9;
      terminal = 0.9;
      desktop = 0.9;
      popups = 0.9;
    };
    
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Amber";
      # name = "Bibata-Modern-Ice";
      size = 20;
    };
  };
}