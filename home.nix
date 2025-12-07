{ config, pkgs, ... }:

{
  home.username = "tony";
  home.homeDirectory = "/home/tony";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    #some apps
    neofetch
    obsidian
    firefoxpwa
    code-cursor
    swayimg

    #some hyprland stuffs
    rofi # rofi app launcher (more stable than walker)
    hyprshot #for screenshots
    hyprcursor #hyprland themed cursor idk
    hyprpolkitagent #hyprland authentication handler shii (asks root perm for apps with GUI like VS Code)
    xdg-desktop-portal-hyprland #some basic desktop utils like screen sharing and screenshot

    #noctalia-shell stuffs
    gpu-screen-recorder #for noctalia screen recorder
    brightnessctl #for noctalia brightness I think
    cliphist #clipboard history (optional)
    wlsunset #night light functionality

    #libre office suite
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
  ];
  
  gtk = { #some code I found online lmao (fixed thunar and other GTK apps): https://discourse.nixos.org/t/nwg-look-installation-help/28978/2 
      enable = true;
      font.name = "TeX Gyre Adventor 10";
      theme = {
        name = "Juno";
        package = pkgs.juno-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Amber"; # Example theme (must be installed via nixpkgs/home-manager)
    package = pkgs.bibata-cursors;
    size = 16;
    gtk.enable = true; # Helps with GTK apps consistency
    x11.enable = true; # Helps with XWayland apps
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings.user.name = "Add852";
    settings.user.email = "xadd852x@gmail.com";
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [ "themes/noctalia.toml" ];
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        # draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  # to resolve some graphics issues on hyprland at home.nix
  # programs.dconf.profiles.user.databases = [
  #   {
  #     settings."org/gnome/desktop/interface" = {
  #       gtk-theme = "Adwaita";
  #       icon-theme = "Flat-Remix-Red-Dark";
  #       font-name = "Noto Sans Medium 11";
  #       document-font-name = "Noto Sans Medium 11";
  #       monospace-font-name = "Noto Sans Mono Medium 11";
  #     };
  #   }
  # ];

  # programs.bash = {
  #   enable = true;
  #   enableCompletion = true;
  #   # TODO add your custom bashrc here
  #   bashrcExtra = ''
  #     export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
  #   '';

  #   # set some aliases, feel free to add more or remove some
  #   shellAliases = {
  #     k = "kubectl";
  #     urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
  #     urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
  #   };
  # };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.

  # services.udev.extraRules = builtins.readFile ./rules-file;

  home.stateVersion = "25.05";
}
