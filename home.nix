{ config, pkgs, ... }:

{
  home.username = "tony";
  home.homeDirectory = "/home/tony";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    #basic apps:
    nemo #file manager: https://wiki.nixos.org/wiki/Nemo
    kdePackages.gwenview # image viewer: alt: swayimg
    vlc #video viewer/player
    rofi # app launcher (more stable than walker)

    #some apps
    neofetch
    obsidian
    code-cursor
    telegram-desktop
    discord
    youtube-music #electron yt music wrapper

    #libre office suite
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH

    #some hyprland stuffs
    hyprshot #for screenshots
    hyprcursor #hyprland themed cursor idk
    hyprpolkitagent #hyprland authentication handler shii (asks root perm for apps with GUI like VS Code)
    xdg-desktop-portal-hyprland #some basic desktop utils like screen sharing and screenshot

    #noctalia-shell stuffs
    gpu-screen-recorder #for noctalia screen recorder
    brightnessctl #for noctalia brightness I think
    cliphist #clipboard history (optional)
    wlsunset #night light functionality

    #some dependencies
    firefoxpwa
  ];

  #SEE NEMO NIXOS DOCUMENTATION HERE: https://wiki.nixos.org/wiki/Nemo
  xdg.desktopEntries.nemo = { #add nemo to the app launcher
    name = "Nemo";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo";
  };
  xdg.mimeApps = { #set nemo as default file manager
      enable = true;
      defaultApplications = {
          "inode/directory" = [ "nemo.desktop" ];
          "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      };
  };
  dconf = { #set alacritty as defualt terminal for nemo
    settings = {
        "org/cinnamon/desktop/applications/terminal" = {
            exec = "alacritty";
            # exec-arg = ""; # argument
        };
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    settings.user.name = "Add852";
    settings.user.email = "xadd852x@gmail.com";
  };
  programs.alacritty = { # alacritty - a cross-platform, GPU-accelerated terminal emulator
    enable = true;
    settings = {
      # general.import = [ "themes/noctalia.toml" ];
      # env.TERM = "xterm-256color";
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

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
